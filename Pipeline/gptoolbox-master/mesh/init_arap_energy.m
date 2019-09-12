function edge_set=init_arap_energy(V,F)
C = cotangent(V,F);
 
 n = size(V,1);
 m = size(F,1);
 nr = size(F,1);
  
 I = F(:,[2 3 1]);
 J = F(:,[3 1 2]);
    
 edge_set = cell(nr,1);
 
 for r = 1:nr
      edge_set{r}.E = [I(r,:)' J(r,:)'];
      edge_set{r}.C = C(r,:);
 end

 
      Fedge_set = edge_set;
      nr = size(V,1);
      edge_set = cell(nr,1);
      V2F = sparse( ...
        F,repmat(1:size(F,1),size(F,2),1)',repmat(1:size(F,2),size(F,1),1),n,m);
      % loop over vertices
      for r = 1:nr
        [~,Fr] = find(V2F(r,:));
        edge_set{r}.E = [];
        edge_set{r}.C = [];
        for f = Fr
          edge_set{r}.E = [edge_set{r}.E;Fedge_set{f}.E];
          edge_set{r}.C = [edge_set{r}.C Fedge_set{f}.C];
        end
      end