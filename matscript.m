clear all;clc;

% [allimgIndex,allimgNames,allallLabels] = readLabelFromFile('test.txt');
% test = dir('E:\workspace\Matlab\LRF\Training\Depth\201403121140\*.png');
% for i = 1:size(allallLabels,1)
%     if(strcmp(allimgNames{i,1}(14:end),test(i).name) ~= 1) 
%         disp(num2str(i)); 
%     end
% end
% %disp('check successfully');
 I2 = imread('E:\workspace\Matlab\LRF\Testing\Depth\test_seq_1/image_0000.png');
 I = I2;
 imshow(I);
    threhold = max(I(find(I < 500)));
    [row,col] = find(I < 500);
    I(find(I > 500)) = threhold;
    figure;imshow(mat2gray(I));
    orignx = mean(col);
    origny = mean(row);
    hold on;
    plot(orignx,origny,'r*');
    I(:,290:end) = threhold;
    [row,col] = find(I < threhold);
    orignx = mean(col);
    origny = mean(row);
    plot(orignx,origny,'b*');
%     orignyd = double(I(uint16(origny),uint16(orignx)));
%     nodeNo = 1;
%     postionSet = {};
%     latentSet = {[orignx origny orignyd]};