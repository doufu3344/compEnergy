function [im,fileh,filehead]=z_headReader(filepath)

fileh = fopen(filepath);
if(fileh<0)
    disp('no such file');
    return;
end
filehead = fread(fileh,3,'uint=>uint');
im = uint32(zeros(filehead(2),filehead(3)));
end