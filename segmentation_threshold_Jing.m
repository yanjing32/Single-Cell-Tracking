function [maskLabel,mask,ncells] = segmentation_threshold_Jing(imgfilter,watershed_value)

% Step 2: Segment individual cells using watershed method 

% inputs:
% imgfilter: filtered 3D image from step 1
% watershed_value: Key parameter to optimize
% recommended value is 100-1000

% output:
% mask: segmented cells. Not numbered
% maskLabel: Segmented cells. Numbered
% ncells: number of cells found in this step

g = imhmin(imcomplement(imgfilter),watershed_value); 
L = watershed(g); 
BW = ones(size(g));
BW (L==0) = 0; % find the boundary and assign zero value. This step effectively separates nearby cells.
imgMask = imgfilter.*BW; 

%  NOTE: Due to degregation of signal in z direction, it is better to find
%  threshold independently for each z-slice. 

for n = 1:size(imgMask,3)
        arr = imgMask(:,:,n);
        arr = arr./max(max(arr));
        BW = im2bw(arr,graythresh(arr)); % automatically find threshold value. Note this works better if first devided by max value. 
        imgMask(:,:,n) = arr.*BW;

end

mask = zeros(size(imgMask)); mask(imgMask>0)=1; % Now cell region is labeled 1 and non-cell region is zero
maskLabel = bwlabeln(mask(:,:,1:size(imgfilter,3))); % label the cells with numbers
ncells = max(maskLabel(:))% output total number of cells as a quick check.

% out put zstack images for quality control
if exist('imagefilter.tif') == 2;
    delete('imagefilter.tif');
end
temp = uint16(imgfilter);
for frame = 1:size(mask,3);
imwrite(temp(:,:,frame), 'imagefilter.tif', 'tif', 'WriteMode', 'append', 'compression', 'none');
end
