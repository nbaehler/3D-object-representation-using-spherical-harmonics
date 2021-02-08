function [sph_verts, vertices, faces, dateline, landmarks, metric] = smooth_surface(maxfn, switchcc, vertices, faces, name)
%	This function performs the initial smoothing of the surface of an
%	object before further processing. 

	t = cputime;

	% adjust face numbers
    fn = size(faces,1);
    if fn>maxfn
        disp(sprintf('Reduce face number from %d to %d',fn,maxfn));
        [faces,vertices] = reducepatch(faces,vertices,maxfn);
    end
    
    % change quadralaterals to triangles
    if size(faces,2)==4
        faces = [faces(:,1:3); faces(:,[3 4 1])];
    end
    
    vertnum = size(vertices,1);
    facenum = size(faces,1);
    
    % switch to counterclockwise
    if switchcc
        disp('switch to counterclockwise ...');
        faces = faces(:,end:-1:1);
    end
        
    % create edges
    edges = create_edges(faces);
    disp(sprintf('%s: %+4d = %d (%d) vertices * 2 - %d faces; %d edges', name, ...
                  vertnum*2-facenum, vertnum, length(unique(faces)), facenum,size(edges,1)));
    [AM, WAM] = adjacency_mat(vertices,edges);
	obj_area = cal_obj_area(vertices,faces);
	obj_area = obj_area/sum(obj_area);    
    poles = determine_poles(vertices); % north 1 south 2

%	disp_surfmesh(name,vertices,faces,poles);
    needtosave = 0;
    [verts,landmarks,dateline] = init_param_wt(vertices,faces,WAM,AM,poles); % initial parameterization
	clear('AM', 'WAM');
	
%	figure; hold on;
%	patch('vertices',verts,'faces',faces,'facecolor','w','edgecolor','k','facealpha',1);
%	view(3); title(num2str(cal_asr(verts, faces, obj_area))); axis equal; hold off;
%	gen_view('disp_outline_info',verts,faces,path,name,dateline,landmarks,'ol_b',needtosave);
    
    sph_verts = verts;
    
%	gen_view('disp_outline_info',vertices,faces,path,name,dateline,landmarks,'ol_a',needtosave);
%	gen_view('disp_outline_info',sph_verts,faces,path,name,dateline,landmarks,'ol_b',needtosave);
%	save(fullfile(path,[name, '_ini.mat']), ...
%         'vertices', 'faces', 'edges', 'sph_verts', 'dateline', 'landmarks');

% added by Li Shen 07/13/07: 
% multiple runs of smoothing can help remove ringing effects
	
	% ============================================
	% smooth_mc.m (Perform smoothing in a fast way, combine matlab and c)
	%
	% Goal: Surface net should preserve the area 
	%   1. Each face should have the same relatively area as before
	%
	% Li Shen 
	% 09/04/2003 - create
	% 
	%  This portion of the file was transcribed from tsh02_smooth.m by Mark McPeek.
	%  07/10/2007

	disp('*********** Smoothing Surface ***********');
	for k=1:3
		info = str2num('50 6 2 2 100 10 1');
		reso = info(6); tmajor=info(7);
		ms = 50;
		shd = 6;
		tole = 2;
		smft = 2;
		iter = 100;
		liter = 10;
	
		disp('Begin Smoothing algorithm.');
	    % initialization
	    verts = sph_verts;
	
		% calculate relative areas of triangles on object surface net
		obj_area = cal_obj_area(vertices,faces);
	    cal_asr(verts, faces, obj_area);
	    vertnum = size(vertices,1); facenum = size(faces,1);
		disp(sprintf('  --- %s: %+4d = %d vertices * 2 - %d faces ', name, vertnum*2-facenum, vertnum, facenum));
	
	    % remove bad areas
	    verts = call_locsmo(verts,vertices,faces-1,10,reso);
	    curinfo = info; 
		premstch = inf; count = 0;
	    for j = 1:info(5)
	        disp(sprintf('-------- SPHARM deg %d: pass %d: %d of %d ---------', curinfo(2), k, j, info(5)));
	        % smooth by interpolation
	        [verts, mstch] = smooth(verts,faces,curinfo,obj_area,tmajor);
	        cal_asr(verts, faces, obj_area);
	        verts = call_locsmo(verts,vertices,faces-1,10,reso);
	        disp(sprintf('mstch=%f',mstch));
	        if (premstch-mstch)>0.001
	            count=0; premstch=mstch;
			else
	            count=count+1;
			end
			
	        if (mstch<1.001 || count>=3) 
				break; 
			end
		end
	
	    sph_verts = verts;
	    metric = get_metric('metric',11);
	    seconds = cputime - t;
	    hours = seconds/3600;
	    metric(end+1)=mstch;
	    metric(end+1)=j;
		metric(end+1)=seconds;
		show_metric(metric);
	    disp(sprintf('================== area scaling (obj/prm): %f, %f ==================', metric(4), metric(5)));
	    if metric(4)+metric(5)<2.8
	        disp('Good enough, stop!'); break;
		else
	        disp('Not good enough, continue.');
		end
	end
return;

