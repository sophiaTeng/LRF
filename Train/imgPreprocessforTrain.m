%TRAIN LATENT REGRESSION TREE for Hand Estimation

%% image pre-process
%
%  call function: imgPreprocess()
%
%  Function:This .m file is used for image pre-process to cut out the hand
%
%  Input:  @imgname :  image name & path
%             @th : threshold deep to cut out hand
%  Output: @originx : center point x
%               @originy : center point y
%               @origind : center point d
%               @img : 
%
%  written by Sophia
%  last modified date: 2016.03.31
%%

function [originx,originy,origind,img] = imgPreprocess(imgname,th)
 
    img = imread(imgname);
    [row,col] = find(img < th);  %取mass center
    originx = mean(col);
    originy = mean(row);
    %     img(find(img > th)) = 1000;

    

    %% find all black image
    if(isnan(originx) || isnan(originy))
        disp(['image=' imgname]);
        origind = 0;
        return;
    end
    %disp(['originx=' num2str(originx) 'originy=' num2str(originy)]);
    origind = double(img(uint16(originy),uint16(originx)));

end
