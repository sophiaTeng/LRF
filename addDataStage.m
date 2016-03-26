%% show test result
%
%  call function: plotLTM()
%                       rlrt()
%
%  Function: This .m file is used for showing test result(31 point & stage)
%
%  Input: @img: test image
%            @LatSet : test result 31points
%            @corctset : ground truth 16 points 
%
%  Output: LTM tree
%
%  written by  Sophia
%  2016.03.26
%%
function new_stage_data  = addDataStage(addindex,cur_stage_set,LRT,imgNames)

nodeindex = zeros(size(cur_stage_set,1),1);
new_stage_data = cur_stage_set;
testresult = cell(size(cur_stage_set,1),1);
%取出所有叶子节点编号
for t = 1:size(cur_stage_set,1)
    nodeindex(t) = cur_stage_set{t,1}(1);
    testresult{t,1} = cur_stage_set{t,1}(1);
end

%每张图分到叶子节点
for i =1:size(addindex,1)
    %pre-process
    I = imread(['./Training/Depth/',imgNames{addindex(i,1),1}]);
    threhold = max(I(find(I < 30000)));
    [row,col] = find(I < 30000);
    I(find(I > 30000)) = threhold;
    orignx = mean(col);
    origny = mean(row);
    orignyd = double(I(uint16(origny),uint16(orignx)));
    nodeNo = 1;
    leafNode = {};
    
    %traverse
    leafNode = traverseUncomLRT(I,nodeNo,LRT,[orignx origny orignyd],leafNode);
    leafNode = cell2mat(leafNode);
    
    if(size(leafNode,1) <= 0 )
        continue;
    else
        for j = 1:size(leafNode,1)
            ind = find(nodeindex == leafNode(j,1));
            new_stage_data{ind,1} = [new_stage_data{ind,1};addindex(i,1)];
            testresult{ind,1} = [testresult{ind,1};addindex(i,1)];
        end
    end
    
end


end