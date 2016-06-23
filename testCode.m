clear all;close all;clc;

label_filename = 'test.txt';
[allimgIndex,allimgNames,allallLabels] = readLabelFromFile(label_filename);

%% assign train data
trainNum = size(allimgNames,1);
imgNames = allimgNames(1:trainNum);
allLabels = allallLabels(1:trainNum,:);
imgIndex = (1:size(imgNames))';%allimgIndex(1:trainNum);
stage = 6;


%% parameter
today = '20160418';
threshold = [50,20,10,5,2,0.1,0];
rcof = [24 11];
maxR2GT = 30;
 
 
%% Train LRT
 LTM = buildingLTM();
 
tic;
allVertexpos = caculateAllVertexes(imgIndex,allLabels,imgNames,LTM);
toc;

%initialize
nodeLTM = 1;
LRT = {};
first_stage_set = {};
currImgIndex = imgIndex(1:6:end);

tic;
%first stage
disp(['********************************************** Stage: ' num2str(1) ' *************************************************************']);
[LRT,first_stage_set] = generateLRTstage(LRT,first_stage_set,-1,currImgIndex,threshold(1,1), rcof(1,1) + rcof(1,2),nodeLTM,allVertexpos,imgNames,LTM);
allStagediv = cell(7,1); %all division node
allStagediv{1,1} = first_stage_set;

%按stage训练
for i = 2:7
    disp(['********************************************** Stage: ' num2str(i) ' *************************************************************']);
    last_left_set = allStagediv{i-1,1};
    r = rcof(1,1)/i + rcof(1,2);
    ig_threshold = threshold(1,i);
    
    %add data
    cur_stage_set  = addDataStage(imgIndex(i:6:end),last_left_set,LRT,imgNames);
    
    next_stage_set = {};
    % 当前stage从上个stage的div node开始
   for j = 1:size(cur_stage_set,1)
       
       % 当前division node在LRT中的位置
       pnode = cur_stage_set{j,1}(1);
       % 当前division node所属的LTM node
       nodeLTM = cur_stage_set{j,1}(2);
       % 当前division node的image set
       currImgIndex = cur_stage_set{j,1}(3:end);
       
       %接下stage的左LTM节点分支
       new_stage_set = {};
       leftLTMsbling = LTM{nodeLTM,1}(3);
       if( LTM{leftLTMsbling,1}(3) ~= -1)   %左节点不是叶子节点
           [LRT,new_stage_set] = generateLRTstage(LRT,new_stage_set,pnode,currImgIndex,ig_threshold,r,leftLTMsbling,allVertexpos,imgNames,LTM);
           next_stage_set = [next_stage_set;new_stage_set];
       else
           LRT{pnode,1}(3) = -2;
       end
       
       %接下stage的右LTM节点分支
       new_stage_set = {};
       rigtLTMsbling = LTM{nodeLTM,1}(4); 
       if(LTM{rigtLTMsbling,1}(3) ~= -1)
           [LRT,new_stage_set] = generateLRTstage(LRT,new_stage_set,pnode,currImgIndex,ig_threshold,r,rigtLTMsbling,allVertexpos,imgNames,LTM);
           next_stage_set = [next_stage_set;new_stage_set];
       else
           LRT{pnode,1}(4) = -2;
       end
       
   end
   
   allStagediv{i,1} = next_stage_set;
end

toc;

% save tree
LRTwithSep = {threshold;r;LRT};
save(['./results/' today '/stageLRTwithSep_' num2str(threshold) '.mat'],'LRTwithSep');

% accurancy = caculateAccurancy(LRT,allimgIndex,allimgNames,allallLabels,maxR2GT);
% disp(['Accurancy : ' num2str(accurancy)]);
