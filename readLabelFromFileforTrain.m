%TRAIN LATENT REGRESSION TREE for Hand Estimation

%% read the label.txt & create imageindex, split imagename & labels
%
%  call function: depthrevise()
%
%  Function: This .m file is used for read the label.txt and save as cells
%
%  Input:   @label_filename: label.txt file
%               @img_path : image path
%
%  Output:  @imageIndex: build an index for all training images
%                @imageNames: all training images' path & names
%                @labels: 16 observed vertexes's position
%
%   written by Sophia
%   2016.01.12
%%

function [imageIndex,imageNames,labels] = readLabelFromFile(label_filename,img_path)

disp('## Reading labels. . . . . . ');

line = textread(label_filename,'%s');
imageNum = size(line,1)/49;
imageNames = cell(imageNum,1);         % save image name
labels = zeros(imageNum,48);           % save all the labels,e.g.[(x,y,z),(x,y,z),...,]

%%
%% separate the image' name and label
for i = 1:imageNum
    imageNames(i) = line(49*i-48);
    labels(i,:) = str2double(line(49*i-47:49*i));
end

%% 去除x,y坐标为负数的样本
index = find(labels < 0 );
[subx,suby] = ind2sub(size(labels),index);
labels(subx,:) = [];
imageNames(subx,:) = [];

imageIndex = (1:1:size(labels,1))';
% 
%% label清洗和预处理 ：根据label(x,y)取图像中的深度depth
for i = 1:size(imageNames)
    I = imread([img_path,imageNames{i,1}]);
%    imshow(I);hold on;
%   title(imageNames{i,1});
    
    for j = 1:16
%         plot(labels(i,j*3-2),labels(i,j*3-1),'r*');
        row = ceil(labels(i,j*3-1));
        col = ceil(labels(i,j*3-2));
        pdepth = I(row,col);
        
        %取到背景深度，以r为领域取值，直到深度小于30000
        if(pdepth > 30000) 
            [x, y, d] =depthrevise(I,row,col,pdepth);
           labels(i,j*3-2) = x;
           labels(i,j*3-1) = y;
           labels(i,j*3) = d;  
        else
           labels(i,j*3) = pdepth;
        end
        
%         plot(labels(i,j*3-2),labels(i,j*3-1),'r*');
    end
    %pause(0.3);
end

end
