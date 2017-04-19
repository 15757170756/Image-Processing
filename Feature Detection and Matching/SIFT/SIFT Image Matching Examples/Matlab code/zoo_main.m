close all;clear all;clc;

im1=imread('..\Simulated Image\0U0A0945.JPG');
im2=imread('..\Simulated Image\0U0A0946.JPG');

im1=imresize(im1, 0.1);
im2=imresize(im2, 0.1);

gray1=zoo_x2gray(im1);
gray2=zoo_x2gray(im2);

[des1,loc1]=zoo_sift(gray1);
[des2,loc2]=zoo_sift(gray2);

figure;
zoo_drawPoints(im1,loc1,im2,loc2);

Num=2;Thresh=0.9;
match=zoo_BidirectionalMatch(des1,des2,Num,Thresh);
clear des1 des2
loc1=loc1(match(:,1),:);
loc2=loc2(match(:,2),:);

figure;
zoo_linePoints(im1,loc1,im2,loc2);

agl=zoo_getRotAgl(loc1,loc2);

figure;
zoo_drawRotAglHist(agl);

opt=zoo_optIndex(agl);
loc1=loc1(opt,:);
loc2=loc2(opt,:);

figure;
zoo_linePoints(im1,loc1,im2,loc2);

T=zoo_getTransMat(gray1,loc1,gray2,loc2);
im=zoo_imRegist(im1,im2,T);

figure;
%imwrite(im, '0U0A0944 and 0U0A0945 Result.jpg');
imshow(im);