function [laplace,cot_sum]=laplace_Ulrich_Pinkall(face,angle_cot,point_label)
%求邻接矩阵
endpoint_a=face(:);
endpoint_b=[face(size(face,1)+1:3*size(face,1)),face(1:size(face,1))]';
cot_value=[angle_cot(2*size(face,1)+1:3*size(face,1)),angle_cot(1:2*size(face,1))]';
adjacency_matrix=sparse([endpoint_a,endpoint_b],[endpoint_b,endpoint_a],[cot_value,cot_value]);%邻接矩阵

inner_point_coordinates=point_label(:,1)==0;
i=1:size(point_label,1);
cot_sum=-sum(adjacency_matrix,2);
degree_matrix=sparse(i,i,cot_sum);
A=sparse(size(point_label,1),size(point_label,1));
A(inner_point_coordinates,:)=adjacency_matrix(inner_point_coordinates,:);%存储邻接矩阵中对应内部点的行向量
laplace=A+degree_matrix;

end