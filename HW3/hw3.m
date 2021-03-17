%%  
clear ; close all; clc
%% Watch movie
load('cam1_4.mat');
filter = zeros(480,640);
filter(:, :) = 1;
numFrames = size(vidFrames1_4,4);
for j = 1:numFrames
    X = vidFrames1_4(:,:,:,j);
    imshow(X); 
    drawnow
end
%% Method 1 
clear ; close all; clc
%% Camera 1
% The range of the bucket is from 310 to 385
filter = zeros(480,640);
filter(47:433,310:385) = 1;
coord1 = [];
load('cam1_1.mat');
numFrames = size(vidFrames1_1,4);
for j = 1:numFrames
    X = vidFrames1_1(:,:,:,j);
    Xgray = rgb2gray(X);
    Xgrayd = double(Xgray);
    Xgrayf = Xgrayd.*filter;
    [mv,idx] = max(Xgrayf(:));
    [x,y] = ind2sub(size(Xgrayf), idx);
    filter = zeros(480,640);
    filter(x-20:x+20,y-20:y+20) = 1;
    coord1 = [coord1, [y;x]];
end
%% Camera 2
load('cam2_1.mat');
coord2 = [];
filter = zeros(480,640);
filter(100:433,250:330) = 1;
numFrames = size(vidFrames2_1,4);
for j = 1:numFrames
    X = vidFrames2_1(:,:,:,j);
    Xgray = rgb2gray(X);
    Xgrayd = double(Xgray);
    Xgrayf = Xgrayd.*filter;
    [mv,idx] = max(Xgrayf(:));
    [x,y] = ind2sub(size(Xgrayf), idx);
    filter = zeros(480,640);
    filter(x-20:x+20,y-20:y+20) = 1;
    coord2 = [coord2, [y;x]];
end
%% Camera 3
load('cam3_1.mat');j
coord3 = [];
% Motion is in X direction so change filter
filter = zeros(480,640);
filter(250:330,220:end) = 1;
numFrames = size(vidFrames3_1,4);
for j = 1:numFrames
    X = vidFrames3_1(:,:,:,j);
    Xgray = rgb2gray(X);
    Xgrayd = double(Xgray);
    Xgrayf = Xgrayd.*filter;
    [mv,idx] = max(Xgrayf(:));
    [x,y] = ind2sub(size(Xgrayf), idx);
    filter = zeros(480,640);
    filter(x-20:x+20,y-20:y+20) = 1;
    coord3 = [coord3, [y;x]];
end
%% SVD
trim = size(coord1);
coord2 = coord2(:,1:trim(2));
coord3 = coord3(:,1:trim(2));
X = [coord1;coord2;coord3];
avgs = mean(X,2);
for j = 1:6
    X(j,:) = X(j,:) - avgs(j);
end
A = X/sqrt(trim(2)-1);
[U,S,V] = svd(A,'econ');
%% Ploting the energy curve
subplot(1,2,1);
sig = diag(S);
plot(sig.^2/sum(sig.^2),'ko','Linewidth',2)
title('Energy of each approximation');
xlabel('Energy captured');
ylabel('The rank of the approximation');
%% Principal Component projection
p = U' * X;
subplot(1,2,2)
hold on
plot(1:trim(2),p(1,:))
plot(1:trim(2),p(2,:))
title('Plot of the significant principal components')
ylabel('Displacement');
xlabel('Time');
legend('PC1','PC2');
%% Method 2
clear ; close all; clc
%% Camera 1
load('cam1_2.mat');
filter = zeros(480,640);
filter(1:320,300:430) = 1;
coord1 = [];
numFrames = size(vidFrames1_2,4);
for j = 1:numFrames
    X = vidFrames1_2(:,:,:,j);
    Xgray = rgb2gray(X);
    Xgrayd = double(Xgray);
    Xgrayf = Xgrayd .* filter;
    [mv,idx] = max(Xgrayf(:));
    [x,y] = ind2sub(size(Xgrayf), idx);
    filter = zeros(480,640);
    filter(x-20:x+12,y-20:y+20) = 1;
    coord1 = [coord1, [y;x]];
end
%% Camera 2
load('cam2_2.mat');
numFrames = size(vidFrames2_2,4);
filter = zeros(480,640);
filter(1:370,210:380) = 1;
coord2 = [];
for j = 1:numFrames
    X = vidFrames2_2(:,:,:,j);
    Xgray = rgb2gray(X);
    Xgrayd = double(Xgray);
    Xgrayf = Xgrayd.*filter;
