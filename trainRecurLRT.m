%Train process
clc;clear all;close all;

label_filename = 'label_test1.txt';
[allimgIndex,allimgNames,allallLabels] = readLabelFromFile(label_filename);

%% assign train data
trainNum = 140;%size(allimgNames,1);
imgIndex = (1:trainNum)';%allimgIndex(1:trainNum);
imgNames = allimgNames(1:trainNum);
allLabels = allallLabels(1:trainNum,:);

%% parameter
today = '20160325';
threshold = [0.5,0.2,0.2,0.2,0.2,0,0];
rcof = [24 8];
maxR2GT = 1;

%% Train LRT
LTM = buildingLTM();

tic;
allVertexpos = caculateAllVertexes(imgIndex,allLabels,imgNames,LTM);
toc;

%initialize variable
nodeLTM = 1;
LRT = {};
currImgIndex = imgIndex;

%grow tree
tic;
LRT = generateLRTrecur(-1,nodeLTM,LRT,LTM,currImgIndex,imgNames,allVertexpos,1,threshold,rcof);
toc;

% save tree
LRTwithSep = {threshold;rcof;LRT};
save(['./results/' today '/recurLRTwithSep_' num2str(threshold) '.mat'],'LRTwithSep');

% caculate accurancy
accurancy = caculateAccurancy(LRT,imgIndex,imgNames,allLabels,maxR2GT);
disp(['Accurancy : ' num2str(accurancy)]);


%% show result 
% postionSet = {};
% for i =1:trainNum%size(imgNames,1)
%     %pre-process
%     I = imread(['./Training/Depth/',imgNames{i,1}]);
%     threhold = max(I(find(I < 30000)));
%     [row,col] = find(I < 30000);
%     I(find(I > 30000)) = threhold;
%     orignx = mean(col);
%     origny = mean(row);
%     orignyd = double(I(uint16(origny),uint16(orignx)));
%     nodeNo = 1;
%     postionSet = {};
%     latentSet = {[orignx origny orignyd]};
%     
%     %test
%     [postionSet,latentSet]  = traverseComLRT(I,nodeNo,LRT,[orignx origny orignyd],postionSet,latentSet);
%     
%     % result visualize
%     posSet = cell2mat(postionSet);
%     LatSet = cell2mat(latentSet);
%     corctset = zeros(16,2);
%     corctset(:,1) = allLabels(i,1:3:end); 
%     corctset(:,2) = allLabels(i,2:3:end);
%     showResult(I,posSet,LatSet,corctset);
% 
%      print( '-djpeg' ,'-r200' ,['./results/' today '/fig' num2str(i)]);
%      close Figure 1;
%     
% end







