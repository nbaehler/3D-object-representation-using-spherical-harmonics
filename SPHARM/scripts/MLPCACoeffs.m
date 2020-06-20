function [currentDir] = MLPCACoeffs(currentDir, x, y, z)
% This script reads in the resulting file from Tri_SPHARM_MakeModel.m, and
% performs a principal components analysis on the spherical harmonic coefficients.

disp('INSIDE MLPCACoeffs');

makeModes = x;
numPCsToKeep = y;
outputFormat = z;

% Set parameters
fvecs = [];	% fvecs is accumulator of coefficients from each species.
meshsize = -4;

% get file list from disk
[names, currentDir] = uigetfile({'*reg.mat','registered SPHARM *reg.mat files'},'Load registered SPHARM models',currentDir,'MultiSelect','on');
[fake, n] = size(names);
moreThanOneFile = iscell(names);
if (isnumeric(names))
    disp('No files chosen to PCA Analysis.');
    currentDir = cd;
    return
else
    if moreThanOneFile
        for i=1:n
            disp(names{i});
        end
    else
        disp('Only one file chosen for PCA.  Too few, so returning.');
        return
    end
end

% do processing of each file
for k = 1:n;
	% read file to get.
    file = fullfile(currentDir,names{k});
    file = deblank(file)
	load(file);
	clear('sph_verts', 'vertices', 'faces', 'landmarks');

	[nrows ncols] = size(fvec);
	temp = fvec.';
%	temp = sqrt(real(temp).^2 + imag(temp).^2); % MAGNITUDE 
	temp = reshape(temp, (nrows*3), 1);
	fvecs = [fvecs temp];
end
% disp('fvecs size is');
% size(fvecs);
clear('fvec', 'temp', 'files','filestring', 'name');

%--------------------
%       Do PCA
%--------------------
fvecs = fvecs.';  
[eigenvecs, scores, eigenvals] = princomp(fvecs);
perc_variance_explained = eigenvals/sum(eigenvals);

% drop cells that are to not be kept
% eigenvecs = eigenvecs(:,1:keep);
% scores = scores(:,1:keep);
% eigenvals = eigenvals(1:keep,1);
% perc_variance_explained = perc_variance_explained(1:keep,:);
sum_percent_explained = cumsum(perc_variance_explained);

% write output to file.
pcFile = fullfile(currentDir,'PCSummary.dta');
fid = fopen(pcFile,'w');
fprintf(fid,'Total Variance \t%20.10f\n\n',sum(eigenvals));
fprintf(fid,'Eigenvalue\t');
for k=1:numPCsToKeep
    fprintf(fid,'%20.10f\t\t',eigenvals(k));
end
fprintf(fid,'\nPercent of Variance Explained\t');
for k=1:numPCsToKeep
    fprintf(fid,'%12.6f\t\t',perc_variance_explained(k));
end
fprintf(fid,'\n\nPC Scores\n');
fprintf(fid,'Object');
for k=1:numPCsToKeep
    fprintf(fid,'\tPC_%-2i real\tPC_%-2i imaginary',k,k);
end
fprintf(fid,'\n');
for k=1:n
    fprintf(fid,'%s', names{k});
    for l=1:numPCsToKeep
        fprintf(fid,'\t%12.6f\t%12.6fi', real(scores(k,l)), imag(scores(k,l)));
    end
    fprintf(fid,'\n');
end
fclose(fid);

if (makeModes == 1)
    % make surfaces from the eigenvectors
    
    PCdir =uigetdir(currentDir,'Directory for Eigenmodes');
    [nrows,ncols] = size(eigenvecs);
    degrees = zeros(1,2);
    degrees(1) = 0;
    degrees(2) = sqrt(nrows/3) - 1;

    % Visualization of each eigenmode using backprojection
    meshsize = -4; % Underlying spherical mesh is an icosahedron subdivision at level 4
    dg = [0 15];

    % get the mean fvec
    mfvec = mean(fvecs,1);

    % mode defines the current eigenmode we want to visualize
    for mode = 1:numPCsToKeep
        eigenmode = eigenvecs(:,mode); % eigenmode direction
        variance = eigenvals(mode); % data variance in the current eigenmode
        standev = sqrt(variance);
        for i=-2:2
            % shift along the current eigenmode direction
            cfvec = mfvec + eigenmode'*i*standev;
            cfvec = reshape(cfvec,3,256)';
            % make vertices and faces for the current fvec
            [spharm_vertices, spharm_faces] = surf_spharm(cfvec,dg,meshsize);
            % output surface based on mesh picked
            new_name = sprintf('PC%d_%d',mode,i);
            switch outputFormat  % format to use for output
                case 'Amira'
                    outputToAmira(PCdir, new_name, spharm_vertices, spharm_faces);
                case 'STL'
                    outputToSTL(PCdir, new_name, spharm_vertices, spharm_faces);
                otherwise   % Amira output is default
                    outputToAmira(PCdir, new_name, spharm_vertices, spharm_faces);
            end
            % write fvec to an .mat file
            fvec = cfvec;
            faces = spharm_faces;
            vertices = spharm_vertices;
            save(fullfile(PCdir, strcat(new_name, '.mat')),  'fvec', 'vertices', 'faces', 'dg');
        end
    end
end

disp('MLPCACoeffs finished.');
end