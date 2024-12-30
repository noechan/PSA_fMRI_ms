function SPM_prepro_wrapper(subjects, outdir, varargin)
%SPM_PREPRO_WRAPPER
%
% INPUT
%   subjects
%   outdir
% VARARGIN
%   'prep_steps'     numeric, numbers of the preprocessing steps to call,
%                    default = [1 4 6 7]
%
% CALLS SPM1_Realignment(), SPM2_Reorient(), SPM6_Normalize(), SPM7_Smoothing()
%------------------------------------------------------------------------


%% Initialise inputs
pp = [6];
p = inputParser;
p.addRequired('subjects', @isstruct)
p.addRequired('outdir', @ischar)

% TODO : MATCH BIDS SPECIFICATION FOR FILE STORAGE LOCATIONS
p.addParameter('funcdir', 'func', @ischar)
p.addParameter('anatdir', 'anat', @ischar)
p.addParameter('ses','ses-001', @ischar)
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('prepdir', 'SPM_prepro', @ischar)
p.addParameter('prep_steps', pp, @(x) isnumeric(x) || iscellstr(x))

p.parse(subjects, outdir, varargin{:})
Arg = p.Results;

%% Loop to copy raw_data to derivatives folder per subject
for sbji = 1:size(subjects, 1)
%     sub_path_func_rw = fullfile(subjects(sbji).folder, subjects(sbji).name, Arg.ses,Arg.funcdir);
%     sub_path_anat_rw = fullfile(subjects(sbji).folder, subjects(sbji).name, Arg.ses,Arg.anatdir);
%     sub_path_func_der = fullfile(subjects(sbji).folder, subjects(sbji).name, Arg.ses,Arg.derdir, Arg.prepdir, Arg.funcdir);
%     sub_path_anat_der = fullfile(subjects(sbji).folder, subjects(sbji).name, Arg.ses,Arg.derdir, Arg.prepdir, Arg.anatdir);
%     
%     %Unzip func & anat scans
%     gunzip(fullfile(sub_path_func_rw,'sub*.nii.gz'))
%     gunzip(fullfile(sub_path_anat_rw,'sub*.nii.gz'))
%     
%     srcfile_func= dir(...
%         fullfile(sub_path_func_rw, 'sub*.nii'));
%     
    %         % Copy func scans
    %         if ~isfolder(sub_path_func_der)
    %             mkdir(sub_path_func_der)
    %         end
    %         for sf = 1:length(srcfile_func)
    %             if ~exist(fullfile(sub_path_func_der, srcfile_func(sf).name), 'file')
    %                 copyfile(fullfile(srcfile_func(sf).folder, srcfile_func(sf).name), sub_path_func_der)
    %             end
    %         end
    %         [srcfile_func.folder] = deal(sub_path_func_der);
    %         subjects(sbji).sourcesfunc = srcfile_func;
    
    
    % Copy lesion scans
    %     if strcmp(Arg.ses,'ses-002') || strcmp(Arg.ses,'ses-003')
    %         if ~strcmp(subjects(sbji).name,'sub-24') && ~strcmp(subjects(sbji).name,'sub-31') && ~strcmp(subjects(sbji).name,'sub-32') && ~strcmp(subjects(sbji).name,'sub-33') && ~strcmp(subjects(sbji).name,'sub-35')
    %             lesf=dir(fullfile(subjects(sbji).folder, subjects(sbji).name,'ses-001','anat','*roLESION*.nii'));
    %             if ~exist(fullfile(sub_path_anat_rw,lesf.name))
    %                 copyfile(fullfile(subjects(sbji).folder, subjects(sbji).name,'ses-001','anat',lesf.name), sub_path_anat_rw)
    %             end
    %         end
    %     end
    %
    % Copy anat scans
    %     srcfile_anat = dir(...
    %         fullfile(sub_path_anat_rw, 'sub*.nii'));
    %
    %     if ~isfolder(sub_path_anat_der)
    %         mkdir(sub_path_anat_der)
    %     end
    %
    %     for sf = 1:length(srcfile_anat)
    %         if ~exist(fullfile(sub_path_anat_der, srcfile_anat(sf).name), 'file')
    %             copyfile(fullfile(srcfile_anat(sf).folder, srcfile_anat(sf).name), sub_path_anat_der)
    %         end
    %     end
    %     [srcfile_anat.folder] = deal(sub_path_anat_der);
    %     subjects(sbji).sourcesanat = srcfile_anat;
end


%----------------------------------------------------
% Initialise SPM
spm('Defaults', 'fMRI')
spm_jobman('initcfg')


%% Perform requested preprocessing steps
if iscellstr(Arg.prep_steps)
    preps = {'T1coregistration' 'realignment' 'reorient' 'coregistration' 'segment' 'normalize' 'smooth'};
    idx = startsWith(preps, Arg.prep_steps, 'IgnoreCase', true);
    Arg.prep_steps = pp(idx);
end
Arg.prep_steps = sort(Arg.prep_steps);
for i = 1:length(Arg.prep_steps)
    switch Arg.prep_steps(i)
        case 0
            SPM0_T1Coregistration(subjects)
        case 1
            SPM1_Realignment(subjects)
        case 2
            SPM2_Reorient(subjects)
        case 3
            SPM3_Coregistration(subjects)
        case 4
            SPM4_Segment(subjects)
        case 5
            SPM5_Normalize(subjects)
        case 6
            SPM6_Smoothing(subjects)
    end
end

%% Loop to remove raw_data from new per-subject folder
% for sbji = 1:size(subjects, 1)
%     for rawi = 1:length(subjects(sbji).sourcesfunc)
%         rwdt = fullfile(subjects(sbji).sourcesfunc(rawi).folder...
%                         , subjects(sbji).sourcesfunc(rawi).name);
%         if exist(rwdt, 'file'), delete(rwdt); end
%     end
% end

% for sbji = 1:size(subjects, 1)
%     for rawi = 1:length(subjects(sbji).sourcesanat)
%         rwdt = fullfile(subjects(sbji).sourcesanat(rawi).folder...
%                         , subjects(sbji).sourcesanat(rawi).name);
%         if exist(rwdt, 'file'), delete(rwdt); end
%     end
% end



