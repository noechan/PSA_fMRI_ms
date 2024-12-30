function SPM_Model_specification(subjects, varargin)


%--------------------------------------------------------------------------
% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct)
p.addParameter('ses','ses-001', @ischar)
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('prepdir', 'SPM_prepro', @ischar)
p.addParameter('funcdir', 'func', @ischar)
p.addParameter('norm','normalize', @ischar)
p.addParameter('smo','smoothing', @ischar)
p.addParameter('eve', 'events',@ischar)
p.addParameter('art','art',@ischar)
p.addParameter('L1','SPM_first_level',@ischar)

p.parse(subjects, varargin{:});
Arg = p.Results;


%% Loop for subjects
for sbj = 1:numel(subjects)
    disp(sbj)
    sub_path = fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses, Arg.derdir);
    
    %Get smoothed scans
    sEPI_tydyy = dir (fullfile(sub_path, Arg.prepdir, Arg.funcdir, Arg.smo,'*task-tydyy*.nii'));
    sEPI_uulaa = dir (fullfile(sub_path,Arg.prepdir, Arg.funcdir, Arg.smo,'*task-uulaa*.nii'));
    
    for i=1:size(sEPI_tydyy)
        fname_sEPI_tydyy{i,1}=fullfile(sub_path, Arg.prepdir, Arg.funcdir, Arg.smo, sEPI_tydyy(i).name);
    end
    
    for j=1:size(sEPI_uulaa)
        fname_sEPI_uulaa{j,1}=fullfile(sub_path, Arg.prepdir, Arg.funcdir, Arg.smo, sEPI_uulaa(j).name);
    end
    
    % Get events
    mult_cond_Tydyy=dir (fullfile(sub_path, Arg.prepdir, Arg.funcdir, Arg.eve,'*tydyy*.mat'));
    mult_cond_Uulaa=dir (fullfile(sub_path, Arg.prepdir, Arg.funcdir, Arg.eve,'*uulaa*.mat'));
    %Get realignment and ART regressors
    rp_art_Tydyy=horzcat( 'art_regression_outliers_and_movement_wror',subjects(sbj).name, '_', Arg.ses, '_task-tydyy_acq-multiband_bold_00001.mat');
    rp_art_Uulaa=horzcat( 'art_regression_outliers_and_movement_wror',subjects(sbj).name, '_', Arg.ses,'_task-uulaa_acq-multiband_bold_00001.mat');
    
    
    %% Model specification
    matlabbatch{1}.spm.stats.fmri_spec.dir = {fullfile(sub_path, Arg.L1, 'L1_dur0_explbase_microres72_art_explmask_TU_missed')};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 9;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 72; %8 time bins/second (default) so TR*8=72
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;%SPM.T0 = (TA/2)/TR * SPM.T so (1.5/2)/9*72=6
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans =  fname_sEPI_tydyy;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = cellstr(fullfile(sub_path, Arg.prepdir, Arg.funcdir, Arg.eve, mult_cond_Tydyy.name));
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg =cellstr(fullfile(sub_path, Arg.prepdir, Arg.funcdir, Arg.norm, rp_art_Tydyy));
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans =fname_sEPI_uulaa;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = cellstr(fullfile(sub_path, Arg.prepdir, Arg.funcdir, Arg.eve, mult_cond_Uulaa.name));
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg =cellstr(fullfile(sub_path, Arg.prepdir, Arg.funcdir, Arg.norm, rp_art_Uulaa));
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.1;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {'/Users/noeliamartinezmolina/spm12/tpm/tpm_grey_thr15.nii,1'};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'none';
    
       %% Model estimation
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

    
    spm_jobman('interactive', matlabbatch);
    clear matlabbatch
    
end


