function [deep,shallow,tblr]=z_preAnalysis(filepath)

fileh = fopen(filepath);
if(fileh<0)
    disp('no such file');
    return;
end
filehead = fread(fileh,3,'uint=>uint');
val = fread(fileh,filehead(1)*filehead(2)*filehead(3),'uint=>uint');

val1 = val(val~=0);
deep=max(val1);
shallow=min(val1);

%%% to do: find suitable bounding box
%%% this is a space consuming process, in a 3-D volume
%%% so be tidy. ^3^ 15KB: 55*320*240
frameWidth = filehead(2);
frameHeight = filehead(3);
frameNumber = filehead(1);
processVolumne = uint32(zeros(frameWidth,frameHeight,frameNumber));
processVolumne(:)=val(:);
summation =sum(processVolumne,3)';

[t,b,l,r]=thisbounding(summation);

tblr = [t;b;l;r];
clear summation;

fclose(fileh);
end

function [top,bottom,left,right]=thisbounding(suma)
for i = 1:size(suma,1)
    if(sum(sum(suma(1:i,:)))~=0)
        top=i;
        break;
    end
end
for i = size(suma,1):-1:1
    if(sum(sum(suma(i:size(suma,1),:)))~=0)
        bottom=i;
        break;
    end
end
for i = 1:size(suma,2)
    if(sum(sum(suma(:,2:i)))~=0)
        left=i;
        break;
    end
end
for i = size(suma,2):-1:1
    if(sum(sum(suma(:,i:size(suma,2))))~=0)
        right=i;
        break;
    end
end
%figure(11);imshow(suma,[]);hold on;line([left,left,right,right,left],[top,bottom,bottom,top,top]);
end