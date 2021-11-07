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
function [ds_c,ds_l] = Fun_discard(ds_c,ds_l)

nc = size(ds_c,1);
ic = false(1,nc);

% % % 
Thr = -3.0; %Threshold

    for c=1:nc
        if ds_c(c,6) < Thr
            ic(c) = true;
        end
    end
ds_c(ic,:) = [];

% %------------------------------------------------------------------------
nl = size(ds_l,1);
il = false(1,nl);

Thr = -1.0; %Threshold

    for l=1:nl
        if ( nc>1 & ds_l(l,6)< Thr )
            il(l) = true;
        end
    end
ds_l(il,:) = [];
end %End Function
