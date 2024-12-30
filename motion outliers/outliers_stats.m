% Load data
clear all
load('motion_outliers_ses-001.mat')
Tydyy_ses1=x1; Uulaa_ses1=x2; clear x1 x2
load('motion_outliers_ses-002.mat')
Tydyy_ses2=x1; Uulaa_ses2=x2; clear x1 x2
load('motion_outliers_ses-003.mat')
Tydyy_ses3=x1; Uulaa_ses3=x2; clear x1 x2

% One-way ANOVA

[p,tbl,stats]=anova1([Tydyy_ses1 Tydyy_ses2 Tydyy_ses3]);
p_Tydyy_anova1=p; clear p tbl stats 
[p,tbl,stats]=anova1([Uulaa_ses1 Tydyy_ses2 Tydyy_ses3]);
p_Uulaa_anova1=p; clear p tbl stats

% paired T test
[h,p,ci,stats] = ttest(Tydyy_ses1, Uulaa_ses1); 
p_TU_ses1=p; clear h p ci stats
[h,p,ci,stats] = ttest(Tydyy_ses2, Uulaa_ses2);
p_TU_ses2=p; clear h p ci stats
[h,p,ci,stats] = ttest(Tydyy_ses3, Uulaa_ses3);
p_TU_ses3=p; clear h p ci stats

save('outliers_stats.mat', 'p_Tydyy_anova1', 'p_Uulaa_anova1', 'p_TU_ses1', 'p_TU_ses2', 'p_TU_ses3')
