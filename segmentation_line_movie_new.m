function segmentation_line_movie_new(img,imgfilter,mask3,direction,centers,line_show_range,iffilter,ifsegmented,iforiginal,iftracked)

% Step 5: Make several z_movies to make sure tracking is correct. 

Zrange = 1:size(img,3);

% Output filtered image
if iffilter
writerObj = VideoWriter('filtered.avi');
writerObj.FrameRate = 10;
open(writerObj)
for t = Zrange
    arr = imgfilter(:,:,t);
    dd = figure(1);
    figureFullScreen(dd);
    imagesc(arr');daspect([1 1 1]);grid on;
    frame = getframe;
    writeVideo(writerObj,frame);
end
close(writerObj);
end

% Output segmented images
if ifsegmented
writerObj = VideoWriter('segmented.avi');
writerObj.FrameRate = 10;
open(writerObj)
dd = figure(2);
figureFullScreen(dd);
    for t = Zrange
     arr = mask3(:,:,t);
     imagesc(arr');daspect([1 1 1]);grid on;
     frame = getframe;
     writeVideo(writerObj,frame);

    end
close(writerObj);
end

% Output original image
if iforiginal
        dd = figure(3);
        figureFullScreen(dd);
        yellowmap = zeros(64,3);
        for n=1:64
        yellowmap(n,1) = (n-1).*1/63;yellowmap(n,2)=yellowmap(n,1);
        end    
        writerObj = VideoWriter('original.avi');
        writerObj.FrameRate = 10;
        open(writerObj)
        for t = Zrange
            arr = img(:,:,t);
            imagesc(arr');daspect([1 1 1]);
            colormap(yellowmap)
            frame = getframe;
            writeVideo(writerObj,frame);
        end
        close(writerObj);
end

% Output tracked image with a red line representing the cells.
if iftracked
        dd = figure(1);
        figureFullScreen(dd);
        
        % output as yellow color
        yellowmap = zeros(64,3);
        for n=1:64
        yellowmap(n,1) = (n-1).*1/63;yellowmap(n,2)=yellowmap(n,1);
        end
        celllength = 4; % maybe should not use a defined value but use the first priciple component value as the cell axis. 

        writerObj = VideoWriter('tracked.avi');
        writerObj.FrameRate = 10;
        open(writerObj)
        for t = Zrange
            arr = img(:,:,t);
            imagesc(arr');daspect([1 1 1]);
            keep = centers(:,3)>t-line_show_range & centers(:,3)<t+line_show_range; % display cells within assigned range. 
            colormap(yellowmap)
            line([centers(keep,1)-celllength.*direction(keep,1) centers(keep,1)+celllength.*direction(keep,1)]',[centers(keep,2)-celllength.*direction(keep,2) centers(keep,2)+celllength.*direction(keep,2)]',[centers(keep,3)-celllength.*direction(keep,3) centers(keep,3)+celllength.*direction(keep,3)]','Color','r','LineWidth',3);
            frame = getframe;
            writeVideo(writerObj,frame);
        end
        close(writerObj);
        
    end    
 end
