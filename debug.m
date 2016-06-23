%Train process
clc;clear all;close all;

disp('## Reading labels. . . . . . ');

line = textread('test3.txt','%s');
imageNum = size(line,1)/49;
imageNames = cell(imageNum,1);         % save image name
labels = zeros(imageNum,48);           % save all the labels,e.g.[(x,y,z),(x,y,z),...,]

%%
%% separate the image' name and label
for i = 1:imageNum
    imageNames(i) = line(49*i-48);
    labels(i,:) = str2double(line(49*i-47:49*i));
end

I = imread('./Training/Depth/201403121135/image_0402.png');
[row,col]= find(I < 30000);
I(find(I > 30000)) = 800;
% [x,y] = find(I > 0);
% z = I(find(I > 0));
% surf(800-I);
mesh(I);hold on;

% for i = 1:16
%     plot3(labels(1,i*3-2),labels(1,i*3-1),labels(1,i*3),'r*');
% end

% if(max(col)-min(col) > max(row)-min(row))
%     subimg = I(min(col):max(row),min(col):max(col));
% else
% end
% 
% I2 = imread('201405151126_image_0004.png');
% 
% mindep = min(min(I));
% I(find(I < 30000)) = I(find(I < 30000)) - mindep;


% %% judge whether result directory is exist
% today = datestr(now,'yyyymmdd');
% if ~exist(['./results/', today],'dir')
%     mkdir(['./results/', today])
% end
% 
% %% parameter
% today = '20160426';
% threshold = [30,30,30,5,5,5,0];
% rcof = [20 20];
%  
% %% Train LRT
% % label_filename = 'label_test1.txt';
% label_filename = 'test2.txt';
% [allimgIndex,allimgNames,allallLabels] = readLabelFromFile(label_filename);        %read training labels
% LTM = buildingLTM();
% allVertexpos = caculateAllVertexes(allimgIndex,allallLabels,allimgNames,LTM);   
% 
% [originx,originy,origind,img] = imgPreprocess(['./Training/Depth/' allimgNames{1,1}],30000);

%% debug
    
%     for tt = 1:size(lindex,2)
%        I = imread(['./Training/Depth/',allmageNames{curImgIndex(lindex(tt)),1}]);
%        figure;imshow(I);
%        title('left');
%     end
%     
%     for tt = 1:size(rindex,2)
%        I = imread(['./Training/Depth/',allmageNames{curImgIndex(rindex(tt)),1}]);
%        figure;imshow(I);
%        title('rigtset');
%     end
    
    
    
%     testset = currImgIndex;
%     for tt = 1:size(testset)
%         for ii = 3:size(testset{tt,1});
%             I = imread(['./Training/Depth/',allimgNames{testset{tt,1}(ii),1}]);
%             figure;imshow(I);
%             title(testset{tt,1}(1));
%             %pause(0.3);
%             %close Figure 1;
%         end     
%     end
    %%