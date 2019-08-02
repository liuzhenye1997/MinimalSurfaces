name='Bunny_head.obj';
[vertex,face]=read_obj(name);
[vertex,face]=subdivdision(vertex,face,5);
face_number=size(face,1);
vertex_number=size(vertex,1);
sprintf('�µ�����ĵ�ĸ���Ϊ%d,��ĸ���Ϊ%d',vertex_number,face_number)
t1=clock;
%�ҵ�ȫ���߲��洢

edge=zeros(3*face_number,2);
edge(:,1)=face(:);
edge(:,2)=[face(face_number+1:3*face_number),face(1:face_number)];

%Ѱ�ұ߽硣
%1.���߰��յ�һ������������
%2.����һ�������ͬ�ı߰��յڶ����������
%3.��ÿ���߸�ֵʹ�����ҽ�����ͬ�ı�ֵ��ȣ�Ȼ������
%4.���ÿ���߳��ֵĴ�������Ϊ1����Ϊ�߽磬�Ӷ��ҵ��߽��

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
 
%���ÿһ���㣬��Ϊ�߽����Ϊ1������Ϊ0.�洢�ڱ���point_label��
point_label=zeros(vertex_number,1);
edge_value=edge_value';
[count,coordinate]=value_and_coordinate(edge_value);%coordinateΪedge_value���ֵ�����ֵ�����������꣬countΪ��Ӧֵ���ֵĴ���
boundary_point_value=coordinate(count==1);
point_label(edge(boundary_point_value,:),1)=1;


area_sum=Calculate_area(vertex,face);
error=area_sum/10000;%�������Ϊԭ�����1/10000
area_difference=area_sum;
while area_difference>error
    %���������ε������ǵ�cotֵ
    angle_cot=Calculate_angle_cot(vertex,face);
    %���Laplace����
    laplace=laplace_Ulrich_Pinkall(face,angle_cot,point_label);
    %����ڱ߽���ֵ��������֤�߽���ֵ����
    boundary_point_value=zeros(vertex_number,3);
    boundary_point_coordinates=point_label(:,1)==1;
    boundary_point_value(boundary_point_coordinates,:)=vertex(boundary_point_coordinates,:);   
    %�任����ڲ����λ��
    new_position=laplace\boundary_point_value;
    vertex=new_position;%�滻���µĵ�
    %����仯��������滻�ܵ����
    new_area_sum=Calculate_area(vertex,face);
    area_difference=abs(area_sum-new_area_sum);
    area_sum=new_area_sum;   
end
t2=clock;
save_name='new_Bunny_head_Ulrich_Pinkall.obj';
save_obj(vertex,face,save_name);

sprintf('����ʱ��Ϊ%.6f��,���Ϊ%.6f',etime(t2,t1),area_sum)

