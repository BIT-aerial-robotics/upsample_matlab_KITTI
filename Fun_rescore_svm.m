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
function [Yc, Yl] = Fun_rescore_svm(fea_c,fea_l,c1,c2,CNorm_c,CNorm_l)

n = size(fea_c,1);
Yc = -10*ones(n,1);

min_c  = CNorm_c.min;
range_c = CNorm_c.max - min_c;
Norm_Fea = (fea_c - repmat(min_c,n,1)) ./ repmat(range_c,n,1);
Yc(:,1) =   F_test_SVM(Norm_Fea,c1.C_model);
% % % % -------------------------------------------------------
n = size(fea_l,1);
Yl = -10*ones(n,1);

min_l  = CNorm_l.min;
range_l = CNorm_l.max - min_l;
Norm_Fea = (fea_l - repmat(min_l,n,1)) ./ repmat(range_l,n,1);
Yl(:,1) =   F_test_SVM(Norm_Fea,c2.C_model); %0.4 sec

end %End Function

% % --------------------------------------------------
% % Compile libsvm-3.12 library (http://www.csie.ntu.edu.tw/~cjlin/libsvm/)
function Y = F_test_SVM(X,model)
n = size(X,1);
[~, ~, Y] = svmpredict(ones(n,1), X, model);
end
% % --------------------------------------------------