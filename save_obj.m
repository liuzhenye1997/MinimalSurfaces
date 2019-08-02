function  save_obj(vertex,face,name)
fid=fopen(name,'wt');
fprintf(fid,'v %.10f %.10f %.10f\r\n',vertex(:,1),vertex(:,2),vertex(:,3)); 
fprintf(fid,'f %d %d %d\r\n',face(:,1),face(:,2),face(:,3));      
fclose(fid);
end