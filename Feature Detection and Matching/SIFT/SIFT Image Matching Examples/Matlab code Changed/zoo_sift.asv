function [des,loc]=zoo_sift(im)
% This function reads SIFT keypoints of an image.
%   Input parameters:
%     pic: gray image.
%
%   Returned:
%     des: a K-by-128 matrix, where each row gives an invariant
%              descriptor for one of the K keypoints.  The descriptor is a vector
%              of 128 values normalized to unit length.
%     loc: K-by-4 matrix, in which each row has the 4 values for a
%            keypoint location (row, column, scale, orientation).  The 
%            orientation is in the range [-PI, PI] radians.
[row,col]=size(im);

% Convert into PGM imagefile, readable by "keypoints" executable
f=fopen('tmp.pgm','w');
if f==-1
    error('Could not create file tmp.pgm.');
end
fprintf(f, 'P5\n%d\n%d\n255\n', col, row); %在文件中写入图像的列和行
fwrite(f,im','uint8'); %a'表示a的共轭转置, 以二进制形式写入
fclose(f);

% Call keypoints executable
if isunix
    command = '!./sift ';
else
    command = '!siftWin32 '; %这个是siftWin32.exe的程序启动的字符命令， 在当前目录下运行 siftWin32 <tmp.pgm > tmp.key
end
command = [command ' <tmp.pgm >tmp.key']; %延长字符串 command = '!siftWin32 <tmp.pgm>tmp.key'
eval(command);  %eval()函数的功能就是将括号内的字符串视为语句并运行

% Open tmp.key and check its header
g=fopen('tmp.key','r');
if g==-1
    error('Could not open file tmp.key.');
end
[header,cnt]=fscanf(g,'%d %d',[1 2]);  %[1 2]与[1,2]一样  head 是一个1*2的向量，cnt代表head中向量个数
if cnt~=2
    error('Invalid keypoint file beginning.');
end

num=header(1); %关键点个数
len=header(2); %关键点维度长度（一般是128维）
if len~=128
    error('Keypoint descriptor length invalid (should be 128).');
end

% Creates the two output matrices (use known size for efficiency)
loc=double(zeros(num,4));  %创建num行4列的全为0的矩阵
des=double(zeros(num,128));
for k=1:num
    [vector,cnt]=fscanf(g, '%f %f %f %f', [1 4]); 
    if cnt~=4
        error('Invalid keypoint file format');
    end
    loc(k,:)=vector(1,:); %loc的第k行为vector的第1行
     [descrip, count] = fscanf(g, '%d', [1 len]);
    if (count ~= 128)
        error('Invalid keypoint file value.');
    end
    descrip = descrip / sqrt(sum(descrip.^2));%先矩阵每个元素平方，然后按列求和(默认）
    des(k, :) = descrip(1, :);
end
fclose(g);
for k=1:size(des,1) %des的行数目
    des(k,:)=des(k,:)/sum(des(k,:)); %归一化
end
delete tmp.key tmp.pgm