%TEST LATENT REGRESSION TREE for Hand Estimation

%% image pre-process for Test
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

function [originx,originy,origind,img] = imgPreprocessforTest(imgname,th)
 
    img = imread(imgname);
    %maxdep = max(img(find(img < th)));
    img(find(img > th)) = 32001;
    img(:,290:end) = 32001;
    [row,col] = find(img < th);
    originx = mean(col);
    originy = mean(row);
    
    if(isnan(originx) || isnan(originy))
        disp(['image=' imgname]);
        origind = 0;
        return;
    end
    %disp(['originx=' num2str(originx) 'originy=' num2str(originy)]);
    origind = double(img(uint16(originy),uint16(originx)));

end
