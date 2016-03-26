%% generate LRT trees using a recursive algorithm | LRTversion1
%
%  call function: generateLRTrecur() 
%                       randomGenCandidates() 
%                       caculateDivNode()
%
%  Function:  This .m file is used for generating a LRT with a LTM
%
%  Input: @pnode: parent node
%            @nodeLTM: current LTM node
%            @LRT :  current LRT tree
%            @LTM : LTM tree
%            @currImgIndex : current image Index
%            @imageNames : all image Names
%            @allVertexpos : all image 's all vertexpos
%            @d£ºcurrent stage of LTM
%            @th : threshold set
%            @r_k_t : the r of rbf function's coefficient  
%
%  Output: a LRT
%
%   written by Sophia
%   2016.01.18
%%

function LRT = generateLRTrecur(pnode,nodeLTM,LRT,LTM,currImgIndex,imageNames,allVertexpos,d,th,rfeat)

%maxDepth = 10;
thrholdIG = th(d);% 20;  %parameter

%% node information
% @LTM{curNodeNo,1}(1) - node type£º 1-split node, 0-division node
% @LTM{curNodeNo,1}(2) - parent node
% @LTM{curNodeNo,1}(3) - left sibling
% @LTM{curNodeNo,1}(4) - right sibling
% @LTM{curNodeNo,1}(5-9) - according node type£ºsplit node-RBF features
%                                                                               /division node-left & right offsets

%% LTM leaf ,also LRT 's leaf node : do not save, set parent 's siblings to -2
if(LTM{nodeLTM,1}(3) == -1) 
    if(pnode >= 1)
        if(LRT{pnode,1}(3) == -1)
            LRT{pnode,1}(3) = -2;   %if left siblings
        else
            LRT{pnode,1}(4) = -2;   %if right siblings
        end
    end
    return;
end

%% non-leaf node, caculater RBF features
if(size(currImgIndex,1) <= 1)  %only one image,directly to division node
    maxIG = 0;
else
    dr = rfeat(1,1)/d + rfeat(1,2);   %RBF features' r
    [maxIG,bestfeat,leftset,rightset] = randomGenCandidates(currImgIndex,allVertexpos,imageNames,LTM,nodeLTM,dr);
    disp('##');
    disp(['Stage:  '  num2str(d) '  >> ThreholdIG = ' num2str(thrholdIG) ' | maxIG= '  num2str(maxIG)]);
end

%% create node, later decide  type(split / division)
curNodeNo = size(LRT,1)+1;  % current node no.
if(pnode >= 1)
    if(LRT{pnode,1}(3) == -1)
        LRT{pnode,1}(3) = curNodeNo;   %if left siblings
    else
        LRT{pnode,1}(4) = curNodeNo;   %if right siblings
    end
end

%%
if(maxIG > thrholdIG)
%% LTMµÄsplit node
    %Save j as a split node into T
    disp(['                                  No. '  num2str(curNodeNo)  ' split node'  '   left:' num2str(size(leftset,1)) '  |  right:' num2str(size(rightset,1))]);
    nodeLRTinfo = [1,pnode,-1,-1,bestfeat];
    LRT{curNodeNo,1} = nodeLRTinfo;
    clear nodeLRTinfo;
    
    % leftset
    LRT = generateLRTrecur(curNodeNo,nodeLTM,LRT,LTM,leftset,imageNames,allVertexpos,d,th,rfeat);
    % rightset
    LRT = generateLRTrecur(curNodeNo,nodeLTM,LRT,LTM,rightset,imageNames,allVertexpos,d,th,rfeat);
    
elseif(LTM{nodeLTM,1}(3)  ~= -1)
%% LTMµÄdivision node
    disp(['                                  No. ' num2str(curNodeNo) ' division node ' ' |  LTM =  ' num2str(nodeLTM) 'th']);
    nodeLRTinfo = [0,pnode,-1,-1];
    %¼ÆËãoffset
    offset = caculateDivNode(currImgIndex,nodeLTM,allVertexpos,LTM);    
    nodeLRTinfo = [nodeLRTinfo,offset];
    LRT{curNodeNo,1} = nodeLRTinfo;
    clear nodeLRTinfo;
    
    %next stage
    leftLTMsbling = LTM{nodeLTM,1}(3);  
    rigtLTMsbling = LTM{nodeLTM,1}(4);
    d = LTM{leftLTMsbling,1}(1);  
    %left LTM branch
    LRT = generateLRTrecur(curNodeNo,leftLTMsbling,LRT,LTM,currImgIndex,imageNames,allVertexpos,d,th,rfeat);  
    %right LTM branch
    LRT = generateLRTrecur(curNodeNo,rigtLTMsbling,LRT,LTM,currImgIndex,imageNames,allVertexpos,d,th,rfeat);  

end

end