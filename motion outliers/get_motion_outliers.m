clear all, close all
data_path='/Volumes/LASA/Aphasia_project/tb-fMRI/data/LASA/';
code_path='/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/';
ses='ses-003';
der='derivatives';
prep='SPM_prepro';
func='func';
norm='normalize';

% Subjects fnames
subjects_s3_n19 = readtable(fullfile(code_path, 'motion outliers', 'subjects_s3_n19.csv'));
subjects_s3_n19 = table2cell(subjects_s3_n19);

%% Loop for subjects
n=1;
for sub=1:size(subjects_s3_n19,1)
   sub_path=fullfile(data_path,subjects_s3_n19{sub,1}, ses, der, prep, func, norm);
   
    %Get number of outliers
    rp_art_Tydyy=horzcat( 'art_regression_outliers_wror',subjects_s3_n19{sub,1}, '_', ses, '_task-tydyy_acq-multiband_bold_00001.mat');
    rp_art_Uulaa=horzcat( 'art_regression_outliers_wror',subjects_s3_n19{sub,1}, '_', ses,'_task-uulaa_acq-multiband_bold_00001.mat');
    cd(sub_path)
    load(rp_art_Tydyy); num_outliers_Tydyy{n}=size(R,2); sub_outliers_Tydyy{n}={subjects_s3_n19{sub,1}};
    load(rp_art_Uulaa); num_outliers_Uulaa{n}=size(R,2); sub_outliers_Uulaa{n}={subjects_s3_n19{sub,1}};
    n=n+1;
end

sub_rp_art_Tydyy=vertcat(sub_outliers_Tydyy, num_outliers_Tydyy);
sub_rp_art_Uulaa=vertcat(sub_outliers_Uulaa, num_outliers_Uulaa);
cd (fullfile(code_path, 'motion outliers'))
save(['sub_rp_art_Tydyy_' ses '.mat'], 'sub_rp_art_Tydyy')
save(['sub_rp_art_Uulaa_' ses '.mat'], 'sub_rp_art_Uulaa')

%% boxchart motion outliers
clear (), close()
ses='ses-003';
Tydyy=load(['sub_rp_art_Tydyy_' ses '.mat']);
Uulaa=load(['sub_rp_art_Uulaa_' ses '.mat']);

x1=cell2mat(Tydyy.sub_rp_art_Tydyy(2,:))';
x1name=(repmat({'Tydyy'},numel(x1),1));
x2=cell2mat(Uulaa.sub_rp_art_Uulaa(2,:))';
x2name=(repmat({'Uulaa'},numel(x1),1));

Allsongs=vertcat(x1, x2); 
Allsongsname=categorical(vertcat(x1name,x2name));
boxchart(Allsongsname,Allsongs)
hold on
mean_outliers=vertcat(mean(cell2mat(Tydyy.sub_rp_art_Tydyy(2,:))), mean(cell2mat(Uulaa.sub_rp_art_Uulaa(2,:)))); 
plot (mean_outliers,'-o'); 
title(['All Outliers ' ses])

savefig(gcf,['Patients Ses3 N19 TU Motion outliers ' ses '.fig'])
save(['motion_outliers_' ses '.mat'], 'x1','x2')
