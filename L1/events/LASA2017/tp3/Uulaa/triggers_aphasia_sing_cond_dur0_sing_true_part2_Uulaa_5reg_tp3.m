clear all
logfile_path='/Volumes/LASA/Aphasia_project/tb-fMRI/logfiles/LASA2017/Uulaa/';
data_path='/Volumes/LASA/Aphasia_project/tb-fMRI/recordings/LASA2017/Noise_reduction/Uulaa/';
panames=dir(data_path);
panames(ismember({panames.name},{'.','..','ID109','ID123','ID128'}))=[]; % ID109, ID123 & ID128 dropouts; 
    %SINGING PERFORMANCE SUMMARY: sub1(ID102) some singm & singa false; sub2(ID104) some singa false;
    ...sub3(ID106) some lis false, sub4(ID110) some singa false
    ...sub5(ID112) some singa false, sub6(ID113) all trials correct,
    ...sub7(ID114) some singa & singm false, sub8(ID116) some singa false,
    ...sub9(ID121) some singm false,
    ...sub10(ID122) some lis, singa & singm false, sub11(ID124) some base, lis & singa false,
    ...sub12(ID127) some base, lis, singa & singm false, sub13(ID134) some 
    ...lis & singa false
for sub=1:numel(panames)
   %% Load corrected trials
    clearvars -except file_path data_path aux fnames sub
    sub_path1=fullfile(data_path,(fnames(sub,:)),[(fnames(sub,:)) '_3']);
    sub_path2=fullfile(file_path,(fnames(sub,:)),[(fnames(sub,:)) '_3'], 'func','Triggers');
    cd (sub_path1)
    load(['baseline_true_index_Uulaa_' (fnames(sub,:)) '.mat'])
    load(['listen_true_index_Uulaa_' (fnames(sub,:)) '.mat'])
    load(['sing_along_true_index_Uulaa_' (fnames(sub,:)) '.mat'])
    load(['sing_memo_true_index_Uulaa_' (fnames(sub,:)) '.mat'])
    cd (sub_path2) 
    load ('aphasia_sing_conditions_Uulaa_dur0_explbase.mat')
     %% Calculate correct trials onsets and durations
           onsets_listen=zeros(1,length(listen_true_index));
         dur_lis=zeros(1,length(listen_true_index));
         for i=1:length(listen_true_index)
             onsets_lis(1,i)=onsets{1,1} (1,listen_true_index(i));
         end

    
    onsets_singal=zeros(1,length(sing_along_true_index));
    dur_singa=zeros(1,length(sing_along_true_index));
    for j=1:length(sing_along_true_index)
        onsets_singa(1,j)=onsets{1,2} (1,sing_along_true_index(j));
    end
    
    onsets_singmem=zeros(1,length(sing_memo_true_index));
    dur_singm=zeros(1,length(sing_memo_true_index));
    for k=1:length(sing_memo_true_index)
        onsets_singm(1,k)=onsets{1,3} (1,sing_memo_true_index(k));
    end
    
    onsets_base=zeros(1,length(baseline_true_index));
    dur_base=zeros(1,length(baseline_true_index));
    for l=1:length(baseline_true_index)
        onsets_base(1,l)=onsets{1,4} (1,baseline_true_index(l));
    end

    %% Calculate missed trial onsets and durations
    
  check30=(1:1:30)';check20=(1:1:20)';
  lis_missed_idx=setxor(check30, listen_true_index);
  singa_missed_idx=setxor(check30, sing_along_true_index);
  singm_missed_idx=setxor(check30, sing_memo_true_index);
   base_missed_idx=setxor(check20, baseline_true_index);
  
      if ~isempty(lis_missed_idx)
          for ii=1:length(lis_missed_idx)
              missed_onsets_lis (1,ii)=onsets{1,1} (1,lis_missed_idx(ii));
          end
          missed_duration_lis=zeros(1,length(lis_missed_idx));
          s.missed_onsets_lis= missed_onsets_lis;
      end
  
  if ~isempty(singa_missed_idx)
      for jj=1:length(singa_missed_idx)
          missed_onsets_singa(1,jj)=onsets{1,2} (1,singa_missed_idx(jj));
      end
       missed_duration_singa=zeros(1,length(singa_missed_idx));
      s.missed_onsets_singa=missed_onsets_singa;
  end
  
  if ~isempty(singm_missed_idx)
      for kk=1:length(singm_missed_idx)
          missed_onsets_singm(1,kk)=onsets{1,3} (1,singm_missed_idx(kk));
      end
      missed_duration_singm=zeros(1,length(singm_missed_idx));
      s.missed_onsets_singm=missed_onsets_singm;
  end
  
  if ~isempty(base_missed_idx)
      for ll=1:length(base_missed_idx)
          missed_onsets_base(1,ll)=onsets{1,4} (1,base_missed_idx(ll));
      end
      missed_duration_base=zeros(1,length(base_missed_idx));
      field='missed_onsets_base';
      s.missed_onsets_base=missed_onsets_base;
  end
  
  if sub~=6 
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
  if sub~=6 
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline'; names{5}='incorrect';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base; onsets{1,5}=missed_onsets_all;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base; durations{1,5}= missed_dur_all;
      cd (sub_path2)
      save('aphasia_sing_conditions_Uulaa_dur0_expl_base_5reg.mat','names','onsets','durations');
  elseif sub==6 %all trials correct
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm; onsets{1,4}=onsets_base;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base;
      cd(sub_path2)
      save('aphasia_sing_conditions_Uulaa_dur0_expl_base_4reg.mat','names','onsets','durations');
  end
end

