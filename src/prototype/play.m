function play (videoPath, saliencyPath)
v1 = VideoReader(videoPath);
v2 = VideoReader(saliencyPath);
figure

i1 = 0;
i2 = 0;
while i1 < v1.NumberOfFrames && i2 < v2.NumberOfFrames
    if i1 < v1.NumberOfFrames
        i1 = i1+1;
        subplot(1,2,1)
        image(v1.read(i1))
    end

    if i2 < v2.NumberOfFrames
        i2 = i2+1;
        subplot(1,2,2)
        image(v2.read(i2))
    end

    drawnow
end