%     imshow(uint8(Xgrayf));  
%     drawnow
    [mv,idx] = max(Xgrayf(:));
    [x,y] = ind2sub(size(Xgrayf), idx);
    filter = zeros(480,640);
    filter(x-50:x+45,y-40:y+40) = 1;
    coord2 = [coord2, [y;x]];
end
%% Camera 3
load('cam3_2.mat');
filter = zeros(480,640);
filter(160:330,:) = 1;
coord3 = [];
numFrames = size(vidFrames3_2,4);
for j = 1:numFrames
    X = vidFrames3_2(:,:,:,j);
    Xgray = rgb2gray(X);
    Xgrayd = double(Xgray);
    Xgrayf = Xgrayd .* filter;
%     imshow(uint8(Xgrayf)); 
%     drawnow
    [mv,idx] = max(Xgrayf(:));
    [x,y] = ind2sub(size(Xgrayf), idx);
    filter = zeros(480,640);
    filter(x-30:x+30,y-30:y+30) = 1;
    coord3 = [coord3, [y;x]];
end
%% SVD
trim = size(coord1);
coord2 = coord2(:,1:trim(2));
coord3 = coord3(:,1:trim(2));
X = [coord1;coord2;coord3];
avgs = mean(X,2);
for j = 1:6
    X(j,:) = X(j,:) - avgs(j);
end
% let A = X/sqrt(n-1)
A = X/sqrt(trim(2)-1);
[U,S,V] = svd(A,'econ');
sig = diag(S);
%% Ploting the energy curve
subplot(1,3,1);
sig = diag(S);
plot(sig.^2/sum(sig.^2),'ko','Linewidth',2)
title('Energy of each approximation');
xlabel('Energy captured');
ylabel('The rank of the approximation');
%% Principal Component projection
p = U' * X;
subplot(1,3,2)
hold on
plot(1:trim(2),p(1,:))
plot(1:trim(2),p(2,:))
title('First two significant principal components')
ylabel('Displacement');
xlabel('Time');
legend('PC1','PC2');
subplot(1,3,3);
hold on
plot(1:trim(2),p(3,:))
plot(1:trim(2),p(4,:))
title('Third and fourth significant principal components')
ylabel('Displacement');
xlabel('Time');
legend('PC3','PC4');
%% Method 3
clear ; close all; clc
%% Camera 1
load('cam1_3.mat');
filter = zeros(480,640);
filter(:,250:400) = 1;
coord1 = [];
numFrames = size(vidFrames1_3,4);
for j = 1:numFrames
    X = vidFrames1_3(:,:,:,j);
    Xgray = rgb2gray(X);
    Xgrayd = double(Xgray);
    Xgrayf = Xgrayd .* filter;
    [mv,idx] = max(Xgrayf(:));
    [x,y] = ind2sub(size(Xgrayf), idx);
    filter = zeros(480,640);
    filter(x-20:x+20,y-20:y+20) = 1;
    coord1 = [coord1, [y;x]];
end
%% Camera 2
load('cam2_3.mat');
filter = zeros(480,640);
filter(:,200:420) = 1;
coord2 = [];
numFrames = size(vidFrames2_3,4);
for j = 1:numFrames
    X = vidFrames2_3(:,:,:,j);
    Xgray = rgb2gray(X);
    Xgrayd = double(Xgray);
    Xgrayf = Xgrayd .* filter;
    [mv,idx] = max(Xgrayf(:));
    [x,y] = ind2sub(size(Xgrayf), idx);
    filter = zeros(480,640);
    filter(x-40:x+40,y-40:y+40) = 1;
    coord2 = [coord2, [y;x]];
end
%% Camera 3
load('cam3_3.mat');
filter = zeros(480,640);
filter(180:340,:) = 1;
numFrames = size(vidFrames3_3,4);
coord3 = [];
for j = 1:numFrames
    X = vidFrames3_3(:,:,:,j);
    Xgray = rgb2gray(X);
    Xgrayd = double(Xgray);
    Xgrayf = Xgrayd .* filter;
    [mv,idx] = max(Xgrayf(:));
    [x,y] = ind2sub(size(Xgrayf), idx);
    filter = zeros(480,640);
    filter(x-30:x+30,y-30:y+30) = 1;
    coord3 = [coord3, [y;x]];
