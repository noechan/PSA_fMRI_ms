function SPM0_T1Coregistration(subjects, varargin)

% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct);
p.addParameter('ses1','ses-001', @ischar)
p.addParameter('sesx','ses-002', @ischar)
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('prepdir', 'SPM_prepro', @ischar)
p.addParameter('anatdir', 'anat', @ischar)

p.parse(subjects, varargin{:});
Arg = p.Results;

for sbj = 1:size(subjects, 1)
    disp(sbj)
    sub_path= fullfile(subjects(sbj).folder, subjects(sbj).name);
    
    roT1s1 = spm_select('FPList', fullfile(sub_path, Arg.ses1, Arg.anatdir), '^*roT1w.*\.nii$');
    [filepath,roT1s1name,ext]=fileparts(roT1s1);
    roT1sx = spm_select('FPList', fullfile(sub_path, Arg.sesx,  Arg.derdir, Arg.prepdir, Arg.anatdir), '^*roT1w.*\.nii$');
    
    clear matlabbatch
    %% Coregistration
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {fullfile(sub_path, Arg.ses1, Arg.derdir, Arg.prepdir, Arg.anatdir,[roT1s1name ext ',1'])};
    matlabbatch{1}.spm.spatial.coreg.estwrite.source ={[roT1sx ',1']};
    matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'ncc'; %within modality: normalised cross correlation
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'ses1cr';  
    
    
    spm_jobman('run',matlabbatch)
    
    ps_file=['spm_',datestr(now, 'yyyymmmdd'),'.ps'];
    if ~exist(fullfile(sub_path, Arg.sesx, Arg.derdir, Arg.prepdir, Arg.anatdir,ps_file))
        copyfile(fullfile(pwd,ps_file),fullfile(sub_path, Arg.sesx, Arg.derdir, Arg.prepdir, Arg.anatdir,['T1ses1cr' ps_file] ))
        if exist(fullfile(pwd, ps_file)),delete(fullfile(pwd,ps_file)); end
    end
    
end
