function [c1,c2,c3]=z_getcentroid(i1,i2,i3)
%%
s1 = regionprops(i1,'area','centroid');
s2 = regionprops(i2,'area','centroid');
s3 = regionprops(i3,'area','centroid');

c1=preventMul(s1);
c2=preventMul(s2);
c3=preventMul(s3);

end


function c = preventMul(s)

if(size(s,1)>1)
    a=zeros(size(s));
    for i = 1:size(s,1)
        a(i)=s(i).Area;
    end
    ma = max(a);
    for i = 1:size(s,1)
        if(a(i)==ma)
            c=s(i).Centroid;
            break;
        end
    end
else
    c=s(1).Centroid;
end

end