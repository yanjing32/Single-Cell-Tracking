function [ncells,maskLabel3,maskLabel3props,mask3] = segmentation_cellfilter(maskLabel,lower_thresh,upper_thresh,ncells)

% Step 3: filter out small and huge cells that are unlikely to be real.

% Input:
% maskLabel: segmented cells with number from last step.
% Lower_thresh: minimal area to be considered as cells. Default value = 20;
% Higher_thresh: maximal area to be considered as cells. Default value = 500;
% ncells: number of unfiltered cells. 
% Note: one might want to use other criteria to filter cells, such as aspect
% ratio, but all of them are a bit subjective.

maskLabelprops = regionprops(maskLabel,'Area');
mask3=zeros(size(maskLabel)); % create another mask where only correct cells have value 1.

% Spill out a plot to show the distribution
% temp = zeros(length(maskLabel3props),1);
% for n = 1:length(maskLabel3props)
% temp(n,1) = maskLabel3props(n).Area;
% end
% [N,edges] = histcounts(temp);
% figure;bar(edges(1:end-1),N);

for i=1:ncells,
    if maskLabelprops(i).Area>lower_thresh && maskLabelprops(i).Area<upper_thresh;
        mask3(maskLabel==i)=1;
    end
    if mod(i,100)==0
        disp(i)
    end
end
% mask3(maskLabel>0)=1;

maskLabel3 = bwlabeln(mask3);  % renumber the cells. 
maskLabel3props = regionprops(maskLabel3,'Area');
ncells = max(maskLabel3(:))
