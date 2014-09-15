function [out1,out2]=z_morph4dis(in1,in2)
%%
iter = 1;
vs = strel('line',10,0);
hs = strel('line',10,90);
while(iter)
    out1 = imdilate(in1,hs);
    out2 = imdilate(in2,vs);
    out1 = imerode(out1,hs);
    out2 = imerode(out2,vs);
    iter=iter-1;
end
% figure();imshow(in1);
% figure();imshow(in2);
% figure();imshow(out1);
% figure();imshow(out2);

end