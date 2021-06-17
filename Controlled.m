function y = Controlled(i,j,n)
    Binarios=dec2bin(0:1:2^n-1)-'0';
    y=zeros(1,2^n);
    for k=1:2^n
            if(Binarios(k,i)==1 && Binarios(k,j)==1)
                y(k)=-1;
            else
                y(k)=1;
            end
        
    end
end