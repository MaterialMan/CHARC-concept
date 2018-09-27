

f1 = figure
v = VideoWriter('NS_2.avi');
%database = all_search_archives{1,40};
xlim([0 200])
ylim([0 70])
xlabel('KR-GR')
ylabel('MC')
hold on
open(v);
cnt = 1;
for i = 1:50:length(database)
    title(strcat('Generation: ',num2str(i)))
    scatter(database(i:i+50-1,1),database(i:i+50-1,2),20,i:i+50-1)
    drawnow
    %pause(0.001)
    colormap('copper')
    F(cnt) = getframe(f1);
    writeVideo(v,F(cnt));
    cnt = cnt+1;
end
hold off
close(v)