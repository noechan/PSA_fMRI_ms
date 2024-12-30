%%% Quality assurance plots %%%
clear all, close all
startup
cohort='LASA2017';
prep='Noise_reduction';
song='Uulaa';
ses=['_3'];
fnames=dir(fullfile(data_path, cohort, prep,song)); 
fnames(ismember({fnames.name},{'.','..','PPA'}))=[];
%% Get variables to plot
c1=1; c2=1; c3=1; c4=1;
for sub=1:numel(fnames)
    sub_path=fullfile(data_path,cohort,prep,song, fnames(sub).name, [fnames(sub).name ses]);
    if exist(sub_path)==7
        cd(sub_path)
        if exist(['baseline_false_' song '_' (fnames(sub).name) '.mat'])==2
            load(fullfile(sub_path,(['baseline_false_' song '_' (fnames(sub).name)])))
            baseline_false_sub{c1,1}=fnames(sub).name;
            baseline_false_sub{c1,2}=numel(baseline_false);
            c1=c1+1; 
        end
       
        if exist(['listen_false_' song '_' (fnames(sub).name) '.mat'])==2
            load(fullfile(sub_path,(['listen_false_' song '_' (fnames(sub).name)])))
            listen_false_sub{c2,1}=fnames(sub).name;
            listen_false_sub{c2,2}=numel(listen_false);
            c2=c2+1; 
        end
        
        if exist(['sing_along_false_' song '_' (fnames(sub).name) '.mat'])==2
            load(fullfile(sub_path,(['sing_along_false_' song '_' (fnames(sub).name)])))
            sing_along_false_sub{c3,1}=fnames(sub).name;
            sing_along_false_sub{c3,2}=numel(sing_along_false);
            c3=c3+1; 
        end
        
        if exist(['sing_memo_false_' song '_' (fnames(sub).name) '.mat'])==2
            load(fullfile(sub_path,(['sing_memo_false_' song '_' (fnames(sub).name)])))
            sing_memo_false_sub{c4,1}=fnames(sub).name;
            sing_memo_false_sub{c4,2}=numel(sing_memo_false);
            c4=c4+1;
        end        
    end
end

baseline_false_sub
save(fullfile(code_path, ['false_trials_sub_' cohort '_' song ses '.mat']), 'baseline_false_sub', 'listen_false_sub', 'sing_along_false_sub', 'sing_memo_false_sub')

%%% RUN MANUALLY AFTER EXECUTING L1-49 FOR ALL COHORTS AND SESSIONS
%% Create plots
cd(code_path)
COH1='LASA2017'; COH2='LASA2019';
song='Uulaa';
ses=['_3'];
TCOH1=load(['false_trials_sub_' COH1 '_' song ses '.mat']);
TCOH2=load(['false_trials_sub_' COH2 '_' song ses '.mat']);

% summary statistics
baseline_sum(1,1)=mean(cell2mat(vertcat(TCOH1.baseline_false_sub(:,2),TCOH2.baseline_false_sub(:,2)))./20); %percent
listen_sum(1,1)=mean(cell2mat(vertcat(TCOH1.listen_false_sub(:,2),TCOH2.listen_false_sub(:,2)))./30); %percent
sing_along_sum(1,1)=mean(cell2mat(vertcat(TCOH1.sing_along_false_sub(:,2),TCOH2.sing_along_false_sub(:,2)))./30); %percent
sing_memo_sum(1,1)=mean(cell2mat(vertcat(TCOH1.sing_memo_false_sub(:,2),TCOH2.sing_memo_false_sub(:,2)))./30); %percent

baseline_sum(1,2)=mean(cell2mat(vertcat(TCOH1.baseline_false_sub(:,2),TCOH2.baseline_false_sub(:,2))));
listen_sum(1,2)=mean(cell2mat(vertcat(TCOH1.listen_false_sub(:,2),TCOH2.listen_false_sub(:,2))));
sing_along_sum(1,2)=mean(cell2mat(vertcat(TCOH1.sing_along_false_sub(:,2),TCOH2.sing_along_false_sub(:,2))));
sing_memo_sum(1,2)=mean(cell2mat(vertcat(TCOH1.sing_memo_false_sub(:,2),TCOH2.sing_memo_false_sub(:,2))));

