% % Remark:
% % Before running this m-file, set 'data_path' to the directory where you 
% % have downloaded KITTI testing dataset.
% % 
% % Third-party software-packages dependencies:
% % 1. Discriminatively trained deformable part models (DPM), version 5
% % http://www.cs.berkeley.edu/~rbg/latent/
% % 2. LIBSVM -- A Library for Support Vector Machines
% % http://www.csie.ntu.edu.tw/~cjlin/libsvm/
% % -----------------------------------------------------------------------
% % This code has the following main tools:
% % 1. 'Fun_dense_range_map' outputs a dense range map 
% % 2. 'imgdetect' is from voc-release5
% % 3. 'NMS' performs Non-Max. Suppression (see NMS.cpp)
% % 4. 'Fun_fea_4_test' extracts some attributes from detection windows
% % 5. 'Fun_rescore_svm' uses Libsvm for rescoring detections
% % -----------------------------------------------------------------------
% % 
% % Reference:
% % @INPROCEEDINGS{FusionIROS14,
% % author={Premebida, C. and Carreira, J. and Batista, J. and Nunes, U.},
% % booktitle={IROS},
% % title={Pedestrian detection combining {RGB} and dense {LIDAR} data},
% % year={2014},
% % month={Sep},
% % pages={0-1},
% % organization={IEEE}, }
% %------------------------------------------------------------------------
clear; dbstop error; clc;
warning off; %close all;

data_path = '...your_dir/KITTI/Dataset/TEST/';
base_dir = [data_path,'velodyne'];
calib_dir = [data_path,'calib/'];
path_ima = [data_path,'image_2/'];

data_path = 'kittidataset/train/'; %put the dataset here
base_dir = [data_path,'data_object_velodyne/training/velodyne/'];
calib_dir = [data_path,'data_object_calib/training/calib/'];
path_ima = [data_path,'data_object_image_2/training/image_2/'];
% % % load data
calib = dir([calib_dir,'*.txt']);   %1 file
ima   = dir([path_ima,'*.png']);    %multiple files

% % % % % --------------------- Load trained DPM-Models -------------------
MC = load(['./DPM_Models/','DPM_4comp_RGB.mat']);
ML = load(['./DPM_Models/','DPM_4comp_LIDAR.mat']);
% %------------------------------------------------------------------------
c1 = load(['./SVM_Models/','rbfSVM_vision.mat']);
c2 = load(['./SVM_Models/','rbfSVM_lidar.mat']);

load(['./SVM_Models/','CNorm_vision.mat']); %'CNorm'
CNorm_c = CNorm; clear CNorm
load(['./SVM_Models/','CNorm_lidar.mat']);  %'CNorm'
CNorm_l = CNorm; clear CNorm

% % Remark:
% % Necessary voc-release5 packages (addpath...):
% % ./voc-release5/gdetect/ ./voc-release5/features/ ./voc-release5/model/
% ./voc-release5/test/ ./voc-release5/bin/

fst_frame = 0; nt_frames = 7480;
% %------------------------------------------------------------------------
for frame = fst_frame: 1: nt_frames
% tic
fd = fopen( [path_ima,ima(frame+1).name] );
if fd < 1
    fprintf('Cound not open RGB image !!!\n');    keyboard
else
    ImaRGB = imread( [path_ima,ima(frame+1).name] );
end
fclose(fd);

%20210908 revised by Chuanbeibei, 
for channel_no = 1:3
ImaRange = Fun_dense_range_map(calib(frame+1),calib_dir,base_dir,frame,ImaRGB, channel_no);

% % % =====================================================================
% voc-release5 is required (http://www.cs.berkeley.edu/~rbg/latent/)
% [ds_c, bs] = imgdetect(ImaRGB, MC.model, MC.model.thresh);
%     if ~isempty(bs)
%       unclipped_ds = ds_c(:,1:4);
%       [ds_c, bs, rm] = clipboxes(ImaRGB, ds_c, bs);
%       unclipped_ds(rm,:) = [];
%     end
%     
% [ds_l, bs] = imgdetect(ImaRange, ML.model, ML.model.thresh);
%     if ~isempty(bs)
%       unclipped_ds = ds_l(:,1:4);
%       [ds_l, bs, rm] = clipboxes(ImaRange, ds_l, bs);
%       unclipped_ds(rm,:) = [];
%     end
% % % =====================================================================
% % % % % ........................... NMS :::
% Aint = 0.4;
% if size(ds_c,1)>0, 
%     [~, vals] = sort(ds_c(:,6)); iroi = NMS([ds_c(:,1:4),vals] , Aint); 
%     ds_c = ds_c(iroi,:);
% end
% if size(ds_l,1)>0, 
%     [~, vals] = sort(ds_l(:,6)); iroi = NMS([ds_l(:,1:4),vals] , Aint);
%     ds_l = ds_l(iroi,:);
% end
% % % ------------ SVM-based Rescoring routine
% % % Attributes/feature calculation
% [Fea_c, Fea_l] = Fun_fea_4_test(ds_c,ds_l,ImaRange);
% 
% % % Re-scoring using RBF-SVM ('libsvm-3.12')
% [Yc, Yl] = Fun_rescore_svm(Fea_c,Fea_l,c1,c2,CNorm_c,CNorm_l);
% ds_c(:,6) = Yc; ds_l(:,6) = Yl;
% % %------------------------------------------------------------------------
% [ds_c,ds_l] = Fun_discard(ds_c,ds_l); %Discard weak detections
% 
% % % % % Final NMS :::::::::
% DetW = [ds_c; ds_l];
% Aint = 0.4;
% if size(DetW,1)>0
% [~, vals] = sort(DetW(:,6));
% iroi = NMS([DetW(:,1:4),vals] , Aint);
% DetW = DetW(iroi,:);
% end
% ========== Some display
% figure(1); cla; imshow(ImaRGB);
% figure(2); cla; imshow(ImaRange);
% Fun_plot_ROI(DetW,'r','-',2,'g');
% title( sprintf('|DetW|=%d',size(DetW,1)) );
% if channel_no ==1 
%    XYZ = zeros(size(ImaRange, 1), size(ImaRange,2), 3);
% end

XYZ(:,:,channel_no) = ImaRange; 
imwrite(ImaRange, sprintf('Frame_%1d_channel_%1d.png',frame, channel_no));
 
end

imwrite(XYZ, sprintf('%06d_2.png',frame));

 % ==========
fprintf('Frame:%1d of %1d \n',frame,nt_frames);
clear XYZ; 
% toc
end


