%% read the label.txt & create imageindex, split imagename & labels
%
%  call function: NULL
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

function [imageIndex,imageNames,labels] = readLabelFromFile(label_filename)

line = textread(label_filename,'%s');
imageNum = size(line,1)/49;
imageIndex = zeros(imageNum,1);        % save image index
imageNames = cell(imageNum,1);         % save image name
labels = zeros(imageNum,48);           % save all the labels,e.g.[(x,y,z),(x,y,z),...,]

%%
%% separate the image' name and label
for i = 1:imageNum
    imageIndex(i) = i;
    imageNames(i) = line(49*i-48);
    labels(i,:) = str2double(line(49*i-47:49*i));
    
%     %show image & labels
%     I = imread(['./Training/Depth/',imageNames{i,1}]);
%     threhold = max(I(find(I < 30000)));
%     [row,col] = find(I < 30000);
%     I(find(I > 30000)) = threhold;
%     figure;imshow(mat2gray(I));
%     hold on;
%     for j = 1:16
%         plot(labels(i,j*3-2),labels(i,j*3-1),'r*');
%         plot(uint16(labels(i,j*3-2)),uint16(labels(i,j*3-1)),'bo');
%     end
%     pause(0.5);
%     close Figure 1;
    
end

end