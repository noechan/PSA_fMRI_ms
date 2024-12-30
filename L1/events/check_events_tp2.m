clear all
data_path='/Volumes/LASA/Aphasia_project/tb-fMRI/data/LASA/';
code_path='/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/events/';
sub=[1 2 5 6 7 8 9 10 11 13 16 20 21 22 23 25 26 29 30];
for n=1:numel(sub)
    if sub(n)<=9
        events_sub=fullfile(data_path,strcat('sub-0',num2str(sub(n))), 'ses-002','derivatives','SPM_prepro','func','events');
    else
        events_sub=fullfile(data_path,strcat('sub-',num2str(sub(n))), 'ses-002','derivatives','SPM_prepro','func','events');
    end
    cd(events_sub)
    if sub(n)<=9
        uulaa_events_check=strcat('sub-0',num2str(sub(n)),'_ses-002_task-uulaa_acq-multiband_events_check.mat'); load(uulaa_events_check)
        names_U_check=names; onsets_U_check=onsets; durations_check=durations; clear names onsets durations
        uulaa_events=strcat('sub-0',num2str(sub(n)),'_ses-002_task-uulaa_acq-multiband_events.mat'); load(uulaa_events)
        check_onsets_U=isequal(onsets_U_check,onsets); clear names_U_check onsets_U_check durations_U_check
        check_uulaa_ses2{n,1}=n;
        check_uulaa_ses2{n,2}=check_onsets_U;
        tydyy_events_check=strcat('sub-0',num2str(sub(n)),'_ses-002_task-tydyy_acq-multiband_events_check.mat'); load(tydyy_events_check)
        names_T_check=names; onsets_T_check=onsets; durations_check=durations; clear names onsets durations
        tydyy_events=strcat('sub-0',num2str(sub(n)),'_ses-002_task-tydyy_acq-multiband_events.mat'); load(tydyy_events)
        check_onsets_T=isequal(onsets_T_check,onsets); clear names_T_check onsets_T_check durations_T_check
        check_tydyy_ses2{n,1}=n;
        check_tydyy_ses2{n,2}=check_onsets_T;


    else
        if sub(n)~=22 && sub(n)~=26
            uulaa_events_check=strcat('sub-',num2str(sub(n)),'_ses-002_task-uulaa_acq-multiband_events_check.mat'); load(uulaa_events_check)
            names_U_check=names; onsets_U_check=onsets; durations_check=durations; clear names onsets durations
            uulaa_events=strcat('sub-',num2str(sub(n)),'_ses-002_task-uulaa_acq-multiband_events.mat'); load(uulaa_events)
            check_onsets_U=isequal(onsets_U_check,onsets); clear names_U_check onsets_U_check durations_U_check
            check_uulaa_ses2{n,1}=n;
            check_uulaa_ses2{n,2}=check_onsets_U;
        end
        tydyy_events_check=strcat('sub-',num2str(sub(n)),'_ses-002_task-tydyy_acq-multiband_events_check.mat'); load(tydyy_events_check)
        names_T_check=names; onsets_T_check=onsets; durations_check=durations; clear names onsets durations
        tydyy_events=strcat('sub-',num2str(sub(n)),'_ses-002_task-tydyy_acq-multiband_events.mat'); load(tydyy_events)
        check_onsets_T=isequal(onsets_T_check,onsets); clear names_T_check onsets_T_check durations_T_check
        check_tydyy_ses2{n,1}=n;
        check_tydyy_ses2{n,2}=check_onsets_T;
    end
end

cd(code_path)
save('check_events_tydyy_ses2.mat', 'check_tydyy_ses2')
save('check_events_uulaa_ses2.mat', 'check_uulaa_ses2')
