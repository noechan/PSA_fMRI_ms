clear all
logfile_path='/Volumes/LASA/Aphasia_project/tb-fMRI/logfiles/LASA2019/Tydyy/';
data_path='/Volumes/LASA/Aphasia_project/tb-fMRI/recordings/LASA2019/Noise_reduction/Tydyy/';
panames=dir(data_path);
panames(ismember({panames.name},{'.','..','PPA','ID136','ID158'}))=[]; %ID136 all recordings empty, ID158 dropout 
        %SINGING PERFORMANCE SUMMARY:sub1 (ID135) some base, lis, singa and singm false, sub2(ID137),
        %sub3(ID138) some base, singa & singm false, sub4(ID139) some lis &
        %singm false, sub5(ID140) all trials true,  sub6(ID142) all trials true,  
        %sub7(ID145) some lis and singm false, sub8(ID146) all trials true,
        %sub9(ID148) some lis, singa and singm false, all base false, 
%         sub10(ID149) some lis, singa and singm false, all base false,
%         sub11(ID150) some lis false, all base true, sub12(ID153) some
%         singa & singm false, all listen false
for sub=1:numel(panames)
        %% Load corrected trials
    clearvars -except file_path data_path aux fnames sub
    sub_path1=fullfile(data_path,(fnames(sub,:)),[(fnames(sub,:)) '_3']);
    sub_path2=fullfile(file_path,(fnames(sub,:)),[(fnames(sub,:)) '_3'], 'Triggers\');
    cd (sub_path1)
    if sub~=9 && sub~=10 %all baseline incorrect
    load(['baseline_true_index_Uulaa_' (fnames(sub,:)) '.mat'])
    end
    if sub~=12 %all listen incorrect
    load(['listen_true_index_Uulaa_' (fnames(sub,:)) '.mat'])
    end
    load(['sing_along_true_index_Uulaa_' (fnames(sub,:)) '.mat'])
    load(['sing_memo_true_index_Uulaa_' (fnames(sub,:)) '.mat'])
    cd (sub_path2)
    load ('aphasia_sing_conditions_Uulaa_dur0_explbase.mat')
     %% Calculate correct trials onsets and durations
     if sub~=12 %all listen incorrect
         onsets_lis=zeros(1,length(listen_true_index));
         dur_lis=zeros(1,length(listen_true_index));
         for i=1:length(listen_true_index)
             onsets_lis(1,i)=onsets{1,1} (1,listen_true_index(i));
         end
     end
    
    onsets_singa=zeros(1,length(sing_along_true_index));
    dur_singa=zeros(1,length(sing_along_true_index));
    for j=1:length(sing_along_true_index)
        onsets_singa(1,j)=onsets{1,2} (1,sing_along_true_index(j));
    end
    
    onsets_singm=zeros(1,length(sing_memo_true_index));
    dur_singm=zeros(1,length(sing_memo_true_index));
    for k=1:length(sing_memo_true_index)
        onsets_singm(1,k)=onsets{1,3} (1,sing_memo_true_index(k));
    end
    
    if sub~=9 && sub~=10 %all baseline incorrect
        onsets_base=zeros(1,length(baseline_true_index));
        dur_base=zeros(1,length(baseline_true_index));
        for l=1:length(baseline_true_index)
            onsets_base(1,l)=onsets{1,4} (1,baseline_true_index(l));
        end
    end
    
    %% Calculate missed trials onsets and durations
    
  check30=(1:1:30)';check20=(1:1:20)';
  if sub~=12 %all listen incorrect
  lis_missed_idx=setxor(check30, listen_true_index);
  end
  singa_missed_idx=setxor(check30, sing_along_true_index);
  singm_missed_idx=setxor(check30, sing_memo_true_index);
  if sub~=9 && sub~=10 && sub~=11 %all baseline incorrect except for sub11
  base_missed_idx=setxor(check20, baseline_true_index);
  end 
  
  if sub~=12
      if ~isempty(lis_missed_idx)
          for ii=1:length(lis_missed_idx)
              missed_onsets_lis (1,ii)=onsets{1,1} (1,lis_missed_idx(ii));
          end
          missed_duration_lis=zeros(1,length(lis_missed_idx));
          s.missed_onsets_lis= missed_onsets_lis;
      end
  elseif sub==12 %all listen incorrect
      missed_duration_lis=zeros(1,30);
      s.missed_onsets_lis=onsets{1,1};
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
  
  if sub~=9 && sub~=10 && sub~=11 %all baseline incorrect except for sub11 all base correct
      if ~isempty(base_missed_idx)
          for ll=1:length(base_missed_idx)
              missed_onsets_base(1,ll)=onsets{1,4} (1,base_missed_idx(ll));
          end
          missed_duration_base=zeros(1,length(base_missed_idx));
          field='missed_onsets_base';
          s.missed_onsets_base=missed_onsets_base;
      elseif sub==9 || sub==10
          missed_duration_base=zeros(1,20);
          s.missed_onsets_base=onsets{1,4};
      end
  end
  
  if sub~=5 && sub~=6 && sub~=8 %all trials correct
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
  
  if sub~=5 && sub~=6 && sub~=8 && sub~=9 && sub~=10 && sub~=12
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline'; names{5}='incorrect';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base; onsets{1,5}=missed_onsets_all;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base; durations{1,5}= missed_dur_all;
      save([sub_path2 'aphasia_sing_conditions_Uulaa_dur0_expl_base_5reg.mat'],'names','onsets','durations');
  elseif sub==5 || sub==6 || sub==8
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base;
      save([sub_path2 'aphasia_sing_conditions_Uulaa_dur0_expl_base_4reg.mat'],'names','onsets','durations');
  elseif sub==9 || sub==10
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='incorrect';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=missed_onsets_all;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=missed_dur_all;
      save([sub_path2 'aphasia_sing_conditions_Uulaa_dur0_expl_base_4reg.mat'],'names','onsets','durations');
  elseif sub==12
      names{1}='singalong';names{2}='singmem'; names{3}='baseline'; names{4}='incorrect';
      onsets{1,1}=onsets_singa;onsets{1,2}=onsets_singm;onsets{1,3}=onsets_base; onsets{1,4}=missed_onsets_all;
      durations{1,1}=dur_singa;durations{1,2}=dur_singm; durations{1,3}=dur_base; durations{1,4}= missed_dur_all;
      save([sub_path2 'aphasia_sing_conditions_Uulaa_dur0_expl_base_4reg.mat'],'names','onsets','durations');
  end    
end