end
%% SVD
trim = size(coord3);
coord1 = coord1(:,1:trim(2));
coord2 = coord2(:,1:trim(2));
X = [coord1;coord2;coord3];
avgs = mean(X,2);
for j = 1:6
    X(j,:) = X(j,:) - avgs(j);
end
% let A = X/sqrt(n-1)
A = X/sqrt(trim(2)-1);
[U,S,V] = svd(A,'econ');
sig = diag(S);
%% Ploting the energy curve
subplot(1,3,1);
sig = diag(S);
plot(sig.^2/sum(sig.^2),'ko','Linewidth',2)
title('Energy of each approximation');
xlabel('Energy captured');
ylabel('The rank of the approximation');
%% Principal Component projection
p = U' * X;
subplot(1,3,2)
hold on
plot(1:trim(2),p(1,:))
plot(1:trim(2),p(2,:))
title('First two significant principal components')
ylabel('Displacement');
xlabel('Time');
legend('PC1','PC2','PC3','PC4');
subplot(1,3,3)
hold on
plot(1:trim(2),p(3,:))
title('Third principal component')
ylabel('Displacement');
xlabel('Time');
legend('PC3');
%% Method 4
clear ; close all; clc
%% Camera 1
load('cam1_4.mat');
filter = zeros(480,640);
filter(:,300:480) = 1;
numFrames = size(vidFrames1_4,4);
coord1 = [];
for j = 1:numFrames
    X = vidFrames1_4(:,:,:,j);
    Xgray = rgb2gray(X);
    Xgrayd = double(Xgray);
    Xgrayf = Xgrayd .* filter;
    [mv,idx] = max(Xgrayf(:));
    [x,y] = ind2sub(size(Xgrayf), idx);
    filter = zeros(480,640);
    filter(x-30:x+30,y-30:y+30) = 1;
    coord1 = [coord1, [y;x]];
end
%% Camera 2
load('cam2_4.mat');
filter = zeros(480,640);
filter(:,200:400) = 1;
numFrames = size(vidFrames2_4,4);
coord2 = [];
for j = 1:numFrames
    X = vidFrames2_4(:,:,:,j);
    Xgray = rgb2gray(X);
    Xgrayd = double(Xgray);
    Xgrayf = Xgrayd .* filter;
    [mv,idx] = max(Xgrayf(:));
    [x,y] = ind2sub(size(Xgrayf), idx);
    filter = zeros(480,640);
    filter(x-30:x+30,y-30:y+30) = 1;
    coord2 = [coord2, [y;x]];
end
%% Camera 3
load('cam3_4.mat');
filter = zeros(480,640);
filter(140:280,250:end) = 1;
numFrames = size(vidFrames3_4,4);
coord3 = [];
for j = 1:numFrames
    X = vidFrames3_4(:,:,:,j);
    Xgray = rgb2gray(X);
    Xgrayd = double(Xgray);
    Xgrayf = Xgrayd .* filter;
    [mv,idx] = max(Xgrayf(:));
    [x,y] = ind2sub(size(Xgrayf), idx);
    filter = zeros(480,640);
    filter(x-30:x+30,y-30:y+30) = 1;
    coord3 = [coord3, [y;x]];
end
%% SVD
trim = size(coord1);
coord2 = coord2(:,1:trim(2));
coord3 = coord3(:,1:trim(2));
X = [coord1;coord2;coord3];
avgs = mean(X,2);
for j = 1:6
    X(j,:) = X(j,:) - avgs(j);
end
% let A = X/sqrt(n-1)
A = X/sqrt(trim(2)-1);
[U,S,V] = svd(A,'econ');
sig = diag(S);
%% Ploting the energy curve
subplot(1,3,1);
sig = diag(S);
plot(sig.^2/sum(sig.^2),'ko','Linewidth',2)
title('Energy of each approximation');
xlabel('Energy captured');
ylabel('The rank of the approximation');
%% Principal Component projection
p = U' * X;
subplot(1,3,2)
hold on
plot(1:trim(2),p(0,:))
plot(1:trim(2),p(2,:))
title('The first two significant principal components')
ylabel('Displacement');
xlabel('Time');
legend('PC1','PC2');
subplot(1,3,3)
hold on
plot(1:trim(2),p(3,:))
title('Third')
ylabel('Displacement');
xlabel('Time');
legend('PC3');