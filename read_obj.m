%��ȡobj�������Բ��ã������ȡ�Ĳ������ơ�Bunny_head.obj���ṹ��obj�ļ����ܶ���������
function [vertex,face]=read_obj(name)
data=importdata(name);
sprintf('��ĸ���Ϊ%d,��ĸ���Ϊ%d',data.data(1,1),data.data(2,1))
vertex=zeros(data.data(1,1),3);
face=zeros(data.data(2,1),3);
vertex_no=1;
face_no=1;
for i=1:(size(data.textdata,1))  
    if char(data.textdata(i,1))=='v'
        vertex(vertex_no,:)=str2num(char(data.textdata(i,2:4)));
        vertex_no=vertex_no+1;
    elseif char(data.textdata(i,1))=='f'
        face(face_no,:)=str2num(char(data.textdata(i,2:4)));
        face_no=face_no+1;
    end
end
if vertex_no~=data.data(1,1)+1 || face_no~=data.data(2,1)+1
    disp('error')
end   