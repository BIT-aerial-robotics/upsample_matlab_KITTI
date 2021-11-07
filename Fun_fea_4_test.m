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
function [Fea_c, Fea_l] = Fun_fea_4_test(ds_c,ds_l,Ima2)

% %*********************** VISION******************************************
nfea = 4;
n = size(ds_c,1);
Fea_c = zeros(n,nfea);

for k=1:n
Fea_c(k,1) = ds_c(k,6);

pw = floor(ds_c(k,1)):ceil(ds_c(k,3));
if pw(1)<1, pw(1)=1; end
if pw(end)>size(Ima2,2), pw(end)=size(Ima2,2); end
pbott = round(ds_c(k,4));
H = pbott - ds_c(k,2);
W = length(pw);

Fea_c(k,2) = ds_c(k,1) + W/2;
Fea_c(k,3) = ds_c(k,2) + H/2;    
    
ix = round([ds_c(k,1),ds_c(k,2),ds_c(k,3),ds_c(k,4)]);
A_ima = Ima2(ix(2):ix(4),ix(1):ix(3));
Adet = numel(A_ima);
Adet = sum(sum(A_ima<1)) / Adet;
Fea_c(k,4) = Adet;

end

% %*********************** LIDAR ******************************************
n = size(ds_l,1);
Fea_l = zeros(n,nfea);

for k=1:n
Fea_l(k,1) = ds_l(k,6);   

pw = floor(ds_l(k,1)):ceil(ds_l(k,3));
if pw(1)<1, pw(1)=1; end
if pw(end)>size(Ima2,2), pw(end)=size(Ima2,2); end
pbott = round(ds_l(k,4));
H = pbott - ds_l(k,2);
W = length(pw);

Fea_l(k,2) = ds_l(k,1) + W/2;
Fea_l(k,3) = ds_l(k,2) + H/2;  

ix = round([ds_l(k,1),ds_l(k,2),ds_l(k,3),ds_l(k,4)]);
A_ima = Ima2(ix(2):ix(4),ix(1):ix(3));
Adet = numel(A_ima);
Adet = sum(sum(A_ima<1)) / Adet;
Fea_l(k,4) = Adet;

end

end %END Main function
