%% generate LRT trees using a tree-wise algorithm |LRT version2 (Control depth instread of threhold)
%
%  call function: generateLRTstage() 
%                       randomGenCandidates() 
%                       caculateDivNode()
%
%  Function: This .m file is used for build a tree only use IG
%                   从某个div node开始根据IG分裂数据集，记录叶节点和叶节点分到的数据集
%
%  Input:   @LRT
%              @new_stage_set: current  div node set & next split node  set
%              @pnode : parent node
%              @cur_index : current image set 
%              @ig_threshold : current stage infomation gain threshold
%              @dr : RBF feature 's r 
%              @LTM_node : current LTM node
%              @allVertexpos ： all image 's all vertexpos
%              @allmageNames ：all image Names
%              @LTM
%
%  Output: @LRT 
%               @new_stage_set： next split node  set [父节点，LTM节点，数据集]
%
%   written by Sophia
%   last modified date : 2016.03.24
%%

function [LRT,new_stage_set] = Copy_of_generateLRTstage(LRT,new_stage_set,pnode,cur_index,ig_threshold,dr,LTM_node,allVertexpos,allimgNames,LTM,lrt_depth)

lrt_depth_th = 8;

%% node information
% @LTM{curNodeNo,1}(1) - node type： 1-split node, 0-division node
% @LTM{curNodeNo,1}(2) - parent node
% @LTM{curNodeNo,1}(3) - left sibling
% @LTM{curNodeNo,1}(4) - right sibling
% @LTM{curNodeNo,1}(5-9) - according node type：split node-RBF features
%%                                                                               /division node-left & right offsets

%new LRT node , decide type later
curNodeNo = size(LRT,1)+1;  % current node no.
if(pnode >= 1)
    if(LRT{pnode,1}(3) == -1)
        LRT{pnode,1}(3) = curNodeNo;   %if left siblings
    else
        LRT{pnode,1}(4) = curNodeNo;   %if right siblings
    end
end

%if only one image, directly into division node
if(size(cur_index,1) <= 1)
    maxIG = 0;
else
    [maxIG,bestfeat,leftset,rigtset] = randomGenCandidates(cur_index,allVertexpos,allimgNames,LTM,LTM_node,dr);    
end

%% division node: IG lower than threshold
if(maxIG <= ig_threshold || lrt_depth > lrt_depth_th)
   % disp(['****************nodeNo:  '  num2str(curNodeNo) '  division node ']);
    offset = caculateDivNode(cur_index,LTM_node,allVertexpos,LTM);
    nodeLRTinfo = [0,pnode,-1,-1,offset];
    LRT{curNodeNo,1} = nodeLRTinfo;
    
    %add into next_stage_node
    new_stage_set{size(new_stage_set,1)+1,1} = [curNodeNo;LTM_node;cur_index];
    return;
end

%% split node
disp(['##' num2str(curNodeNo) ' :split node']);
disp(['##LTM:  '  num2str(LTM_node) ', stage_depth = ' num2str(lrt_depth) '  >> ThreholdIG = ' num2str(ig_threshold) ' | maxIG= '  num2str(maxIG) ' left:' num2str(leftset') ' | right: ' num2str(rigtset')]);
nodeLRTinfo = [1,pnode,-1,-1,bestfeat];
LRT{curNodeNo,1} = nodeLRTinfo;
clear nodeLRTinfo;
lrt_depth = lrt_depth +1;
[LRT,new_stage_set] = Copy_of_generateLRTstage(LRT,new_stage_set,curNodeNo,leftset,ig_threshold,dr,LTM_node,allVertexpos,allimgNames,LTM,lrt_depth);
[LRT,new_stage_set] = Copy_of_generateLRTstage(LRT,new_stage_set,curNodeNo,rigtset,ig_threshold,dr,LTM_node,allVertexpos,allimgNames,LTM,lrt_depth);


end