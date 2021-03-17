%%  
clear ; close all; clc
%% Load the movies
monte = VideoReader('monte_carlo_low.mp4');
%% Creating matrix frame by frame
[frame1,t1,dt1,h1,w1] = frame2Matrix(monte);
%% DMD of monte 
[background, foreground] = DMD(frame1,t1,dt1,0.1);
numFrames1 = size(frame1,2);
%% Foreground construction
for i = 1:numFrames1
    currFrame = reshape(foreground(:,i),h1,w1);
    pcolor(flipud(currFrame)), colormap(gray), shading interp
    drawnow
end
%% Background construction
for i = 1:numFrames1
    currFrame = reshape(background(:,i),h1,w1);
    pcolor(flipud(currFrame)), colormap(gray), shading interp
    drawnow
end
%% Original video construction
total = background + foreground;
for i = 1:numFrames1
    currFrame = reshape(total(:,i),h1,w1);
    pcolor(flipud(currFrame)), colormap(gray), shading interp
    drawnow
end
%% Plot one frame
frame = 40;
subplot(1,2,1)
backFrame = reshape(background(:,frame),h1,w1);
pcolor(flipud(backFrame)), colormap(gray), shading interp
title('Background frame 40')
subplot(1,2,2)
foreFrame = reshape(foreground(:,frame),h1,w1);
pcolor(flipud(foreFrame)), colormap(gray), shading interp
title('Foreground frame 40')
%% Compare original
subplot(1,2,1)
totalFrame = reshape(total(:,frame),h1,w1);
pcolor(flipud(totalFrame)), colormap(gray), shading interp
title('Background+Foreground frame 40')
subplot(1,2,2)
OriginalFrame = reshape(frame1(:,frame),h1,w1);
pcolor(flipud(OriginalFrame)), colormap(gray), shading interp
title('Original frame 40')
%%  
clear; close all; clc
%% DMD for ski
ski = VideoReader('ski_drop_low.mp4');
[frame2,t2,dt2,h2,w2] = frame2Matrix(ski);
[background2, foreground2] = DMD(frame2,t2,dt2,0.1);
%% Foreground construction
numFrames1 = size(frame2,2);
for i = 1:numFrames1
    currFrame = reshape(abs(foreground2(:,i)),h2,w2);
    pcolor(flipud(currFrame)), colormap(gray), shading interp
    drawnow
end
%% Background construction
for i = 1:numFrames1
    currFrame = reshape(abs(background2(:,i)),h2,w2);
    pcolor(flipud(currFrame)), colormap(gray), shading interp
    drawnow
end
%% Original video construction
total = background2 + foreground2;
for i = 1:numFrames1
    currFrame = reshape(abs(total(:,i)),h2,w2);
    pcolor(flipud(currFrame)), colormap(gray), shading interp
    drawnow
end
%% Plot one frame
frame = 410;
subplot(1,2,1)
backFrame = reshape(background2(:,frame),h2,w2);
pcolor(flipud(backFrame)), colormap(gray), shading interp
title('Background frame 410')
subplot(1,2,2)
foreFrame = reshape(foreground2(:,frame),h2,w2);
pcolor(flipud(foreFrame)), colormap(gray), shading interp
title('Foreground frame 410')
%% Compare original
subplot(1,2,1)
totalFrame = reshape(total(:,frame),h2,w2);
pcolor(flipud(totalFrame)), colormap(gray), shading interp
title('Background+Foreground frame 410')
subplot(1,2,2)
OriginalFrame = reshape(frame2(:,frame),h2,w2);
pcolor(flipud(OriginalFrame)), colormap(gray), shading interp
title('Original frame 410')