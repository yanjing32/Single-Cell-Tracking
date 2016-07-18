function [direction_norm,centers_norm] = direction_and_center(direction,centers,pixel_size_x,zstep)

% Step 6: Convert the cell properties into real unit(um)

% Need to correct for the unuqual size of z and xy during image
% acquisition. 

Zfactor = zstep / pixel_size_x;
direction(:,3) = direction(:,3).*Zfactor;

% Normalize the cell director into a unit vector
[~,~,r] = cart2sph(direction(:,1),direction(:,2),direction(:,3));
direction(:,1) = direction(:,1)./r;
direction(:,2) = direction(:,2)./r;
direction(:,3) = direction(:,3)./r;

% convert xyz to absolute units
centers(:,1:2) = centers(:,1:2)*pixel_size_x; 
centers(:,3) = centers(:,3)*zstep;

direction_norm = direction;
centers_norm = centers;