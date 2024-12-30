clear all
logfile_path='/Volumes/LASA/Aphasia_project/tb-fMRI/logfiles/LASA2019/Uulaa/';
data_path='/Volumes/LASA/Aphasia_project/tb-fMRI/recordings/LASA2019/Noise_reduction/Uulaa/';
panames=dir(data_path);
panames(ismember({panames.name},{'.','..','ID135','ID136','ID137','ID148','ID149','ID158','PPA'}))=[];
        %SINGING PERFORMANCE SUMMARY:sub1(ID138) some lis false, sub2(ID139) some base, lis & singmemfalse,
        %sub3(ID140) all trials true, sub4(ID142) some lis false,
        %sub5(ID145) some lis & singa false & all singm false, sub6(ID146)
        %all trials true, sub7(ID150) some lis, singa false, sub8(ID153) some singm false, all lis false 
for sub=1:numel(panames)
        %% Load corrected trials
    clearvars -except file_path data_path aux panames sub
    sub_path1=fullfile(data_path,panames(sub).name,[panames(sub).name '_2']);
    sub_path2=fullfile(data_path,panames(sub).name,[panames(sub).name '_2'], 'func','Triggers/');
    cd (sub_path1)
        load(['baseline_true_index_Uulaa_' panames(sub).name '.mat'])
    if sub~=8 %all listen incorrect
    load(['listen_true_index_Uulaa_' panames(sub).name '.mat'])
    end
    load(['sing_along_true_index_Uulaa_' panames(sub).name '.mat'])
    if sub~=5 %all sing memo incorrect
    load(['sing_memo_true_index_Uulaa_' panames(sub).name '.mat'])
    end
    cd (sub_path2)
    load ('aphasia_sing_conditions_Uulaa_dur0_explbase.mat')
     %% Calculate correct trials onsets and durations
     if sub~=8%all listen incorrect
         onsets_listen=zeros(1,length(listen_true_index));
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
    
    if sub~=5 %all sing memo incorrect
        onsets_singmem=zeros(1,length(sing_memo_true_index));
        dur_singm=zeros(1,length(sing_memo_true_index));
        for k=1:length(sing_memo_true_index)
            onsets_singm(1,k)=onsets{1,3} (1,sing_memo_true_index(k));
        end
    end
    
        onsets_base=zeros(1,length(baseline_true_index));
        dur_base=zeros(1,length(baseline_true_index));
        for l=1:length(baseline_true_index)
            onsets_base(1,l)=onsets{1,4} (1,baseline_true_index(l));
        end
    
    %% Calculate missed trials onsets and durations
    
  check30=(1:1:30)';check20=(1:1:20)';
  if sub~=8 %all listen incorrect
  lis_missed_idx=setxor(check30, listen_true_index);
  end
  singa_missed_idx=setxor(check30, sing_along_true_index);
  if sub~=5 %all sing memo incorrect
  singm_missed_idx=setxor(check30, sing_memo_true_index);
  end
  base_missed_idx=setxor(check20, baseline_true_index);
  
  if sub~=8
      if ~isempty(lis_missed_idx)
          for ii=1:length(lis_missed_idx)
              missed_onsets_lis (1,ii)=onsets{1,1} (1,lis_missed_idx(ii));
          end
          missed_duration_lis=zeros(1,length(lis_missed_idx));
          s.missed_onsets_lis= missed_onsets_lis;
      end
  elseif sub==8 %all listen incorrect
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
  
  if sub~=5
      if ~isempty(singm_missed_idx)
          for kk=1:length(singm_missed_idx)
              missed_onsets_singm(1,kk)=onsets{1,3} (1,singm_missed_idx(kk));
          end
          missed_duration_singm=zeros(1,length(singm_missed_idx));
          s.missed_onsets_singm=missed_onsets_singm;
      end
  elseif sub==5 %all sing memo incorrect
      missed_duration_singm=zeros(1,30);
      s.missed_onsets_singm=onsets{1,3};
  end
  
      if ~isempty(base_missed_idx)
          for ll=1:length(base_missed_idx)
              missed_onsets_base(1,ll)=onsets{1,4} (1,base_missed_idx(ll));
          end
          missed_duration_base=zeros(1,length(base_missed_idx));
          s.missed_onsets_base=missed_onsets_base;
      end 
  
if sub~=3 && sub~=6 %all trials correct
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
  
if sub~=3 && sub~=5 && sub~=6 && sub~=8
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline'; names{5}='incorrect';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base; onsets{1,5}=missed_onsets_all;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base; durations{1,5}= missed_dur_all;
      cd (sub_path2)
      save('aphasia_sing_conditions_Uulaa_dur0_expl_base_5reg.mat','names','onsets','durations');
elseif sub==5  %all singmem false
      names{1}='listen';names{2}='singalong';names{3}='baseline'; names{4}='incorrect';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_base;onsets{1,4}=missed_onsets_all;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_base; durations{1,4}= missed_dur_all;
      cd (sub_path2)
      save('aphasia_sing_conditions_Uulaa_dur0_expl_base_4reg.mat','names','onsets','durations');
elseif sub==8 %all listen false
      names{1}='singalong';names{2}='singmem';names{3}='baseline'; names{4}='incorrect';
      onsets{1,1}=onsets_singa;onsets{1,2}=onsets_singm;onsets{1,3}=onsets_base;onsets{1,4}=missed_onsets_all;
      durations{1,1}=dur_singa; durations{1,2}=dur_singm;durations{1,3}=dur_base; durations{1,4}= missed_dur_all;
      cd (sub_path2)
      save('aphasia_sing_conditions_Uulaa_dur0_expl_base_4reg.mat','names','onsets','durations');
elseif sub==3 || sub==6%all trials correct
        names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline';
        onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base;
        durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base;
        cd (sub_path2)
        save('aphasia_sing_conditions_Tydyy_dur0_expl_base_4reg.mat','names','onsets','durations');
end   

end

