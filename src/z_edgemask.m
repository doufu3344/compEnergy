function [e1,e2,e3]= z_edgemask(m1,m2,m3)
ms = strel('disk',2,0);
e1 = imerode(~edge(m1,'canny'),ms);
e2 = imerode(~edge(m2,'canny'),ms);
e3 = imerode(~edge(m3,'canny'),ms);
end