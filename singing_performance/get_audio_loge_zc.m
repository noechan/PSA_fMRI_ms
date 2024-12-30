%% Input Arguments
startup
load('/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/singing_performance/trial_idx.mat') %loads array with indices for listen, sing along, sing from memo and baseline trials
%%% To be edited manually %%%
cohort='LASA2019';
prep='Noise_reduction_copy';
song='Uulaa';
ses='_1';
fnames=dir(fullfile(data_path, cohort, prep,song));
fnames(ismember({fnames.name},{'.','..'}))=[];
%% Start analysis
for sub=1%:numel(fnames)
    sub_path=fullfile(data_path,cohort,prep,song, fnames(sub).name, [fnames(sub).name ses]);
    if exist(sub_path)==7
        cd(sub_path)
        if strcmp(cohort,'LASA2019')
            if (strcmp(ses,'_3') && sub==3) || (strcmp(song,'Uulaa') && sub==2)
                all_wav_files_nr=dir('norm*');
            elseif ~strcmp(ses,'_1') || sub==10
                all_wav_files_nr=dir('NR*');
            else
                all_wav_files_nr=dir('renorm*');
            end
        else
            all_wav_files_nr=dir('renorm*');
        end

        all_wav_files_nr(ismember({all_wav_files_nr.name},{'.','..'}))=[];
    l=1;
    for j=1:size(listen,1)
        listen_wav_nr{l,1}=all_wav_files_nr(listen(j,1)).name;
        l=l+1;
    end

    ll=1;
    for jj=1:size(sing_along,1)
        sing_along_wav_nr{ll,1}=all_wav_files_nr(sing_along(jj,1)).name;
        ll=ll+1;
    end

    q=1;
    for k=1:size(sing_memo,1)
        sing_memo_wav_nr{q,1}=all_wav_files_nr(sing_memo(k,1)).name;
        q=q+1;
    end

    qq=1;
    for kk=1:size(baseline,1)
        baseline_wav_nr{qq,1}=all_wav_files_nr(baseline(kk,1)).name;
        qq=qq+1;
    end
    clear m mm j jj q qq k kk

    %% Loading noise reduced recordings and computing log e
    cd (code_path)
    Lm=40; %window length threshold
    Rm=10; %frame shift step
    for j=1:30
        fname1=fullfile(sub_path,char(listen_wav_nr(j)));
        [xin,fs]=audioread(fname1);
        listen_audio_nr (:,j)=xin;
        L=round(Lm*fs/1000);
        R=round(Rm*fs/1000);
        [loge,zc,nfrm]=analysis(xin,L,R,fs);
        listen_loge_nr (:,j)=loge;
        listen_zc_nr (:,j)=zc;
        clear xin loge zc
    end

    for jj=1:30
        fname1=fullfile(sub_path,char(sing_along_wav_nr(jj)));
        [xin,fs]=audioread(fname1);
        sing_along_audio_nr (:,jj)=xin;
        L=round(Lm*fs/1000);
        R=round(Rm*fs/1000);
        [loge,zc,nfrm]=analysis(xin,L,R,fs);
        sing_along_loge_nr (:,jj)=loge;
        sing_along_zc_nr (:,jj)=zc;
        clear xin loge zc
    end

    for k=1:30
        fname1=fullfile(sub_path,char(sing_memo_wav_nr(k)));
        [xin,fs]=audioread(fname1);
        sing_memo_audio_nr (:,k)=xin;
        L=round(Lm*fs/1000);
        R=round(Rm*fs/1000);
        [loge,zc,nfrm]=analysis(xin,L,R,fs);
        sing_memo_loge_nr (:,k)=loge;
        sing_memo_zc_nr (:,k)=zc;
        clear xin loge zc
    end

    for kk=1:20
        fname2=fullfile(sub_path,char(baseline_wav_nr(kk)));
        [xin,fs]=audioread(fname2);
        baseline_audio_nr (:,kk)=xin;
        L=round(Lm*fs/1000);
        R=round(Rm*fs/1000);
        [loge,zc,nfrm]=analysis(xin,L,R,fs);
        baseline_loge_nr (:,kk)=loge;
        baseline_zc_nr (:,kk)=zc;
        clear xin loge zc j jj k kk fname1 fname2
    end
    cd(sub_path)
    save (['fs_audio_loge_zc_by_cond_' song '_',(fnames(sub).name)],'listen_audio_nr','listen_loge_nr','listen_zc_nr','sing_along_audio_nr','sing_along_loge_nr','sing_along_zc_nr','sing_memo_audio_nr','sing_memo_loge_nr','sing_memo_zc_nr','baseline_audio_nr','baseline_loge_nr','baseline_zc_nr','fs');
    clear listen_wav_nr sing_along_wav_nr sing_memo_wav_nr baseline_wav_nr
    end
end
