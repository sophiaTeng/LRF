%TRAIN LATENT REGRESSION TREE for Hand Estimation

function[x,y,d] = depthrevise(I,row,col,pdepth)

%取到背景深度，以r为领域取值，直到深度小于30000

r = 0;
minpix = pdepth;
%取该点领域为r的像素值最小的像素值
while(minpix > 30000)
    r = r+1;
    if(row-r <= 0)  %领域r超出图像上界
        neardepth = I(row:row+r,col-r:col+r);
        [minpix,dindex] = min(neardepth(:));
        [subr,subc] = ind2sub(size(neardepth),dindex);
        corct_row = row+subr;
        corct_col = col-(r+1)+subc;
    elseif(row+r > 240)  %领域r超出图像下界
        neardepth = I(row-r:row,col-r:col+r);
        [minpix,dindex] = min(neardepth(:));
        [subr,subc] = ind2sub(size(neardepth),dindex);
        corct_row = row-subr;
        corct_col = col-(r+1)+subc;
    else %未超出上下界（此处没靠考虑左右界）
        neardepth = I(row-r:row+r,col-r:col+r);
        [minpix,dindex] = min(neardepth(:));
        [subr,subc] = ind2sub(size(neardepth),dindex);
        corct_row = row-(r+1)+subr;
        corct_col = col-(r+1)+subc;
    end
    
    %check image
    if(r >50)
        disp('Please check this image');
    end
    
end
%plot(corct_col,corct_row,'g.');
x = corct_col;
y = corct_row;
d = I(corct_row,corct_col);
           

        
end
