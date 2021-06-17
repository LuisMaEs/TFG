Matriz=zeros(16,32768);

for i=1:(16384)
    for j=1:16
   
    Matriz(j,2*i-1)=real(GrupoD(j,j,i));
    Matriz(j,2*i)=-real(GrupoD(j,j,i));
    Matriz(16+j,2*i-1)=imag(GrupoD(j,j,i));
    Matriz(16+j,2*i)=-imag(GrupoD(j,j,i));  
    
    end
end





fileID= fopen('Matriz4D_Sinfases.txt','w');


for j=1:32
    for i=1:(32768)
    if (i==32768)
        fprintf(fileID,'%f\n',Matriz(j,i));
    else
        fprintf(fileID,'%f\t',Matriz(j,i));
    end
        
    end   
end
fclose(fileID);

%%


Comprobador=zeros(1,32768);
m=2;
for i=1:32768
    for j=m:32768
     if(Matriz(:,i)==Matriz(:,j))
        Comprobador(i)=1;
     end
    end
    m=m+1;
end








%

