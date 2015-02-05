function [] = imageBasics(imagePath)
    test = imread(imagePath);
    %test = im2bw(test,.78);
    imshow(im2bw(test,.2));
end