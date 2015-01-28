function [] = imageBasics(imagePath)
    test = imread(imagePath);
    test = im2bw(test,.78);
    imagesc(test);
end