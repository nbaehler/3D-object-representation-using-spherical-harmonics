% ============================================
% view_shsurf.m
%
% Goal: visualize parametric surfaces
%
% Li Shen 
% 04/30/2003 - create

function [ output_args ] = view_shsurf( info, files )

   %%% TURN OFF GUI (HF, 9.9.05)
   if(0)
      inform = spm_input('degrees meshsize', '+0', 's', '0 30 32');
      info = str2num(inform); dg = info(1:2); meshsize = info(3);
      
      % read objects
      files = spm_get(Inf,'*_des.mat',['workspace file']);
      if (length(files)<1)
	 return;
      end
   else
      dg = info(1:2); 
      meshsize = info(3);
   end

% read and process images
n = size(files,1);
% spm_progress_bar('Init',n,'Reading objects','objects completed');
for i = 1:n
    subfile = deblank(files(i,:));
    [path,name,ext,ver] = fileparts(subfile);
    load(subfile);

    gen_view('disp_spharm_desc',fvec,meshsize,dg,path,name,[],0);

%     spm_progress_bar('Set',i);
end
% spm_progress_bar('Clear');

return;
