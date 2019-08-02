%先算角度，再利用cot函数
function angle_cot=Calculate_angle_cot(vertex,face)
length=zeros(size(face,1),3);
for i=1:3
    length(:,i)=sum((vertex(face(:,mod(i,3)+1),:)-vertex(face(:,mod(i+1,3)+1),:)).^2,2);
end
angle=zeros(size(face,1),3);
for i=1:3
    angle(:,i)=acos((length(:,mod(i,3)+1)+length(:,mod(i+1,3)+1)-length(:,i))./sqrt(length(:,mod(i+1,3)+1).*length(:,mod(i,3)+1))/2);    
end
angle_cot=cot(angle);
end

%利用cot=cos/sin
% function angle_cot=Calculate_angle_cot(vertex,face)
% length=zeros(size(face,1),3);
% for i=1:3
%     for j=1:size(face,1)
%         length(j,i)=sum((vertex(face(j,mod(i,3)+1),:)-vertex(face(j,mod(i+1,3)+1),:)).^2,2);
%     end    
% end
% angle_cos=zeros(size(face,1),3);
% for i=1:3
%     angle_cos(:,i)=(length(:,mod(i,3)+1)+length(:,mod(i+1,3)+1)-length(:,i))./sqrt(length(:,mod(i+1,3)+1).*length(:,mod(i,3)+1))/2.0;    
% end
% angle_sin=sqrt(1-angle_cos.^2);
% angle_cot=angle_cos./angle_sin;
% end