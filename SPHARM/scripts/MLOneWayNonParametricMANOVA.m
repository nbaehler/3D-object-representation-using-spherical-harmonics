function [currentDir] = MLOneWayNonParametricMANOVA() 
% This function performs a one-way multivariate ANOVA based on the methods
% described in Anderson, M. J. 2001. A new method for non-parametric
% multivariate analysis of variance. Austral Ecology 26:32-46.  
%
% The method is based on using distances to calculate sums of squares and
% not multiple response variables.  The function uses the Euclidian
% distances between objects and the centroids of various groups to
% calculate sums of squares (this is a different routine than is used in
% the original paper, but it has the same effect), and does a permutation
% test to develop an alternative test of significance.

disp('INSIDE MLOneWayNonparametricMANOVA');
clear;

currentDir = 'C:\Documents and Settings\Mark McPeek\My Documents\Work\Damselflies\Morphology\Adults\Spherical Harmonics Analyses\Male Data\Enallagma Intraspecific\All Species\Centroid Size';

% Set up variables to hold groups
groupID = 1;
holdIDs = [];
holdNames = [];
fvecs = [];

getAnotherGroup = 1;
while (getAnotherGroup)
    [names, currentDir] = uigetfile({'*reg.mat','registered Matlab .mat files'},'Select Files that form a group in the MANOVA',currentDir,'MultiSelect','on');
    [fake, n] = size(names);
    moreThanOneFile = iscell(names);
    if (isnumeric(names))
        disp('No files chosen, so function MLOneWayNonparametricMANOVA is returning.');
        return
    else
%         if moreThanOneFile
%             for i=1:n
%                 disp(names{i});
%             end
%         else
%             n = 1;
%             disp(names);
%         end
    end

    % add the data from these files to the analysis
    for k = 1:n
        holdIDs(end+1) = groupID;
        holdNames{end+1} = names{k};
        
        % read file to get.
        file = fullfile(currentDir,names{k});
        file = deblank(file);
        load(file);
        clear('sph_verts', 'vertices', 'faces', 'landmarks');

        [nrows ncols] = size(fvec);
        fvec = fvec.';
        temp = reshape(fvec, 1, (nrows*ncols));
        realTemp = real(temp);
		imagTemp = imag(temp);
		temp = [realTemp imagTemp];
        fvecs = [fvecs; temp];
    end
    clear('fvec', 'temp', 'realTemp','imagTemp','filestring','file');
    
    % see if another group should be added
    resp = questdlg('Define another group?');
    if (strcmp(resp,'Yes')) 
        getAnotherGroup = 1;
        groupID = groupID + 1;
    else
        getAnotherGroup = 0;
    end
end

[numObs, cols] = size(fvecs);
numGroups = groupID;

dfTot = numObs - 1;
dfTrt = numGroups - 1;
dfError = dfTot - dfTrt;


% Calculate the real F value for a difference among the groups.
[SSTot, SSTrt, SSError] = doMANOVA(holdIDs,fvecs);

MSTrt = SSTrt / dfTrt;
MSError = SSError / dfError;
F = MSTrt/MSError;
P = 1.0 - fcdf(F,dfTrt,dfError);

% Output data
title = sprintf('\n****************************\n* Exact MANOVA Calculations *\n****************************\nOne-way MANOVA\n\n');
output = sprintf(title);
more = sprintf('           df        SS             MS             F              P \n');
output = [output more];
more = sprintf('Groups    %3i   %.10f   %.10f   %.10f   %.5f \n', dfTrt, SSTrt, MSTrt, F, P);
output = [output more];
more = sprintf('Error     %3i   %.10f   %.10f \n', dfError, SSError, MSError);
output = [output more];
more = sprintf('Total     %3i   %.10f \n', dfTot, SSTot);
output = [output more];
disp(output);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now do randomization to get F distribution
reps = 10000;

fprintf('Doing %i randomizations.\n\n', reps);

holdFvecs = fvecs;
holdFs = [];

for k=1:reps
    
if (mod(k,1000) == 0)
    fprintf('rep %i\n', k);
end

    holdFvecs = holdFvecs(randperm(numObs),:);
    [newSSTot, newSSTrt, newSSError] = doMANOVA(holdIDs, holdFvecs);
    holdFs(end+1,1) = (newSSTrt/dfTrt)/(newSSError/dfError);
end

holdFs = sort(holdFs);

X = holdFs > F;

Prand = sum(X)/reps;

fprintf('P based on %i randomizations is %.10f\n\n', reps, Prand);

disp('end MLOneWayNonparametricMANOVA');

end

function [SSTot, SSTrt, SSError] = doMANOVA(IDs,fvecs)
% This function calculates the F value for a set of observations.
[numRows, numCols] = size(fvecs);

% Calculate the various centroids needed
totCentroid = mean(fvecs);
groupCentroids = [];
currentGroup(1,1) = -1;
accumulateFvecs = [];
for j=1:numRows
    % get first fvec
    if (currentGroup == -1)
        currentGroup = IDs(j);
        accumulateFvecs(end+1,:) = fvecs(j,:);
    elseif (j == numRows)
        % last observation
        accumulateFvecs(end+1,:) = fvecs(j,:);
        groupCentroids(end+1,:) = mean(accumulateFvecs);
    elseif (IDs(j) == currentGroup)
        accumulateFvecs(end+1,:) = fvecs(j,:);
    elseif (IDs(j) ~= currentGroup)
        % first calculate centroid for the previous group
        groupCentroids(end+1,:) = mean(accumulateFvecs);
        currentGroup = IDs(j);    
        accumulateFvecs = fvecs(j,:);
    end
end

for j=1:numRows
    % make centroid matrices
    totCentroidMatrix(j,:) = totCentroid;
    groupCentroidMatrix(j,:) = groupCentroids(IDs(j),:);
end

% Calculate SSTot
SSTot = (fvecs - totCentroidMatrix); 
SSTot = SSTot * SSTot';
SSTot = trace(SSTot);
%fprintf('First calculation of SSTot is %.15f\n',SSTot);

%Calculate SSTrt
SSTrt = (groupCentroidMatrix - totCentroidMatrix);
SSTrt = SSTrt * SSTrt';
SSTrt = trace(SSTrt);
%fprintf('First calculation of SSTrt is %.15f\n',SSTrt);

%Calculate SSError
SSError = fvecs - groupCentroidMatrix;
SSError = SSError * SSError';
SSError = trace(SSError);
%fprintf('First calculation of SSError is %.15f\n',SSError);
end
