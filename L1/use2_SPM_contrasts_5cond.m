clear all
addpath('/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/L1/')
code_path='/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/L1/';
data_path='/Volumes/LASA/Aphasia_project/tb-fMRI/data/LASA/';
load(fullfile(code_path, 'subjects_s1.mat')); load(fullfile(code_path, 'subjects_s2.mat')); load(fullfile(code_path, 'subjects_s3.mat')); 


%% Build group of subjects with 5 conditions in both tasks
% Session 1
c1=1; r1=1;
for sbjd= 1: size(subjects_s1,1)
        events_path1=fullfile(data_path, subjects_s1(sbjd).name, 'ses-001', 'derivatives','SPM_prepro','func','events');
        events_Tydyy=horzcat(subjects_s1(sbjd).name, '_ses-001_task-tydyy_acq-multiband_events.mat');
        cond_Tydyy_temp=load(fullfile(events_path1,events_Tydyy)); cond_Tydyy=numel(cond_Tydyy_temp.names); cond_Tydyy_sbj_ses1(1,c1)=cond_Tydyy;
        events_Uulaa=horzcat(subjects_s1(sbjd).name, '_ses-001_task-uulaa_acq-multiband_events.mat');
        cond_Uulaa_temp=load(fullfile(events_path1,events_Uulaa)); cond_Uulaa=numel(cond_Uulaa_temp.names); cond_Uulaa_sbj_ses1(1,c1)=cond_Uulaa;
        if cond_Tydyy==5 && cond_Uulaa==5
            subjects_s1_5cond(1,r1)=subjects_s1(sbjd);
            r1=r1+1;
        end
        c1=c1+1;
    end

% Session 2
c2=1; r2=1;
for sbjd= 1: size(subjects_s2,1)
        events_path1=fullfile(data_path, subjects_s2(sbjd).name, 'ses-002', 'derivatives','SPM_prepro','func','events');
        events_Tydyy=horzcat(subjects_s2(sbjd).name, '_ses-002_task-tydyy_acq-multiband_events.mat');
        cond_Tydyy_temp=load(fullfile(events_path1,events_Tydyy)); cond_Tydyy=numel(cond_Tydyy_temp.names); cond_Tydyy_sbj_ses2(1,c2)=cond_Tydyy;
        events_Uulaa=horzcat(subjects_s2(sbjd).name, '_ses-002_task-uulaa_acq-multiband_events.mat');
        cond_Uulaa_temp=load(fullfile(events_path1,events_Uulaa)); cond_Uulaa=numel(cond_Uulaa_temp.names); cond_Uulaa_sbj_ses2(1,c2)=cond_Uulaa;
        if cond_Tydyy==5 && cond_Uulaa==5
            subjects_s2_5cond(1,r2)=subjects_s2(sbjd);
            r2=r2+1;
        end
        c2=c2+1;
end

% Session 3
c3=1; r3=1;
for sbjd= 1: size(subjects_s3,1)
        events_path1=fullfile(data_path, subjects_s3(sbjd).name, 'ses-003', 'derivatives','SPM_prepro','func','events');
        events_Tydyy=horzcat(subjects_s3(sbjd).name, '_ses-003_task-tydyy_acq-multiband_events.mat');
        cond_Tydyy_temp=load(fullfile(events_path1,events_Tydyy)); cond_Tydyy=numel(cond_Tydyy_temp.names); cond_Tydyy_sbj_ses3(1,c3)=cond_Tydyy;
        events_Uulaa=horzcat(subjects_s3(sbjd).name, '_ses-003_task-uulaa_acq-multiband_events.mat');
        cond_Uulaa_temp=load(fullfile(events_path1,events_Uulaa)); cond_Uulaa=numel(cond_Uulaa_temp.names); cond_Uulaa_sbj_ses3(1,c3)=cond_Uulaa;
        if cond_Tydyy==5 && cond_Uulaa==5
            subjects_s3_5cond(1,r3)=subjects_s3(sbjd);
            r3=r3+1;
        end
        c3=c3+1;
    end

cd(code_path)
save('subjects_s1_5cond.mat', 'subjects_s1_5cond')
save('subjects_s2_5cond.mat', 'subjects_s2_5cond')
save('subjects_s3_5cond.mat', 'subjects_s3_5cond')
% Do contrasts
%C0_SPM_Contrasts_w_incorrect_trials_5cond(subjects_s2_5cond(14))

