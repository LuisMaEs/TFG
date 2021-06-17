%%
clear;clc;
P=[1,0;0,complex(0,1)];
I1=[1,0;0,1];
CZ=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,-1];
fases=[exp(i*0),exp(i*pi/4),exp(i*pi*2/4),exp(i*pi*3/4),exp(i*pi),exp(i*pi*5/4),exp(i*pi*6/4),exp(i*pi*7/4)];

%% Una dimensión
fileID= fopen('Diag1D.txt','w');
GrupoDiag=[];
for i=1:4
              
       Aux=P^i;
       GrupoDiag=[GrupoDiag;Aux];          
   
end

m=(length(GrupoDiag(:,1))/2);
GrupoD=zeros(2,2,m);

for i=1:m
    
    GrupoD(:,:,i)=GrupoDiag((((i-1)*2+1):i*2),:);
    
end
for n=1:8
for i=1:m
    for j=1:2
        for k=1:2
            if k==2
                fprintf(fileID,'%f\n',real(GrupoD(j,k,i)*fases(n)));
            else
                fprintf(fileID,'%f\t',real(GrupoD(j,k,i)*fases(n)));
            end
        
        end
    end
    for j=1:2
         for l=1:2
            if l==2
                fprintf(fileID,'%f\n',imag(GrupoD(j,l,i)*fases(n)));
            else
                fprintf(fileID,'%f\t',imag(GrupoD(j,l,i)*fases(n)));
            end
        end
    end 
end
end
fclose(fileID);   



%% Dos dimensiones
fileID= fopen('Diag2D.txt','w');
P1=kron(P,I1);
P2=kron(I1,P);
P1P2=kron(P,P);%SOBRAAAAAAAAAAAAAAAAAAAAAAAAAAA
I1I2=kron(I1,I1);
GrupoDiag=[];
for i=1:4
    for j=1:4
        for k=1:4
            for l=1:2
            Aux=P1^(i)*P2^(j)*P1P2^(k)*CZ^(l);
            GrupoDiag=[GrupoDiag;Aux];
            end
        end
    end

end

m=(length(GrupoDiag(:,1))/4);
GrupoD=zeros(4,4,m);

for i=1:m
    
    GrupoD(:,:,i)=GrupoDiag((((i-1)*4+1):i*4),:);
    
end
for n=1:8
for i=1:m
    for j=1:4
        for k=1:4
            if k==4
                fprintf(fileID,'%f\n',real(GrupoD(j,k,i)*fases(n)));
            else
                fprintf(fileID,'%f\t',real(GrupoD(j,k,i)*fases(n)));
            end
        
        end
    end
    for j=1:4
         for l=1:4
            
            if l==4
                fprintf(fileID,'%f\n',imag(GrupoD(j,l,i)*fases(n)));
            else
                fprintf(fileID,'%f\t',imag(GrupoD(j,l,i)*fases(n)));
            end
        end
    end
end    
    
    
    
end



fclose(fileID);   
    %% Tres dimensiones

P1=kron(P,kron(I1,I1));
P2=kron(I1,kron(P,I1));
P3=kron(I1,kron(I1,P));
I=kron(I1,kron(I1,I1));
CZ12=kron(CZ,I1);
CZ23=kron(I1,CZ);
CZ13=diag([1,1,1,1,1,-1,1,-1]);

fileID= fopen('Diag3D.txt','w');
GrupoDiag=[];
for i=1:4
for j=1:4
for k=1:4
for l=1:2
for m=1:2
for n=1:2
            Aux=P1^(i)*P2^(j)*P3^(k)*CZ12^(l)*CZ23^(n)*CZ13^(m);
            GrupoDiag=[GrupoDiag;Aux];
end
end
end
end
end
end

m=(length(GrupoDiag(:,1))/8);
GrupoD=zeros(8,8,m);

for i=1:m
    
    GrupoD(:,:,i)=GrupoDiag((((i-1)*8+1):i*8),:);
    
end
for n=1:8
for i=1:m
    for j=1:8
        for k=1:8
            if k==8
                fprintf(fileID,'%f\n',real(GrupoD(j,k,i)*fases(n)));
            else
                fprintf(fileID,'%f\t',real(GrupoD(j,k,i)*fases(n)));
            end
        
        end
    end
    for j=1:8
         for l=1:8
            
            if l==8
                fprintf(fileID,'%f\n',imag(GrupoD(j,l,i)*fases(n)));
            else
                fprintf(fileID,'%f\t',imag(GrupoD(j,l,i)*fases(n)));
            end
        end
    end
end    
    
    
    
end

fclose(fileID);







