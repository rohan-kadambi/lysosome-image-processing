% Other params will be added in later eg threshold for "on" conversion and
% probably some other things
function [] = process(imagePath)
% Prepare to Supress Warning about image size
s = warning('off', 'Images:initSize:adjustingMag');

% Read image and convert to binary
image = imread(imagePath);
bw = imcomplement(im2bw(image,.2));

% Remove noise of small dots
% This line may be moved to the end or entirely removed in the future
% Note, to remove anything the second param must be >0
bw2 = ~bwareaopen(~bw,0);

% Display image and supress warning
imshow(bw2);
warning(s);

% Return to complement for processing
bw2 = imcomplement(bw2);

% Collect all region properties for all regions in image
measurements = regionprops(bwlabel((bw2)), (bw2), 'all');   
numberOfRegions = size(measurements, 1);

% Step through the list of regions and compile a list of those deemed "too
% big", 400 pix area is the arbitrary value for now
possibleClusters = [];
for i = 1:numberOfRegions
    if(measurements(i).Area > 400)
        possibleClusters = [possibleClusters, measurements(i)];
    end
end

% This step and the previous can like be done in tandom saving O(n) memory
% but for readibility and testing they will be separated.
% Send each possible cluster to another method where a watershed
% segmentation will be run and then the structure array will be returned
% with images potentially overwritten
possibleClusters = segmentationAttempt(possibleClusters);

% Using possibleClusters as a guide the new images will be cut into the old
% image in the approriate boundry and then regionprops will be calculated
% again.
for i = 1:size(possibleClusters,1)
    temp = possibleClusters(i).BoundingBox;
    temp = floor(temp);
    for j= temp(1):temp(1)+temp(3)-1
        for k = temp(2):temp(2)+temp(4)-1
           bw2(k,j)=possibleClusters(i).Image(k-temp(2)+1,j-temp(1)+1);
        end
    end 
end

% At this point all regions too large, small, or ovular are removed from
% the list and their areas added to an array in order to display 

%Recalculate region properties
measurements = regionprops(bwlabel((bw2)), (bw2), 'all');   
numberOfRegions = size(measurements, 1);

%initialize these values to something useful
min = 100;
max = 800;
% Matlab uses c/a to calculate (aka linear) eccentricity
tooLong = 1;
z = [];
for i = 1:numberOfRegions
    %if(measurements(i).Area < max && measurements(i).Area > min &&...
            %measurements(i).Eccentricity < tooLong)
        z = [z,measurements(i).Area];
    %end
end

% Draw boundries of all regions on bw2
% This line should move to the end in the future once unneeded regions are
% removed
hold on;
boundaries = bwboundaries((bw2));	
numberOfBoundaries = size(boundaries);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
hold off;

figure;
histogram(z);

end

% This is the magical part where matlab decides if regions are actually
% composed of two intersecting regions
function [possibleClusters] = segmentationAttempt(possibleClusters)
for i = 1:size(possibleClusters,1)
    bw = possibleClusters(i).Image;
    bw2 = -bwareaopen(~bw,10);
    D = - bwdist(~bw);
    Ld = watershed(D);
    bw2= bw;
    bw2(Ld == 0) = 0;
    mask = imextendedmin(D,2);
    D2 = imimposemin(D,mask);
    Ld2 = watershed(D2);
    bw3 = bw;
    bw3(Ld2 == 0) = 0;
    possibleClusters(i).Image = bw3;
   
    
end
end