%TEST LATENT REGRESSION TREE for Hand Estimation

%% caculate the accurancy with max allow distance to GT
%
%  call function:  imgPreprocess()
%                        traverseComLRT()
%
%  Function:This .m file is used for caculating accurancy of a LRT
%
%  Input:  @LRT :  current LRT tree
%             @imgIndex : test image Index
%             @imageNames : all image Names
%             @allLabels : all image 's ground truth
%             @maxDist : max allowed
%             @trainortest : whether is a train phase or a test phase
%  Output: @accurancy 
%
%  written by Sophia
%  last modified date: 2016.01.12
%%

function accurancy = caculateAccurancy(LRT,imgIndex,imgNames,allLabels,maxDist,trainortest)

disp('## Caculate accurancy...');

% LRT = load('./results/20160317/LRTwithSep_10.mat');
%LRT = LRT.LRTwithSep{3,1};
%[imgIndex,imgNames,allLabels] = readLabelFromFile(testfile);

countCorrect = 0;

for i =1:size(imgIndex,1)
    % pre-process
    if(trainortest == 0)
        [originx,originy,origind,I] = imgPreprocess(['./Training/Depth/',imgNames{i,1}],500);
    else
        [originx,originy,origind,I] = imgPreprocessforTest(['./Testing/Depth/',imgNames{i,1}],500);
    end

    nodeNo = 1;
    postionSet = {};
    latentSet = {[originx originy origind]};
    
    %test
    [postionSet,latentSet]  = traverseComLRT(I,nodeNo,LRT,[originx originy origind],postionSet,latentSet);
   
    corctset = zeros(16,2);
    corctset(:,1) = allLabels(i,1:3:end); 
    corctset(:,2) = allLabels(i,2:3:end);
    resultSet = cell2mat(postionSet);
    
    eucdis = sqrt(power(resultSet(:,1)-corctset(:,1),2)+ power(resultSet(:,2)-corctset(:,2),2));
    maxeucdis = max(eucdis);
    
   % disp(['Euc dis : ' num2str(maxeucdis)]);
    
    if(maxeucdis <= maxDist)
        countCorrect = countCorrect + 1;
    end
    
end
    disp(['countCorrect : ' num2str(countCorrect)]);
    accurancy = countCorrect/size(imgIndex,1);
    
end
