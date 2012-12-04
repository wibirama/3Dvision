%------------------------------------------------------------------------%
% Computing Center of Mass from Image                                    %
% created by : Sunu Wibirama                                             %
% Please add the DIP website url in your references if you use this code %
% http://wibirama.com/dip/                                               %
%------------------------------------------------------------------------%

clear all;
close all;

im = imread('lego1.png');
figure(1),imshow(im);
g = rgb2gray(im);
c = 255*im2double(g); %normalized the pixel intensity to 0-1 and multiply by 255
th = 80; %choosed threshold value
BW = zeros(size(c,1),size(c,2));

%scanning for pixels
for x = 1:size(c,1)
    for y = 1:size(c,2)
        if (c(x,y)>th)
            BW(x,y) = 1;
        end
    end
end

figure(2),imagesc(BW),colormap(gray),axis image
BW = ~BW;   % ~ is MATLAB's logical negation operator
BWL = bwlabel(BW);   % BWL contains the labeled image
figure(3),imagesc(BWL), colormap(gray), axis image
ob1 = BWL == 1;
figure(4),imshow(ob1);
%pixval on

% Rotating image
%ob1 = imrotate(ob1,50);


%Performing moment calculation%
[rows,cols] = size(ob1);
x = ones(rows,1)*[1:cols];    % Matrix with each pixel set to its x coordinate
y = [1:rows]'*ones(1,cols);   %   "     "     "    "    "  "   "  y    "

area = sum(sum(ob1));
meanx = sum(sum(double(ob1).*x))/area;
meany = sum(sum(double(ob1).*y))/area;

disp('X coordinate of centroid = '),disp(meanx);
disp('Y coordinate of centroid = '),disp(meany);

figure(5),imshow(ob1);
hold on
X = meanx;
Y = meany;
line(X,Y,'marker','+','markersize',90,'color','r');

%computing the ellipse orientation
m20 = sum(sum(double(ob1).*x.^2));
m02 = sum(sum(double(ob1).*y.^2));
m11 = sum(sum(double(ob1).*x.*y));
u20 = (m20/area) - (meanx^2);
u02 = (m02/area) - (meany^2);
u11 = (m11/area) - (meanx*meany);

teta = 0.5*atan(2*u11/(u20-u02));
deg = teta*57.2957795;
disp('u20 = '),disp(u20);
disp('u02 = '),disp(u02);
disp('Tilt angle (degree) = '),disp(deg);