save(['Trials_summary_' song '_ses' ses '.mat'], 'baseline_sum','listen_sum','sing_along_sum','sing_memo_sum')

% plot mean false trials
t=tiledlayout(1,4);

nexttile
x1=vertcat(cell2mat(TCOH1.baseline_false_sub(:,2)), cell2mat(TCOH2.baseline_false_sub(:,2)));
bar(x1,'k'); axis square
xticks(1:length(x1)); xticklabels(vertcat(TCOH1.baseline_false_sub(:,1),TCOH2.baseline_false_sub(:,1))'); xtickangle(45)
title(['Baseline False_' song '_ses' ses])

nexttile
x2=vertcat(cell2mat(TCOH1.listen_false_sub(:,2)), cell2mat(TCOH2.listen_false_sub(:,2)));
bar(x2,'w'); axis square
xticks(1:length(x2));xticklabels(vertcat(TCOH1.listen_false_sub(:,1),TCOH2.listen_false_sub(:,1))'); xtickangle(45)
title(['Listen False_' song '_ses' ses])

nexttile
x3=vertcat(cell2mat(TCOH1.sing_along_false_sub(:,2)), cell2mat(TCOH2.sing_along_false_sub(:,2)));
bar(x3,'m'); axis square; 
xticks(1:length(x3)); xticklabels(vertcat(TCOH1.sing_along_false_sub(:,1),TCOH2.sing_along_false_sub(:,1))'); xtickangle(45)
title(['Sing Along_' song '_ses' ses])

nexttile
x4=vertcat(cell2mat(TCOH1.sing_memo_false_sub(:,2)), cell2mat(TCOH2.sing_memo_false_sub(:,2)));
bar(x4,'b'); axis square; 
xticks(1:length(x4)); xticklabels(vertcat(TCOH1.sing_memo_false_sub(:,1),TCOH2.sing_memo_false_sub(:,1))'); xtickangle(45)
title(['Sing Memo_' song '_ses' ses])
savefig(gcf,['False Trials All' song '_ses' ses '.fig'])

figure
bar([mean(x1), mean(x2), mean(x3), mean(x4)]); axis square
xticklabels ({'baseline', 'listen', 'sing along', 'sing memo'})
title(['Group Mean False Trials' song '_ses' ses])
savefig(gcf,['Mean False Trials' song '_ses' ses '.fig'])
close all

% plot mean performance

x1=cell2mat(vertcat(TCOH1.baseline_false_sub(:,2),TCOH2.baseline_false_sub(:,2)))./20;
x1name=(repmat({'baseline'},numel(x1),1));
x2=cell2mat(vertcat(TCOH1.listen_false_sub(:,2),TCOH2.listen_false_sub(:,2)))./30;
x2name=(repmat({'listen'},numel(x2),1));
x3=cell2mat(vertcat(TCOH1.sing_along_false_sub(:,2),TCOH2.sing_along_false_sub(:,2)))./30;
x3name=(repmat({'sing_along'},numel(x3),1));
x4=cell2mat(vertcat(TCOH1.sing_memo_false_sub(:,2),TCOH2.sing_memo_false_sub(:,2)))./30;
x4name=(repmat({'sing_memo'},numel(x4),1));

AllTrials=vertcat(1.-x1,1.-x2,1.-x3,1.-x4); 
AllTrialsname=categorical(vertcat(x1name,x2name,x3name,x4name));
boxchart(AllTrialsname,AllTrials)
hold on
mean_performance=vertcat(1-baseline_sum(1,1), 1-listen_sum(1,1), 1-sing_along_sum(1,1), 1-sing_memo_sum(1,1));
plot (mean_performance,'-o'); 

title(['Singing Performance' song '_ses' ses])
savefig(gcf,['Singing Performance' song '_ses' ses '.fig'])

