% % 
% % CPremebida: 2014
% % updated on: 12/June
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
function Ima_Range = Fun_dense_range_map(calib,calib_dir,base_dir,...
    frame,ImaRGB, channel_no)

T = Fun_open_calib_selfdata(calib.name,calib_dir);

% velo= [];
%accumulate the recent 10 frames
% for i_int = 1:3
fd = fopen(sprintf('%s/%06d.bin',base_dir,frame),'rb');
    if fd < 1
        fprintf('No LIDAR files !!!\n');
        keyboard
    else
    velo = fread(fd,[4 inf],'single')';
    fclose(fd);
    end
%     velo = [velo; velo_i];
% end

% remove all points behind image plane (approximation),
%Chuanbebe: in flying systems, may revise
idx = velo(:,1)< 5;
velo(idx,:) = [];

%20210908 revised by Chuanbeibei, the homogeneous coordinates:
velo(:,4) = 1;

% project to image plane (exclude luminance)
T_tol = T.P0 * T.R0_rect * T.Tr_velo_to_cam;
px = (T.P0 * T.R0_rect * T.Tr_velo_to_cam * velo')';
px(:,1) = px(:,1)./px(:,3);
px(:,2) = px(:,2)./px(:,3);


fdvelo = fopen('velo_data', 'w');
[r_velo, c_velo] = size(velo);
for i = 1:r_velo
    for j = 1:c_velo-1
        fprintf(fdvelo, '%g,', velo(i,j));
    end
    fprintf(fdvelo, '%g', velo(i,c_velo));
    fprintf(fdvelo, '\n');
end
fclose(fdvelo);

fdimg = fopen('pngvelo_img_data', 'w');
[r_px, c_px] = size(px);
for i = 1:r_px
    fprintf(fdimg, '%g,%g', px(i,1), px(i,2));
    fprintf(fdimg, '\n');
end
fclose(fdimg);

%20210908 revised by Chuanbeibei, replace the range with the three
%coordinates of PC:
% channel_no = 1; 
if channel_no == 1
    px(:,3) = velo(:,1);
elseif channel_no == 2
    px(:,3) = velo(:,2);
elseif channel_no == 3
    px(:,3) = velo(:,3);
end

% % -----------------------------------------------------------------------
ix = px(:,1)<1;                 px(ix,:)=[];
ix = px(:,1)>size(ImaRGB,2);    px(ix,:)=[];
ix = px(:,2)>size(ImaRGB,1);    px(ix,:)=[];
% % Ordering
Pts = zeros(size(px,1),4);
Pts = sortrows(px,2);
% % ======================= Interpolation / Upsampling :::
c_px = floor(min(px(:,2)));
i_size = size(ImaRGB(c_px:end,:,1));
Ima3D = zeros( size(ImaRGB(:,:,1)) );

% Simply type: mex fun_dense3D.cpp
Ima3D(c_px:end,:) = fun_dense3D(Pts,[c_px i_size]); % MEX-file
% % -----------------------------------------------------------------------
% Normalization 8 bits
Ima_Range = uint8( 255*Ima3D/max(max(Ima3D)) ); % :)

end %END main Function
