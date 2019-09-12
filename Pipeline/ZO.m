%%%%%
% Code for article:
% Marin, R. and Melzi, S. and Rodolà, E. and Castellani, U., High-Resolution Augmentation for Automatic Template-Based Matching of Human Models, 3DV 2019
% Github: https://github.com/riccardomarin/FARM-ZOSR
%%%%%

function [C, pF_lb2] = ZO(C,Tar,Src,TarLaplaceBasis,SrcLaplaceBasis,pF_lb2,params)
   % [pF_lb2]=flann_search((C*Src.laplaceBasis(:,1:30)'), Tar.laplaceBasis(:,1:50)',1,params);
    for k=1:params.iters
   %     k
        Pi=sparse([1:Tar.nv], pF_lb2,1,Tar.nv,Src.nv);
        C= TarLaplaceBasis(:,1:params.init_tar+k)'*Tar.Ae*Pi*SrcLaplaceBasis(:,1:params.init_src+k);
        [pF_lb2]=flann_search((C*SrcLaplaceBasis(:,1:30+k)'), TarLaplaceBasis(:,1:50+k)',1,params);
    end
end