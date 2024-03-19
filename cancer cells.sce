clc
clear
close(winsid());

cancer_image = imread(".\cancer.bmp");
cell_image = imread(".\cell.bmp");

[row, col, deep] = size(cancer_image);
cancer_image = double(cancer_image);
[P_row, P_col, P_deep] = size(cell_image);
cell_image = double(cell_image);

IG0 = sum(cancer_image, 3) / 3 / 255;
PG0 = sum(cell_image, 3) / 3 / 255;

P = PG0;
I = IG0;

num_cells = 5;
IB1 = zeros(row, col, 3);
for i = 1:row
    for j = 1:col
        IB1(i,j,:) = [IG0(i,j,:), IG0(i,j,:), IG0(i,j,:)];
    end
end

for k = 1:num_cells
    A = zeros(row - P_row + 1, col - P_col + 1);
    for i = 1:row - P_row + 1
        for j = 1:col - P_col + 1
            A(i, j) = sum(abs(I(i:i+P_row-1, j:j+P_col-1) - P));
        end
    end
    
    min_val = 10000;
    best_row = 1;
    best_col = 1;
    for i = 1:row - P_row + 1
        for j = 1:col - P_col + 1
            if A(i,j,:) < min_val
                min_val = A(i, j);
                best_row = i;
                best_col = j;
            end
        end
    end

    for i = best_row:best_row+P_row-1
        for j = best_col:best_col+P_col-1
            IB1(i,j,3) = 1;
            A(i-best_row+1,j-best_col+1) = 10000;
            I(i,j,:) = 1;
        end
    end
end

imshow(IB1)
