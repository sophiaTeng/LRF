
%%

function plotmaxGT(accuracy)

figure;
hold on;
xlabel('max allowed distance to GT/(mm)');
ylabel('%frames with all joints with D');
set(gca,'ygrid','on')
ltmgeo = [0;12;30;48;62;75;81.5;85];
accuracy = accuracy * 100;

    
    plot(0,0,'r-');
    plot(0,0,'b-');
    line([0,10],[0,ltmgeo(1)],'color','r');
    line([0,10],[0,accuracy(1)],'color','b');
    
for ii = 1:size(accuracy,1)
    maxDis = ii*10;
    %accurancySet(ii) = accurancyCount(ii) / size(allimgNames,1)
    disp(['Maxdis : ',num2str(maxDis)]);
    disp(['Accurancy : ' num2str(accuracy(ii))]);
    
    plot(maxDis,ltmgeo(ii),'r-');
    plot(maxDis,accuracy(ii),'b-');
    
    if(ii > 1)
        line([maxDis,(ii-1)*10],[ltmgeo(ii),ltmgeo(ii-1)],'color','r');
        line([maxDis,(ii-1)*10],[accuracy(ii),accuracy(ii-1)],'color','b');
    end
end
 legend('LTM(Geodesic)','Our implement','Location','NorthWest');

end