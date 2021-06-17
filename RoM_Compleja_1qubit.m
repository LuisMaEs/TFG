clear all;clc;

fp=fopen('Grupo1D_sinfases.txt');

A=fscanf(fp,'%lf\t%lf\n',[2 inf]);
A=A';
fclose(fp);

M=zeros(4,24);
n=0;

m=24*2;
Grupo=zeros(2,2,m);
intermedia=zeros(2,2,24);

for i=1:m
    
    Grupo(:,:,i)=A((((i-1)*2+1):i*2),:);
    
end
for i=1:m/2
    
    intermedia(:,:,i)=complex(Grupo(:,:,(i)*2-1),Grupo(:,:,i*2));
    
end


n=1;
m=1;
for j=1:24
    for i=1:4
        M(i,j)=intermedia(n,m,j);
        if(mod((i),2)==0)
            n=n+1;m=1;
        else
            m=m+1;
        end
        
        
    end
    n=1;m=1;
end
Resultados=zeros(1,181);
thetar=zeros(1,181);

for j=1:90

 %theta=pi/4;
theta=(2*pi/90)*(j-1);
z=complex(cos(theta),sin(theta));
%z=complex(0.5,0.5);
z2=conj(z);
Rx=[cos(theta/2),-complex(0,sin(theta/2))...
    -complex(0,sin(theta/2)),cos(theta/2)]';
Ry=[cos(theta/2),-sin(theta/2)...
   sin(theta/2),cos(theta/2)]';
Rz=[complex(-cos(theta/2),-sin(theta/2)),0,...
   0,complex(cos(theta/2),sin(theta/2))]';
%b=b';
n=24;
Rotaccion=Rx*Ry;
cvx_begin
variable x(n) complex
minimize ( norm(x,1) )
subject to 
M*x==Rz
cvx_end

thetar(j)=theta;
Resultados(j)=cvx_optval;

end
Indicador=zeros(24,1);
%end
m=1;
for i=1:24
    if(abs(x(i,1))>0.0001)
        Indicador(m,1)=i;
        m=m+1;
    end
    

end


%plot(thetar,Resultados)
%shg

