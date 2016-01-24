function saveScreenshot(hObject, eventdata, handles) 
i=0;
while exist(strcat('file',num2str(i),'.png'),'file' ) == 2
    i = i+1;
end
saveas(1, strcat('file',num2str(i)), 'png');