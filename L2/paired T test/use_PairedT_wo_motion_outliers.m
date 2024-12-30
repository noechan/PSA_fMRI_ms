clear all
 %% Initialise inputs, pathnames 
rawdir = '/Volumes/LASA/Aphasia_project/tb-fMRI/data/LASA/';
code_path='/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/L2/paired T test/';
addpath('/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/utils/')
subjects = build_dataset((rawdir));
outdir = '/Volumes/LASA/Aphasia_project/tb-fMRI/results/paired T test/';
 %% Build datasets for multiple sessions
s1=1;s2=1;s3=1;
for sbji =1:size(subjects, 1)
    sub_path=fullfile(subjects(sbji).folder, subjects(sbji).name);
    ses=dirflt(sub_path);
    if numel(ses)==3
        if ismember({ses(1).name}, {'ses-001'})
            Idx_s1(s1,1)=sbji; 
            s1=s1+1;
        end
        if ismember({ses(2).name}, {'ses-002'})
            Idx_s2(s2,1)=sbji; 
            s2=s2+1;
        end
        if ismember({ses(3).name}, {'ses-003'})
            Idx_s3(s3,1)=sbji; 
            s3=s3+1;
        end
    end  
end
   
%Subjects with all fMRI session scans
subjects_s1=subjects(Idx_s1); subjects_s2=subjects(Idx_s2); subjects_s3=subjects(Idx_s3);
% Remove motion outliers
idx_motion_outliers=find(ismember({subjects_s1.name},{'sub-03','sub-14','sub-19','sub-27','sub-28'})); %original BIDS ID code of motion outliers
subjects_s1(idx_motion_outliers)=[];
subjects_s2(idx_motion_outliers)=[];
subjects_s3(idx_motion_outliers)=[];
%Remove sub-17(technical issue with recordings in ses-003)
subjects_s1(ismember({subjects_s1.name}, {'sub-17'})) = [];
subjects_s2(ismember({subjects_s2.name}, {'sub-17'})) = [];
subjects_s3(ismember({subjects_s3.name}, {'sub-17'})) = [];

% Load group file and add covariates to dataset
cd(code_path);
LASA_cov= readtable('LASA_group_BIDS_wo_motion_outliers_cov.csv');
group=num2cell(LASA_cov.Group); age=num2cell(LASA_cov.Age); TIV=num2cell(LASA_cov.TIV); BDEA=num2cell(LASA_cov.BDAE_severity_1); WAB_AQ=num2cell(LASA_cov.WAB_AQ_original_1); Lesion_size=num2cell(LASA_cov.Lesionsize_ac_cm3);
[subjects_s3.group] =group{:}; [subjects_s3.age] =age{:}; [subjects_s3.TIV] =TIV{:}; [subjects_s3.BDEA] =BDEA{:}; [subjects_s3.WAB_AQ] =WAB_AQ{:}; [subjects_s3.Lesion_size] =Lesion_size{:};

% Do second-level
L2_PairedT_SingaVSRest_Trained_age_TIV_expBRAVEles(subjects_s3,outdir)
L2_PairedT_SingaVSRest_TrainedvsUntrained_age_TIV_expBRAVEles(subjects_s3,outdir)

