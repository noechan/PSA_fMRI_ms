function SPM3_Coregistration(subjects, varargin)

% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct);
p.addParameter('ses','ses-001', @ischar)
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('prepdir', 'SPM_prepro', @ischar)
p.addParameter('funcdir', 'func', @ischar)
p.addParameter('anatdir', 'anat', @ischar)

p.parse(subjects, varargin{:});
Arg = p.Results;

for sbj = 1:size(subjects, 1)
    disp(sbj)
    sub_path= fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses, Arg.derdir, Arg.prepdir);
    
    romeanEPI = spm_select('FPList', fullfile(sub_path, Arg.funcdir), '^romean.*\.nii$');
    roT1 = spm_select('FPList', fullfile(sub_path, Arg.anatdir), '^*roT1w.*\.nii$');
    
    if ~strcmp(subjects(sbj).name,'sub-24') && ~strcmp(subjects(sbj).name,'sub-31') && ~strcmp(subjects(sbj).name,'sub-32') && ~strcmp(subjects(sbj).name,'sub-33') && ~strcmp(subjects(sbj).name,'sub-35')
        roLESION = spm_select('FPList', fullfile(sub_path, Arg.anatdir), '^*roLESION.*\.nii$');
        
        clear matlabbatch
        %% Coregistration
        matlabbatch{1}.spm.spatial.coreg.estimate.ref = {romeanEPI};
        matlabbatch{1}.spm.spatial.coreg.estimate.source = {roT1};
        matlabbatch{1}.spm.spatial.coreg.estimate.other = {roLESION};
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
        
    else
        clear matlabbatch
        %% Coregistration
        matlabbatch{1}.spm.spatial.coreg.estimate.ref = {romeanEPI};
        matlabbatch{1}.spm.spatial.coreg.estimate.source = {roT1};
        matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    end
    
    spm_jobman('run',matlabbatch)
    
    ps_file=['spm_',datestr(now, 'yyyymmmdd'),'.ps'];
    if ~exist(fullfile(sub_path, Arg.anatdir,ps_file))
        copyfile(fullfile(pwd,ps_file),fullfile(sub_path, Arg.anatdir,['coreg' ps_file]))
        if exist(fullfile(pwd, ps_file)),delete(fullfile(pwd,ps_file)); end
    end
    
end
