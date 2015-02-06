%Using region props I do return Ecentricity can use this later for lysozome
%identification
function [seemToLarge] = messingWithWatershed(imagePath)
s = warning('off', 'Images:initSize:adjustingMag');
%Read image and convert to binary (convert to complement for visual)
image = imread(imagePath);
bw = imcomplement(im2bw(image,.2));
%imshow(imagebw);

% this line is removing things that seem to small, 0 actually does nothing
bw2 = ~bwareaopen(~bw,0);
imshow(bw2);
warning(s);
bw2 = imcomplement(bw2);

blobMeasurements = regionprops(bwlabel((bw2)),...
    (bw2), 'all');   
numberOfBlobs = size(blobMeasurements, 1);

hold on;
boundaries = bwboundaries((bw2));	
numberOfBoundaries = size(boundaries);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
hold off;

z = zeros(numberOfBlobs);
seemToLarge = [];

for k = 1 : numberOfBlobs
    z(k) = blobMeasurements(k).Area;
    % the function call values are fixed to make my life easy now, can
    % un-hardcode in the future.
    if(z(k) > micronToPixel(500,1))
        seemToLarge = [seemToLarge,blobMeasurements(k)];
    end
end
for i = 1:size(seemToLarge,1)
    figure;
    imTemp = seemToLarge(1,i).Image;
    imshow(~imTemp);
end
z = z(1:end,1);
figure;
histogram(z);

%for k = 1:num
%    disp(measurements(k).Area);
%end
%bwarea(bw2)
%testing line to show overlap of what was removed
end

function [pixels] = micronToPixel(value, conversion)
pixels = value*conversion;
end
function [microns] = pixelToMicron(value, conversion)
microns = value*conversion;
end