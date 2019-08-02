name='big_Bunny_head.obj';
[vertex,face]=read_obj(name);

t1=clock;
%找到全部边并存储
edge=zeros(3*size(face,1),2);
for i=1:size(face,1)
   edge(3*(i-1)+1,1)=face(i,1);
   edge(3*(i-1)+1,2)=face(i,2);
   edge(3*(i-1)+2,1)=face(i,1);
   edge(3*(i-1)+2,2)=face(i,3);
   edge(3*(i-1)+3,1)=face(i,2);
   edge(3*(i-1)+3,2)=face(i,3);
end
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
for i=1:size(face,1)
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
end

is_adjacent=sparse(edge_a,edge_b,ones(6*size(face,1),1));
number_of_adjacency=full(sum(is_adjacent,2)); %每个点的相邻点个数的二倍
number_of_inside=size(vertex,1)-sum(point_label(:)); %内部点个数


%预先存储与点i,j在同一个三角形的另外的点在face的行列坐标。其中m代表行，a代表列。

t5=clock;
vertex_number=size(vertex,1);
i_j_m=zeros([vertex_number,vertex_number,2]);
i_j_a=zeros([vertex_number,vertex_number,2]);
i_j_number=ones([vertex_number,vertex_number]);



for i=1:size(face,1)    
    for j=1:3
        k=mod(j,3)+1;
        i_j_m(face(i,j),face(i,k),i_j_number(face(i,j),face(i,k)))=i;
        i_j_m(face(i,k),face(i,j),i_j_number(face(i,k),face(i,j)))=i;
        i_j_a(face(i,j),face(i,k),i_j_number(face(i,j),face(i,k)))=mod(j+1,3)+1;
        i_j_a(face(i,k),face(i,j),i_j_number(face(i,k),face(i,j)))=mod(j+1,3)+1;        
        i_j_number(face(i,j),face(i,k))=i_j_number(face(i,j),face(i,k))+1;
        i_j_number(face(i,k),face(i,j))=i_j_number(face(i,k),face(i,j))+1;
    end
end
t6=clock;
i_j_m1=i_j_m(:,:,1);
i_j_m2=i_j_m(:,:,2);
i_j_a1=i_j_a(:,:,1);
i_j_a2=i_j_a(:,:,2);

angle_cot=Calculate_angle_cot(vertex,face);
angle_cot=angle_cot';
angle_cot=angle_cot(:);
area_sum=Calculate_area(vertex,face);
e=area_sum/10000;%允许误差为原面积的1/10000
area_difference=area_sum;
while area_difference>e
    %矩阵A
    A=sparse(number_of_inside,number_of_inside);
    times=0;
    cot_sum=zeros(number_of_inside,1);
    index1= point_label(:,1)==0    ;  
    coor=find(index1);
    j=coor;
    index=(is_adjacent(coor,j)>0)  &(coor~=j') ;                          
    [i,j]=find(index);
    id=coor(i)+(coor(j)-1)*vertex_number;
    id1=i_j_m1(id).*3+i_j_a1(id)-3;
    id2=i_j_m2(id).*3+i_j_a2(id)-3;
    A_x=-angle_cot(id1)-angle_cot(id2);      
    coor1=find(point_label(:,1)==0);             
    index2=index(coor1);            
    coor2=find(index2);   
    k=1:size(A_x,1);
    id3=i(k)+(j(k)-1)*number_of_inside;
    A(id3)=A_x(k);
    t3=clock;
    for k=1:size(A_x,1)
         cot_sum(i(k))=cot_sum(i(k))-A_x(k);
    end
    t4=clock;
       
    %矩阵b
    b=zeros(number_of_inside,3);    
    index2=(point_label(:,1)==1)' & is_adjacent(coor,:)>0;  
    [i,j]=find(index2);
    id=coor(i)+(j-1)*vertex_number;
    id1=i_j_m1(id)*3+i_j_a1(id)-3;
    id2=i_j_m2(id)*3+i_j_a2(id)-3;
    cot=angle_cot(id1)+ angle_cot(id2);  
    b_x=(cot).*vertex(j,:); 
    
    t5=clock;
    for k=1:size(b_x,1)
        b(i(k),:)=b(i(k),:)+b_x(k,:);
        cot_sum(i(k))=cot_sum(i(k))+cot(k);
    end
    t6=clock;
    
    i=1:number_of_inside;   
    A((i-1)*number_of_inside+i)=cot_sum(i,1);
    %变换后的内部点的位置
    new_position=A\b;
    vertex(coor,:)=new_position(:,:);%替换成新的内部点

    
    new_area_sum=Calculate_area(vertex,face);
    area_difference=abs(area_sum-new_area_sum);
    area_sum=new_area_sum;
    angle_cot=Calculate_angle_cot(vertex,face);
    angle_cot=angle_cot';
    angle_cot=angle_cot(:);
end
t2=clock;
save_name='new_Bunny_head_Ulrich_Pinkall.obj'
save_obj(vertex,face,save_name);

format long
area=Calculate_area(vertex,face);

sprintf('所用时间为%.6f秒,面积为%.6f',etime(t2,t1),area)

