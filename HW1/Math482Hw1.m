clear all; close all; clc 
%% 
load subdata.mat 
% Imports the data as the 262144x49 (space by time) matrix called subdata
L = 10; 
% spatial domain
n = 64; 
% Fourier modes
x2 = linspace(-L,L,n+1);
x = x2(1:n); 
y = x; 
z = x;
k = (2*pi/(2*L))*[0:(n/2 - 1) -n/2:-1];
ks = fftshift(k);
[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);
for j=1:49
   Un(:,:,:)=reshape(subdata(:,j),n,n,n);
    M = max(abs(Un),[],'all');
end
%% Averaging
avg = zeros(64,64,64);
for j=1:49
   Un(:,:,:)=reshape(subdata(:,j),n,n,n);
   Unt = fftn(Un);
   avg =  avg + Unt;
end
avg = abs(fftshift(avg))./49;
[mxv,idx] = max(avg(:));
[x1,y1,z1] = ind2sub(size(avg),idx);
%% Generating Figure 1
avg = abs(avg)/max(abs(avg(:)));
isosurface(Kx,Ky,Kz,avg,0.2);
axis([-20 20 -20 20 -20 20]), grid on, drawnow
%% Center frequency
Kx0 = Kx(x1,y1,z1);
Ky0 = Ky(x1,y1,z1);
Kz0 = Kz(x1,y1,z1);
%% Gaussian Filter
tau = 0.8;
filter = exp(-tau*(Kx - Kx0).^2 + -tau*(Ky - Ky0).^2 + -tau*(Kz - Kz0).^2);
%% X,Y,Z coordinates of the submarine
res = zeros(3,49);
for j=1:49
   Un(:,:,:)=reshape(subdata(:,j),n,n,n);
   Unt = fftshift(fftn(Un));
   Untf = Unt.*filter;
   Unf = ifftn(Untf);
   [m,i] = max(Unf(:));
   [x2,y2,z2] = ind2sub(size(Unf),i);
   res(:,j) = [x2,y2,z2];
end
%% Plotting the result
plot3(res(1,:),res(2,:),res(3,:));
grid on, drawnow
xlabel('X'); ylabel('Y'); zlabel('Z'); 