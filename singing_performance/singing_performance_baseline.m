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
        %% Finding recordings with voice in baseline trials
        ethreshold=10; %in dB
        zcthreshold=80; %crossings per 10msec interval
        b=1;bb=1;
        for n=1:size(baseline,1)
            [M,I]=max(baseline_loge_nr(:,n));
            if M > ethreshold
                baseline_false(b)=baseline(n);
                b=b+1;
            else
                if  I < 12 && mean (baseline_zc_nr([I:I+24],n)) < zcthreshold %Look for mean zc rate in the 960msec window centered the max location
                    baseline_false(b)=baseline(n);
                    b=b+1;
                elseif I >12 && I <= 385 && mean (baseline_zc_nr([I-12:I+12],n)) < zcthreshold %Look for mean zc rate in the 960msec window centered the max location
                    baseline_false(b)=baseline(n);
                    b=b+1;
                elseif I > 385 && mean (baseline_zc_nr([I-24:I],n)) < zcthreshold
                    baseline_false(b)=baseline(n);
                    b=b+1;
                else
                    baseline_true(bb)=baseline(n);
                    bb=bb+1;
                end
            end
            clear M I
        end

        if exist('baseline_false') ==1
            baseline_false=baseline_false';
            save (['baseline_false_' song '_' (fnames(sub).name)],'baseline_false');
        end

        if exist('baseline_true') ==1
            baseline_true=baseline_true';
            a=num2cell(baseline_true);
            save (['baseline_true_' song '_' (fnames(sub).name)],'baseline_true');
        end

        %% Calculating index array for true conditions
        if exist('baseline_true') ==1
            d2=1;
            for w2=1:length (baseline_true)
                baseline_true_index (d2,1)= find (baseline(:,1)==baseline_true(w2));
                d2=d2+1;
            end
            save (['baseline_true_index_' song '_' (fnames(sub).name)],'baseline_true_index');
        end

        %% plot voiced signal from baseline recording
        if exist('baseline_false')==1
            figure ('Visible','off'); % to open figure: openfig('figurename.fig', 'new','Visible')
            L=length(baseline_audio_nr);
            T=1/fs;
            t = (0:L-1)*T;
            for p=1:length (baseline_false)
                subplot (5,4,p)
                plot(t,baseline_audio_nr(:, find(baseline(:,1)==baseline_false(p))),'r','LineWidth',2),hold on,grid on;
                title (num2str(baseline_false(p)))
            end
            sgtitle('Baseline False')
            saveas(gcf,['baseline_false_' song '_' (fnames(sub).name) '.fig'])
        end

        %% plot unvoiced signal from baseline recording
        if exist('baseline_true')==1
            figure ('Visible','off'); % to open figure: openfig('figurename.fig', 'new','Visible')
            L=length(baseline_audio_nr);
            T=1/fs;
            t = (0:L-1)*T;
            for p=1:length (baseline_true)
                subplot (5,4,p)
                plot(t,baseline_audio_nr(:,find(baseline(:,1)==baseline_true(p))),'r','LineWidth',2),hold on,grid on;
                title (num2str(baseline_true(p)))
            end
            sgtitle('Baseline True')
            saveas(gcf,['baseline_true_' song '_' (fnames(sub).name) '.fig'])
        end

    end
end