% Output patches of three views (pchFrt,pchSid,pchTop)
% TODO: assign dpath to your data path (line 9).
% Author: Chenyang Zhang
% Date:   July 2012
% Input: a binary file indicating to a depth video;
% Output: 3 pathches from different views (frontal, side and top) to calculate HoG.

clear;close all;clc;

dpath = '.';

addpath('.\src');
di=1; % control patch size
nof = 10000; % control how many frames limit

for ai = 1:20
    for si = 1:10
        for ei = 1:3
            actionID=ai;subjectID=si;exampleID=ei;
            %disp([num2str(actionID),'|',num2str(subjectID),'|',num2str(exampleID)]);
            [acsr,susr,exsr]=getsr(ai,si,ei);
            filepath = [dpath,'\MSRAction3D\a',acsr,'_s',susr,'_e',exsr,'_sdepth.bin'];
            if ~exist(filepath,'file');
                continue;
            end;
            disp(filepath);
            
            %%% pre-analyse sequence, find the deepest and shallowest pixels
            %%% for normalization; secondary task: try if this file exist
            try
                [deep,shallow,bbox]=z_preAnalysis(actionID,subjectID,exampleID,dpath);
            catch err
                disp(err.identifier);
            end
            deep=double(deep);shallow=double(shallow);
            
            %%% re-open the file, read header, not close file.
            [im,fileh,filehead]= z_headReader(actionID,subjectID,exampleID,dpath);
            %%% read frame # and width and height (of frontal view) from file-head
            noframe = filehead(1);
            fwidth = filehead(2);
            fheight = filehead(3);

            %%% allocate sideview and topview image
            sideim = zeros(fheight,100);
            topim=zeros(100,fwidth);
            if(nof>noframe)
                nnof=noframe;
            else
                nnof=nof;
            end
            %%% main routine
            hist = zeros(1,nnof);
            for i = 1:nnof
                %%% get frontal image from file
                frame = fread(fileh,fwidth*fheight,'uint=>uint');
                im(:)=frame(:);
                %%% transpose image for display and doublize for process
                frontim = double(im');
                %%% find Non-Zero-mIn for scaling
                %%% generate sideview image and topview image from frontal image
                sideview = front2side(frontim,deep,shallow);
                topview = front2top(frontim,deep,shallow);
                sideim(:)=sideview(:);
                topim(:)=topview(:);
                %%% do morphology to remove 'strip'
                [topimo,sideimo] = z_morph4dis(topim,sideim);
               
                %%% only concern on "flat" case
                bf=frontim~=0;
                bs=sideimo~=0;
                bt=topimo~=0;
                %%% get inverse edge mask
                [ief,ies,iet]=z_edgemask(bf,bs,bt);
                %%% observe mask diffrence
                if(i>1)
                    mfront = accumMap(mfront,frontim,of,ief);
                    mside = accumMap(mside,sideimo,os,ies);
                    mtop = accumMap(mtop,topimo,ot,iet);

                   hist(i) = sum(sum(mfront))+sum(sum(mside))+sum(sum(mtop));

%                     hist(i) = sum(sum(mfront));
                else% layer 0
                    mfront=zeros(size(ief));
                    mside=zeros(size(ies));
                    mtop=zeros(size(iet));
                    
                    
                    prefront = frontim;
                    
                end
                of = frontim;
                os = sideimo;
                ot = topimo;
                
                
                
            end%for i=1:nnof
            
%             enerfolder = 'energy_only_front';
            enerfolder = 'energy_three_views';
            if ~exist(enerfolder,'dir')
                mkdir(enerfolder);
            end
            [acsr,susr,exsr]=getsr(ai,si,ei);
            enerpath =[enerfolder,'\a',acsr,'_s',susr,'_e',exsr,'_ener.mat'];
            save(enerpath,'hist');
            fclose(fileh);
        end
    end
end
