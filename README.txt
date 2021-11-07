Pedestrian detection combining RGB and dense LIDAR data
===============
Bib Reference:
@INPROCEEDINGS{FusionIROS14,
author={Premebida, C. and Carreira, J. and Batista, J. and Nunes, U.},
booktitle={IROS},
title={Pedestrian detection combining {RGB} and dense {LIDAR} data},
year={2014},
month={Sep},
pages={0-1},
organization={IEEE}, }
===============
The codes of this package were developed under Linux with Matlab R2012b 64-bit. There is no guarantee it will run on other operating systems or Matlab versions (though it probably will).
As sub-components, this tool uses third-party software:
1. Discriminatively trained deformable part models (DPM), version 5. http://www.cs.berkeley.edu/~rbg/latent/
@misc{voc-release5,
 author = "Girshick, R. B. and Felzenszwalb, P. F. and McAllester, D.",
 title = "Discriminatively Trained Deformable Part Models, Release 5",
 howpublished = "http://people.cs.uchicago.edu/~rbg/latent-release5/"}

2. LIBSVM -- A Library for Support Vector Machines. http://www.csie.ntu.edu.tw/~cjlin/libsvm/
@article{CC01a,
 author = {Chang, Chih-Chung and Lin, Chih-Jen},
 title = {{LIBSVM}: A library for support vector machines},
 journal = {ACM Transactions on Intelligent Systems and Technology},
 volume = {2},
 issue = {3},
 year = {2011},
 pages = {27:1--27:27},
}
===============

Introduction
------------
Main script: 'DEMO_run_on_testing_set.m'

Please refer KITTI benchmark for details and useful tool-kit:
http://www.cvlibs.net/datasets/kitti/eval_object.php


Matlab main functions
----------------
'Fun_dense_range_map.m' outputs a dense range map
'Fun_fea_4_test.m' extracts some attributes from detection windows
'Fun_rescore_svm.m' uses Libsvm for rescoring detections
'NMS.cpp' performs Non-Max. Suppression
'fun_dense3D.cpp' upsampling filter


Third party codes/software:
----------------
'svmpredict': from LIBSVM.
'imgdetect' and dependencies: from DPM, version 5.


Support
-------
For any query/suggestion/complaint:
cpremebida(at)isr.uc.pt



Versions history and comments
----------------
Aug/2014: first release.



----------------
The codes are provided "as is", without warranty of any kind,
express or implied.
================================================================
