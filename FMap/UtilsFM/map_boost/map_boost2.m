%%
function [C_out,matches_out] = map_boost2(Src,Tar, C,pF_lb2,plotflag)

%addpath('./tools/')
%addpath(genpath('./ema_tools'))
% M = load_obj('./Dati/smpl_base_male.obj');
% 
% N = load_obj('./Faust/055_191/Dato_test_scan_191.obj');
% load('./Faust/055_191/result_test_scan_191.mat')

M.evecs = Tar.laplaceBasis;
M.S = Tar.Ae;
M.n=Tar.nv;
M.VERT=Tar.X;
M.TRIV=Tar.T;

N.evecs = Src.laplaceBasis;
N.S = Src.Ae;
N.n = Src.nv;
N.VERT=Src.X;
N.TRIV=Src.T;


C_in = C;
matches_in = pF_lb2;

options = struct;
options.refine_iters = 20;

fps = fps_euclidean(M.VERT, 1e3, 1);
F = sparse(matches_in(fps), 1:length(fps), 1, N.n, length(fps));
G = sparse(fps, 1:length(fps), 1, M.n, length(fps));

% r = 0.04*sqrt(sum(calc_tri_areas(M)));
% F = calc_shot(N.VERT', N.TRIV', 1:N.n, 9, r, 3)';
% G = calc_shot(M.VERT', M.TRIV', 1:M.n, 9, r, 3)';

[C_out, matches_out] = refine_matches(N, M, F, G, C_in, options);
if exist('plotflag')==1
figure, colormap(bluewhitered)
subplot(121), imagesc(C_in), axis image
subplot(122), imagesc(C_out), axis image

colors = create_colormap(N,N);
figure
subplot(131), colormap(colors), plot_scalar_map(N, 1:N.n), shading flat; freeze_colors; axis off
subplot(132), colormap(colors(matches_in,:)), plot_scalar_map(M, 1:M.n), shading flat; view([0 90]); freeze_colors; axis off; title('init')
subplot(133), colormap(colors(matches_out,:)), plot_scalar_map(M, 1:M.n), shading flat; view([0 90]); axis off; title('filtered')
end
end
