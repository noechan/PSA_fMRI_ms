%% Find patients with different number of trials
clear all
addpath('/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/L1/')
code_path='/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/L1/';
load(fullfile(code_path, 'subjects_s1_5cond.mat')); load(fullfile(code_path, 'subjects_s2_5cond.mat')); load(fullfile(code_path, 'subjects_s3_5cond.mat')); 
load(fullfile(code_path, 'subjects_s1.mat')); load(fullfile(code_path, 'subjects_s2.mat')); load(fullfile(code_path, 'subjects_s3.mat')); 

T_subjects_s1=struct2table(subjects_s1);
T_subjects_s1_5cond=struct2table(subjects_s1_5cond);
T_subjects_s1_diff=setdiff(T_subjects_s1,T_subjects_s1_5cond);
subjects_s1_diff=table2struct(T_subjects_s1_diff);

% Session 1
d1=1;
for sbjd= 1: size(subjects_s1_diff,1)
        events_path1=fullfile(subjects_s1_diff(sbjd).folder, subjects_s1_diff(sbjd).name, 'ses-001', 'derivatives','SPM_prepro','func','events');
        events_Tydyy1=horzcat(subjects_s1_diff(sbjd).name, '_ses-001_task-tydyy_acq-multiband_events.mat');
        cond_Tydyy_temp1=load(fullfile(events_path1,events_Tydyy1)); cond_Tydyy_names1=cond_Tydyy_temp1.names; cond_Tydyy_names_sbj_ses1{d1,:}=cond_Tydyy_names1;
        events_Uulaa1=horzcat(subjects_s1_diff(sbjd).name, '_ses-001_task-uulaa_acq-multiband_events.mat');
        cond_Uulaa_temp1=load(fullfile(events_path1,events_Uulaa1)); cond_Uulaa_names1=cond_Uulaa_temp1.names; cond_Uulaa_names_sbj_ses1{d1,1}=cond_Uulaa_names1;
        d1=d1+1;
end

Tydyy_cond_ses1=table(cond_Tydyy_names_sbj_ses1{1,1}, cond_Tydyy_names_sbj_ses1{2,1}, cond_Tydyy_names_sbj_ses1{3,1}, cond_Tydyy_names_sbj_ses1{4,1}, cond_Tydyy_names_sbj_ses1{5,1},cond_Tydyy_names_sbj_ses1{6,1},cond_Tydyy_names_sbj_ses1{7,1},cond_Tydyy_names_sbj_ses1{8,1});
Tydyy_cond_ses1.Properties.VariableNames=T_subjects_s1_diff.name([1:end])';

Uulaa_cond_ses1=table(cond_Uulaa_names_sbj_ses1{1,1}, cond_Uulaa_names_sbj_ses1{2,1}, cond_Uulaa_names_sbj_ses1{3,1}, cond_Uulaa_names_sbj_ses1{4,1}, cond_Uulaa_names_sbj_ses1{5,1},cond_Uulaa_names_sbj_ses1{6,1},cond_Uulaa_names_sbj_ses1{7,1},cond_Uulaa_names_sbj_ses1{8,1});
Uulaa_cond_ses1.Properties.VariableNames=T_subjects_s1_diff.name([1:end])';

cd(code_path)
writetable(Tydyy_cond_ses1, 'Tydyy_cond_ses1.xlsx','Sheet',1)
writetable(Uulaa_cond_ses1, 'Uulaa_cond_ses1.xlsx','Sheet',1)

% Session 2
T_subjects_s2=struct2table(subjects_s2);
T_subjects_s2_5cond=struct2table(subjects_s2_5cond);
T_subjects_s2_diff=setdiff(T_subjects_s2,T_subjects_s2_5cond);
subjects_s2_diff=table2struct(T_subjects_s2_diff);

d2=1;
for sbjd= 1: size(subjects_s2_diff,1)
        events_path2=fullfile(subjects_s2_diff(sbjd).folder, subjects_s2_diff(sbjd).name, 'ses-002', 'derivatives','SPM_prepro','func','events');
        events_Tydyy2=horzcat(subjects_s2_diff(sbjd).name, '_ses-002_task-tydyy_acq-multiband_events.mat');
        cond_Tydyy_temp2=load(fullfile(events_path2,events_Tydyy2)); cond_Tydyy_names2=cond_Tydyy_temp2.names; cond_Tydyy_names_sbj_ses2{d2,:}=cond_Tydyy_names2;
        events_Uulaa2=horzcat(subjects_s2_diff(sbjd).name, '_ses-002_task-uulaa_acq-multiband_events.mat');
        cond_Uulaa_temp2=load(fullfile(events_path2,events_Uulaa2)); cond_Uulaa_names2=cond_Uulaa_temp2.names; cond_Uulaa_names_sbj_ses2{d2,1}=cond_Uulaa_names2;
        d2=d2+1;
