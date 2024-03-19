clc
clear
close(winsid());

IG0 = imread(".\circles1.bmp");
[row col deep] = size(IG0);
IG0 = double(IG0);
IG1 = IG0
IG1 = double(IG1)

//accumulator
max_x = col
max_y = row
min_r = 25
max_r = 29
A = zeros(max_x,max_y,max_r)
//circle hough transform
for x=1:col
    for y=1:row
        if IG0(y,x,1) == 0
        for r=min_r:max_r
            nop = round(2*%pi*r)
            q = 360/(2*%pi*r)
            for a=1:nop
                Angle = round(a*q)
                xc = x+round(r*cos(Angle))
                yc = y+round(r*sin(Angle))
                if(xc>=1) && (xc<=max_x) && (yc>=1) && (yc<=max_y)
                    A(xc,yc,r) = A(xc,yc,r)+1;
                end
            end
        end
        end
    end
end
for number_of_circles=1:4
//searching for max(A)
    max_A=0;
    xm=1;
    ym=1;
    rm=1;
    for xc=min_r:max_x-min_r
        for yc=min_r:max_y-min_r
            for r=min_r:max_r
                if max_A<A(xc,yc,r)
                    max_A=A(xc,yc,r)
                    xm=xc; ym=yc; rm=r;
                end
            end
        end
    end
    
// the best circle drawing
    for t=0:0.05:2*%pi
        x=round(xm+rm*cos(t))
        y=round(ym+rm*sin(t))
        if(x>0) & (x<=col) & (y>0) & (y<=row)
            IG1(y,x,1) = 255
            IG1(y,x,2) = 0
            IG1(y,x,3) = 0
        end
    end
//removing the global maximum
    A(xm-20:xm+20,ym-20:ym+20,rm-20:rm+20)=0;
end

imshow(uint8(IG1))
