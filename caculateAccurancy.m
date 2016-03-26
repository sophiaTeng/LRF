%% caculate the accurancy with max allow distance to GT
%
%  call function: traverseComLRT()
%
%  Function:This .m file is used for caculating accurancy of a LRT
%
%  Input:  @LRT :  current LRT tree
%             @imgIndex : test image Index
%             @imageNames : all image Names
%             @allLabels : all image 's ground truth
%             @maxDist : max allowed
%  Output: @accurancy 
%
%  written by Sophia
%  last modified date: 2016.01.12
%%

function accurancy = caculateAccurancy(LRT,imgIndex,imgNames,allLabels,maxDist)

% LRT = load('./results/20160317/LRTwithSep_10.mat');
%LRT = LRT.LRTwithSep{3,1};
%[imgIndex,imgNames,allLabels] = readLabelFromFile(testfile);

countCorrect = 0;

for i =1:size(imgIndex,1)
    % pre-process
    I = imread(['./Training/Depth/',imgNames{i,1}]);
    threhold = max(I(find(I < 30000)));
    [row,col] = find(I < 30000);
    I(find(I > 30000)) = threhold;
    orignx = mean(col);
    origny = mean(row);
    orignyd = double(I(uint16(origny),uint16(orignx)));
    nodeNo = 1;
    postionSet = {};
    latentSet = {[orignx origny]};
    
    %test
    [postionSet,latentSet]  = traverseComLRT(I,nodeNo,LRT,[orignx origny orignyd],postionSet,latentSet);
   
    corctset = zeros(16,2);
    corctset(:,1) = allLabels(i,1:3:end); 
    corctset(:,2) = allLabels(i,2:3:end);
    resultSet = cell2mat(postionSet);
    
    eucdis = max(sqrt(power(resultSet(:,1)-corctset(:,1),2)+ power(resultSet(:,2)-corctset(:,2),2)));
    
   % disp(['Euc dis : ' num2str(eucdis)]);
    
    if(eucdis <= maxDist)
        countCorrect = countCorrect + 1;
    end
    
end
    
    accurancy = countCorrect/size(imgIndex,1);
    
    %% result visualize
%     showResult(img,postionSet,latentSet);
%     print( '-djpeg' ,'-r200' ,['./results/' today '/fig' num2str(i)]);
%     close Figure 1;
%     print( '-djpeg' ,'-r200' ,['./results/' today '/fig' num2str(i)]);
%     close Figure 1;

    %% show correct answer
%     figure;imshow(mat2gray(I));
%     title(imgNames{i,1});
%     hold on;
%     corctset = cell(31,1);
%     LTMex = zeros(31,4);
%     for t=1:31
%         corctset{t,1} = [allVertexpos(i,t*3-2) allVertexpos(i,t*3-1)];
%         LTMex(t,:) = LTM{t,1}(1:4);
%     end
%     plotLTM(LTMex,1,corctset);

end