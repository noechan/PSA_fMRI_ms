%%% Quality assurance plots %%%
clear all, close all
startup
prep='Noise_reduction';
song='Tydyy';
ses=['_1'];
% Subjects fnames
subjects_s3 = readtable(fullfile(code_path, 'subjects_s3.csv'));
subjects_s3 = table2cell(subjects_s3);
%% Get variables to plot
c1=1; c2=1; c3=1; c4=1;
for sub=1:size(subjects_s3,1)
    if sub>13
        cohort='LASA2019';
    else
        cohort='LASA2017';
    end
    sub_path=fullfile(data_path,cohort,prep,song, subjects_s3{sub,2}, [subjects_s3{sub,2} ses]);
    if exist(sub_path)==7
        cd(sub_path)
        if exist(['baseline_false_' song '_' subjects_s3{sub,2} '.mat'])==2
            load(fullfile(sub_path,(['baseline_false_' song '_' subjects_s3{sub,2}])))
            baseline_false_sub{c1,1}=subjects_s3{sub,2};
            baseline_false_sub{c1,2}=numel(baseline_false);
            c1=c1+1; 
        end
       
        if exist(['listen_false_' song '_' subjects_s3{sub,2} '.mat'])==2
            load(fullfile(sub_path,(['listen_false_' song '_' subjects_s3{sub,2}])))
            listen_false_sub{c2,1}=subjects_s3{sub,2};
            listen_false_sub{c2,2}=numel(listen_false);
            c2=c2+1; 
        end
        
        if exist(['sing_along_false_' song '_' subjects_s3{sub,2} '.mat'])==2
            load(fullfile(sub_path,(['sing_along_false_' song '_' subjects_s3{sub,2}])))
            sing_along_false_sub{c3,1}=subjects_s3{sub,2};
            sing_along_false_sub{c3,2}=numel(sing_along_false);
            c3=c3+1; 
        end
        
        if exist(['sing_memo_false_' song '_' subjects_s3{sub,2} '.mat'])==2
            load(fullfile(sub_path,(['sing_memo_false_' song '_' subjects_s3{sub,2}])))
            sing_memo_false_sub{c4,1}=subjects_s3{sub,2};
            sing_memo_false_sub{c4,2}=numel(sing_memo_false);
            c4=c4+1;
        end        
    end
end

save(fullfile(code_path, ['pathwithallses_false_trials_sub_' song ses '.mat']), 'baseline_false_sub', 'listen_false_sub', 'sing_along_false_sub', 'sing_memo_false_sub')

%% Create plots
cd(code_path)
song=['Tydyy'];
ses=['_1'];
T=load(['pathwithallses_false_trials_sub_' song ses '.mat']);

% summary statistics
baseline_sum(1,1)=mean(cell2mat(T.baseline_false_sub(:,2))./20); %percent
listen_sum(1,1)=mean(cell2mat(T.listen_false_sub(:,2))./30); %percent
sing_along_sum(1,1)=mean(cell2mat(T.sing_along_false_sub(:,2))./30); %percent
sing_memo_sum(1,1)=mean(cell2mat(T.sing_memo_false_sub(:,2))./30); %percent

baseline_sum(1,2)=mean(cell2mat(T.baseline_false_sub(:,2)));
listen_sum(1,2)=mean(cell2mat(T.listen_false_sub(:,2)));
sing_along_sum(1,2)=mean(cell2mat(T.sing_along_false_sub(:,2)));
sing_memo_sum(1,2)=mean(cell2mat(T.sing_memo_false_sub(:,2)));

save(['pathwithallses_Trials_summary_' song '_ses' ses '.mat'], 'baseline_sum','listen_sum','sing_along_sum','sing_memo_sum')

% plot mean false trials
t=tiledlayout(1,4);

nexttile
x1=cell2mat(T.baseline_false_sub(:,2));
bar(x1,'k'); axis square
xticks(1:length(x1)); xticklabels(T.baseline_false_sub(:,1)); xtickangle(45)
title(['Baseline False_' song '_ses' ses])

nexttile
x2=cell2mat(T.listen_false_sub(:,2));
bar(x2,'w'); axis square
xticks(1:length(x2));xticklabels(T.listen_false_sub(:,1)); xtickangle(45)
title(['Listen False_' song '_ses' ses])

nexttile
x3=cell2mat(T.sing_along_false_sub(:,2));
bar(x3,'m'); axis square; 
xticks(1:length(x3)); xticklabels(T.sing_along_false_sub(:,1)); xtickangle(45)
title(['Sing Along_' song '_ses' ses])

