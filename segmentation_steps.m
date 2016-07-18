% This document is non-executable.
% This document gives step by step instruction to perform single cell analysis on a
% biofilm 3D image after deconvolution. 

tif_filename = 'deconed.tif'; % The deconvolved file name

% Step 1: Read data into Matlab. Start with the full x,y,z range and fine
% tune later. 

range1 = 100:370; range2 = 110:380; rangeZ = 4:35; % for the test data set
[imgfilter,img] = segmentation_readingdata(tif_filename,range1,range2,rangeZ); 

% Step 2: Key thresholding step.
watershed_value = 600; % Key parameter to optimize. Smaller value leads to more segmentation.
[maskLabel,mask,ncells] = segmentation_threshold_Jing(imgfilter,watershed_value); 
save_segmented_tif(mask);

% At this stage, need to open the segmented.tif and imgfilter.tif (for example in Huygens) to
% check if segmentation works. Depending on the quality of tracking, one
% needs to adjust the Z-range to removes slices in which signal-to-noise
% ratio is too low. Then, one need to optimize the watershed_value for
% optimum segmentation result. 

save('result.mat');

% Step 3: Filter out incorrected tracked objects.
% Noises might be counted as small cells. Cells that are correctly separated are regarded as giant cells.
% Hence, one need to set threshold values to filter out these objects. 
lower_thresh = 20; upper_thresh = 300; % representative value; need to optimize. 
[ncells,maskLabel3,maskLabel3props,mask3] = segmentation_cellfilter(maskLabel,lower_thresh,upper_thresh,ncells); 

% Step 4: Analyze the cell properties such as center position and orientation.
[direction,centers,maskLabel3props] = segmentation_cell_property(ncells,maskLabel3,maskLabel3props,imgfilter); 

% Step 5: Generate a movie going through z to double check the tracking quality. 
% Each cell is representated as a red line. 
segmentation_line_movie_new(img,imgfilter,mask3,direction,centers,2,0,0,0,1);

% Step 6: Convert the coordinate into real unit in um. 
pixel_size_x = 0.166; zstep = 0.2; % depending on the optical setting.
[direction_norm,centers_norm] = direction_and_center(direction,centers,pixel_size_x,zstep);
save('result.mat');

