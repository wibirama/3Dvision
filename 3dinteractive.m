%------------------------------------------------------------------%
% Matlab implementation of 3D Reconstruction  		         
% with interactive point selector										 
% Sunu Wibirama                  			    							
% Department of Electrical Engineering and				 
% Information Technology, UGM										 
% Email : sunu@jteti.gadjahmada.edu							
% Acknowledgment : 													
% Thanks to Mr. Sorapong Aootaphao for teaching	
% a lot of basic computer vision algorithm				 
%  																					
%------------------------------------------------------------------%
%read input 
clear
for j=1:3
   switch (j)
    case 1
       a=imread('pic1.jpg','jpg');
       aa=a(:,:,1);
        figure(1);imagesc(aa);colormap('gray');
     case 2
       a=imread('pic2.jpg','jpg');
       aa=a(:,:,1);
        figure(2);imagesc(aa);colormap('gray');
     case 3
       a=imread('pic3.jpg','jpg');
       aa=a(:,:,1);
        figure(3);imagesc(aa);colormap('gray');
      end
 hold on;
%define 2D coordinate of each point
 for i=1:8
   [u(i,1),u(i,2)]=ginput(1);
   plot(u(i,1),u(i,2),'r+');
end
% define world coordinate of the box

xx=[0 0 0 1
    10.5 0 0 1
    10.5 10.5 0 1 
    0 10.5 0 1
    0 0 10.5 1
    10.5 0 10.5 1
    10.5 10.5 10.5 1 
    0 10.5 10.5 1];


%compute matrix M 
for i=1:8
   G(2*i,1)=0;
   G(2*i,2)=0;
   G(2*i,3)=0;
   G(2*i,4)=0;
   G(2*i,5)=xx(i,1);
   G(2*i,6)=xx(i,2);
   G(2*i,7)=xx(i,3);
   G(2*i,8)=1;
   G(2*i,9)=-u(i,2)*xx(i,1);
   G(2*i,10)=-u(i,2)*xx(i,2);
   G(2*i,11)=-u(i,2)*xx(i,3);
   G(2*i,12)=-u(i,2);

   G((2*i)-1,1)=xx(i,1);
   G((2*i)-1,2)=xx(i,2);
   G((2*i)-1,3)=xx(i,3);
   G((2*i)-1,4)=1;
   G((2*i)-1,5)=0;
   G((2*i)-1,6)=0;
   G((2*i)-1,7)=0;
   G((2*i)-1,8)=0;
   G((2*i)-1,9)=-u(i,1)*xx(i,1);
   G((2*i)-1,10)=-u(i,1)*xx(i,2);
   G((2*i)-1,11)=-u(i,1)*xx(i,3);
   G((2*i)-1,12)=-u(i,1);
end
[U, D, V]=svd(G);
VT=V;
M=VT(:,end); %last columm
%M = transpose(reshape(M_vector, 4, 3));
m(1,1)=M(1);
m(1,2)=M(2);
m(1,3)=M(3);
m(1,4)=M(4);
m(2,1)=M(5);
m(2,2)=M(6);
m(2,3)=M(7);
m(2,4)=M(8);
m(3,1)=M(9);
m(3,2)=M(10);
m(3,3)=M(11);
m(3,4)=M(12);
switch (j)
    case 1
       u1=u;
       m1=m;
    case 2
       u2=u;
       m2=m;
     case 3  
       u3=u;
       m3=m;
     end
vv=m*xx';
vv=vv';
vv(:,1)=vv(:,1)./vv(:,3);
vv(:,2)=vv(:,2)./vv(:,3);
title('Re project')
for i=1:8
      plot(vv(i,1),vv(i,2),'go');
end  
end%for j=1:3
size(u);m=ans(1);
%3D Reconstruction using Direct Linear Transformation
for i=1:8
   A(1,1:4)=u1(i,1)*m1(3,1:4)-m1(1,1:4);
   A(2,1:4)=u1(i,2)*m1(3,1:4)-m1(2,1:4);
   A(3,1:4)=u2(i,1)*m2(3,1:4)-m2(1,1:4);
   A(4,1:4)=u2(i,2)*m2(3,1:4)-m2(2,1:4);
   A(5,1:4)=u3(i,1)*m3(3,1:4)-m3(1,1:4);
   A(6,1:4)=u3(i,2)*m3(3,1:4)-m3(2,1:4);
   [U, D, V]=svd(A);
     zz(:,i)=V(:,4);
 end
 ake=zz;
 zz=zz';
 zz(:,1)=zz(:,1)./zz(:,4);
 zz(:,2)=zz(:,2)./zz(:,4);
 zz(:,3)=zz(:,3)./zz(:,4);
% Plot image
figure(4);
cla reset; hold on
d = [1 2 3 4 1 5 6 7 8 5 6 2 3 7 8 4];
plot3(zz(d,1),zz(d,2),zz(d,3),'b:');
plot3(zz(:,1),zz(:,2),zz(:,3),'b.','markersize',20)
A=m1(:,2:4);
%scaling = sqrt(m1(3,2)^2 + m1(3,3)^2 + m1(3,4)^2);
%m1 = m1 ./ scaling;
A=m1(:,2:4);
[Q R]=qr(A^-1);
R1=R^-1;
R1=R1/R1(3,3)
 
A=m2(:,2:4);
%scaling = sqrt(m2(3,2)^2 + m2(3,3)^2 + m2(3,4)^2);
%m2 = m2 ./ scaling;
A=m2(:,2:4);
[Q R]=qr(A^-1);
R2=R^-1;
R2=R2/R2(3,3)
A=m3(:,1:3);
%scaling = sqrt(m3(3,2)^2 + m3(3,3)^2 + m3(3,4)^2);
%m3 = m3 ./ scaling;
A=m3(:,2:4);
[Q R]=qr(A^-1);
R3=R^-1;
R3=R3/R3(3,3)

