clear all
logfile_path='/Volumes/LASA/Aphasia_project/tb-fMRI/logfiles/LASA2017/Uulaa/';
data_path='/Volumes/LASA/Aphasia_project/tb-fMRI/recordings/LASA2017/Noise_reduction/Uulaa/';
panames=dir(data_path);
panames(ismember({panames.name},{'.','..','ID106','ID109','ID123','ID127','ID128'}))=[];
    %SINGING PERFORMANCE SUMMARY:sub1(ID102) some singa & singm false, sub2(ID104) some singa and singm false
    ...sub3(ID110) all trials correct, sub4(ID112) all trials correct,
    ...sub5(ID113) all trials correct, sub6(ID114) some singa & singm false, sub7(ID116) some lis false
    ...sub8(ID121) some singm false, sub9(ID122) some lis, base, singa & singm false,
    ...sub10(ID124) some lis & singm false, 
    ...sub11(ID134) some lis false
for sub=1:numel(panames)
        %% Load corrected trials
    clearvars -except file_path data_path aux panames sub
    sub_path1=fullfile(data_path,panames(sub).name,[panames(sub).name '_2']);
    sub_path2=fullfile(data_path,panames(sub).name,[panames(sub).name '_2'], 'func','Triggers');
    cd (sub_path1)
    load(['baseline_true_index_Uulaa_' panames(sub).name '.mat'])
    load(['listen_true_index_Uulaa_' panames(sub).name '.mat'])
    load(['sing_along_true_index_Uulaa_' panames(sub).name '.mat'])
    load(['sing_memo_true_index_Uulaa_' panames(sub).name '.mat'])
    cd(sub_path2)
    load ('aphasia_sing_conditions_Uulaa_dur0_explbase.mat')
     %% Calculate correct trials onsets and durations
         onsets_listen=zeros(1,length(listen_true_index));
         dur_lis=zeros(1,length(listen_true_index));
         for i=1:length(listen_true_index)
             onsets_lis(1,i)=onsets{1,1} (1,listen_true_index(i));
         end
    
    onsets_singa=zeros(1,length(sing_along_true_index));
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
    
    %% Calculate missed trials onsets and durations
    
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
  
if sub~=3 && sub ~=4 && sub~=5
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
  if sub~=3 && sub~=4 && sub~=5
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline'; names{5}='incorrect';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base; onsets{1,5}=missed_onsets_all;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base; durations{1,5}= missed_dur_all;
      cd (sub_path2)
      save('aphasia_sing_conditions_Uulaa_dur0_expl_base_5reg.mat','names','onsets','durations');
  elseif sub==3 || sub==4  || sub==5 %all trials correct
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm; onsets{1,4}=onsets_base;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base;
      cd(sub_path2)
      save('aphasia_sing_conditions_Uulaa_dur0_expl_base_4reg.mat','names','onsets','durations');
  end
end

