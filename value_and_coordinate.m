%Ѱ������x���ֹ�������ֵ��x�е����꼰��Ӧ�ĳ��ִ���
%��https://www.mathworks.com/help/matlab/matlab_prog/vectorization.html�����һ��������΢�Ķ���������
% x = [2 1 2 2 3 1 3 2 1 3];
% x = sort(x);
% difference  = diff([x,max(x)+1]);
% count = diff(find([1,difference]))
% y = x(find(difference))
function [count,coordinate]=value_and_coordinate(x)
difference  = diff([x,max(x)+1]);
count = diff(find([1,difference]));
coordinate = find(difference);
end