end

Tydyy_cond_ses2=table(cond_Tydyy_names_sbj_ses2{1,1}, cond_Tydyy_names_sbj_ses2{2,1}, cond_Tydyy_names_sbj_ses2{3,1}, cond_Tydyy_names_sbj_ses2{4,1}, cond_Tydyy_names_sbj_ses2{5,1},cond_Tydyy_names_sbj_ses2{6,1},cond_Tydyy_names_sbj_ses2{7,1},cond_Tydyy_names_sbj_ses2{8,1});
Tydyy_cond_ses2.Properties.VariableNames=T_subjects_s2_diff.name([1:end])';

Uulaa_cond_ses2=table(cond_Uulaa_names_sbj_ses2{1,1}, cond_Uulaa_names_sbj_ses2{2,1}, cond_Uulaa_names_sbj_ses2{3,1}, cond_Uulaa_names_sbj_ses2{4,1}, cond_Uulaa_names_sbj_ses2{5,1},cond_Uulaa_names_sbj_ses2{6,1},cond_Uulaa_names_sbj_ses2{7,1},cond_Uulaa_names_sbj_ses2{8,1});
Uulaa_cond_ses2.Properties.VariableNames=T_subjects_s2_diff.name([1:end])';

cd(code_path)
writetable(Tydyy_cond_ses2, 'Tydyy_cond_ses2.xlsx','Sheet',1)
writetable(Uulaa_cond_ses2, 'Uulaa_cond_ses2.xlsx','Sheet',1)

% Session 3
T_subjects_s3=struct2table(subjects_s3);
T_subjects_s3_5cond=struct2table(subjects_s3_5cond);
T_subjects_s3_diff=setdiff(T_subjects_s3,T_subjects_s3_5cond);
subjects_s3_diff=table2struct(T_subjects_s3_diff);

d3=1;
for sbjd= 1: size(subjects_s3_diff,1)
        events_path3=fullfile(subjects_s3_diff(sbjd).folder, subjects_s3_diff(sbjd).name, 'ses-003', 'derivatives','SPM_prepro','func','events');
        events_Tydyy3=horzcat(subjects_s3_diff(sbjd).name, '_ses-003_task-tydyy_acq-multiband_events.mat');
        cond_Tydyy_temp3=load(fullfile(events_path3,events_Tydyy3)); cond_Tydyy_names3=cond_Tydyy_temp3.names; cond_Tydyy_names_sbj_ses3{d3,:}=cond_Tydyy_names3;
        events_Uulaa3=horzcat(subjects_s3_diff(sbjd).name, '_ses-003_task-uulaa_acq-multiband_events.mat');
        cond_Uulaa_temp3=load(fullfile(events_path3,events_Uulaa3)); cond_Uulaa_names3=cond_Uulaa_temp3.names; cond_Uulaa_names_sbj_ses3{d3,1}=cond_Uulaa_names3;
        d3=d3+1;
end

Tydyy_cond_ses3=table(cond_Tydyy_names_sbj_ses3{1,1}, cond_Tydyy_names_sbj_ses3{2,1}, cond_Tydyy_names_sbj_ses3{3,1}, cond_Tydyy_names_sbj_ses3{4,1}, cond_Tydyy_names_sbj_ses3{5,1},cond_Tydyy_names_sbj_ses3{6,1});
Tydyy_cond_ses3.Properties.VariableNames=T_subjects_s3_diff.name([1:end])';

Uulaa_cond_ses3=table(cond_Uulaa_names_sbj_ses3{1,1}, cond_Uulaa_names_sbj_ses3{2,1}, cond_Uulaa_names_sbj_ses3{3,1}, cond_Uulaa_names_sbj_ses3{4,1}, cond_Uulaa_names_sbj_ses3{5,1},cond_Uulaa_names_sbj_ses3{6,1});
Uulaa_cond_ses3.Properties.VariableNames=T_subjects_s3_diff.name([1:end])';

cd(code_path)
writetable(Tydyy_cond_ses3, 'Tydyy_cond_ses3.xlsx','Sheet',1)
writetable(Uulaa_cond_ses3, 'Uulaa_cond_ses3.xlsx','Sheet',1)

save('subjects_s1_diff.mat','subjects_s1_diff')
save('subjects_s2_diff.mat','subjects_s2_diff')
save('subjects_s3_diff.mat','subjects_s3_diff')



