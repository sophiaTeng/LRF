

figure;
hold on;
axis([1 18 10 50]);
% plot(0,35,'b-');
%xlabel('max allowed distance to GT/(mm)');
ylabel('%average time per frames/(ms)');
xlabel('Number of trees');
set(gca,'ygrid','on')

% plot(1,100,'k.');

x = 1:17;
oury = [28.54, 29.2, 28.74, 29.61, 30.64, 33.23, 32.54, 32.1, 32.19, 31.88, 33.48, 32.08, 32.73, 35.0, 35.54, 35.5,35.12 ];


for ii =1:17
    
    plot(x(ii),oury(ii),'bo','MarkerFaceColor','b');
    
    if(ii > 1)
        line([x(ii),x(ii-1)],[oury(ii),oury(ii-1)],'color','b');
    end
    
end

 legend('AvgNodeNum = 118025/tree','Location','NorthWest');
 
 
 %% plot trees
%  
% figure;
% hold on;
% axis([1 18 0 90]);
% % plot(0,35,'b-');
% %xlabel('max allowed distance to GT/(mm)');
% ylabel('%frames with all joints with D');
% xlabel('Number of trees');
% set(gca,'ygrid','on')
% 
% % plot(1,100,'k.');
% 
% x = 1:17;
% oury = [40.11; 50.85; 54.64; 60.42; 61.99; 64.92; 66.4; 67.06; 68.40; 68.58; 70.07; 69.94; 70.60; 70.18; 70.55; 71.08; 70.94];
% ltmgeo = [10; 11;19; 21; 24; 30; 35; 32; 33; 35; 37; 38; 39; 41; 43; 44; 43];
% 
% for ii =1:17
%     
%     plot(x(ii),ltmgeo(ii),'ro','MarkerFaceColor','r');
%     plot(x(ii),oury(ii),'bo','MarkerFaceColor','b');
%     
%     if(ii > 1)
%         line([x(ii),x(ii-1)],[ltmgeo(ii),ltmgeo(ii-1)],'color','r');
%         line([x(ii),x(ii-1)],[oury(ii),oury(ii-1)],'color','b');
%     end
%     
% end
% 
%  legend('LTM(Geodesic)','Our implement','Location','NorthWest');

