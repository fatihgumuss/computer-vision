clc
clear
close(winsid());
I0 = imread(".\flames.bmp");
P0 = imread(".\flames_pattern.bmp");

[row, col, deep] = size(I0);
I0 = double(I0);
[p_row, p_col, p_deep] = size(P0);
P0 = double(P0);
IG=I0
IG = sum(I0, 3) / 3 / 255;
PG = sum(P0, 3) / 3 / 255;
IG0 = IG
a_step=15; noa=360/a_step;
N=p_row;
M=zeros(N,N);
r=N/2;
for i=1:N
  for j=1:N
    if sqrt((i-r-0.5)^2+(j-r-0.5)^2)<r
      M(i,j)=1;
    end;
  end;
end;

for a=1:noa
    PGF(a,:,:)=-1*ones(N,N);
    alpha=(a-1)*a_step;
    alpha=alpha*%pi/180;
    R=[cos(-alpha) -sin(-alpha); sin(-alpha) cos(-alpha)];
    for i=1:N
        for j=1:N
            if M(i,j)
                ij2=R*[i-r-0.5;j-r-0.5];
                i2=round(ij2(1)+r+0.5);
                j2=round(ij2(2)+r+0.5);
                PGF(a,i,j)=PG(i2,j2,1);
            end
        end
    end
end 

imshow_G=zeros(row,col);
imshow_G=IG(:,:,1);
PATTERNS=PGF(:,:,:);

max_r=row-p_row+1;
max_c=col-p_col+1;
A=zeros(noa,max_r,max_c);

for a=1:noa
    for r=1:max_r
        for c=1:max_c
            P=squeeze(PATTERNS(a,:,:));
            A(a,r,c)=sum(sum(abs(imshow_G(r:r+p_row-1,c:c+p_col-1)-P)));
        end;
    end;
end;
Aorg=A;

for object_number=1:8
    maxA=max(max(max(A)));
    min_A=maxA; am=1; rm=1; cm=1;
    for a=1:noa
        for r=1:max_r
            for c=1:max_c
                if min_A>A(a,r,c)
                    min_A=A(a,r,c);
                    am=a; rm=r; cm=c;
                end;
            end;
        end;
    end;
    if object_number==1
        first_a=am;
    end;    
    object_number
    angle=(am-ceil(noa/2))*a_step

    for p_r=1:p_row
        for p_c=1:p_col
            IG0(rm+p_r-1,cm+p_c-1,1)=0;
        end;
    end;

    roc=10;
    for r=rm-roc:rm+roc
        for c=cm-roc:cm+roc
            if (r>0) & (r<=max_r)
               if (c>0) & (c<=max_c)
                  A(:,r,c)=maxA; 
               end;
            end;
        end;
    end;
end;

figure();
imshow(IG);

figure();
imshow(PG);

figure();
imshow(IG0);
