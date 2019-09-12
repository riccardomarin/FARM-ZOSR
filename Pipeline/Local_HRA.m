%%%%%
% Code for article:
% Marin, R. and Melzi, S. and Rodolà, E. and Castellani, U., High-Resolution Augmentation for Automatic Template-Based Matching of Human Models, 3DV 2019
% Github: https://github.com/riccardomarin/FARM-ZOSR
%%%%%

clear all;

list = dir('../Results/dato_*.obj');
addpath(genpath('..'));


    for f=1:size(list,1)

    name=list(f).name(6:end);

    o_smpl = readObj(['../results/ARAP/arap_',name]);
    [v f] = readOBJ(['../Results/datofull/datofull_', name]);
    M.VERT=v;M.TRIV=f;M.n=size(M.VERT,1);M.m=size(M.TRIV,1);

    curv_options.curvature_smoothing = 1;
    curv_options.verb = 0;
    [Umin,Umax,Cmin,Cmax,Cmean,Cgauss,Normal] = compute_curvature(M.VERT, M.TRIV, curv_options);

    o_target.v=v;
    o_target.f=f;

    o_target.n=per_vertex_normals(o_target.v,o_target.f);
    try_1 = abs(Cmean)>0.3;
    trisurf(o_target.f,o_target.v(:,1),o_target.v(:,2),o_target.v(:,3),try_1*1,'EdgeColor','None');

    a_arap=0.2 - (0.19 * 1/10);
    a_data=0.4 - (0.3 * 1/10);
    M.VERT=o_smpl.v;M.TRIV=o_smpl.f;M.n=size(M.VERT,1);M.m=size(M.TRIV,1);
    [idx] = knnsearch(o_smpl.v,o_target.v(try_1,:));
    idx=unique(idx);
    Selection=calc_dist_map(M, idx) < 0.002;
     f=zeros(size(o_smpl.v,1),1);
     f(Selection)=1;
     trisurf(o_smpl.f,o_smpl.v(:,1),o_smpl.v(:,2),o_smpl.v(:,3),f,'EdgeColor','None')
     
    tris_to_keep = Selection(M.TRIV(:,1)) | Selection(M.TRIV(:,2)) | Selection(M.TRIV(:,3));

    [v,f]=local_refinement(M.VERT,M.TRIV,tris_to_keep);

    o_smpl.v=v;
    o_smpl.f=f;

    delta_t=0.01;


    new=o_smpl.v;
    disp(name);
    for i=1:400

    if(a_arap>0)
        [G,E] = arap_gradient(o_smpl.v,o_smpl.f,new);
        if(E>0.5)
            o_smpl.v=new;
            disp(E)
        end
    else
        G=zeros(6890,3);
    end

    o_new.v=new;
    o_new.f=o_smpl.f;
    o_new.n=per_vertex_normals(o_new.v,o_new.f);
    if (mod(i, 50) == 1)
        targetId = knnsearch(o_target.v, new);
    end
    G2=new-o_target.v(targetId,:);
    new=new-delta_t*(a_arap*G+a_data*G2);
    if(mod(i,5)==0)
        disp(i);
     trisurf(o_smpl.f,new(:,1),new(:,2),new(:,3));
     view(0,90);
     pause(0.01);
    end

    if a_arap>0.9
    a_arap=a_arap-0.005;
    end
    
    end
    fileid=fopen(['../Results/ARAPsuper/arapHRAL','_',name(1:end)],'w');
    fprintf(fileid,'v %6.6f %6.6f %6.6f\n',new');
    fprintf(fileid,'f %d %d %d\n',o_smpl.f');
    fclose(fileid);
    

end
