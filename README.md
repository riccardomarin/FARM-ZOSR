# FARM-ZOSR
Marin, R. and Melzi, S. and Rodolà, E. and Castellani, U., High-Resolution Augmentation for Automatic Template-Based Matching of Human Models, 3DV 2019

<p align="center">
<img src="teaser.png"
</p>
  
## Contents
* [Quick-start](https://github.com/riccardomarin/FARM-ZOSR#Quick-start)
* [Requirements](https://github.com/riccardomarin/FARM-ZOSR#requirements)
* [Citation](https://github.com/riccardomarin/FARM-ZOSR#citation)
* [License](https://github.com/riccardomarin/FARM-ZOSR#license)
* [Acknowledgements](https://github.com/riccardomarin/FARM-ZOSR#acknowledgements)

## Quick-start
The code runs over all meshes inside "Testset" directory. 

To run the whole pipline adjust the paths of Matlab and Python interpreters inside the file: 
```
Pipeline\run_me.bat
```
and run it.

You can also run each step individually, following this order:
```
First_round.m
Local_patch.m
Fitting.py
ARAP_HRA.m
Local_HRA.m
```

We provide a shapes from FAUST test scan to verify the setup is done correctly.
The output is stored in the directory:

```
Results\ARAP
```

Other directories contain results after each steps and other useful computations (e.g. FMAP correspondence, landmarks, hands and head patches).

The code compute one step of High-Detail Augmentation and one step of Local High-Detail Augmentation. To replicate paper results, you have to perform more steps.

## Requirements
This code is tested over Windows 10 64bit w\ Matlab 2018a, and Python 2.7 (but parsing to 3 should be easy). 
All necessary files are already conteined inside this repository.

Several pieces of this pipeline come from third parts contributions; in particular we would list the following credits:
* SMPL model: http://smpl.is.tue.mpg.de
* File readers, ARAP implementation and subdivision methods: https://github.com/alecjacobson/gptoolbox
* Functional Maps frameworks (w\ commutativity): http://www.lix.polytechnique.fr/~maks/publications.html
* Open3d python library: http://www.open3d.org/
* MeshFix: https://github.com/MarcoAttene/MeshFix-V2.1
* Remesh (Qslim): http://tosca.cs.technion.ac.il
* Discrete Time Evolution Process (DEP) for landmarks: https://sites.google.com/site/melzismn/publications
* FLANN: https://www.cs.ubc.ca/research/flann/
* Coherent Point Drift (CPD): https://sites.google.com/site/myronenko/research/cpd
* Curvature computation: https://github.com/gpeyre/matlab-toolboxes/tree/master/toolbox_graph

Finally, some Matlab ToolBoxes are required (e.g. Symbolic, Parallel Computing).

## Citation
If you use this code, please cite the following:
```
@article{doi:10.1111/cgf.13751,
author = {Marin, R. and Melzi, S. and Rodolà, E. and Castellani, U.},
title = {High-Resolution Augmentation for Automatic Template-Based Matching of Human Models},
booktitle={2019 International Conference on 3D Vision (3DV)},
}
```

## License
Please check the license terms (also of third parts software) before downloading and/or using the code, the models and the data. 
All code and results obtained from it not already covered by other licenses has to be intendend only for non-commercial scientific research purposes.
Any other use, in particular any use for commercial purposes, is prohibited. This includes, without limitation, incorporation in a commercial product, use in a commercial service, or production of other artefacts for commercial purposes including, for example, 3D models, movies, or video games. 
