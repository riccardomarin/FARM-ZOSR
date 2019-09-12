function [E,ER] = my_arap_energy(V,F,U,edge_set)
%%V= Vertici
% F= Facce
% C= Cotangent
% U=Arrivo
 nr = size(V,1);

  ER = zeros(nr,1);
  %
  % loop over rotations
  for r = 1:nr
    % get edges for this rotation
    Er = edge_set{r}.E;
    Cr = edge_set{r}.C;
    S = zeros(3,3);
    % loop over edges to build covariance matrix for rotation fitting
    i=Er(:,1);
    j=Er(:,2);
    ev=V(j,:)-V(i,:);
    eu = U(j,:)-U(i,:);
    S = S + (Cr(:) .* eu)'*ev;
    R = fit_rotation(S);
    % Loop over edges to compute energy contribution
    ER(r) = sum(0.5 * Cr(:) .* (diag(eu*eu') - 2*diag(ev*R*eu') + diag(ev*ev')));
  end
  E = sum(ER);