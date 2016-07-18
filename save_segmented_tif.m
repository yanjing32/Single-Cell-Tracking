function save_segmented_tif(mask)

% Output the segmented data into a multipage tiff. 

% During trial and error, one might generate multiple segmented.tif. It is better to generate a new
% file each time so that one can compare later.

% Caution: sometimes one might run into trouble of the data are not written to harddrive fast enough. In this case, disp(frame) should work. or simple add a pause to it. 

if exist('segmented.tif') == 2;
    
    h = 1;
    while exist(['segmented' num2str(h) '.tif']) == 2
        h = h+1;
    end
    newname = ['segmented' num2str(h) '.tif'];
    for frame = 1:size(mask,3);
%         disp(frame)
        imwrite(mask(:,:,frame), newname, 'tif', 'WriteMode', 'append', 'compression', 'none');
    end
    
else
    for frame = 1:size(mask,3);
        imwrite(mask(:,:,frame), 'segmented.tif', 'tif', 'WriteMode', 'append', 'compression', 'none');
%         disp(frame)
    end
%     delete('segmented.tif');
end