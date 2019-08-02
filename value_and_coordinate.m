%寻找向量x出现过的所有值在x中的坐标及对应的出现次数
%是https://www.mathworks.com/help/matlab/matlab_prog/vectorization.html里面的一个例子稍微改动而来。即
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