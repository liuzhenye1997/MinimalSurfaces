function area_sum=Calculate_area(vertex,face)
length=zeros(size(face,1),3);
i=1:3;
length(:)=sqrt(sum((vertex(face(:,mod(i,3)+1),:)-vertex(face(:,mod(i+1,3)+1),:)).^2,2));
p=sum(length,2)/2;
area=sqrt(p.*(p-length(:,1)).*(p-length(:,2)).*(p-length(:,3)));
area_sum=sum(abs(area()));
end
