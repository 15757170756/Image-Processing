function zoo_drawPoints(im1,loc1,im2,loc2)
im=zoo_appendingImages(im1,im2);
imshow(im);
hold on
set(gcf,'Color','w');
plot(loc1(:,2),loc1(:,1),'r*',loc2(:,2)+size(im1,2),loc2(:,1),'b*');
hold off

% plot�÷�����
% a = [1 2;3 4];
% b = [5 6;7 8];
% plot(a, b, 'r*',b, a, 'b*');
% ���㣨1,5�� ��2,6�� ��3,7�� ��4,8�� ��ɫ *�ű�ʾ
% ���㣨5,1�� ��6,2�� ��7,3�� ��8,4�� ��ɫ *�ű�ʾ