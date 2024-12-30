function SPM_Contrasts_w_incorrect_trials_5cond(subjects, varargin)


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
for sbj = 1:numel(subjects)
    disp(sbj)
    sub_path = fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses, Arg.derdir);
    
    %Get SPM
    SPM_path= fullfile(sub_path, Arg.L1_parent, Arg.L1,'SPM.mat');
    
    % Get number of motion outliers per session and subject
    rp_art_Tydyy=horzcat( 'art_regression_outliers_and_movement_wror',subjects(sbj).name, '_', Arg.ses, '_task-tydyy_acq-multiband_bold_00001.mat');
    rp_art_Uulaa=horzcat( 'art_regression_outliers_and_movement_wror',subjects(sbj).name, '_', Arg.ses,'_task-uulaa_acq-multiband_bold_00001.mat');
    
    rp_art_Tydyy_path=fullfile(sub_path, Arg.prepdir, Arg.funcdir, Arg.normdir);
    art_Tydyy_temp=load(fullfile(rp_art_Tydyy_path, rp_art_Tydyy)); outliers_Tydyy=size(art_Tydyy_temp.R,2);
    
    rp_art_Uulaa_path=fullfile(sub_path, Arg.prepdir, Arg.funcdir, Arg.normdir);
    art_Uulaa_temp=load(fullfile(rp_art_Uulaa_path, rp_art_Uulaa)); outliers_Uulaa=size(art_Uulaa_temp.R,2);
    
    % Specify contrasts weights
        matlabbatch{1}.spm.stats.con.spmmat = {SPM_path};
  
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Listen>sing_along';
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 -1 0 0 zeros(1,outliers_Tydyy) 1 -1 0 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Listen>sing_mem';
        matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) 1 0 -1 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Sing_along> sing_mem';
        matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) 0 1 -1 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Sing_mem>sing_along';
        matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) 0 -1 1 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Sing_along>listen';
        matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [-1 1 0 0 zeros(1,outliers_Tydyy) -1 1 0 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'Sing_mem>listen';
        matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) -1 0 1 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'Listen>baseline';
        matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = [1 0 -1 0 zeros(1,outliers_Tydyy) 1 0 0 -1 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'Sing_along>baseline';
        matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = [0 1 -1 0 zeros(1,outliers_Tydyy) 0 1 0 -1 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'Sing_mem>baseline';
        matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) 0 0 1 -1 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'Listen>sing_along Tydyy';
        matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = [1 -1 0 0 zeros(1,outliers_Tydyy) 0 0 0 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'Sing_along>listen Tydyy';
        matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = [-1 1 0 0 zeros(1,outliers_Tydyy) 0 0 0 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'Listen>baseline Tydyy';
        matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = [1 0 -1 0 zeros(1,outliers_Tydyy) 0 0 0 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'Sing_along>baseline Tydyy';
        matlabbatch{1}.spm.stats.con.consess{13}.tcon.weights = [0 1 -1 0 zeros(1,outliers_Tydyy) 0 0 0 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{14}.tcon.name = 'Listen>sing_along Uulaa';
        matlabbatch{1}.spm.stats.con.consess{14}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) 1 -1 0 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{15}.tcon.name = 'Listen>sing_mem Uulaa';
        matlabbatch{1}.spm.stats.con.consess{15}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) 1 0 -1 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{16}.tcon.name = 'Sing_along> sing_mem Uulaa';
        matlabbatch{1}.spm.stats.con.consess{16}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) 0 1 -1 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{17}.tcon.name = 'Sing_mem>sing_along Uulaa';
        matlabbatch{1}.spm.stats.con.consess{17}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) 0 -1 1 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{17}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{18}.tcon.name = 'Sing_along>listen Uulaa';
        matlabbatch{1}.spm.stats.con.consess{18}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) -1 1 0 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{19}.tcon.name = 'Sing_mem>listen Uulaa';
        matlabbatch{1}.spm.stats.con.consess{19}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) -1 0 1 0 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{19}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{20}.tcon.name = 'Listen>baseline Uulaa';
        matlabbatch{1}.spm.stats.con.consess{20}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) 1 0 0 -1 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{20}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{21}.tcon.name = 'Sing_along>baseline Uulaa';
        matlabbatch{1}.spm.stats.con.consess{21}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) 0 1 0 -1 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{21}.tcon.sessrep = 'none';
        
        matlabbatch{1}.spm.stats.con.consess{22}.tcon.name = 'Sing_mem>baseline Uulaa';
        matlabbatch{1}.spm.stats.con.consess{22}.tcon.weights = [0 0 0 0 zeros(1,outliers_Tydyy) 0 0 1 -1 0 zeros(1,outliers_Uulaa)];
        matlabbatch{1}.spm.stats.con.consess{22}.tcon.sessrep = 'none';
        
        
        matlabbatch{1}.spm.stats.con.delete = 0;     
        

    
    spm_jobman('run', matlabbatch);
    clear matlabbatch
    
end