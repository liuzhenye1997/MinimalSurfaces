name='Bunny_head.obj';
[vertex,face]=read_obj(name);
[vertex,face]=subdivdision(vertex,face,5);
face_number=size(face,1);
vertex_number=size(vertex,1);
sprintf('新的网格的点的个数为%d,面的个数为%d',vertex_number,face_number)
t1=clock;
%找到全部边并存储

edge=zeros(3*face_number,2);
edge(:,1)=face(:);
edge(:,2)=[face(face_number+1:3*face_number),face(1:face_number)];

%寻找边界。
%1.将边按照第一个点的序号排序
%2.将第一个序号相同的边按照第二个序号排序
%3.对每条边赋值使得有且仅有相同的边值相等，然后排序
%4.算出每条边出现的次数，若为1次则为边界，从而找到边界点

I=edge(:,1)>edge(:,2);
temp1=edge(:,1);
temp2=edge(:,2);
edge(:,1)=I.*temp2+(1-I).*temp1;
edge(:,2)=I.*temp1+(1-I).*temp2;

[~,index]=sort(edge(:,1));
edge=edge(index,:);

edge_value=vertex_number*edge(:,1)+edge(:,2);
[edge_value,index]=sort(edge_value);
edge=edge(index,:);
 
%标记每一个点，若为边界点则为1，否则为0.存储在变量point_label中
point_label=zeros(vertex_number,1);
edge_value=edge_value';
[count,coordinate]=value_and_coordinate(edge_value);%coordinate为edge_value出现的所有值在向量的坐标，count为对应值出现的次数
boundary_point_value=coordinate(count==1);
point_label(edge(boundary_point_value,:),1)=1;


area_sum=Calculate_area(vertex,face);
error=area_sum/10000;%允许误差为原面积的1/10000
area_difference=area_sum;
while area_difference>error
    %计算三角形的三个角的cot值
    angle_cot=Calculate_angle_cot(vertex,face);
    %获得Laplace矩阵
    laplace=laplace_Ulrich_Pinkall(face,angle_cot,point_label);
    %获得在边界点的值，用来保证边界点的值不变
    boundary_point_value=zeros(vertex_number,3);
    boundary_point_coordinates=point_label(:,1)==1;
    boundary_point_value(boundary_point_coordinates,:)=vertex(boundary_point_coordinates,:);   
    %变换后的内部点的位置
    new_position=laplace\boundary_point_value;
    vertex=new_position;%替换成新的点
    %计算变化的面积并替换总的面积
    new_area_sum=Calculate_area(vertex,face);
    area_difference=abs(area_sum-new_area_sum);
    area_sum=new_area_sum;   
end
t2=clock;
save_name='new_Bunny_head_Ulrich_Pinkall.obj';
save_obj(vertex,face,save_name);

sprintf('所用时间为%.6f秒,面积为%.6f',etime(t2,t1),area_sum)

