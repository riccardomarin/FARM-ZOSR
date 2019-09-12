function [VV, FF] = local_refinement(V,F,tris_to_keep)

[E2V, T2E, E2T, T2T] = connectivity(F);

while 1
idx_tris=find(tris_to_keep);
neig=reshape(T2T(idx_tris,:),[],1);
idx_not_taken=find(not(ismember(neig,idx_tris)));
not_taken=neig(idx_not_taken);
counts =hist(not_taken,unique(not_taken));
un_del=unique(not_taken);
duplicati=un_del(counts>1);
if isempty(duplicati)
    break;
end
tris_to_keep(duplicati)=true;
end

M.VERT=V;M.TRIV=F;M.n=size(M.VERT,1);M.m=size(M.TRIV,1);

V=extract_patch(M,tris_to_keep);

% Suddivisione patch locale
[VV,FF,SS,J, on_boundary, Sodd] = loop_local(V.VERT,V.TRIV, 1);

% Riaggancio patch locale a globale
M_new=M.VERT;
M_new(V.fullshape_idx,:)=VV([1:V.n],:);
M_new=[M_new;VV(V.n+1:size(VV,1),:)];
new_TRIV=M.TRIV(not(tris_to_keep),:);
triv_sub=FF;
triv_sub(triv_sub>V.n)=triv_sub(triv_sub>V.n)-V.n+M.n;
triv_sub(triv_sub<=V.n)=V.fullshape_idx(triv_sub(triv_sub<=V.n));
new_TRIV=[new_TRIV;triv_sub];

N.VERT=M_new; N.TRIV=new_TRIV; N.n=size(N.VERT,1); N.m=size(N.TRIV,1);


% Sistemazione buchi
% Individuazione Odd Boundary Vertices su N
Boundary_Odd = Sodd * V.VERT;
Boundary_Odd = Boundary_Odd(on_boundary,:);
i2 = knnsearch(N.VERT,Boundary_Odd);

% Individuazione 
idx_tris_to_keep = find(tris_to_keep);
idx_tris_to_not_keep = find(not(tris_to_keep)); 
[E2V, T2E, E2T, T2T] = connectivity(M.TRIV);
edge_to_keep=reshape(abs(T2E(idx_tris_to_keep,:)),[],1);
edge_to_not_keep=reshape(abs(T2E(idx_tris_to_not_keep,:)),[],1);
idx_shared = ismember(edge_to_keep,edge_to_not_keep);
shared_edges=edge_to_keep(idx_shared);
faces_shared = E2T(shared_edges,[1,2]);
vertex_shared = E2V(shared_edges,:);

[E2V, T2E, E2T, T2T] = connectivity(N.TRIV);
del = [];
face_to_add = [];
for i=1:size(vertex_shared,1)
    flag=ismember(E2V,vertex_shared(i,:));
    ed=find(sum(flag,2)>1);
    break_T=E2T(ed);
    break_T_vert = N.TRIV(break_T,:);
    free_v=ismember(N.TRIV(break_T,:),vertex_shared(i,:));
    idx_free_v=N.TRIV(break_T,(not(free_v)));
    
    subset=N.TRIV(find(sum(ismember(N.TRIV, i2),2)),:);
    idx_good=find(sum(ismember(subset,vertex_shared(i,:)),2));
    subset=reshape(subset(idx_good,:),[],1);
    subset=subset(not(ismember(subset,vertex_shared(i,:))));
    subset=subset(ismember(subset,i2));
    
    [a,b] = histc(subset,unique(subset));
    y = a(b);    
    winner = find(y>1);
    winner_idx=subset(winner(1));
    assert (ismember(winner_idx,i2));

    face_to_add=[face_to_add;winner_idx,idx_free_v,  vertex_shared(i,1);
        idx_free_v,winner_idx,  vertex_shared(i,2)];

    del=[del,break_T];
end

for i=1:length(del)
    verts=N.TRIV(del(i),:);
    face1=face_to_add(i*2-1,:);
    face2=face_to_add(i*2,:);
    edges = [verts([1,2]);verts([2,3]);verts([3,1])];
    f1 = ismember(edges,face1);
    n = find(sum(f1,2)>1);
    excluded=find(not(ismember(face1,edges(n,:))));
    new_face1=[edges(n,:),face1(excluded)];
    
    f1 = ismember(edges,face2);
    n = find(sum(f1,2)>1);
    excluded=find(not(ismember(face2,edges(n,:))));
    new_face2=[edges(n,:),face2(excluded)];
       
    face_to_add(i*2-1,:)=new_face1;
    face_to_add(i*2,:) = new_face2;
end
N.TRIV(del,:)=[];
N.TRIV=[N.TRIV;face_to_add];

VV=N.VERT; FF=N.TRIV;
end