%Train process
clc;clear all;close all;

%% judge whether result directory is exist
today = datestr(now,'yyyymmdd');
if ~exist(['./results/', today],'dir')
    mkdir(['./results/', today])
end

%% parameter
threshold = [5,5,5,5,5,5,0];
rcof = [20 20];
 
%% Train LRT
label_filename = 'label_test1.txt';
% label_filename = 'test2.txt';
[allimgIndex,allimgNames,allallLabels] = readLabelFromFile(label_filename);        %read training labels
LTM = buildingLTM();
allVertexpos = caculateAllVertexes(allimgIndex,allallLabels,allimgNames,LTM);

%initialize
nodeLTM = 1;
LRT = {};
first_stage_set = {};
currImgIndex = allimgIndex(1:6:end);

% for t = 1:size(currImgIndex,1)
%     figure;
%     imshow(imread(['./Training/Depth/',allimgNames{currImgIndex(t),1}]));
%     title(num2str(currImgIndex(t)));
% end

tic;
%first stage
disp(['********************************************** Stage: ' num2str(1) ' *************************************************************']);
[LRT,first_stage_set] = Copy_of_generateLRTstage(LRT,first_stage_set,-1,currImgIndex,threshold(1,1), rcof(1,1) + rcof(1,2),nodeLTM,allVertexpos,allimgNames,LTM,0);
allStagediv = cell(7,1); %all division node
allStagediv{1,1} = first_stage_set;

%按stage训练
for i = 2:7
    disp(['********************************************** Stage: ' num2str(i) ' *************************************************************']);
    last_left_set = allStagediv{i-1,1};
    r = rcof(1,1)/i + rcof(1,2);
    ig_threshold = threshold(1,i);
    
    %add data
    cur_stage_set  = addDataStage(allimgIndex(i:6:end),last_left_set,LRT,allimgNames);
    
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
           [LRT,new_stage_set] = Copy_of_generateLRTstage(LRT,new_stage_set,pnode,currImgIndex,ig_threshold,r,leftLTMsbling,allVertexpos,allimgNames,LTM,0);
           next_stage_set = [next_stage_set;new_stage_set];
       else
           LRT{pnode,1}(3) = -2;
       end
       
       %接下stage的右LTM节点分支
       new_stage_set = {};
       rigtLTMsbling = LTM{nodeLTM,1}(4); 
       if(LTM{rigtLTMsbling,1}(3) ~= -1)
           [LRT,new_stage_set] = Copy_of_generateLRTstage(LRT,new_stage_set,pnode,currImgIndex,ig_threshold,r,rigtLTMsbling,allVertexpos,allimgNames,LTM,0);
           next_stage_set = [next_stage_set;new_stage_set];
       else
           LRT{pnode,1}(4) = -2;
       end
       
   end
   
   allStagediv{i,1} = next_stage_set;
end
toc;

% save tree
time = datestr(now,'HH-MM');
LRTwithSep = {threshold;rcof;LRT};
save(['./results/',today,'/',time,'_stageLRTwithSep_controldepth',num2str(size(allimgNames,1)),'_th=',num2str(threshold(1,1)),'.mat'],'LRTwithSep');

