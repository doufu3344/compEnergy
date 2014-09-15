function [im,fileh,filehead]=z_headReader(acnr,sunr,exnr,dpath)
[acsr,susr,exsr]=getsr(acnr,sunr,exnr);
fileh = fopen([dpath,'\MSRAction3D\a',acsr,'_s',susr,'_e',exsr,'_sdepth.bin']);
if(fileh<0)
    disp('no such file');
    return;
end
filehead = fread(fileh,3,'uint=>uint');
im = uint32(zeros(filehead(2),filehead(3)));
end