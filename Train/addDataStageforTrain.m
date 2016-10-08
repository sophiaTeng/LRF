%TRAIN LATENT REGRESSION TREE for Hand Estimation

%% add new image at a new stage start
%
%  call function: imgPreprocess()
%                       traverseUncomLRT()
%
%  Function: This .m file is used for adding new data at a new stage start
%
%  Input: @addindex: added image 's index
%            @cur_stage_set : the pre-process node at current stage 
%            @LRT : unfinished LRT
%            @imgNames : all image names
%
%  Output: new_stage_data : the pre-process node after add some new image  
%
%  written by  Sophia
%  2016.03.26
%%
function new_stage_data  = addDataStage(addindex,cur_stage_set,LRT,imgNames,img_path)

disp('## Adding data...');
nodeindex = zeros(size(cur_stage_set,1),1);
new_stage_data = cur_stage_set;
%取出所有叶子节点编号
for t = 1:size(cur_stage_set,1)
    nodeindex(t) = cur_stage_set{t,1}(1);
end

%每张图分到叶子节点
for i =1:size(addindex,1)
    %pre-process
    [originx,originy,origind,I] = imgPreprocess([img_path,imgNames{addindex(i,1),1}],30000);
    nodeNo = 1;
    leafNode = {};
    
%     imshow(mat2gray(I));hold on;
%     plot(originx,originy,'r*');
    
    %traverse
    leafNode = traverseUncomLRT(I,nodeNo,LRT,[originx originy origind],leafNode);
    leafNode = cell2mat(leafNode);
    
    %disp(['addindex= ',num2str(addindex(i)),', ','leafNode = ',num2str(leafNode)]);
    if(size(leafNode,1) <= 0 )
        continue;
    else
        for j = 1:size(leafNode,1)
            ind = find(nodeindex == leafNode(j,1));
            new_stage_data{ind,1} = [new_stage_data{ind,1};addindex(i,1)];
        end
    end
    
end

end
