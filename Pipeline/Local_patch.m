%%%%%
% Code for article:
% Marin, R. and Melzi, S. and Rodolà, E. and Castellani, U., High-Resolution Augmentation for Automatic Template-Based Matching of Human Models, 3DV 2019
% Github: https://github.com/riccardomarin/FARM-ZOSR
%%%%%

addpath(genpath('..\FMap'));
list = dir('../Testset/*.*');
list = list(3:end);

for fm=1:size(list,1)
    name=list(fm).name(1:end-4);
    localMaps(name);
end

exit;