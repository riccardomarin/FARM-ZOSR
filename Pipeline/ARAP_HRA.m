%%%%%
% Code for article:
% Marin, R. and Melzi, S. and Rodolà, E. and Castellani, U., High-Resolution Augmentation for Automatic Template-Based Matching of Human Models, 3DV 2019
% Github: https://github.com/riccardomarin/FARM-ZOSR
%%%%%


clear all;
addpath(genpath('..\FMap'));
list = dir('../Results/*.obj');
addpath(genpath('ARAP'));


for f=1:size(list,1)

name=list(f).name(6:end);
 
o_smpl = readObj(['../Results/Opt2/optimized2_', name]);
o_target = readObj(['../Results/dato_', name]);
o_target.n=per_vertex_normals(o_target.v,o_target.f);
addpath(genpath('gptoolbox-master'));
delta_t=0.01;


a_arap=0.5;
a_data=1;

new=o_smpl.v;
  disp(name);
for i=1:400
  
if(a_arap>0)
    [G,E] = arap_gradient(o_smpl.v,o_smpl.f,new);
    if(E>1)
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
if (i > 350)
    targetId = knnsearch(o_target.v, new);
else
   targetId=myknn2(o_new,o_target);
end
end
G2=new-o_target.v(targetId,:);
new=new-delta_t*(a_arap*G+a_data*G2);
if(mod(i,5)==0)

end

if a_arap>0.9
a_arap=a_arap-0.005;
end

end

load(['../Results/Opt2/Visualizerot_',name(1:end-4),'.mat']);
opt2=new'+trans';
rotmatrix=rotation(:,:,1);
opt2_rot=[opt2;ones(size(opt2,2),1)'];
opt2_rot=rotmatrix*opt2_rot;
opt2_rot=opt2_rot(1:3,:);

fileid=fopen(['../Results/ARAP/arapVis_',name],'w');
fprintf(fileid,'v %6.6f %6.6f %6.6f\n',opt2_rot);
fprintf(fileid,'f %d %d %d\n',o_smpl.f');
fclose(fileid);
disp('end');


load(['../Cache/cache_',name(1:end-4),'.mat'])
fileid=fopen(['../Results/ARAP/arap_',name],'w');
fprintf(fileid,'v %6.6f %6.6f %6.6f\n',new');
fprintf(fileid,'f %d %d %d\n',o_smpl.f');
fclose(fileid);

fileid=fopen(['../Results/ARAP/arap_',name],'w');
fprintf(fileid,'v %6.6f %6.6f %6.6f\n',new');
fprintf(fileid,'f %d %d %d\n',o_smpl.f');
fclose(fileid);

new = new./factorOK; 
o_target.v =  o_target.v./factorOK;

fileid=fopen(['../Results/ARAP/subsampled/arapS_',name],'w');
fprintf(fileid,'v %6.6f %6.6f %6.6f\n',new');
fprintf(fileid,'f %d %d %d\n',o_smpl.f');
fclose(fileid);

fileid=fopen(['../Results/ARAP/subsampled/datoS_',name],'w');
fprintf(fileid,'v %6.6f %6.6f %6.6f\n',o_target.v');
fprintf(fileid,'f %d %d %d\n',o_target.f');
fclose(fileid);

end
%%


clear all;
addpath(genpath('..\FMap'));
list = dir('../Results/*.obj');
addpath(genpath('ARAP'));
addpath(genpath('gptoolbox-master'));

for f=1:size(list,1)

name=list(f).name(6:end);
 
o_smpl = readObj(['../Results/ARAP/arap_',name]);

[v f ss j] = loop(o_smpl.v,o_smpl.f,1);
o_smpl.v=v;
o_smpl.f=f;

[v f] = readOBJ(['../Results/datofull/datofull_', name]);
o_target.v=v;
o_target.f=f;

o_target.n=per_vertex_normals(o_target.v,o_target.f);

delta_t=0.01;


a_arap=0.2;
a_data=0.4;


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
%a_data=a_data+0.005;
end


fileid=fopen(['../Results/ARAPsuper/arapsup_',name],'w');
fprintf(fileid,'v %6.6f %6.6f %6.6f\n',new');
fprintf(fileid,'f %d %d %d\n',o_smpl.f');
fclose(fileid);

load(['../Cache/cache_',name(1:end-4),'.mat'])
new = new./factorOK; 
o_target.v =  o_target.v./factorOK;

fileid=fopen(['../Results/ARAPsuper/arapSsup_',name],'w');
fprintf(fileid,'v %6.6f %6.6f %6.6f\n',new');
fprintf(fileid,'f %d %d %d\n',o_smpl.f');
fclose(fileid);

end