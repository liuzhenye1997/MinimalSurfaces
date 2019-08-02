name='Bunny_head.obj';
[vertex,face]=read_obj(name);
[vertex,face]=subdivdision(vertex,face,5);
sprintf('�µ�����ĵ�ĸ���Ϊ%d,��ĸ���Ϊ%d',size(vertex,1),size(face,1))
t1=clock;
%�ҵ�ȫ���߲��洢
edge=zeros(3*size(face,1),2);
i=1:size(face,1);
edge(3*(i-1)+1,1)=face(i,1);
edge(3*(i-1)+1,2)=face(i,2);
edge(3*(i-1)+2,1)=face(i,1);
edge(3*(i-1)+2,2)=face(i,3);
edge(3*(i-1)+3,1)=face(i,2);
edge(3*(i-1)+3,2)=face(i,3);

%�����С�ĵ����ǰ��
i=1:3*size(face,1);
I=edge(i,1)>edge(i,2);
temp1=edge(i,1);
temp2=edge(i,2);
edge(i,1)=I.*temp2+(1-I).*temp1;
edge(i,2)=I.*temp1+(1-I).*temp2;

etime(clock,t1);
%Ѱ�ұ߽硣
%1.���߰��յ�һ������������
%2.����һ�������ͬ�ı߰��յڶ����������
%3.ͨ��ǰ��ĵ��Ƿ���ͬ�ж��ǲ��Ǳ߽磬�Ӷ��ҵ��߽��

[~,index]=sort(edge(:,1));
edge=edge(index,:);

edge_value=size(vertex,1)*edge(:,1)+edge(:,2);
[~,index]=sort(edge_value);
edge=edge(index,:);

%���ÿһ���㣬��Ϊ�߽����Ϊ1������Ϊ0
point_label=zeros(size(vertex,1),1);
point_value=edge(:,1)*size(vertex,1)+edge(:,2);
point_value=point_value';
difference  = diff([point_value,max(point_value)+1]);
count = diff(find([1,difference]));
value=find(difference);%valueΪpoint_value���ֵ�����ֵ��countΪ��Ӧֵ���ֵĴ���
boundary_point_value=value(count==1);
point_label(edge(boundary_point_value,1),1)=1;
point_label(edge(boundary_point_value,2),1)=1;
number_of_inside=size(vertex,1)-sum(point_label(:)); %�ڲ������


%Ԥ�ȴ洢���i,j��ͬһ�������ε�����ĵ���face���������ꡣ����m�����У�a�����С�

t5=clock;
vertex_number=size(vertex,1);

angle_cot=Calculate_angle_cot(vertex,face);

area_sum=Calculate_area(vertex,face);
error=area_sum/10000;%�������Ϊԭ�����1/10000
area_difference=area_sum;
while area_difference>error
    %���Laplace����
    [laplace,cot_sum]=laplace_Ulrich_Pinkall(face,angle_cot,point_label);
    %����ڱ߽�������ֵ
    boundary_point_value=zeros(size(vertex,1),3);
    boundary_point_coordinates=point_label(:,1)==1;
    boundary_point_value(boundary_point_coordinates,:)=cot_sum(boundary_point_coordinates).*vertex(boundary_point_coordinates,:);
    
    %�任����ڲ����λ��
    new_position=laplace\boundary_point_value;
    vertex=new_position;%�滻���µĵ�
    
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

sprintf('����ʱ��Ϊ%.6f��,���Ϊ%.6f',etime(t2,t1),area)

