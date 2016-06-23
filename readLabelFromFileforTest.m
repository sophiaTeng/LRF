%% read the label.txt & create imageindex, split imagename & labels
%
%  call function: depthrevise()
%
%  Function: This .m file is used for read the label.txt and save as cells
%
%  Input:   @label_filename: label.txt file
%
%  Output:  @imageIndex: build an index for all training images
%                @imageNames: all training images' path & names
%                @labels: 16 observed vertexes's position
%
%   written by Sophia
%   2016.01.12
%%

function [imageIndex,imageNames,labels] = readLabelFromFileforTest(label_filename,img_path)

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