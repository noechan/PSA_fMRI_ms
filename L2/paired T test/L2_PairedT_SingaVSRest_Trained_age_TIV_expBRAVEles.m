function L2_PairedT_SingaVSRest_Trained_age(subjects, outdir, varargin)
%L2_PairedT_LisVsRest_TU
%----------------------------------------------------------------------------------------
% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct);
p.addRequired('outdir', @ischar);
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('L1dir', 'SPM_first_level', @ischar)
p.addParameter('L1folder', 'L1_dur0_explbase_microres72_art_explmask_TU_missed', @ischar)
p.addParameter('L2folder', 'singa_vs_rest_Trained_Age_TIV_wo_motion_outliers_wo_14_expBRAVEles', @ischar)

p.parse(subjects, outdir, varargin{:});
Arg = p.Results;
 
%% Model specification    
matlabbatch{1}.spm.stats.factorial_design.dir = {fullfile(outdir, Arg.L2folder)};
%Select pair of scans for each group
n=1; a=1;
for sbj = 1:size(subjects, 1)
    disp(subjects(sbj).name)
    if subjects(sbj).group==1 % Trained Song Uulaa
        ses_pre='ses-001'; ses_post='ses-002';
        sub_path_pre= fullfile(subjects(sbj).folder, subjects(sbj).name, ses_pre, Arg.derdir,Arg.L1dir, Arg.L1folder);
        cd(sub_path_pre), load('SPM.mat')
        con_idx_pre=find(ismember({SPM.xCon.name}, {'Sing_along>baseline Uulaa'}));
        if ~isempty(con_idx_pre)
            if con_idx_pre >9
                con_pre{sbj,1}=spm_select('List', fullfile(sub_path_pre),['^con_00' num2str(con_idx_pre) '.*\.nii$']);
            elseif con_idx_pre <10
                con_pre{sbj,1}=spm_select('List', fullfile(sub_path_pre),['^con_000' num2str(con_idx_pre) '.*\.nii$']);
            end
            con_fnames_pre{sbj,1}=fullfile(sub_path_pre, con_pre{sbj,1});
        end
        clear SPM
        sub_path_post= fullfile(subjects(sbj).folder, subjects(sbj).name, ses_post, Arg.derdir,Arg.L1dir, Arg.L1folder);
        cd(sub_path_post)
        load('SPM.mat')
        con_idx_post=find(ismember({SPM.xCon.name}, {'Sing_along>baseline Uulaa'}));
        if ~isempty(con_idx_post)
            if con_idx_post >9
                con_post{sbj,1}=spm_select('List', fullfile(sub_path_post),['^con_00' num2str(con_idx_post) '.*\.nii$']);
            elseif con_idx_post <10
                con_post{sbj,1}=spm_select('List', fullfile(sub_path_post),['^con_000' num2str(con_idx_post) '.*\.nii$']);
            end
            con_fnames_post{sbj,1}=fullfile(sub_path_post, con_post{sbj,1});
        end
        clear SPM
    elseif subjects(sbj).group==2 % Trained Song Tydyy
        ses_pre='ses-002'; ses_post='ses-003';
        sub_path_pre= fullfile(subjects(sbj).folder, subjects(sbj).name, ses_pre, Arg.derdir,Arg.L1dir, Arg.L1folder);
        cd(sub_path_pre), load('SPM.mat')
        con_idx_pre=find(ismember({SPM.xCon.name}, {'Sing_along>baseline Tydyy'}));
        if ~isempty(con_idx_pre)
            if con_idx_pre >9
                con_pre{sbj,1}=spm_select('List', fullfile(sub_path_pre),['^con_00' num2str(con_idx_pre) '.*\.nii$']);
            elseif ~isempty(con_idx_pre) && con_idx_pre <10
                con_pre{sbj,1}=spm_select('List', fullfile(sub_path_pre),['^con_000' num2str(con_idx_pre) '.*\.nii$']);
            end
            con_fnames_pre{sbj,1}=fullfile(sub_path_pre, con_pre{sbj,1});
        end
        clear SPM
        sub_path_post= fullfile(subjects(sbj).folder, subjects(sbj).name, ses_post, Arg.derdir,Arg.L1dir, Arg.L1folder);
        cd (sub_path_post), load('SPM.mat')
        con_idx_post=find(ismember({SPM.xCon.name}, {'Sing_along>baseline Tydyy'}));
        if ~isempty(con_idx_post)
            if con_idx_post >9
                con_post{sbj,1}=spm_select('List', fullfile(sub_path_post),['^con_00' num2str(con_idx_post) '.*\.nii$']);
            elseif con_idx_post <10
                con_post{sbj,1}=spm_select('List', fullfile(sub_path_post),['^con_000' num2str(con_idx_post) '.*\.nii$']);
            end
            con_fnames_post{sbj,1}=fullfile(sub_path_post, con_post{sbj,1});
        end
        clear SPM
    end
    
    if ~isempty(con_idx_pre) && ~isempty(con_idx_post)
        matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(n).scans = vertcat(con_fnames_pre(sbj,1), con_fnames_post(sbj,1));
        n=n+1;
    else
        idx_cov(a,1)=sbj;
        exclude_sbj{a,1}= subjects(sbj).name;
        a=a+1;
    end
end

matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;


% Input covariates:
if exist('idx_cov'), subjects(idx_cov)=[]; end
age_pairs= [subjects(:).age]; age_pairs(2,:)=age_pairs(1,:); age_pairs=reshape(age_pairs,numel(age_pairs),1);
TIV_pairs= [subjects(:).TIV]; TIV_pairs(2,:)=TIV_pairs(1,:); TIV_pairs=reshape(TIV_pairs,numel(TIV_pairs),1);
Lesion_pairs= [subjects(:).Lesion_size]; Lesion_pairs(2,:)=Lesion_pairs(1,:); Lesion_pairs=reshape(Lesion_pairs,numel(Lesion_pairs),1);
matlabbatch{1}.spm.stats.factorial_design.cov(1).c = age_pairs;
matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'Age';
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).c = TIV_pairs;
matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'TIV';
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(3).c = Lesion_pairs;
matlabbatch{1}.spm.stats.factorial_design.cov(3).cname = 'Lesion';
matlabbatch{1}.spm.stats.factorial_design.cov(3).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(3).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {'/Volumes/LASA/Aphasia_project/tb-fMRI/results/masks/BRAVE_masks/Sing_along-baseline_unc_p0-001_k248.nii,1'};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

%% Model estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%% Contrast specification
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Sing along vs Rest Trained AB/BA Pre vs Post';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Sing along vs Rest Trained AB/BA Post vs Pre';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
spm_jobman('interactive', matlabbatch)