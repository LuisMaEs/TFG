%%
clear;clc;
P=[1,0;0,complex(0,1)];
I1=[1,0;0,1];
CZ=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,-1];
fases=[exp(i*0),exp(i*pi/4),exp(i*pi*2/4),exp(i*pi*3/4),exp(i*pi),exp(i*pi*5/4),exp(i*pi*6/4),exp(i*pi*7/4)];

%% Todos los generadores!


P1=diag(kron(P,kron(I1,kron(I1,kron(I1,I1)))))';
P2=diag(kron(I1,kron(P,kron(I1,kron(I1,I1)))))';
P3=diag(kron(I1,kron(I1,kron(P,kron(I1,I1)))))';
P4=diag(kron(I1,kron(I1,kron(I1,kron(P,I1)))))';
P5=diag(kron(I1,kron(I1,kron(I1,kron(I1,P)))))';

CZ12=diag(kron(CZ,kron(I1,kron(I1,I1))))';
CZ23=diag(kron(I1,kron(CZ,kron(I1,I1))))';
CZ34=diag(kron(I1,kron(I1,kron(CZ,I1))))';
CZ45=diag(kron(I1,kron(I1,kron(I1,CZ))))';


CZ13=(Controlled(1,3,5));
CZ14=(Controlled(1,4,5));
CZ15=(Controlled(1,5,5));
CZ24=(Controlled(2,4,5));
CZ25=(Controlled(2,5,5));
CZ35=(Controlled(3,5,5));

%%

%fileID= fopen('Diag3D.txt','w');
GrupoDiag=zeros(32,1048576);
contador=1;
for i=1:4
for j=1:4
for k=1:4
for w=1:4
for x=1:4
for l=1:2
for m=1:2
for n=1:2
for o=1:2
for p=1:2
for q=1:2
for r=1:2
for s=1:2
for t=1:2
for u=1:2
            Aux=P1.^(i).*P2.^(j).*P3.^(k).*P4.^(w).*P5.^(x).*CZ12.^(l).*CZ23.^(n).*CZ13.^(m).*CZ14.^(o).*...
                CZ24.^(p).*CZ34.^(q).*CZ15.^(r).*CZ25.^(s).*CZ35.^(t).*CZ45.^(u);
            GrupoDiag(:,contador)=Aux;
            contador=contador+1;
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end




% m=(length(GrupoDiag(:,1))/16);
% GrupoD=zeros(16,16,m);
% 
% for i=1:m
%     
%     GrupoD(:,:,i)=GrupoDiag((((i-1)*16+1):i*16),:);
%     
% end
