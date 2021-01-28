% ============================================
% gen_utils.m
%
% Goal: 
%   1. Some general routines called by different scripts
%
% Li Shen 
% 07/22/2002 - create

function varargout = gen_utils(choice,varargin)

switch (choice)
case 'con_1d_to_2d'
    is = varargin{1}; d = varargin{2};
    [xs, ys] = con_1d_to_2d(is, d);
    varargout{1} = xs; varargout{2} = ys;
case 'con_2d_to_1d'
    xs = varargin{1}; ys = varargin{2}; d = varargin{3};
    is = con_2d_to_1d(xs, ys, d);
    varargout{1} = is;
case 'con_1d_to_3d'
    is = varargin{1}; d = varargin{2};
    [xs, ys, zs] = con_1d_to_3d(is, d);
    varargout{1} = xs; varargout{2} = ys; varargout{3} = zs;
case 'con_3d_to_1d'
    xs = varargin{1}; ys = varargin{2}; zs = varargin{3}; d = varargin{5};
    is = con_3d_to_1d(xs, ys, zs, d);
    varargout{1} = is;
case 'disp_cls_setting'
    degs = varargin{1}; regstr = varargin{2}; fvecstr = varargin{3}; ldmks = varargin{4};
    scastr = varargin{5}; pcs = varargin{6}; grp = varargin{7}; fname = varargin{8};
    disp_cls_setting(degs,regstr,fvecstr,ldmks,scastr,pcs,grp,fname);
case 'create_ldmks'
    meshsize = varargin{1}; degree = varargin{2}; fvs = varargin{3}; fvs_b = varargin{4}; dim_ind = varargin{5};
    points = create_ldmks(meshsize,degree,fvs,fvs_b,dim_ind);
    varargout{1} = points;
case 'get_fnames'
    info_str = varargin{1};
    [files, path, name] = get_fnames(info_str);
    varargout{1} = files; varargout{2} = path; varargout{3} = name;
case 'arrange_label'
    content = varargin{1};
    label = arrange_label(content);
    varargout{1} = label;
end

return;

%
% generate landmarks based on feature vectors (not useful yet)
%

function points = create_ldmks(meshsize,degree,fvs,fvs_b,dim_ind)

% sph11_can_basis(meshsize, degree, fast)
% if need gc, set (fast~=1)
[Z, fs] = sph11_can_basis(meshsize, max(degree), 0);
[d(1),d(2),d(3)] = size(fvs); 
dimen = (meshsize+1)^2*3;

for i = 1:d(3)
	vs = Z(:,dim_ind)*fvs(dim_ind,:,i);
    points(i,:) = reshape(vs,1,dimen);
%        plot_result('plot_vs_scatter3',vs);
end
if ~isempty(fvs_b)
    for i = 1:d(3)
    	vs = Z(:,dim_ind)*fvs(dim_ind,:,i);
        points_b(i,:) = reshape(vs,1,dimen);
%            plot_result('plot_vs_scatter3',vs);
    end
    points = [points, points_b];        
end

points = real(points);

return;


%
% convert 1d index to 2d index
%

function [xs, ys] = con_1d_to_2d(is, d)

xs = mod((is-1), d(1))+1;
ys = floor((is-1)/d(1))+1;

return;

%
% convert 2d index to 1d index
%

function is = con_2d_to_1d(xs, ys, d)

is = (ys-1)*d(1) + xs;

return;

%
% convert 1d index to 3d index
%

function [xs, ys, zs] = con_1d_to_3d(is, d)

xs = mod(is-1, d(1))+1;ys = mod((is-xs)/d(1), d(2))+1;
zs = (is-xs-(ys-1)*d(1))/(d(1)*d(2))+1;

return;

%
% convert 3d index to 1d index
%

function is = con_3d_to_1d(xs, ys, zs, d)

is = (zs-1)*d(1)*d(2) + (ys-1)*d(1) + xs;

return;

%
% display classification setting
%

function disp_cls_setting(degs,regstr,fvecstr,ldmks,scastr,pcs,grp,fname)

disp( ' ');
disp( '****************** Classification Batch Setting ******************');
disp(['* degree   :' sprintf(' %d',degs)]);
str = regstr{1};
for i = 2:length(regstr) str = [str,', ',regstr{i}]; end
disp(['* region   : ' str]);
str = fvecstr{1};
for i = 2:length(fvecstr) str = [str,', ',fvecstr{i}]; end
disp(['* fvector  : ' str]);
ldmks
disp(['* landmark :' sprintf(' %d',ldmks)]);
str = scastr{1};
for i = 2:length(scastr) str = [str,', ',scastr{i}]; end
disp(['* scaling  : ' str]);
disp(['* pcnum    :' sprintf(' %d',pcs)]);
disp(['* group    :' sprintf(' %d',grp)]);
disp( '* ----------------------------------------------------------------');
num = [length(degs),length(regstr),length(fvecstr),length(scastr)];
disp(['* ITERATION:' sprintf(' %d*%d*%d*%d=%d',num,prod(num))]);
disp(['* FILENAME :' sprintf(' %s',fname)]);
disp( '******************************************************************');

return;

%
% get file names from a content file
%

function [files, path, name] = get_fnames(info_str)
confile = spm_get(1,'*.lst',[info_str]);
[path,name,ext,ver] = fileparts(confile);
fid = fopen(confile);
line_num = str2num(fgetl(fid));
directory = deblank(fgetl(fid));
for i=1:line_num-2
    files{i} = fullfile(path, [directory, fgetl(fid)]);
end
fclose(fid);

files = char(files);
return;

%
% break long label into multiple lines
%

function label = arrange_label(content)

limit = 100;
templabel = sprintf(' %0.0f',content);
segnum = ceil(length(templabel)/limit);
seglen = ceil(length(content)/segnum);
for i=1:segnum-1
    label{i} = sprintf(' %0.0f',content(((i-1)*seglen+1):(i*seglen)));
end
label{segnum} = sprintf(' %0.0f',content(((segnum-1)*seglen+1):end));
label = char(label);

return;
