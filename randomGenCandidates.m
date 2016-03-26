%% random generate RBF features and choose maxIG RBF
%
%  call function: NULL
%
%  Function: This .m file is used for randomly propose a set of split candidates {fi,ti}
%
%  Input:  @curImgIndex : current image index
%             @allVertexpos : all image 's all vertexpos(x,y,z)
%             @imageNames : all image Names
%             @LTM
%             @nodeLTM:  current LTM node
%
%  Output: @maxIG:  max Information Gain
%              @bestfeat: best RBF feature
%              @leftset: the left image set after splitting
%              @rigtset:  the right image set after splitting
%
%   written by Sophia
%   2016.01.14
%%

function [maxIG,bestfeat,leftset,rigtset] = randomGenCandidates(curImgIndex,allVertexpos,allmageNames,LTM,nodeLTM,dr)

%if only one image
if(size(curImgIndex,1) <= 1)
    maxIG = 0;
    bestfeat = 0;
    leftset = curImgIndex;
    rigtset = curImgIndex;
    return;
end

currVertexpos = allVertexpos(curImgIndex,:);  %当前子数据集的所有vertexpos坐标
normalizeDepth = currVertexpos(:,3);  %所有图像的center position的深度，用来归一化

numOffsets = 100; %参数：生成u,v的数量
numTaos = 20;     %参数：生成tao的数量
numImages = size(curImgIndex,1);
%numCandidates = numOffsets*numTaos;   %得到Candidate的数量

%%randomly generate 
r = mean(normalizeDepth)*dr; %取值半径
u = (rand(numOffsets,2)*2-1)*r;  %生成（0,1）间的offset u
v = (rand(numOffsets,2)*2-1)*r;  %生成（0,1）间的offset v
taoindex = uint32((rand(numTaos,1))*(numImages-1)+1);     %随机生成下标，用于选取tao
f = zeros(numOffsets,numImages); 


for i = 1:numImages
    dI0 = normalizeDepth(i);
    I = imread(['./Training/Depth/',allmageNames{curImgIndex(i),1}]);
    %切出手掌，避免深度差过大
    maxpix = max(I(find(I < 30000)));
    I(find(I > 30000)) = maxpix;
    curVertexpos_x = repmat(currVertexpos(i,(nodeLTM-1)*3+1),numOffsets,1);
    curVertexpos_y = repmat(currVertexpos(i,(nodeLTM-1)*3+2),numOffsets,1);  
    
%     imshow(I);
%     hold on; 
%     plot(uint16(curVertexpos_x(1,1)),uint16(curVertexpos_y(1,1)),'ro');
%     plot(curVertexpos_x(1,1),curVertexpos_y(1,1),'g.');
%     depth = I(uint16(curVertexpos_y(1,1)),uint16(curVertexpos_x(1,1)));
    
    uI = [uint16(curVertexpos_x+(u(:,1)/dI0)),uint16(curVertexpos_y+(u(:,2)/dI0))];
    vI = [uint16(curVertexpos_x+(v(:,1)/dI0)),uint16(curVertexpos_y+(v(:,2)/dI0))];
    
    %judge whether position in the range of image 0<pos<240*320
    uI(find(uI(:,1)<=0 | uI(:,1)>=320),1) = ceil(curVertexpos_x(1,1));
    uI(find(uI(:,2)<=0 | uI(:,2)>=240),2) = ceil(curVertexpos_y(1,1));
    vI(find(vI(:,1)<=0 | vI(:,1)>=320),1) = ceil(curVertexpos_x(1,1));
    vI(find(vI(:,2)<=0 | vI(:,2)>=240),2) = ceil(curVertexpos_y(1,1));
    
    uf = zeros(size(uI,1),1); 
    vf = zeros(size(vI,1),1); 

    for t = 1:size(uI,1)
        uf(t,1) = I(uI(t,2),uI(t,1));
        vf(t,1) = I(vI(t,2),vI(t,1)); %一张图片一列，100组offset对应的深度差；一行表示同一组offset
    end
    f(:,i) = uf - vf;

end;

lnodeLTM = LTM{nodeLTM,1}(3);  %当前节点的左子节点
rnodeLTM = LTM{nodeLTM,1}(4);  %当前节点的右子结点
alloffvector2left = [currVertexpos(:,lnodeLTM*3-2)-currVertexpos(:,nodeLTM*3-2) , currVertexpos(:,lnodeLTM*3-1)-currVertexpos(:,nodeLTM*3-1) , currVertexpos(:,lnodeLTM*3)-currVertexpos(:,nodeLTM*3)];
alloffvector2rigt = [currVertexpos(:,rnodeLTM*3-2)-currVertexpos(:,nodeLTM*3-2) , currVertexpos(:,rnodeLTM*3-1)-currVertexpos(:,nodeLTM*3-1) , currVertexpos(:,rnodeLTM*3)-currVertexpos(:,nodeLTM*3)];
allcov = sum(diag(cov(alloffvector2left))) + sum(diag(cov(alloffvector2rigt))); %所有样本的所有offset vector的协方差矩阵

IG = zeros(numOffsets,numTaos);

for j = 1:numTaos
    tao = f(:,taoindex(j));
    flag = f - repmat(tao,1,numImages);  
   
    flag(find(flag<=0)) = 0;
    flag(find(flag>0)) = 1;   %0表示别分到左边，1表示被分到右边
    
    for t = 1:numOffsets
        %%left dataset
        lindex = find(flag(t,:) == 0);
        if(size(lindex,2) <= 1)
            lcov = 0;
        else
            lcov = sum(diag(cov(alloffvector2left(lindex,:)))) + sum(diag(cov(alloffvector2rigt(lindex,:))));
        end
        
        %right dataset
        rindex = find(flag(t,:) == 1);
        if(size(rindex,2) <= 1)
            rcov = 0;
        else
            rcov = sum(diag(cov(alloffvector2left(rindex,:)))) + sum(diag(cov(alloffvector2rigt(rindex,:))));
        end
        
        IG(t,j) = allcov - lcov*size(lindex,2)/numImages - rcov*size(rindex,2)/numImages;
    end;
end

[maxIG,index] = max(IG(:));
[subx,suby] = ind2sub(size(IG),index);
% disp(['maxIG = ' num2str(maxIG) 'index = ' num2str(index)]);
besttao = f(subx,taoindex(suby));
bestfeat = [u(subx,:),v(subx,:),besttao];
leftset = curImgIndex(find(f(subx,:) <= besttao));
rigtset = curImgIndex(find(f(subx,:) > besttao));

end
