function wms = cal_asr(verts, faces, obj_area)
% calculate area scaling ratio between object mesh and parameter mesh
%

par_area = cal_par_area(verts,faces);

bix = find(par_area>pi | par_area<=0);
if ~isempty(bix)
    disp(['bad areas:' sprintf(' %f',par_area(bix))]);
end

asr = par_area./obj_area; asr2 = 1./asr;
stretch = max(asr,asr2);

wms = sum(stretch.*obj_area);

% figure; hist(asr);

disp(sprintf('fc_asr ==> asr_min %f, asr_max %f, weighted_mean %f, stretch_mean %f, stretch_std %f',...
              min(asr),max(asr),wms,mean(stretch),std(stretch)));

return;
