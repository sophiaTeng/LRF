%% test Process : recursively traverse a unfinished LRT
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

function leafNode= traverseUncomLRT(img,nodeNo,LRT,pos,leafNode)

x = pos(1,1);
y = pos(1,2);
origind = pos(1,3);

%% 遍历树
if(LRT{nodeNo,1}(1) == 1)
%split node

%     u = [x+(LRT{nodeNo,1}(5)/origind) y+(LRT{nodeNo,1}(6)/origind)];
%     v = [x+(LRT{nodeNo,1}(7)/origind) y+(LRT{nodeNo,1}(8)/origind)];
    
    u = [x+(LRT{nodeNo,1}(5)) y+(LRT{nodeNo,1}(6))];
    v = [x+(LRT{nodeNo,1}(7)) y+(LRT{nodeNo,1}(8))];
    
        %offset <= 0
        if(u(1,1)<1)
            u(1,1) = 1;
        elseif(u(1,1) >320)
            u(1,1) = 320;
        end
        if(u(1,2)<1)
            u(1,2) =1;
        elseif(u(1,2) >240)
            u(1,2) = 240;
        end;
        
        if(v(1,1) < 1)
            v(1,1) = 1;
        elseif( v(1,1) >320)
            v(1,1) = 320;
        end
        if(v(1,2) < 1)
            v(1,2) = 1;
        elseif(v(1,2) >240)
             v(1,2) = 240;
        end
    %disp(['u=(' num2str(u(1,1)) ','  num2str(u(1,2)) ') v=(' num2str(v(1,1)) ','  num2str(v(1,2)) ')'] );
  
    f = double(img(uint16(u(1,2)),uint16(u(1,1)))) - double(img(uint16(v(1,2)),uint16(v(1,1))));
%     plot(u(1,1),u(1,2),'r.');
%     plot(v(1,1),v(1,2),'g.');
%     disp(['u = (', num2str(u(1,1)),',',num2str(u(1,2)),') ','v = (',num2str(v(1,1)),',',num2str(v(1,2)),') ','f=',num2str(f),'| tao= ',num2str(LRT{nodeNo,1}(9)),', nodeNo = ', num2str(nodeNo)]);
%     
    if(f < LRT{nodeNo,1}(9))
        %% left 
        [leafNode] = traverseUncomLRT(img,LRT{nodeNo,1}(3),LRT,pos,leafNode);
    else 
        %% right
        [leafNode] = traverseUncomLRT(img,LRT{nodeNo,1}(4),LRT,pos,leafNode);
    end
else
    
    %% no hand size normolize 
        posl = pos + [LRT{nodeNo,1}(5) LRT{nodeNo,1}(6) 0];
        posr = pos + [LRT{nodeNo,1}(7) LRT{nodeNo,1}(8) 0];

%         plot(posl(1,1),posl(1,2),'r*');
%         plot(posr(1,1),posr(1,2),'g*');
%         disp(['posl = (', num2str(posl(1,1)),',',num2str(posl(1,2)),') ','posr = (',num2str(posr(1,1)),',',num2str(posr(1,2)),') ',' nodeNo = ',num2str(nodeNo)]);
    
    if(LRT{nodeNo,1}(3) == -2 && LRT{nodeNo,1}(4) ~= -2)
    %%division node 左节点是叶子节点
       leafNode = traverseUncomLRT(img,LRT{nodeNo,1}(4),LRT,posr,leafNode);
    elseif(LRT{nodeNo,1}(4) == -2 && LRT{nodeNo,1}(3) ~= -2)
    %%division node 右节点是叶子节点
        leafNode = traverseUncomLRT(img,LRT{nodeNo,1}(3),LRT,posl,leafNode);
    elseif(LRT{nodeNo,1}(3) == -1 && LRT{nodeNo,1}(4) == -1)
    %%LRT division node 是叶子节点
        leafNode{size(leafNode,1)+1,1} = nodeNo;
        return;
    elseif(LRT{nodeNo,1}(3) == -2 && LRT{nodeNo,1}(4) == -2)
     %%LTM division node 是叶子节点
        return;
    else
    %%division node中间节点
        leafNode = traverseUncomLRT(img,LRT{nodeNo,1}(3),LRT,posl,leafNode);
        leafNode = traverseUncomLRT(img,LRT{nodeNo,1}(4),LRT,posr,leafNode);
    end
end