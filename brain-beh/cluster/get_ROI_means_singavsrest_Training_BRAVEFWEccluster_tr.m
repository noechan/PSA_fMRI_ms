% Get ROI means using MarsBar v0.45
% Remember to launch MarsBar from the SPM toolbox
clear()
marsbar_path='/Users/noeliamartinezmolina/spm12/toolbox/marsbar/';
roi_path='/Volumes/LASA/Aphasia_project/tb-fMRI/code_project/L2/behaviour/roi/';
code_path='/Volumes/LASA/Aphasia_project/tb-fMRI/code_project/L2/behaviour/';
output_path='/Volumes/LASA/Aphasia_project/tb-fMRI/results/behaviour/cluster/mean/';
addpath(marsbar_path)

%start MarsBar
marsbar('on')
%% Define rois
cd(roi_path)
roi_names=dir('*_trained_cluster.nii'); 
roi_names(1)=[]; %on macOS
for r=1:numel(roi_names)
    mars_img2rois(roi_names(r).name,roi_path, roi_names(r).name);
end
roi_mat=dir('*_trained_cluster_roi.mat');
roi_mat(1)=[]; %on macOS
for m=1:numel(roi_mat)
    roi_array{m} = maroi(fullfile(roi_path,roi_mat(m).name));
end
%% Define L1 contrasts
datadir= '/Volumes/LASA/Aphasia_project/tb-fMRI/results/post-pre_diff_images/';
Tydyy_folder= 'Tydyy';
Uulaa_folder= 'Uulaa';
contrast_folder='Sing_along>Baseline';

cd(code_path)
load('subjects_s3.mat')
subjects=subjects_s3;
 [num,txt,raw] =xlsread('LASA_group_BIDS_ses3.xlsx',1,'A2:E20');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
 group=num2cell(num(:,1)); 
 [subjects.group] =group{:}; 
% Exclude sub-06, not Tydyy image
group(4)=[]; subjects(4)=[];
for sbj =1:size(subjects, 1)
    disp(subjects(sbj).name)
    if subjects(sbj).group==1 % Trained Song Uulaa;
        postvspre_singavsrest_trained{sbj,1}=spm_select('List', fullfile(datadir, Uulaa_folder,contrast_folder,['Sing_along>baseline_Uulaa_Post>Pre_' subjects(sbj).name '.nii']));
        postvspre_singavsrest_trained_fnames{sbj,1}=fullfile(datadir,Uulaa_folder,contrast_folder,postvspre_singavsrest_trained{sbj,1});
    elseif subjects(sbj).group==2 % Trained Song Tydyy
        postvspre_singavsrest_trained{sbj,1}=spm_select('List', fullfile(datadir, Tydyy_folder,contrast_folder,['Sing_along>baseline_Tydyy_Post>Pre_' subjects(sbj).name '.nii']));
        postvspre_singavsrest_trained_fnames{sbj,1}=fullfile(datadir,Tydyy_folder,contrast_folder,postvspre_singavsrest_trained{sbj,1});
    end
end

cd(output_path)
%% Extract mean from rois 
%Session 1
c=0;
for roi_no = 1:length(roi_array)
roi = roi_array{roi_no};
for c_prepost=1:numel(postvspre_singavsrest_trained_fnames)
    V = spm_vol(postvspre_singavsrest_trained_fnames{c_prepost}); %load contrast file
    D = strvcat(V.fname); %load images into format for Marsbar  
    % Extract data
    Yprepost = get_marsy(roi,D, 'mean');%get the values
    [datamean_prepost datavar_prepost o_prepost] = summary_data(Yprepost, 'mean'); %assign the mean extractions for each ROI and each image to variable called datamean
    regionname = char(region_name(Yprepost)); %note the regionname   
    datamean_prepost_allsbj{c_prepost,1}=datamean_prepost; clear datamean_prepost datavar_prepost o_prepost
    datamean_prepost_allsbj{c_prepost,2}=regionname;
end
c=c+1;
end
datamean_prepost_allsbj(:,end+1)=group;
writecell(datamean_prepost_allsbj,'Brain-beh_singavsrest_Trained_BRAVE_FWEccluster_Trained_N19_prepost_mean.xlsx')
clear c roi 



