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
        %% Finding recordings with voice in listen trials
        ethreshold=10; %in dB
        zcthreshold=80; %crossings per 10msec interval
        a=1;aa=1;
        for m=1:size(listen,1)
            [M,I]=max(listen_loge_nr(:,m));
            if M > ethreshold
                listen_false(a)=listen(m,1);
                a=a+1;
            else
                if  I < 12 && mean (listen_zc_nr([I:I+24],m)) < zcthreshold %Look for mean zc rate in the 960msec window centered the max location
                    listen_false(a)=listen(m,1);
                    a=a+1;
                elseif I >12 && I <= 385 && mean (listen_zc_nr([I-12:I+12],m)) < zcthreshold %Look for mean zc rate in the 960msec window centered the max location
                    listen_false(a)=listen(m,1);
                    a=a+1;
                elseif I > 385 && mean (listen_zc_nr([I-24:I],m)) < zcthreshold
                    listen_false(a)=listen(m,1);
                    a=a+1;
                else
                    listen_true(aa)=listen(m,1);
                    aa=aa+1;
                end
            end
            clear M I
        end

        if exist('listen_false') ==1
            listen_false=listen_false';
            save (['listen_false_' song '_' (fnames(sub).name)],'listen_false');
        end

        if exist('listen_true') ==1
            listen_true=listen_true';
            b=num2cell(listen_true);
             save (['listen_true_' song '_' (fnames(sub).name)],'listen_true');
        end
        clear a aa

        %% Calculating index array for true conditions
        if exist('listen_true') ==1
            d1=1;
            for w1=1:length (listen_true)
                listen_true_index (d1,1)= find (listen(:,1)==listen_true(w1));
                d1=d1+1;
            end
             save (['listen_true_index_' song '_' (fnames(sub).name)],'listen_true_index');
        end

        %% plot voiced signal from listen recording
        if exist('listen_false')
            figure ('Visible','off'); % to open figure: openfig('figurename.fig', 'new','Visible')
            L=length(listen_audio_nr);
            T=1/fs;
            t = (0:L-1)*T;
            for p=1:length (listen_false)
                subplot (6,5,p)
                plot(t,listen_audio_nr(:,find(listen(:,1)==listen_false(p))),'r','LineWidth',2),hold on,grid on;
                title (num2str(listen_false(p)))
            end
            sgtitle('Listen False')
             saveas(gcf,['listen_false_' song '_' (fnames(sub).name) '.fig'])
        end
        %% plot unvoiced signal from listen recording
        if exist('listen_true')
            figure ('Visible','off'); % to open figure: openfig('figurename.fig', 'new','Visible')
            L=length(listen_audio_nr);
            T=1/fs;
            t = (0:L-1)*T;
            for p=1:length(listen_true)
                subplot (6,5,p)
                plot(t,listen_audio_nr(:,find(listen(:,1)==listen_true(p))),'r','LineWidth',2),hold on,grid on;
                title (num2str(listen_true(p)))
            end
            sgtitle('Listen True')
            saveas(gcf,['listen_true_' song '_' (fnames(sub).name) '.fig'])
        end
    end
end