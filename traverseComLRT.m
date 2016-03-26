%% test Process : recursively traverse a finished LRT
%
%  call function: traverseComLRT
%
%  Function:  This .m file is used for traverse a LRT with a single image
%
%  Input: @img ： test image
%            @nodeNo :  current node no.
%            @LRT : a finished LRT tree 
%            @pos : centre of mass of depth image(x,y,z/ z is an origin depth using to normalize)
%            @postionSet : 16 obserable vertexes
%            @latentSet : all vertexes including latent vertexes
%
%  Output: @postionSet : final 16 positions
%               @latentSet: 31 vertexes
%
%   written by Sophia
%   2016.01.22
%%
function [postionSet,latentSet]= traverseComLRT(img,nodeNo,LRT,pos,postionSet,latentSet)

x = pos(1,1);
y = pos(1,2);
origind = pos(1,3);

%% 遍历树
if(LRT{nodeNo,1}(1) == 1)
%split node
    u = [x+(LRT{nodeNo,1}(5)/origind) y+(LRT{nodeNo,1}(6)/origind)];
    v = [x+(LRT{nodeNo,1}(7)/origind) y+(LRT{nodeNo,1}(8)/origind)];
    f = double(img(uint16(u(1,2)),uint16(u(1,1)))) - double(img(uint16(v(1,2)),uint16(v(1,1))));
    if(f <= LRT{nodeNo,1}(9))
        %% left 
        [postionSet,latentSet] = traverseComLRT(img,LRT{nodeNo,1}(3),LRT,pos,postionSet,latentSet);
    else 
        %% right
        [postionSet,latentSet] = traverseComLRT(img,LRT{nodeNo,1}(4),LRT,pos,postionSet,latentSet);
    end
else
    %%division node
    posl = pos + [LRT{nodeNo,1}(5) LRT{nodeNo,1}(6) 0];
    posr = pos + [LRT{nodeNo,1}(8) LRT{nodeNo,1}(9) 0];
    
%     plot(posl(1,1),posl(1,2),'go');
%     text(posl(1,1),posl(1,2),'-------------------------------------left');
%     plot(posr(1,1),posr(1,2),'go');
%     text(posr(1,1),posr(1,2),'-------------------------------------right');

    latentSet{size(latentSet,1)+1,1} = posl;
    latentSet{size(latentSet,1)+1,1} = posr;
    
    if(LRT{nodeNo,1}(3) == -2 && LRT{nodeNo,1}(4) ~= -2)
    %%division node 左节点是叶子节点
        postionSet{size(postionSet,1)+1,1} = posl;
        [postionSet,latentSet] = traverseComLRT(img,LRT{nodeNo,1}(4),LRT,posr,postionSet,latentSet);
    elseif(LRT{nodeNo,1}(4) == -2 && LRT{nodeNo,1}(3) ~= -2)
    %%division node 右节点是叶子节点
        postionSet{size(postionSet,1)+1,1} = posr;
        [postionSet,latentSet] = traverseComLRT(img,LRT{nodeNo,1}(3),LRT,posl,postionSet,latentSet);
    elseif(LRT{nodeNo,1}(4) == -2 && LRT{nodeNo,1}(3) == -2)
    %%division node 两个节点都是叶子节点
        postionSet{size(postionSet,1)+1,1} = posl;
        postionSet{size(postionSet,1)+1,1} = posr;
        return;
%     hold on;
%     plot(posl(1,1),posl(1,2),'r.');
%     plot(posr(1,1),posr(1,2),'r.');
%     pause(1);
    else
    %%division node中间节点
        [postionSet,latentSet] = traverseComLRT(img,LRT{nodeNo,1}(3),LRT,posl,postionSet,latentSet);
        [postionSet,latentSet] = traverseComLRT(img,LRT{nodeNo,1}(4),LRT,posr,postionSet,latentSet);
    end
end



