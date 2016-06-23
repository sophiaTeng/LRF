clear all;close all;clc;

today = datestr(now,'yyyymmdd');
phase = 1;
img_path =  './imgProcess/lab/';
model_path = './results/20160520/';
model_list = dir(fullfile(model_path,'*.mat'));
mat_num = size(model_list,1);
models = cell(mat_num,1);

for ff = 1:size(model_list,1)
    LRT = load(fullfile(model_path,model_list(ff).name));
    models{ff} = LRT.LRTwithSep{3,1};
end
models_num = 18;%size(models,1);
%% test image set
if(phase == 0)
    disp('## Test model using train images...');
    label_filename = 'normolizelabels.txt';
    [allimgIndex,allimgNames,allallLabels] = readLabelFromFile(label_filename,img_path);
%     label_filename = 'test3.txt';
else
    disp('## Test model using test images...');
    label_filename = [img_path 'new_test_seq_1_labels.txt'];
    [allimgIndex,allimgNames,allallLabels] = readLabelFromFileforTest(label_filename);
end



%% traverse LRT 
accurancyCount = zeros(8,1);
meanerrordis = zeros(16,1);
for i = 1:size(allimgNames,1)
%     pre-process

    [originx,originy,origind,I] = imgPreprocess(fullfile(img_path,allimgNames{i,1}),30000);

    
%     imshow(mat2gray(I));
%     hold on;
%     plot(originx,originy,'r*');
%     disp(['origin = (', num2str(originx),',',num2str(originy),',',num2str(origind),')']);
    
    %test
    allpostionSet = zeros(16,2);
    alllatentSet = zeros(31,2);
    for j =1:models_num
        nodeNo = 1;
        postionSet = {};
        latentSet = {[originx originy origind]};
        [postionSet,latentSet]  = traverseComLRT(I,nodeNo,models{j,1},[originx originy origind],postionSet,latentSet);
        posSet = cell2mat(postionSet);
        latSet = cell2mat(latentSet);
        allpostionSet = allpostionSet + posSet(:,1:2);
        alllatentSet =  alllatentSet + latSet(:,1:2);
    end
    
    allpostionSet = allpostionSet / models_num;
    alllatentSet =  alllatentSet / models_num;
    
    % ground truth position
    gtset = zeros(16,2);
    gtset(:,1) = allallLabels(i,1:3:end); 
    gtset(:,2) = allallLabels(i,2:3:end);
%     showResult(I,alllatentSet,gtset);

%     print( '-djpeg' ,'-r200' ,[model(1:end-4) '_testfig' num2str(i)]);
%     pause(0.5);
%     close Figure 1;

    % caculate accurancy
    eucdis = sqrt(power(allpostionSet(:,1)-gtset(:,1),2)+ power(allpostionSet(:,2)-gtset(:,2),2));
    meanerrordis = meanerrordis + eucdis;
    maxeucdis = max(eucdis);
   
    disp(['>> Testing the ' num2str(i) ' image. meanError = ' num2str(mean(eucdis)) ]);
    
    
    for tt = 1:size(accurancyCount,1)
   % disp(['Euc dis : ' num2str(maxeucdis)]);
        maxDist = 10*tt/1.4;
        if(maxeucdis <= maxDist)
            accurancyCount(tt) = accurancyCount(tt) + 1;
        end
    end
    clear allpostionSet;
    clear alllatentSet;
    
end
accurancySet = accurancyCount / size(allimgNames,1);%zeros(8,1);
meanerrorSet = meanerrordis / size(allimgNames,1);

plotmaxGT(accurancySet);

plotMeanError(meanerrorSet);
% 
% figure;
% hold on;
% xlabel('max allowed distance to GT/(mm)');
% ylabel('frames with all joints with D');
% if(phase == 0)
%     title(['Train images-' num2str(models_num) ' trees']);
% else
%     title(['Test  images-' num2str(models_num) ' trees']);
% end
% 
% accurancySet = accurancyCount / size(allimgNames,1);%zeros(8,1);
% for ii = 1:8
%     maxDis = ii*10;
%     %accurancySet(ii) = accurancyCount(ii) / size(allimgNames,1);
%     plot(maxDis,accurancySet(ii),'b.');
%     disp(['Maxdis : ',num2str(maxDis)]);
%     disp(['Count : ',num2str(accurancyCount(ii))]);
%     disp(['Accurancy : ' num2str(accurancySet(ii))]);
%     
%     if(ii > 1)
%         line([maxDis,(ii-1)*10],[accurancySet(ii),accurancySet(ii-1)],'color','b');
%     end
% end

%print( '-djpeg' ,'-r200' ,[model(1:end-4) '_test.fig' ]);
