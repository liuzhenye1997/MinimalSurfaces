%读取obj。兼容性不好，如果读取的不是类似‘Bunny_head.obj’结构的obj文件可能读不出来。
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




i=1:3*size(face,1);
I=edge(i,1)>edge(i,2);
temp1=edge(i,1);
temp2=edge(i,2);
edge(i,1)=I.*temp2+(1-I).*temp1;
edge(i,2)=I.*temp1+(1-I).*temp2;


[~,index]=sort(edge(:,1));
edge=edge(index,:);


edge_value=size(vertex,1)*edge(:,1)+edge(:,2);
[aaa,index]=sort(edge_value);
edge=edge(index,:);



point_label=zeros(size(vertex,1),1);
point_value=edge(:,1)*size(vertex,1)+edge(:,2);
point_value=point_value';
difference  = diff([point_value,max(point_value)+1]);
count = diff(find([1,difference]));
y=find(difference);
z=y(count==1);
point_label(edge(z,1),1)=1;
point_label(edge(z,2),1)=1;

%利用稀疏矩阵存储点是否相邻的关系
edge_a=zeros(6*size(face,1),1);
edge_b=zeros(6*size(face,1),1);
i=1:size(face,1);
edge_a(6*(i-1)+1,1)=face(i,1);
edge_a(6*(i-1)+2,1)=face(i,1);
edge_a(6*(i-1)+3,1)=face(i,2);
edge_a(6*(i-1)+4,1)=face(i,2);
edge_a(6*(i-1)+5,1)=face(i,3);
edge_a(6*(i-1)+6,1)=face(i,3);
edge_b(6*(i-1)+1,1)=face(i,2);
edge_b(6*(i-1)+2,1)=face(i,3);
edge_b(6*(i-1)+3,1)=face(i,1);
edge_b(6*(i-1)+4,1)=face(i,3);
edge_b(6*(i-1)+5,1)=face(i,1);
edge_b(6*(i-1)+6,1)=face(i,2);



is_adjacent=sparse(edge_a,edge_b,-ones(6*size(face,1),1));
number_of_adjacency=full(sum(is_adjacent,2)); %每个点的相邻点个数的二倍
number_of_inside=size(vertex,1)-sum(point_label(:)); %内部点个数

t3=clock;
%计算矩阵A,A存储各点权值
index1=point_label(:,1)==0;
i=1:size(vertex,1);
B=sparse(i,i,-number_of_adjacency);%存储对角线元素
A=sparse(size(vertex,1),size(vertex,1));
A(index1,:)=is_adjacent(index1,:);
A=A+B;


%矩阵b
b=zeros(size(vertex,1),3);
index2=point_label(:,1)==1;
b(index2,:)=number_of_adjacency(index2).*vertex(index2,:);

t4=clock;

%变换后的内部点的位置
new_position=A\b;
vertex=new_position;

t2=clock;
%将结果输入obj
save_name='new_Bunny_head_vectorization.obj';
save_obj(vertex,face,save_name);



area=Calculate_area(vertex,face);

sprintf('所用时间为%.6f秒,面积为%.6f',etime(t2,t1),area)
etime(t4,t3);