function SPM_Contrasts(subjects, varargin)


%--------------------------------------------------------------------------
% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct)
p.addParameter('ses','ses-001', @ischar)
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('prepdir', 'SPM_prepro', @ischar)
p.addParameter('funcdir', 'func', @ischar)
p.addParameter('normdir', 'normalize', @ischar)
p.addParameter('art','art',@ischar)
p.addParameter('L1_parent','SPM_first_level',@ischar)
p.addParameter('L1','L1_dur0_explbase_microres72_art_explmask_TU_missed',@ischar)

p.parse(subjects, varargin{:});
Arg = p.Results;


%% Loop for subjects
for sbj = 1:size(subjects, 1)
    disp(sbj)
    sub_path = fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses, Arg.derdir);
    
    %Get SPM.mat
    SPM= dir (fullfile(sub_path, Arg.L1_parent, Arg.L1,'SPM.mat'));
    
    % Get number of motion outliers per session and subject
    rp_art_Tydyy=horzcat( 'art_regression_outliers_and_movement_wror',subjects(sbj).name, '_', Arg.ses, '_task-tydyy_acq-multiband_bold_00001.mat');
    rp_art_Uulaa=horzcat( 'art_regression_outliers_and_movement_wror',subjects(sbj).name, '_', Arg.ses,'_task-uulaa_acq-multiband_bold_00001.mat');
    
    rp_art_Tydyy_path=fullfile(sub_path, Arg.derdir, Arg.prepdir, Arg.funcdir, Arg.normdir);
    art_Tydyy_temp=load(fullfile(rp_art_Tydyy_path, rp_art_Tydyy)); outliers_Tydyy=size(art_Tydyy_temp.R,2);
    
    rp_art_Uulaa_path=fullfile(sub_path, Arg.derdir, Arg.prepdir, Arg.funcdir, Arg.normdir);
    art_Uulaa_temp=load(fullfile(rp_art_Tydyy_path, rp_art_Tydyy)); outliers_Uulaa=size(art_Tydyy_temp.R,2);
    
    % Specify contrasts weights
        matlabbatch{1}.spm.stats.con.spmmat(1) = cfg_dep(SPM, substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
  
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Listen>sing_along';
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 -1 0 0 zeros(1,outliers_Tydyy) 1 -1 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Listen>sing_mem';
        matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [1 0 -1 0 zeros(1,outliers_Tydyy) 1 0 -1 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Sing_along> sing_mem';
        matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 1 -1 0 zeros(1,outliers_Tydyy) 0 1 -1 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Sing_mem>sing_along';
        matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 -1 1 0 zeros(1,outliers_Tydyy) 0 -1 1 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Sing_along>listen';
        matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [-1 1 0 0 zeros(1,outliers_Tydyy) -1 1 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'Sing_mem>listen';
        matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [-1 0 1 0 zeros(1,outliers_Tydyy) -1 0 1 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'Listen>baseline';
        matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = [1 0 0 -1 zeros(1,outliers_Tydyy) 1 0 0 -1 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'Sing_along>baseline';
        matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = [0 1 0 -1 zeros(1,outliers_Tydyy) 0 1 0 -1 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'Sing_mem>baseline';
        matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = [0 0 1 -1 zeros(1,outliers_Tydyy) 0 0 1 -1 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';

        
        matlabbatch{1}.spm.stats.con.delete = 0;     
        

    
    spm_jobman('interactive', matlabbatch);
    clear matlabbatch
    
end