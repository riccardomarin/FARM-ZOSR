% This code implements a basic version of the algorithm described in:
% 
% Informative Descriptor Preservation via Commutativity for Shape Matching,
% Dorian Nogneng and Maks Ovsjanikov, Proc. Eurographics 2017
% 
% To try it, simply run this file in MATLAB. This should produce
% a map (correspondence) between a pair of meshes from the FAUST dataset,
% and create an image that visualizes this correspondence.
% 
% This code was written by Etienne Corman and modified by Maks Ovsjanikov.

function createresult(srcmesh, plotflag)

    numEigsSrc = 30;
    numEigsTar = 50;
    params.algorithm = 'kdtree';
    params.trees = 8;
    params.checks = 64;
    params.init_src = numEigsSrc;
    params.init_tar = numEigsTar;
    params.iters = 100;
    
    load('basicmodel_m_lbs.mat');
    %
    tarmesh = 'smpl_base_neutro.obj';

    load(['cache_', tarmesh(1:end-4),'.mat']);
    load(['../Cache/cache_', srcmesh(1:end-4),'.mat']);
    
    SrcLaplaceBasis = Src.laplaceBasis; SrcEigenvalues = Src.eigenvalues;
    Src.laplaceBasis = SrcLaplaceBasis(:,1:numEigsSrc); Src.eigenvalues = SrcEigenvalues(1:numEigsSrc);
    TarLaplaceBasis = Tar.laplaceBasis; TarEigenvalues = Tar.eigenvalues;
    Tar.laplaceBasis = TarLaplaceBasis(:,1:numEigsTar); Tar.eigenvalues = TarEigenvalues(1:numEigsTar);

    for iters=1:3

        landmarks = [landmarks1' landmarks2'];

        %% Descriptors
        fct_src = [];
        %fprintf('Computing the descriptors...\n');tic;
        fct_src = [fct_src, waveKernelSignature(SrcLaplaceBasis, SrcEigenvalues, Src.Ae, 200)];
        fct_src = [fct_src, waveKernelMap(SrcLaplaceBasis, SrcEigenvalues, Src.Ae, 200, landmarks(:,1))];

        fct_tar = [];
        fct_tar = [fct_tar, waveKernelSignature(TarLaplaceBasis, TarEigenvalues, Tar.Ae, 200)];
        fct_tar = [fct_tar, waveKernelMap(TarLaplaceBasis, TarEigenvalues, Tar.Ae, 200, landmarks(:,2))];

        % Subsample descriptors (for faster computation). More descriptors is
        % usually better, but can be slower. 
        fct_src = fct_src(:,1:10:end);
        fct_tar = fct_tar(:,1:10:end);

        %fprintf('done computing descriptors (%d on source and %d on target)\n',size(fct_src,2),size(fct_tar,2)); toc;

        assert(size(fct_src,2)==size(fct_tar,2));

        % Normalization
        no = sqrt(diag(fct_src'*Src.Ae*fct_src))';
        fct_src = fct_src ./ repmat(no, [Src.nv,1]);
        fct_tar = fct_tar ./ repmat(no, [Tar.nv,1]);

        %% Multiplication Operators
        numFct = size(fct_src,2);
        OpSrc = cell(numFct,1);
        OpTar = cell(numFct,1);
        for i = 1:numFct
            OpSrc{i} = Src.laplaceBasis'*Src.Ae*(repmat(fct_src(:,i), [1,numEigsSrc]).*Src.laplaceBasis);
            OpTar{i} = Tar.laplaceBasis'*Tar.Ae*(repmat(fct_tar(:,i), [1,numEigsTar]).*Tar.laplaceBasis);
        end

        Fct_src = Src.laplaceBasis'*Src.Ae*fct_src;
        Fct_tar = Tar.laplaceBasis'*Tar.Ae*fct_tar;

        %% Fmap Computation
        Dlb = (repmat(Src.eigenvalues, [1,numEigsTar]) - repmat(Tar.eigenvalues', [numEigsSrc,1])).^2;
        Dlb = Dlb/norm(Dlb, 'fro')^2;
        constFct = sign(Src.laplaceBasis(1,1)*Tar.laplaceBasis(1,1))*[sqrt(sum(Tar.area)/sum(Src.area)); zeros(numEigsTar-1,1)];

        a = 1e-1; % Descriptors preservation
        b = 1;    % Commutativity with descriptors
        c = 1e-3; % Commutativity with Laplacian 
        funObj = @(F) deal( a*sum(sum((reshape(F, [numEigsTar,numEigsSrc])*Fct_src - Fct_tar).^2))/2 + b*sum(cell2mat(cellfun(@(X,Y) sum(sum((X*reshape(F, [numEigsTar,numEigsSrc]) - reshape(F, [numEigsTar,numEigsSrc])*Y).^2)), OpTar', OpSrc', 'UniformOutput', false)), 2)/2 + c*sum( (F.^2 .* Dlb(:))/2 ),...
                    a*vec((reshape(F, [numEigsTar,numEigsSrc])*Fct_src - Fct_tar)*Fct_src') + b*sum(cell2mat(cellfun(@(X,Y) vec(X'*(X*reshape(F, [numEigsTar,numEigsSrc]) - reshape(F, [numEigsTar,numEigsSrc])*Y) - (X*reshape(F, [numEigsTar,numEigsSrc]) - reshape(F, [numEigsTar,numEigsSrc])*Y)*Y'), OpTar', OpSrc', 'UniformOutput', false)), 2) + c*F.*Dlb(:));
        funProj = @(F) [constFct; F(numEigsTar+1:end)];

        F_lb = zeros(numEigsTar*numEigsSrc, 1); F_lb(1) = constFct(1);

        % Compute the optional functional map using a quasi-Newton method.
        options.verbose = 1;
        F_lb = reshape(minConf_PQN(funObj, F_lb, funProj, options), [numEigsTar,numEigsSrc]);

        %%
        [F_lb2, ~] = icp_refine(Src.laplaceBasis, Tar.laplaceBasis, F_lb, 5);

        %% Evaluation
        % Compute the p2p map

        % fmap before ICP (for comparison)
        pF_lb = knnsearch((F_lb*Src.laplaceBasis')', Tar.laplaceBasis);
        
        % fmap after ICP 
        pF_lb2 = knnsearch((F_lb2*Src.laplaceBasis')', Tar.laplaceBasis);

        C=F_lb2;
        C_old=C;
        
        %Zoout
        pF_lb2_old=pF_lb2;
        [C, pF_lb2] = ZO(C,Tar,Src,TarLaplaceBasis,SrcLaplaceBasis,pF_lb2,params); 
       
        output=TarLaplaceBasis(:,1:params.iters+params.init_tar)*C*SrcLaplaceBasis(:,1:params.iters+params.init_src)'*(Src.Ae*Src.X);
        Joints_Target=S*output;

        l=SymBreaker(landmarks1,Joints_Target,KT);
        if isequal(l, landmarks1)
            break;
        else
            if(iters==3)
                disp('WARNING: Symmetry hasn''t been solved')
            else
                landmarks1=l;
            end
        end
    end
    
   % [C, pF_lb2] = map_boost2(Src,Tar,C,pF_lb2,1);
   % pF_lb2_old=pF_lb2;
   % [C, pF_lb2] = ZO(C,Tar,Src,TarLaplaceBasis,SrcLaplaceBasis,pF_lb2,params);


    N.TRIV=Src.T;N.VERT=Src.X;N.n=size(N.VERT,1);N.m=size(N.TRIV,1);
    M.TRIV=Tar.T;M.VERT=Tar.X;M.n=size(M.VERT,1);M.m=size(M.TRIV,1);
    colors = create_colormap(N,N);
    figure
    subplot(131), colormap(colors), plot_scalar_map(N, 1:N.n), shading flat; freeze_colors; axis off
    subplot(132), colormap(colors(pF_lb2_old,:)), plot_scalar_map(M, 1:M.n), shading flat; view([0 90]); freeze_colors; axis off
    subplot(133), colormap(colors(pF_lb2,:)), plot_scalar_map(M, 1:M.n), shading flat; view([0 90]); axis off
        
    output=TarLaplaceBasis(:,1:params.iters+params.init_tar)*C*SrcLaplaceBasis(:,1:params.iters+params.init_src)'*(Src.Ae*Src.X);
    Joints_Target=S*output;

    save(['../Results/Res1/result_',srcmesh(1:end-4),'.mat'],'pF_lb2','Tar','Src','landmarks1','landmarks2','C','output','Joints_Target','C_old')
    fileid=fopen(['../Results/Dato_',srcmesh(1:end-4) ,'.obj'],'w');
    fprintf(fileid,'v %6.6f %6.6f %6.6f\n',Src.X');
    fprintf(fileid,'f %d %d %d\n',Src.T');
    fclose(fileid);

end