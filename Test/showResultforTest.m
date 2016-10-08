%TEST LATENT REGRESSION TREE for Hand Estimation

%% show test result
%
%  call function: plotLTM()
%                       rlrt()
%
%  Function: This .m file is used for showing test result(31 point & stage)
%
%  Input: @img: test image
%            @LatSet : test result 31points
%            @corctset : ground truth 16 points 
%
%  Output: LTM tree
%
%  written by  Sophia
%  2016.01.12
%%
function showResult(img,LatSet,corctset)

%     posSet = cell2mat(posSet);
%     LatSet = cell2mat(LatSet);
    
    figure;imshow(mat2gray(img));
    hold on;
    plot(LatSet(1,1),LatSet(1,2),'rd');
    for j = 1:size(corctset,1)
        plot(corctset(j,1),corctset(j,2),'bo');
    end
    
    resultlrt = rlrt();
    plotLTM(resultlrt,1,LatSet);
        
end

%% plot LTM node in the test image
%       递归地遍历rlrt，结果可视化
%
%  call function: plotLTM()
%
%  Function: This .m file is used for ploting  LTM position in test image
%
%  Input: @rlrt: result LTM
%            @node: current node
%            @posSet :  test result position
%
%  Output: test image
%
%   written by Sophia
%   last modified date : 2016.03.20
%%
function plotLTM(rlrt,node,posSet)

lef = rlrt(node,3);
rig = rlrt(node,4);
if(lef == -1 && rig == -1)
    plot(posSet(node,1),posSet(node,2),'g*');
    %pause(1);
    return;
else
    plot(posSet(node,1),posSet(node,2),'ro');
    text(posSet(node,1),posSet(node,2),['---------------------------------------------' num2str(rlrt(node,1))]);
    %pause(1);
    line([posSet(node,1),posSet(lef,1)],[posSet(node,2),posSet(lef,2)],'color','r');
    %pause(1);
    plotLTM(rlrt,lef,posSet);
    line([posSet(node,1),posSet(rig,1)],[posSet(node,2),posSet(rig,2)],'color','r');
   % pause(1);
    plotLTM(rlrt,rig,posSet);
end

end

%%
%测试结果得到的31个点根据LTM的分布
%
function resultlrt = rlrt()
rlrt = zeros(31,4);
rlrt(1,:) = [1,-2,2,3];
rlrt(2,:) = [2,1,4,5];
rlrt(3,:) = [2,1,10,11];
rlrt(4,:) = [3,2,-1,-1];
rlrt(5,:) = [3,2,6,7];
rlrt(6,:) = [4,5,-1,-1];
rlrt(7,:) = [4,5,8,9];
rlrt(8,:) = [5,7,-1,-1];
rlrt(9,:) = [5,7,-1,-1];
rlrt(10,:) = [3,3,12,13];
rlrt(11,:) = [3,3,28,29];
rlrt(12,:) = [4,10,14,15];
rlrt(13,:) = [4,10,24,25];
rlrt(14,:) = [5,12,16,17];
rlrt(15,:) = [5,12,20,21];
rlrt(16,:) = [6,14,-1,-1];
rlrt(17,:) = [6,14,18,19];
rlrt(18,:) = [7,17,-1,-1];
rlrt(19,:) = [7,17,-1,-1];
rlrt(20,:) = [6,15,-1,-1];
rlrt(21,:) = [6,15,22,23];
rlrt(22,:) = [7,21,-1,-1];
rlrt(23,:) = [7,21,-1,-1];
rlrt(24,:) = [5,13,-1,-1];
rlrt(25,:) = [5,13,26,27];
rlrt(26,:) = [6,25,-1,-1];
rlrt(27,:) = [6,25,-1,-1];
rlrt(28,:) = [4,11,-1,-1];
rlrt(29,:) = [4,11,30,31];
rlrt(30,:) = [5,29,-1,-1];
rlrt(31,:) = [5,29,-1,-1];
resultlrt = rlrt;
end
