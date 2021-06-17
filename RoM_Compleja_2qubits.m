clear all;clc;

fp=fopen('Grupo2D_sinfases.txt');

A=fscanf(fp,'%lf\t%lf\t%lf\t%lf\n',[4 inf]);
A=A';
fclose(fp);

M=zeros(16,11520);
n=0;

m=11520*2;
Grupo=zeros(4,4,m);
intermedia=zeros(4,4,11520);

for i=1:m
    
    Grupo(:,:,i)=A((((i-1)*4+1):i*4),:);
    
end
for i=1:m/2
    
    intermedia(:,:,i)=complex(Grupo(:,:,(i)*2-1),Grupo(:,:,i*2));
    
end


n=1;
m=1;
for j=1:11520
    for i=1:16
        M(i,j)=intermedia(n,m,j);
        if(mod((i),4)==0)
            n=n+1;m=1;
        else
            m=m+1;
        end
        
        
    end
    n=1;m=1;
end
Resultados=zeros(1,181);
thetar=zeros(1,181);

%for j=1:181
theta=pi/4;
%theta=(2*pi/180)*(j-1);
z=complex(cos(theta),sin(theta));
%z=complex(0.5,0.5);
z2=conj(z);
Swap12=[1,0,0,0,0,0.5*(1+complex(0,1)),0.5*(1-complex(0,1)),0,0,...
    0.5*(1-complex(0,1)),0.5*(1+complex(0,1)),0,0,0,0,1]';
b=[1,0,0,0,0,1,0,0,0,0,-1,0,0,0,0,-1];
b=b';
n=11520;
Swap=[1,0,0,0,0,0,complex(0,1),0,0,complex(0,1),0,0,0,0,0,1]';
cvx_begin
variable x(n) complex
minimize ( norm(x,1) )
subject to 
M*x==b
cvx_end

%thetar(j)=theta;
%Resultados(j)=cvx_optval;
Indicador=zeros(11520,1);
%end
m=1;
for i=1:11520
    if(abs(x(i,1))>0.0001)
        Indicador(m,1)=i;
        m=m+1;
    end
    

end
%plot(thetar,Resultados)
%shg







