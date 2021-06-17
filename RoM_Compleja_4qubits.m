%clear all;clc;

%fp=fopen('Grupo2D_sinfases.txt');
% A=fscanf(fp,'%lf\t%lf\t%lf\t%lf\n',[4 inf]);
% A=A';
% fclose(fp);

% M=zeros(16,11520);
% n=0;
% 
% m=11520*2;
% Grupo=zeros(4,4,m);
% intermedia=zeros(4,4,11520);

% for i=1:m
%     
%     Grupo(:,:,i)=A((((i-1)*4+1):i*4),:);
%     
% end
% 
% for i=1:m/2
%     
%     intermedia(:,:,i)=complex(Grupo(:,:,(i)*2-1),Grupo(:,:,i*2));
%     
% end


% n=1;
% m=1;
% for j=1:16384
%     for i=1:16
%         M(i,j)=intermedia(n,m,j);
%         if(mod((i),4)==0)
%             n=n+1;m=1;
%         else
%             m=m+1;
%         end
%         
%         
%     end
%     n=1;m=1;
% end
Resultados=zeros(1,181);
thetar=zeros(1,181);
M=GrupoDiag;

%for j=1:181
theta=pi/4;
%theta=(2*pi/180)*(j-1);
z=complex(cos(theta),sin(theta));
%z=complex(0.5,0.5);
z2=conj(z);
%b=[1,z,z,z^2,z,z^2,z^2,z^3,z,z^2,z^2,z^3,z^2,z^3,z^3,z^4]; %T^4
T3=[1,1,z,z,z,z,z^2,z^2,z,z,z^2,z^2,z^2,z^2,z^3,z^3]'; %T^3
T2=[1,1,1,1,z,z,z,z,z,z,z,z,z^2,z^2,z^2,z^2]'; %T^2
T4=[1,z,z,z^2,z,z^2,z^2,z^3,z,z^2,z^2,z^3,z^2,z^3,z^3,z^4]'; %T^1
b=[1,z,1,z,1,z,1,z,1,z,1,z,1,z,-1,-z]'; %CCZ^T
%b=[1,-1,1,1,1,1,1,1,1,1,1,1,1,1,1,-1];
CCZ=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,-1,-1]';
CCZabajo=[1,1,1,1,1,1,1,-1,1,1,1,1,1,1,1,-1]';
%T1=[1,1,z,z,z,z,z^2,z^2,z,z,z^2,z^2,z^2,z^2,z^3,z^3];
%b=Circuito';
T1=[1,1,1,1,1,1,1,1,z,z,z,z,z,z,z,z]';
n=16384;

cvx_begin
variable x(n) complex
minimize ( norm(x,1) )
subject to 
M*x==A'
cvx_end

%thetar(j)=theta;
 %Resultados(j)=cvx_optval;

%end
Indicador=zeros(16384,1);
m=1;
for i=1:16384
    if(abs(x(i,1))>0.0001)
        Indicador(m,1)=i;
        m=m+1;
    end
    

end
