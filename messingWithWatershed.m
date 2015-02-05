function [] = messingWithWatershed(imagePath)
%Read image and convert to binary (convert to complement for visual)
image = imread(imagePath);
bw = imcomplement(im2bw(image,.2));
%imshow(imagebw);

% this line is removing things that seem to small, 0 actually does nothing
bw2 = ~bwareaopen(~bw,0);
imshow(bw2);

blobMeasurements = regionprops(bwlabel(imcomplement(bw2)),...
    imcomplement(bw2), 'all');   
numberOfBlobs = size(blobMeasurements, 1);

hold on;
boundaries = bwboundaries(imcomplement(bw2));	
numberOfBoundaries = size(boundaries);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
hold off;



z = zeros(numberOfBlobs);
for k = 1 : numberOfBlobs
    z(k) = blobMeasurements(k).Area;
end
z = z(1:end,1);
histogram(z);
%for k = 1:num
%    disp(measurements(k).Area);
%end
%bwarea(bw2)
%testing line to show overlap of what was removed
end