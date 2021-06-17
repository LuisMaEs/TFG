%%
clear all;clc;
P=[1,0;0,complex(0,1)];
I1=[1,0;0,1];
CZ=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,-1];
fases=[exp(i*0),exp(i*pi/4),exp(i*pi*2/4),exp(i*pi*3/4),exp(i*pi),exp(i*pi*5/4),exp(i*pi*6/4),exp(i*pi*7/4)];

%%
%genera la matriz tal cual

P1=diag(kron(P,kron(I1,kron(I1,I1))));
P2=diag(kron(I1,kron(P,kron(I1,I1))));
P3=diag(kron(I1,kron(I1,kron(P,I1))));
P4=diag(kron(I1,kron(I1,kron(I1,P))));
CZ12=diag(kron(CZ,kron(I1,I1)));
CZ23=diag(kron(I1,kron(CZ,I1)));
CZ34=diag(kron(I1,kron(I1,CZ)));
CZ13=[1,1,1,1,1,1,1,1,1,1,-1,-1,1,1,-1,-1];
CZ14=[1,1,1,1,1,1,1,1,1,-1,1,-1,1,-1,1,-1];
CZ24=[1,1,1,1,-1,1,-1,1,1,1,1,1,1,-1,1,-1];
CZ13=CZ13';
CZ14=CZ14';
CZ24=CZ24';
count=1;
%fileID= fopen('Matriz4D_confases.txt','w');
GrupoDiag=zeros(16,16384);
for i=1:4
for j=1:4
for k=1:4
for w=1:4
for l=1:2
for m=1:2
for n=1:2
for o=1:2
for p=1:2
for q=1:2
  
            Aux=P1.^(i).*P2.^(j).*P3.^(k).*P4.^(w).*CZ12.^(l).*CZ23.^(n).*CZ13.^(m).*CZ14.^(o).*...
                CZ24.^(p).*CZ34.^(q);
            
            GrupoDiag(:,count)=Aux;
            count=count+1;
    
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
% 
% for i=1:16
%     for j=1:(8*16384)
%         if j==(8*16384)
%                 fprintf(fileID,'%f\t%f\n',real(GrupoD(i,j)),-real(GrupoD(i,j)));
%         else
%                 fprintf(fileID,'%f\t%f\t',real(GrupoD(i,j)),-real(GrupoD(i,j)));
%         end
%     end
%     
% end
% 
% for i=1:16
%     for j=1:(8*16384)
%         if j==(8*16384)
%                 fprintf(fileID,'%f\t%f\n',imag(GrupoD(i,j)),-imag(GrupoD(i,j)));
%         else
%                 fprintf(fileID,'%f\t%f\t',imag(GrupoD(i,j)),-imag(GrupoD(i,j)));
%         end
%     end
%     
% end

% for n=1:8
% for i=1:m
%     for j=1:8
%         for k=1:8
%             if k==8
%                 fprintf(fileID,'%f\n',real(GrupoD(j,k,i)*fases(n)));
%             else
%                 fprintf(fileID,'%f\t',real(GrupoD(j,k,i)*fases(n)));
%             end
%         
%         end
%     end
%     for j=1:8
%          for l=1:8
%             
%             if l==8
%                 fprintf(fileID,'%f\n',imag(GrupoD(j,l,i)*fases(n)));
%             else
%                 fprintf(fileID,'%f\t',imag(GrupoD(j,l,i)*fases(n)));
%             end
%         end
%     end
% end    
    

%fclose(fileID);