function SPM2_Reorient(subjects, varargin)

% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct);
p.addParameter('ses','ses-003', @ischar)
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('prepdir', 'SPM_prepro', @ischar)
p.addParameter('funcdir', 'func', @ischar)

p.parse(subjects, varargin{:});
Arg = p.Results;


%% Loop for subjects
for sbj = 1:size(subjects, 1)
    sub_path = fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses, Arg.derdir, Arg.prepdir, Arg.funcdir);
    
    mean_rEPI = dir (fullfile(sub_path,'*mean*.nii'));
    rEPI = dir (fullfile(sub_path,'*rsub*.nii'));
    for r=1:size(rEPI,1)
        if contains(rEPI(r).name,'tydyy')
            rEPI_tydyy=rEPI(r);
        elseif contains(rEPI(r).name,'uulaa')
            rEPI_uulaa=rEPI(r);
        end
    end
    matrix = load(fullfile(sub_path, 'reorient.mat'));
    
    clear matlabbatch
    % Reorient images to AC
    matlabbatch{1}.spm.util.reorient.srcfiles = cellstr(fullfile(sub_path,mean_rEPI.name));
    matlabbatch{1}.spm.util.reorient.transform.transM = matrix.M;
    matlabbatch{1}.spm.util.reorient.prefix = 'ro';
    matlabbatch{2}.spm.util.reorient.srcfiles = cellstr([fullfile(sub_path,rEPI_tydyy.name) ',1']);
    matlabbatch{2}.spm.util.reorient.transform.transM = matrix.M;
    matlabbatch{2}.spm.util.reorient.prefix = 'ro';
    matlabbatch{3}.spm.util.reorient.srcfiles = cellstr([fullfile(sub_path,rEPI_uulaa.name) ',1']);
    matlabbatch{3}.spm.util.reorient.transform.transM = matrix.M;
    matlabbatch{3}.spm.util.reorient.prefix = 'ro';
    
    spm_jobman('run', matlabbatch)
    
end
