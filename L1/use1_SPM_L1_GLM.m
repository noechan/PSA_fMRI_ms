clear all
%% Initialise inputs, pathnames
rawdir = '/Volumes/LASA/Aphasia_project/tb-fMRI/data/LASA/';
code_path='/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/L1/';
addpath('/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/utils/')
subjects = build_dataset((rawdir));
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
cd(code_path)
save('subjects_s1.mat', 'subjects_s1')
save('subjects_s2.mat', 'subjects_s2')
save('subjects_s3.mat', 'subjects_s3')
%Call SPM function for model estimation & specification
%SPM_Model_spec_est(subjects_s3)

