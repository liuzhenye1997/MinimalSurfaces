%由于直接点除使laplace矩阵的对角线变为1以避免cot_sum的传递这一操作过于耗时，即adjacency_matrix=adjacency_matrix./cot_sum。
%于是分为两部分构造了laplace矩阵的对角线元素，内部点对应的行为cot_sum对应的元素，
%边界点对应的行为1。但是这样就会增加了代码量，不过在不传递cot_sum和保证速度的前提下暂时没有其它方案。
function laplace=laplace_Ulrich_Pinkall(face,angle_cot,point_label)
point_number=size(point_label,1);
%求邻接矩阵
endpoint_a=face(:);
endpoint_b=[face(size(face,1)+1:3*size(face,1)),face(1:size(face,1))]';
cot_value=[angle_cot(2*size(face,1)+1:3*size(face,1)),angle_cot(1:2*size(face,1))]';
adjacency_matrix_upper=sparse(endpoint_a,endpoint_b,cot_value);%邻接矩阵的右上部分
adjacency_matrix=adjacency_matrix_upper+adjacency_matrix_upper';
%内部点和边界点的坐标
inner_point_coordinates=point_label(:,1)==0;
boundary_point_coordinates=point_label(:,1)==1;
%只保留内部点的邻接矩阵
adjacency_matrix_inner=sparse(point_number,point_number);
adjacency_matrix_inner(inner_point_coordinates,:)=adjacency_matrix(inner_point_coordinates,:);
%分别计算内部点和边界点的度矩阵
cot_sum=-sum(adjacency_matrix,2);
degree_matrix_inner=sparse(find(inner_point_coordinates),find(inner_point_coordinates),cot_sum(inner_point_coordinates),point_number,point_number);
degree_matrix_boundary=sparse(find(boundary_point_coordinates),find(boundary_point_coordinates),1,point_number,point_number);
%获得laplace矩阵
laplace=adjacency_matrix_inner+degree_matrix_inner+degree_matrix_boundary;
end