nexttile
x4=cell2mat(T.sing_memo_false_sub(:,2));
bar(x4,'b'); axis square; 
xticks(1:length(x4)); xticklabels(T.sing_memo_false_sub(:,1)); xtickangle(45)
title(['Sing Memo_' song '_ses' ses])
savefig(gcf,['Patients with all ses False Trials All' song '_ses' ses '.fig'])

figure
bar([mean(x1), mean(x2), mean(x3), mean(x4)]); axis square
xticklabels ({'baseline', 'listen', 'sing along', 'sing memo'})
title(['Group Mean False Trials' song '_ses' ses])
savefig(gcf,['Patients with all ses Mean False Trials' song '_ses' ses '.fig'])
close all

% plot mean performance

x1=cell2mat(T.baseline_false_sub(:,2))./20;
x1name=(repmat({'baseline'},numel(x1),1));
x2=cell2mat(T.listen_false_sub(:,2))./30;
x2name=(repmat({'listen'},numel(x2),1));
x3=cell2mat(T.sing_along_false_sub(:,2))./30;
x3name=(repmat({'sing_along'},numel(x3),1));
x4=cell2mat(T.sing_memo_false_sub(:,2))./30;
x4name=(repmat({'sing_memo'},numel(x4),1));

AllTrials=vertcat(1.-x1,1.-x2,1.-x3,1.-x4); 
AllTrialsname=categorical(vertcat(x1name,x2name,x3name,x4name));
boxchart(AllTrialsname,AllTrials)
hold on
mean_performance=vertcat(1-baseline_sum(1,1), 1-listen_sum(1,1), 1-sing_along_sum(1,1), 1-sing_memo_sum(1,1));
plot (mean_performance,'-o'); 

title(['Singing Performance' song '_ses' ses])
savefig(gcf,['Patients with All Ses Singing Performance' song '_ses' ses '.fig'])

% plot overall mean performance in both songs

clear all
ses=['_1'];
Tydyy=load(['pathwithallses_false_trials_sub_Tydyy' ses '.mat']);
Uulaa=load(['pathwithallses_false_trials_sub_Uulaa' ses '.mat']);

Tydyy_sum=load(['pathwithallses_Trials_summary_Tydyy_ses' ses '.mat']);
Uulaa_sum=load(['pathwithallses_Trials_summary_Uulaa_ses' ses '.mat']);

TU_baseline_sum=mean(vertcat(Tydyy_sum.baseline_sum(1,1), Uulaa_sum.baseline_sum(1,1)));
TU_listen_sum=mean(vertcat(Tydyy_sum.listen_sum(1,1), Uulaa_sum.listen_sum(1,1)));
TU_sing_along_sum=mean(vertcat(Tydyy_sum.sing_along_sum(1,1), Uulaa_sum.sing_along_sum(1,1)));
TU_sing_memo_sum=mean(vertcat(Tydyy_sum.sing_memo_sum(1,1), Uulaa_sum.sing_memo_sum(1,1)));

x1=cell2mat(vertcat(Tydyy.baseline_false_sub(:,2), Uulaa.baseline_false_sub(:,2)))./20;
x1name=(repmat({'baseline'},numel(x1),1));
x2=cell2mat(vertcat(Tydyy.listen_false_sub(:,2), Uulaa.listen_false_sub(:,2)))./30;
x2name=(repmat({'listen'},numel(x2),1));
x3=cell2mat(vertcat(Tydyy.sing_along_false_sub(:,2), Uulaa.sing_along_false_sub(:,2)))./30;
x3name=(repmat({'sing_along'},numel(x3),1));
x4=cell2mat(vertcat(Tydyy.sing_memo_false_sub(:,2), Uulaa.sing_memo_false_sub(:,2)))./30;
x4name=(repmat({'sing_memo'},numel(x4),1));

AllTrials=vertcat(1.-x1,1.-x2,1.-x3,1.-x4); 
AllTrialsname=categorical(vertcat(x1name,x2name,x3name,x4name));
boxchart(AllTrialsname,AllTrials)
hold on
mean_performance=vertcat(1-TU_baseline_sum(1,1), 1-TU_listen_sum(1,1), 1-TU_sing_along_sum(1,1), 1-TU_sing_memo_sum(1,1));
plot (mean_performance,'-o'); 

title(['TU Singing Performance_ses' ses])
savefig(gcf,['Patients With all Ses TU Singing Performance_ses' ses '.fig'])

