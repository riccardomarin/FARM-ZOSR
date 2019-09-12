function createcache(srcmesh,Tar)

    src = RFR_mesh(['../Testset/',srcmesh],'lqsim',6890);

    tmp = MeshInfo(src.v, src.f, 1);
    factorOK = sqrt(sum(Tar.area)/sum(tmp.area));
    src.v = src.v.*factorOK; 
    Src = MeshInfo(src.v, src.f, 200);
    landmarks1 = find_DEPlandmarks(Src,0);
    save(['../Cache/cache_', srcmesh(1:end-4)],'Src','src','landmarks1','factorOK');

    src = RFR_mesh(['../Testset/',srcmesh],'lqsim',0);
    tmp = MeshInfo(src.v, src.f, 1);
    factorOK = sqrt(sum(Tar.area)/sum(tmp.area));
    src.v = src.v.*factorOK; 
    
    fileid=fopen(['../Results/datofull/datofull_',srcmesh(1:end-4),'.obj'],'w');
    fprintf(fileid,'v %6.6f %6.6f %6.6f\n',src.v_pre'.*factorOK);
    fprintf(fileid,'f %d %d %d\n',src.f_pre');
    fclose(fileid);
    disp('end');
end