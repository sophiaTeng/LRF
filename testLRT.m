%clear all;close all;clc

label_filename = 'label_test1.txt';
[allimgIndex,allimgNames,allallLabels] = readLabelFromFile(label_filename);

%% assign train data
trainNum = 260;%size(allimgNames,1);
imgIndex = (1:trainNum)';%allimgIndex(1:trainNum);
imgNames = allimgNames(1:trainNum);
allLabels = allallLabels(1:trainNum,:);

%LRT = load('E:\workspace\Matlab\LRF\results\20160324\LRTwithSep_10            2          0.5          0.3          0.1            0            0.mat');
%LRT = LRT.LRTwithSep{3,1};

%% show LRT 
postionSet = {};
for i =1:trainNum%size(imgNames,1)
    %pre-process
    I = imread(['./Training/Depth/',imgNames{i,1}]);
    threhold = max(I(find(I < 30000)));
    [row,col] = find(I < 30000);
    I(find(I > 30000)) = threhold;
    orignx = mean(col);
    origny = mean(row);
    orignyd = double(I(uint16(origny),uint16(orignx)));
    nodeNo = 1;
    postionSet = {};
    latentSet = {[orignx origny orignyd]};
    
    %test
    [postionSet,latentSet]  = traverseComLRT(I,nodeNo,LRT,[orignx origny orignyd],postionSet,latentSet);
    
    % result visualize
    posSet = cell2mat(postionSet);
    LatSet = cell2mat(latentSet);
    corctset = zeros(16,2);
    corctset(:,1) = allLabels(i,1:3:end); 
    corctset(:,2) = allLabels(i,2:3:end);
    showResult(I,LatSet,corctset);

    print( '-djpeg' ,'-r200' ,['./results/' today '/fig' num2str(i)]);
    close Figure 1;
    
end

accurancy = caculateAccurancy(LRT,imgIndex,imgNames,allLabels,1);
disp(['Accurancy : ' num2str(accurancy)]);
