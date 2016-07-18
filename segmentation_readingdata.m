function [imgfilter,img] = segmentation_readingdata(tif_file_name,range1,range2,rangeZ)

% Step 1: Read the 3D image into Matlab and apply basic bandpass filtering

% Inputs
% tif_file_name
% range1 = xrange, range 2 = yrange
% rangeZ: This range needs to be finetuned. Generally, tracking does not work for more than 25 um.

% Outputs
% img: raw 3D images
% imgfilter: filtered 3D images 

I = imread(tif_file_name,1);
info = imfinfo(tif_file_name);
img1raw = zeros(size(I,1), size(I,2), length(info));
for i=1:length(info)
    I = imread(tif_file_name,i);
    img1raw(:,:,i)=I;  
%     disp(i)
end

img = double(img1raw(range1,range2,rangeZ)); 

%filter image
imgfilter = bpass3D_final(img1raw,1,3,3); % Using crocker and grier method to bandpass3D data. This improves the sementation a lot. 
imgfilter = imgfilter(range1,range2,rangeZ); 

