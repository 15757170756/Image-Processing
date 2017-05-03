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
fprintf(f, 'P5\n%d\n%d\n255\n', col, row); %���ļ���д��ͼ����к���
fwrite(f,im','uint8'); %a'��ʾa�Ĺ���ת��, �Զ�������ʽд��
fclose(f);

% Call keypoints executable
if isunix
    command = '!./sift ';
else
    command = '!siftWin32 '; %�����siftWin32.exe�ĳ����������ַ���� �ڵ�ǰĿ¼������ siftWin32 <tmp.pgm > tmp.key
end
command = [command ' <tmp.pgm >tmp.key']; %�ӳ��ַ��� command = '!siftWin32 <tmp.pgm>tmp.key'
eval(command);  %eval()�����Ĺ��ܾ��ǽ������ڵ��ַ�����Ϊ��䲢����

% Open tmp.key and check its header
g=fopen('tmp.key','r');
if g==-1
    error('Could not open file tmp.key.');
end
[header,cnt]=fscanf(g,'%d %d',[1 2]);  %[1 2]��[1,2]һ��  head ��һ��1*2��������cnt����head����������
if cnt~=2
    error('Invalid keypoint file beginning.');
end

num=header(1); %�ؼ������
len=header(2); %�ؼ���ά�ȳ��ȣ�һ����128ά��
if len~=128
    error('Keypoint descriptor length invalid (should be 128).');
end

% Creates the two output matrices (use known size for efficiency)
loc=double(zeros(num,4));  %����num��4�е�ȫΪ0�ľ���
des=double(zeros(num,128));
for k=1:num
    [vector,cnt]=fscanf(g, '%f %f %f %f', [1 4]); 
    if cnt~=4
        error('Invalid keypoint file format');
    end
    loc(k,:)=vector(1,:); %loc�ĵ�k��Ϊvector�ĵ�1��
     [descrip, count] = fscanf(g, '%d', [1 len]);
    if (count ~= 128)
        error('Invalid keypoint file value.');
    end
    descrip = descrip / sqrt(sum(descrip.^2));%�Ⱦ���ÿ��Ԫ��ƽ����Ȼ�������(Ĭ�ϣ�
    des(k, :) = descrip(1, :);
end
fclose(g);
for k=1:size(des,1) %des������Ŀ
    des(k,:)=des(k,:)/sum(des(k,:)); %��һ��
end
delete tmp.key tmp.pgm