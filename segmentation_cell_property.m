function [direction, centers, maskLabel3props] = segmentation_cell_property(ncells,maskLabel3,maskLabel3props,imgfilter)

% Step 4: Calculate the center and orienation of each cell
% Inputs: all from previous steps
% outputs:
% maskLabel3props: now contain information of the three PCA axis, area, and
% center of a cell

for i=1:ncells

    onecell=zeros(size(maskLabel3));
    onecell(maskLabel3==i)=1; % pick the spaces occupied by the single cell.
    
       [x,y,z] = ind2sub(size(onecell),find(onecell == 1));
       intensity = zeros(length(x),1);
       for t = 1:length(x)
           intensity(t) = imgfilter(x(t),y(t),z(t)); % record the intensity information of the original pixel
       end
      S = [x y z intensity]; 
      
      % Find the centere of the cell using weighted sum
      S(:,4) = S(:,4)./(sum(sum(S(:,4)))); 
      S(:,5) = S(:,1).*S(:,4);
      S(:,6) = S(:,2).*S(:,4);
      S(:,7) = S(:,3).*S(:,4);
      cent = sum(S(:,5:7));
   
  
   [Evec,~,Eval] = pca(S(:,1:3)); % very clever way to extract the main axis of weird object: using PCA analysis 
    
    if length(Eval)>=1; % If the cell is too small or too isotropic, one cannot find the three axis. Usually they are wrong cells
        if Evec(3,1)<0 
            Evec=Evec*-1; % this is to note the 180 degree symmetry of a rod object
        end
        maskLabel3props(i).Centroid=cent;   
        maskLabel3props(i).DirVector1=Evec(:,1); 
        maskLabel3props(i).EigVal1=Eval(1);
      
    end
         
    if mod(i,100)==0
        disp(i);
    end
end

% obtain center information
centers = [];
for n = 1:length(maskLabel3props)
centers = [centers
maskLabel3props(n).Centroid];
end
% obtain direction information

direction =[];
for n = 1:length(maskLabel3props)
direction = [direction
maskLabel3props(n).DirVector1'];
end
