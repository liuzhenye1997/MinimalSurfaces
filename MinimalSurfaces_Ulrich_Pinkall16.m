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


point_label=zeros(size(vertex,1),1);
point_value=edge(:,1)*size(vertex,1)+edge(:,2);
point_value=point_value';
difference  = diff([point_value,max(point_value)+1]);
count = diff(find([1,difference]));
y=find(difference);
z=y(count==1);
point_label(edge(z,1),1)=1;
point_label(edge(z,2),1)=1;
number_of_inside=size(vertex,1)-sum(point_label(:)); %�ڲ������


%Ԥ�ȴ洢���i,j��ͬһ�������ε�����ĵ���face���������ꡣ����m�����У�a�����С�

t5=clock;
vertex_number=size(vertex,1);

angle_cot=Calculate_angle_cot(vertex,face);

area_sum=Calculate_area(vertex,face);
e=area_sum/10000;%�������Ϊԭ�����1/10000
area_difference=area_sum;
while area_difference>e
    %����A
    edge_a=zeros(6*size(face,1),1);
    edge_b=zeros(6*size(face,1),1);
    cot_value=zeros(6*size(face,1),1);
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
    cot_value(6*(i-1)+1,1)=angle_cot(i,3);
    cot_value(6*(i-1)+2,1)=angle_cot(i,2);
    cot_value(6*(i-1)+3,1)=angle_cot(i,3);
    cot_value(6*(i-1)+4,1)=angle_cot(i,1);
    cot_value(6*(i-1)+5,1)=angle_cot(i,2);
    cot_value(6*(i-1)+6,1)=angle_cot(i,1);
    
    is_adjacent=sparse(edge_a,edge_b,cot_value);
    index1=point_label(:,1)==0;
    i=1:size(vertex,1);
    cot_sum=-sum(is_adjacent,2);
    B=sparse(i,i,cot_sum);%�洢�Խ���Ԫ��
    A=sparse(size(vertex,1),size(vertex,1));
    A(index1,:)=is_adjacent(index1,:);
    A=A+B;
    t4=clock;
    %����b
    b=zeros(size(vertex,1),3);
    index2=point_label(:,1)==1;
    b(index2,:)=cot_sum(index2).*vertex(index2,:);
    %�任����ڲ����λ��
    new_position=A\b;
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

