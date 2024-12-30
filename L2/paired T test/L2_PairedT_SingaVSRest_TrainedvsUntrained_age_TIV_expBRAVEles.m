function L2_PairedT_SingaVSRest_TrainedvsUntrained_age_TIV_expBRAVEles(subjects, outdir, varargin)
%L2_PairedT_LisVsRest_TU
%----------------------------------------------------------------------------------------
% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct);
p.addRequired('outdir', @ischar);
p.addParameter('datadir', '/Volumes/LASA/Aphasia_project/tb-fMRI/results/post-pre_diff_images/', @ischar)
p.addParameter('TU_folder', 'TU', @ischar)
p.addParameter('Tydyy_folder', 'Tydyy', @ischar)
p.addParameter('Uulaa_folder', 'Uulaa', @ischar)
p.addParameter('contrast_folder', 'Sing_along>Baseline', @ischar)
p.addParameter('L2folder', 'singa_vs_rest_TrainedvsUntrained_Age_TIV_wo_motion_outliers_wo_14_expmaskBRAVE_les', @ischar)

p.parse(subjects, outdir, varargin{:});
Arg = p.Results;
 
%% Model specification    
matlabbatch{1}.spm.stats.factorial_design.dir = {fullfile(outdir, Arg.L2folder)};
%Select pair of scans for each group
n=1; a=1;
for sbj = 1:size(subjects, 1)
    disp(subjects(sbj).name)
    if subjects(sbj).group==1 % Trained Song Uulaa;
        postvspre_trained{sbj,1}=spm_select('List', fullfile(Arg.datadir,Arg.Uulaa_folder,Arg.contrast_folder),['^Sing_along>baseline_Uulaa_Post>Pre_' subjects(sbj).name '.*\.nii$']);
        postvspre_trained_fnames{sbj,1}=fullfile(Arg.datadir,Arg.Uulaa_folder,Arg.contrast_folder,postvspre_trained{sbj,1});
        postvspre_untrained{sbj,1}=spm_select('List', fullfile(Arg.datadir,Arg.Tydyy_folder,Arg.contrast_folder),['^Sing_along>baseline_Tydyy_Post>Pre_' subjects(sbj).name '.*\.nii$']);
        postvspre_untrained_fnames{sbj,1}=fullfile(Arg.datadir,Arg.Tydyy_folder,Arg.contrast_folder,postvspre_untrained{sbj,1});
    elseif subjects(sbj).group==2 % Trained Song Tydyy
        postvspre_trained{sbj,1}=spm_select('List', fullfile(Arg.datadir,Arg.Tydyy_folder,Arg.contrast_folder),['^Sing_along>baseline_Tydyy_Post>Pre_' subjects(sbj).name '.*\.nii$']);
        postvspre_trained_fnames{sbj,1}=fullfile(Arg.datadir,Arg.Tydyy_folder,Arg.contrast_folder,postvspre_trained{sbj,1});
        postvspre_untrained{sbj,1}=spm_select('List', fullfile(Arg.datadir,Arg.Uulaa_folder,Arg.contrast_folder),['^Sing_along>baseline_Uulaa_Post>Pre_' subjects(sbj).name '.*\.nii$']);
        postvspre_untrained_fnames{sbj,1}=fullfile(Arg.datadir,Arg.Uulaa_folder,Arg.contrast_folder,postvspre_untrained{sbj,1});
    end
    if ~isempty(postvspre_trained{sbj,1}) && ~isempty(postvspre_untrained{sbj,1})
        matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(n).scans = vertcat(postvspre_trained_fnames(sbj,1), postvspre_untrained_fnames(sbj,1));
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
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Sing along vs Rest Trained vs Untrained AB/BA';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Sing along vs Rest Untrained vs Trained AB/BA';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
spm_jobman('interactive', matlabbatch)