clear all;close all;clc;

today = datestr(now,'yyyymmdd');
phase = 0;
model = ['.\results\20160504','\00-36_stageLRTwithSep_22044_th=100.mat'];
% LRT = load(['.\results\',today,'\10-46_stageLRTwithSep_22044_th=20.mat']);

%% decide test accurancy or generalization 
if(phase == 0)
    disp('## Test model using train images...');
    label_filename = 'label_test1.txt';
else
    disp('## Test model using test images...');
    label_filename = '.\Testing\test_seq_1.txt';
end

LRT = load(model);
LRT = LRT.LRTwithSep{3,1};
[allimgIndex,allimgNames,allallLabels] = readLabelFromFileforTest(label_filename);


%% show single image result
%
% for i = 1:size(imgNames,1)
%     %  pre-process
%     if(phase == 0)
%         [originx,originy,origind,I] = imgPreprocess(['./Training/Depth/',imgNames{i,1}],30000);
%     else
%         [originx,originy,origind,I] = imgPreprocessforTest(['./Testing/Depth/',imgNames{i,1}],500);
%     end 
%     
%     nodeNo = 1;
%     postionSet = {};
%     latentSet = {[originx originy origind]};
%     
%     imshow(mat2gray(I));
%     hold on;
%     plot(originx,originy,'r*');
%     disp(['origin = (', num2str(originx),',',num2str(originy),',',num2str(origind),')']);
%     
%     % traverse  a complete lrt
%     [postionSet,latentSet]  = traverseComLRT(I,nodeNo,LRT,[originx originy origind],postionSet,latentSet);
%     
%     % result visualize
%     posSet = cell2mat(postionSet);
%     LatSet = cell2mat(latentSet);     
%     corctset = zeros(16,2);
%     corctset(:,1) = allLabels(i,1:3:end); 
%     corctset(:,2) = allLabels(i,2:3:end);
%     showResult(I,LatSet,corctset);
%       
%     % save test img
%     print( '-djpeg' ,'-r200' ,[model(1:end-4) '_testfig' num2str(i)]);
% %     pause(0.5);
%     close Figure 1;
%     
% end

%% caculateAccurancy
accuset = zeros(8,2);
figure;
hold on;
xlabel('max allowed distance to GT/pix');
ylabel('frames with all joints with D');
if(phase == 0)
    title(['Train images-' model(20:end)]);
else
    title(['Test  images-' model(20:end)]);
end

for i = 1:8
    maxDis = i*10;
    accurancy= caculateAccurancy(LRT,imgIndex,imgNames,allLabels,maxDis/1.4,phase);
    accuset(i,1) =maxDis;
    accuset(i,2) = accurancy;
    plot(maxDis,accurancy,'b.');
    disp(['Maxdis : ',num2str(maxDis)]);
    disp(['Accurancy : ' num2str(accurancy)]);
    
    if(i > 1)
        line([maxDis,accuset(i-1,1)],[accurancy,accuset(i-1,2)],'color','b');
    end
end

print( '-djpeg' ,'-r200' ,[model(1:end-4) '_test.fig' ]);
