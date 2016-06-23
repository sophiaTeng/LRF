clear all;close all;
scale = 1.3;

%%
[allimgIndex,allimgNames,allallLabels] = readLabelFromFile('201405151126.txt');        %read training labels
newLabels = allallLabels;

for i = 140:size(allimgNames,1)
    I = imread(['./Training/Depth/', allimgNames{i,1}]);
    imshow(I);
    I2 = imresize(I,scale,'bilinear');
    figure; imshow(I2);
    [row,col] = find(I2 < 500);
    center_x = mean(row);
    center_y = mean(col);
    I2 = I2(uint16(center_x-120):uint16(center_x+120), uint16(center_y-160):uint16(center_y+160));
    newLabels(i,1:3:end) = newLabels(i,1:3:end)*scale - repmat(center_x -120,1,16);
    newLabels(i,2:3:end) = newLabels(i,2:3:end)*scale - repmat(center_y -160,1,16);
    
end

% %%
% subimg = imageNames(1:5:size(imageNames,1));
% for i = 1:size(subimg,1)
%     if(mod(i,4) == 0)
%         subplot(2,2,4);
%         imshow(imread(['./testImg/', subimg{i,1}]));
%         title(subimg{i,1});
%         figure;
%     else
%         subplot(2,2,mod(i,4));
%         imshow(imread(['./testImg/', subimg{i,1}]));
%         title(subimg{i,1});
%     end
% end
% 
% %%
% imshow( imread(['./testImg/', imageNames{1,1}]));
% I = imread(['./testImg/', imageNames{11,1}]);
% figure;imshow(I);hold on;
% 
% % 取出手
% [row,col] = find(I < 500);
% x1 = min(col);
% y1 = min(row);
% plot(min(col),min(row),'r*');
% 
% %%
% I2 = imresize(I,1.3,'bilinear');
% figure; imshow(I2);hold on;
% %% 取出手
% [row2,col2] = find(I2 < 500);
% x2 = min(col2);
% y2 = min(row2);
% plot(min(col2),min(row2),'r*');
% 
% I3 = I2(mean(row2)-120:mean(row2)+120,mean(col2)-160:mean(col2)+160);
% figure;imshow(I3);
