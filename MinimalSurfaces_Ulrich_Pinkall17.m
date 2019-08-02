name='Bunny_head.obj';
[vertex,face]=read_obj(name);
[vertex,face]=subdivdision(vertex,face,5);
sprintf('新的网格的点的个数为%d,面的个数为%d',size(vertex,1),size(face,1))
t1=clock;
%找到全部边并存储
edge=zeros(3*size(face,1),2);
i=1:size(face,1);
edge(3*(i-1)+1,1)=face(i,1);
edge(3*(i-1)+1,2)=face(i,2);
edge(3*(i-1)+2,1)=face(i,1);
edge(3*(i-1)+2,2)=face(i,3);
edge(3*(i-1)+3,1)=face(i,2);
edge(3*(i-1)+3,2)=face(i,3);

%将序号小的点放在前面
i=1:3*size(face,1);
I=edge(i,1)>edge(i,2);
temp1=edge(i,1);
temp2=edge(i,2);
edge(i,1)=I.*temp2+(1-I).*temp1;
edge(i,2)=I.*temp1+(1-I).*temp2;

etime(clock,t1);
%寻找边界。
%1.将边按照第一个点的序号排序
%2.将第一个序号相同的边按照第二个序号排序
%3.通过前后的点是否相同判断是不是边界，从而找到边界点

[~,index]=sort(edge(:,1));
edge=edge(index,:);

edge_value=size(vertex,1)*edge(:,1)+edge(:,2);
[~,index]=sort(edge_value);
edge=edge(index,:);

%标记每一个点，若为边界点则为1，否则为0
point_label=zeros(size(vertex,1),1);
point_value=edge(:,1)*size(vertex,1)+edge(:,2);
point_value=point_value';
difference  = diff([point_value,max(point_value)+1]);
count = diff(find([1,difference]));
value=find(difference);%value为point_value出现的所有值，count为对应值出现的次数
boundary_point_value=value(count==1);
point_label(edge(boundary_point_value,1),1)=1;
point_label(edge(boundary_point_value,2),1)=1;
number_of_inside=size(vertex,1)-sum(point_label(:)); %内部点个数


%预先存储与点i,j在同一个三角形的另外的点在face的行列坐标。其中m代表行，a代表列。

t5=clock;
vertex_number=size(vertex,1);

angle_cot=Calculate_angle_cot(vertex,face);

area_sum=Calculate_area(vertex,face);
error=area_sum/10000;%允许误差为原面积的1/10000
area_difference=area_sum;
while area_difference>error
    %获得Laplace矩阵
    [laplace,cot_sum]=laplace_Ulrich_Pinkall(face,angle_cot,point_label);
    %获得在边界点的坐标值
    boundary_point_value=zeros(size(vertex,1),3);
    boundary_point_coordinates=point_label(:,1)==1;
    boundary_point_value(boundary_point_coordinates,:)=cot_sum(boundary_point_coordinates).*vertex(boundary_point_coordinates,:);
    
    %变换后的内部点的位置
    new_position=laplace\boundary_point_value;
    vertex=new_position;%替换成新的点
    
    new_area_sum=Calculate_area(vertex,face);
    area_difference=abs(area_sum-new_area_sum);
    area_sum=new_area_sum;
    angle_cot=Calculate_angle_cot(vertex,face);
    
end
t2=clock;
save_name='new_Bunny_head_Ulrich_Pinkall.obj';
save_obj(vertex,face,save_name);

format long
area=Calculate_area(vertex,face);

sprintf('所用时间为%.6f秒,面积为%.6f',etime(t2,t1),area)

