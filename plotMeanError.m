
%%
function plotMeanError(meanerrorSet)
figure;
hold on;
% plot(0,35,'b-');
%xlabel('max allowed distance to GT/(mm)');
ylabel('Mean error distance(mm)');
xlabel('Joints');
set(gca,'ygrid','on')

ltmgeo = [9.4; 12; 17.4; 25; 14; 21.5; 27; 12; 22; 28; 11; 18; 24; 12; 17; 26; 18];
meanerrorSet = [meanerrorSet; mean(meanerrorSet)];

fig = [ltmgeo meanerrorSet];
h = bar(fig,1);
set(h(1),'FaceColor','[0.8 0.1 0]','EdgeColor','[0.8 0.1 0]');
set(h(2),'FaceColor','[0 0 0.8]','EdgeColor','[0 0 0.8]');
x = 1:17;
y ={'Plam', 'Thumb R.', 'Thumb M.', 'Thumb T.', 'Index R.', 'Index M.', 'Index T.', 'Mid R.', 'Mid M.', 'Mid T.', 'Ring R.', 'Ring M.', 'Ring T', 'Pinky R.' , 'Pinky M.', 'Pinky T.', 'Mean'};
% text(x,y,'HorizontalAlignment','right','rotation',45);
set(gca, 'XTick',x,'XTickLabel',y);
set(gca,'XTickLabelRotation',90);

 legend('LTM(Geodesic)','Our implement','Location','NorthWest');
 plot(0,50,'w-');

end