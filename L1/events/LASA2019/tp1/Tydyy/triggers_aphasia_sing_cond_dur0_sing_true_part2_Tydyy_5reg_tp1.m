clear all
logfile_path='/Volumes/LASA/Aphasia_project/tb-fMRI/logfiles/LASA2019/Tydyy/';
data_path='/Volumes/LASA/Aphasia_project/tb-fMRI/recordings/LASA2019/Noise_reduction/Tydyy/';
panames=dir(data_path);
panames(ismember({panames.name},{'.','..','ID135','ID136','ID137','ID148','ID149','ID158','PPA'}))=[];
%SINGING PERFORMANCE SUMMARY: sub5(ID145) & sub8(ID153) all sing memo incorrect...
...sub2 (ID139) & sub4 (ID142) all listen incorrect, sub3 (ID140) all trials correct ...
    for sub=1:numel(panames)
    clearvars -except file_path data_path aux panames sub
    %% Load corrected trials
    sub_path1=fullfile(data_path,panames(sub).name,[panames(sub).name '_1']);
    sub_path2=fullfile(data_path,panames(sub).name,[panames(sub).name '_1'], 'func','Triggers');
    cd (sub_path1)
    load(['baseline_true_index_Tydyy_' panames(sub).name '.mat'])
    if sub~=2 && sub~=4 %all listen incorrect
        load(['listen_true_index_Tydyy_' panames(sub).name '.mat'])
    end
    load(['sing_along_true_index_Tydyy_' panames(sub).name '.mat'])
    if sub~=5 && sub~=8 %all sing memo incorrect
        load(['sing_memo_true_index_Tydyy_' panames(sub).name '.mat'])
    end
    cd(sub_path2)
    load ('aphasia_sing_conditions_Tydyy_dur0_explbase.mat')
    %% Calculate correct trials onsets and durations
    if sub~=2 && sub~=4 %all listen incorrect
        dur_lis=zeros(1,length(listen_true_index));
        for i=1:length(listen_true_index)
            onsets_lis(1,i)=onsets{1,1} (1,listen_true_index(i));
        end
    end

    dur_singa=zeros(1,length(sing_along_true_index));
    for j=1:length(sing_along_true_index)
        onsets_singa(1,j)=onsets{1,2} (1,sing_along_true_index(j));
    end
    if sub~=5 && sub~=8 %all sing memo incorrect
        dur_singm=zeros(1,length(sing_memo_true_index));
        for k=1:length(sing_memo_true_index)
            onsets_singm(1,k)=onsets{1,3} (1,sing_memo_true_index(k));
        end
    end

    dur_base=zeros(1,length(baseline_true_index));
    for l=1:length(baseline_true_index)
        onsets_base(1,l)=onsets{1,4} (1,baseline_true_index(l));
    end

    %% Calculate missed trial onsets and durations
    %sub06 all trials correct
    check30=(1:1:30)';check20=(1:1:20)';
    if sub~=2 && sub~=3  && sub~=4 %all listen incorrect except for sub03
        lis_missed_idx=setxor(check30, listen_true_index);
    end
    if sub~=3 %all singa correct
        singa_missed_idx=setxor(check30, sing_along_true_index);
    end
    if sub~=3 && sub~=5 && sub~=8 % all sing memo incorrect except for sub03
        singm_missed_idx=setxor(check30, sing_memo_true_index);
    end
    if sub~=3 %all baseline correct
        base_missed_idx=setxor(check20, baseline_true_index);
    end

    if sub~=2 && sub~=3  && sub~=4 %all listen incorrect except for sub03
        if ~isempty(lis_missed_idx)
            for ii=1:length(lis_missed_idx)
                missed_onsets_lis (1,ii)=onsets{1,1} (1,lis_missed_idx(ii));
            end
            missed_duration_lis=zeros(1,length(lis_missed_idx));
            s.missed_onsets_lis= missed_onsets_lis;
        end
    else
        missed_duration_lis=zeros(1,30);
        s.missed_onsets_lis= onsets{1,1};
    end

    if sub~=3 %all singa correct
        if ~isempty(singa_missed_idx)
            for jj=1:length(singa_missed_idx)
                missed_onsets_singa(1,jj)=onsets{1,2} (1,singa_missed_idx(jj));
            end
            missed_duration_singa=zeros(1,length(singa_missed_idx));
            s.missed_onsets_singa=missed_onsets_singa;
        end
    end

    if sub~=3 && sub~=5 && sub~=8 %all sing memo incorrect except for sub03 all correct
        if ~isempty(singm_missed_idx)
            for kk=1:length(singm_missed_idx)
                missed_onsets_singm(1,kk)=onsets{1,3} (1,singm_missed_idx(kk));
            end
            missed_duration_singm=zeros(1,length(singm_missed_idx));
            s.missed_onsets_singm=missed_onsets_singm;
        end
    else
        missed_duration_singm=zeros(1,30);
        s.missed_onsets_singm=onsets{1,3};
    end
    if sub~=3 %all baseline correct
        if ~isempty(base_missed_idx)
            for ll=1:length(base_missed_idx)
                missed_onsets_base(1,ll)=onsets{1,4} (1,base_missed_idx(ll));
            end
            missed_duration_base=zeros(1,length(base_missed_idx));
            s.missed_onsets_base=missed_onsets_base;
        end
    else
        missed_duration_base=zeros(1,20);
        s.missed_onsets_base=onsets{1,4};
    end
    if sub~=3
        if ~isempty(s)
            ss=struct2cell(s);
            for iii=1:size(ss,1)
                ss{iii,1}=ss{iii,1}';
            end
            missed_onsets_all=sortrows(vertcat(ss{1:end,1}));
            missed_dur_all=zeros(1,length(missed_onsets_all));
        end
    end
    clear onsets durations names s
    if sub~=2 && sub~=3  && sub~=4 && sub~=5  && sub~=8
        names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline'; names{5}='incorrect';
        onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base; onsets{1,5}=missed_onsets_all;
        durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base; durations{1,5}= missed_dur_all;
        cd (sub_path2)
        save('aphasia_sing_conditions_Tydyy_dur0_expl_base_5reg.mat','names','onsets','durations');
    elseif sub==5 || sub==8
        names{1}='listen';names{2}='singalong';names{3}='baseline'; names{4}='incorrect';
        onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_base; onsets{1,4}=missed_onsets_all;
        durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_base; durations{1,4}= missed_dur_all;
        cd(sub_path2)
        save('aphasia_sing_conditions_Tydyy_dur0_expl_base_4reg.mat','names','onsets','durations');
    elseif sub==2 || sub==4
        names{1}='singalong';names{2}='singmem'; names{3}='baseline'; names{4}='incorrect';
        onsets{1,1}=onsets_singa;onsets{1,2}=onsets_singm;onsets{1,3}=onsets_base; onsets{1,4}=missed_onsets_all;
        durations{1,1}=dur_singa;durations{1,2}=dur_singm; durations{1,3}=dur_base; durations{1,4}= missed_dur_all;
        cd (sub_path2)
        save('aphasia_sing_conditions_Tydyy_dur0_expl_base_4reg.mat','names','onsets','durations');
    elseif sub==3
        names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline';
        onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base;
        durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base;
        cd (sub_path2)
        save('aphasia_sing_conditions_Tydyy_dur0_expl_base_4reg.mat','names','onsets','durations');
    end
    end

