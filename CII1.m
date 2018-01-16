function cii_val = CII1(imageref,imageenh)
%% CII value
%imageref =  'C:\Users\DIwanshu Jain\Desktop\Final.tar\Final\images\park.png';
%imageenh =  'enequ.png';
imgr = imageref;
if size(imgr,3)==3
    imgr = rgb2gray(imgr);
    imgr = imresize(imgr,[512,512]);                                    %Converting the RGB to grayscale
end
imge = imageenh;
if size(imge,3)==3
    imge = rgb2gray(imge);
    imge = imresize(imge,[512,512]);                                    %Converting the RGB to grayscale
end

[m,n] = size(imgr);
[me,ne] = size(imge);
l1 = 4;                 
l2 = 4;
k = ceil(m*n/(l1*l2));
ke = ceil(me*ne/(l1*l2));
k1 = ceil(k/2);
k2 = ceil(k/2);
k1e = ceil(ke/2);
k2e = ceil(ke/2);
I = ones(l1,l2,k);
J = ones(l1,l2,ke);
u = 1;
c = 1;
r = 1;
flagr = 0;
flagc = 0;

while flagr ~=1
    while flagc ~=1
        I(:,:,u) = imgr([r,r+1,r+2,r+3],[c, c+1, c+2,c+3]);
        J(:,:,u) = imge([r,r+1,r+2,r+3],[c, c+1, c+2,c+3]);
        u = u+1;
        c = c+4;
        if c > n || c+1 >n ||c+2>n ||c+3>n
            flagc =1;
        end
    end
    r = r+4;
    if r > m || r+1>m || r+2>m ||r+3>m
        flagr = 1;
    end
end
u = u-1;
num = 0;
den = 0;
p = 0;
q = 0;
g = 1;
%temp2 for enhanced, temp1 for reference
temp1 = zeros(16,1);
temp2 = zeros(16,1);
val1 = zeros(u,1);
val2 = zeros(u,1);
for i = 1:u
    A = I(:,:,i);
    B = J(:,:,i);
    for e=1:16
        temp1(e) = A(e);
        temp2(e) = B(e);
    end
    val1(i) = (max(temp1)-min(temp1))/(max(temp1)+min(temp1));
    val2(i) = (max(temp2)-min(temp2))/(max(temp2)+min(temp2));
end

num = mean(val2);
den = mean(val1);
cii_val = num/den;
if isnan(cii_val) == 1
    cii_val = 0;
    fprintf('\n!Nan found');
end

fprintf('\n CII value** = %f\n', cii_val);

end

