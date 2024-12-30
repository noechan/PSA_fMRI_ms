clear con con_fnames
%% Specify paths and list subjects
input_path='/Volumes/LASA/Aphasia_project/tb-fMRI/data/raw_data_BRAVE/'; %Path for L1
code_path='/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/L2/one sample T test BRAVE/'; %Path for code
L2_path='/Volumes/LASA/Aphasia_project/tb-fMRI/results/one sample T test BRAVE/'; %Path to save the analysis
cd(input_path)
subnames= dir('sub*');
der='derivatives';
L1='SPM_first_level';
L1_folder='L1_LASA-BRAVE_8mm_20210524_art_z4_mdiff3';
L2_folder='BRAVE_singa_vs_rest_N30_Age_TIV';
 % Get nuisance covariates
cd(code_path)
BRAVE_cov= readtable('BRAVE_BIDS.csv');
age=BRAVE_cov.Age'; TIV=BRAVE_cov.TIV';
%% Prepare inputs
n=1;
for sbj = 1:size(subnames, 1)
    disp(subnames(sbj).name)
    sub_path= fullfile(subnames(sbj).folder, subnames(sbj).name,der,L1,L1_folder);
    cd(sub_path), load('SPM.mat')
    con_idx=find(ismember({SPM.xCon.name}, {'Sing_along>baseline'}));
    if ~isempty(con_idx)
        if con_idx>9
            con{n,1}=spm_select('List', fullfile(sub_path),['^con_00' num2str(con_idx) '.*\.nii$']);
        elseif con_idx <10
            con{n,1}=spm_select('List', fullfile(sub_path),['^con_000' num2str(con_idx) '.*\.nii$']);
        end
        con_fnames{n,1}=fullfile(sub_path, con{n,1});
        n=n+1;
    end
    clear SPM
end
    
%% Model specification    
matlabbatch{1}.spm.stats.factorial_design.dir = {fullfile(L2_path,L2_folder)};
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = con_fnames;
matlabbatch{1}.spm.stats.factorial_design.cov(1).c = age;
matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'Age';
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).c = TIV;
matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'TIV';
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {'/Users/noeliamartinezmolina/spm12/tpm/tpm_grey_thr15.nii,1'};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

%% Model estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%% Contrast specification
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Sing along vs Rest';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
spm_jobman('interactive', matlabbatch)