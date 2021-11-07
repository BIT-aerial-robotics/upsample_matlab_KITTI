% 
% 
function Fun_plot_ROI(roi, cor, gtype, lw, cor2)

if nargin<1,
    error('Requires at least one input arguments: axis, bbox');
end

if nargin<2
    lw = 2; gtype = '-'; cor = 'k'; cor2 = 'y';
elseif nargin<3
    lw = 2; gtype = '-'; cor2 = 'y';
elseif nargin<4
    lw = 2; cor2 = 'y';
elseif nargin<5
    cor2 = 'y';
end

bbox = [0 0 0 0];
for k=1:size(roi,1)

    bbox(1) = roi(k,1);
    bbox(2) = roi(k,2);

    bbox(3) = roi(k,3) - roi(k,1);
    bbox(4) = roi(k,4) - roi(k,2);
    if roi(k,6)<0
    rectangle('Position',bbox, 'LineStyle', gtype,'LineWidth',lw, 'EdgeColor',cor2);
    else
    rectangle('Position',bbox, 'LineStyle', gtype,'LineWidth',lw, 'EdgeColor',cor);        
    end
end

end %End function
