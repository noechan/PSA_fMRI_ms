clearvars -except cohort prep song ses , close all
%% Load trial indices and get filenames
data_path='/Volumes/LASA/Aphasia_project/tb-fMRI/recordings';
load('/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/singing_performance/trial_idx.mat') 
fnames=dir(fullfile(data_path, cohort, prep,song));
fnames(ismember({fnames.name},{'.','..'}))=[];

for sub=1%:numel(fnames)
    sub_path=fullfile(data_path,cohort,prep,song, fnames(sub).name, [fnames(sub).name ses]);
    if exist(sub_path)==7
        cd(sub_path)
        load(['fs_audio_loge_zc_by_cond_' song '_' (fnames(sub).name)])%loads array with indices for listen, sing along, sing from memo and baseline trials
        %% Finding recordings with voice in sing memo trials
        ethreshold=10; %in dB
        zcthreshold=80; %crossings per 10msec interval
        a=1;aa=1;
        for m=1:size(sing_memo,1)
            [M,I]=max(sing_memo_loge_nr(:,m));
            if M > ethreshold
                sing_memo_true(a)=sing_memo(m);
                a=a+1;
            else
                if  I < 12 && mean (sing_memo_zc_nr([I:I+24],m)) < zcthreshold %Look for mean zc rate in the 960msec window centered the max location
                    sing_memo_true(a)=sing_memo(m);
                    a=a+1;
                elseif I >12 && I <= 385 && mean (sing_memo_zc_nr([I-12:I+12],m)) < zcthreshold %Look for mean zc rate in the 960msec window centered the max location
                    sing_memo_true(a)=sing_memo(m);
                    a=a+1;
                elseif I > 385 && mean (sing_memo_zc_nr([I-24:I],m)) < zcthreshold
                    sing_memo_true(a)=sing_memo(m);
                    a=a+1;
                else
                    sing_memo_false(aa)=sing_memo(m);
                    aa=aa+1;
                end
            end
            clear M I
        end

        if exist('sing_memo_false') ==1
            sing_memo_false=sing_memo_false';
            save (['sing_memo_false_' song '_' (fnames(sub).name)],'sing_memo_false');
        end
        if exist('sing_memo_true') ==1
            sing_memo_true=sing_memo_true';
            d=num2cell(sing_memo_true);
            save (['sing_memo_true_' song '_' (fnames(sub).name)],'sing_memo_true');
        end
        clear a aa

        %% Calculating index array for true conditions
        if exist('sing_memo_true') ==1
            d4=1;
            for w4=1:length (sing_memo_true)
                sing_memo_true_index(d4,1)= find (sing_memo(:,1)==sing_memo_true(w4));
                d4=d4+1;
            end
           save (['sing_memo_true_index_' song '_' (fnames(sub).name)],'sing_memo_true_index');
        end

        %% plot unvoiced signal from singing memo recording
        if exist('sing_memo_false')
            figure ('Visible','off'); % to open figure: openfig('figurename.fig', 'new','Visible')
            L=length(sing_memo_audio_nr);
            T=1/fs;
            t = (0:L-1)*T;
            for p=1:length (sing_memo_false)
                subplot (6,5,p)
                plot(t,sing_memo_audio_nr(:,find(sing_memo(:,1)==sing_memo_false(p))),'r','LineWidth',2),hold on,grid on;
                title (num2str(sing_memo_false(p)))
            end
            sgtitle('Sing Memo False')
            saveas(gcf,['sing_memo_false_' song '_' (fnames(sub).name) '.fig'])
        end

        %% plot voiced signal from singing memo recording
        if exist('sing_memo_true')
            figure ('Visible','off'); % to open figure: openfig('figurename.fig', 'new','Visible')
            L=length(sing_memo_audio_nr);
            T=1/fs;
            t = (0:L-1)*T;
            for p=1:length(sing_memo_true)
                subplot (6,5,p)
                plot(t,sing_memo_audio_nr(:,find(sing_memo(:,1)==sing_memo_true(p))),'r','LineWidth',2),hold on,grid on;
                title (num2str(sing_memo_true(p)))
            end
            sgtitle('Sing Memo True')
            saveas(gcf,['sing_memo_true_' song '_' (fnames(sub).name) '.fig'])
        end
    end
end