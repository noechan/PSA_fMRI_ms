function SPM1_Realignment(subjects, varargin)

% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct)
p.addParameter('ses','ses-003', @ischar)
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('prepdir', 'SPM_prepro', @ischar)
p.addParameter('funcdir', 'func', @ischar)

p.parse(subjects, varargin{:});
Arg = p.Results;


%% Loop for subjects
for sbj = 1:size(subjects, 1)
    sub_path = fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses, Arg.derdir, Arg.prepdir, Arg.funcdir);
        
        EPI_tyddy = dir (fullfile(sub_path,'*task-tydyy*.nii'));
        EPI_uulaa = dir (fullfile(sub_path,'*task-uulaa*.nii'));
        
        % Spatial realignment
        matlabbatch{1}.spm.spatial.realign.estwrite.data = {
            cellstr(fullfile(sub_path,EPI_tyddy.name))
            cellstr(fullfile(sub_path,EPI_uulaa.name))
            }';
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
        
        spm_jobman('run', matlabbatch);
        clear matlabbatch
        ps_file=['spm_',datestr(now, 'yyyymmmdd'),'.ps'];
        if ~exist(fullfile(sub_path,ps_file))
            copyfile(fullfile(pwd,ps_file),fullfile(sub_path,ps_file))
            if exist(fullfile(pwd, ps_file)), delete(fullfile(pwd,ps_file)); end
        end   
end


