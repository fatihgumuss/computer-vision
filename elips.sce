clc
clear
close(winsid());

IG0 = imread(".\E.bmp");
IG0 = double(IG0);
[row, col, deep] = size(IG0);
IG1 = IG0;
min_ra = 5;
max_ra = 30;
min_rb = 5;
max_rb = 10;
max_x = col;
max_y = row;
A = zeros(max_x,max_y, max_ra, max_rb);
//hough transform for ellips
for x = 1:col
    for y = 1:row
        if IG0(y,x,1) == 0
            for xs = min_ra:max_x-min_ra
                for ys = min_rb:max_y-min_rb
                    for ra = min_ra:max_ra
                        for rb = min_rb:max_rb
                            if ra*rb == round(sqrt((((x-xs)^2)*(rb^2))+(((y-ys)^2)*(ra^2))))
                                A(x,y,ra,rb) = A(x,y,ra,rb) + 1;
                            end
                        end
                    end
                end
            end
        end
    end
end
for number_of_ellipses=1:2
    //searching for global maximum
    max_A=0; xm=1; ym=1; ram=1; rbm=1;
    for x = min_ra:max_x-min_ra
        for y = min_rb:max_y-min_rb
            for ra = min_ra:max_ra
                for rb = min_rb:max_rb
                    if max_A < A(x,y,ra,rb)
                        max_A = A(x,y,ra,rb);
                        xm = x;
                        ym = y;
                        ram = ra;
                        rbm = rb;
                    end
                end
            end
        end
    end
    
    //drawing the best ellipse
    for t=0:0.05:2*%pi
        x = round(xm + ram * cos(t));
        y = round(ym + rbm * sin(t));
            IG1(y,x,1) = 255
            IG1(y,x,2) = 0;
            IG1(y,x,3) = 0;
    end
    
    //removing the global maximum
    A(xm - 2:xm + 2, ym - 2:ym + 2, ram - 2:ram + 2, rbm - 2:rbm + 2) = 0;
end
imshow(uint8(IG1))
