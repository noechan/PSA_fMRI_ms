% Get ROI means using MarsBar v0.45
% Remember to launch MarsBar from the SPM toolbox
clear()
marsbar_path='/Users/noeliamartinezmolina/spm12/toolbox/marsbar/';
roi_path='/Volumes/LASA/Aphasia_project/tb-fMRI/code_project/L2/behaviour/roi/';
contrast_path='/Volumes/LASA/Aphasia_project/tb-fMRI/results/post-pre_diff_images/TrainedvsUntrained/Sing_along>Baseline/';
code_path='/Volumes/LASA/Aphasia_project/tb-fMRI/code_project/L2/behaviour/';
output_path='/Volumes/LASA/Aphasia_project/tb-fMRI/results/behaviour/cluster/mean/';
addpath(marsbar_path)

%start MarsBar
marsbar('on')
%% Define rois
cd(roi_path)
roi_names=dir('*trainedvsuntrained_cluster.nii'); 
for r=1:numel(roi_names)
    mars_img2rois(roi_names(r).name,roi_path, roi_names(r).name);
end
roi_mat=dir('*trainedvsuntrained_cluster_roi.mat');
roi_mat(1)=[]; %on macOS
for m=1:numel(roi_mat)
    roi_array{m} = maroi(fullfile(roi_path,roi_mat(m).name));
end
%% Define contrasts
cd(contrast_path)
postvspre_singavsrest_TRvsUTR=dir('Sing_along>baseline_TRvsUTR*');

%% Define groups
cd(code_path)
load('subjects_s3.mat')
subjects=subjects_s3;
 [num,txt,raw] =xlsread('LASA_group_BIDS_ses3.xlsx',1,'A2:E20');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
 group=num2cell(num(:,1)); 
 [subjects.group] =group{:}; 
% Exclude sub-06, not Tydyy image
group(4)=[]; subjects(4)=[];

cd(output_path)
%% Extract mean from rois 
%Session 1
c=0;
for roi_no = 1:length(roi_array)
roi = roi_array{roi_no};
for c_prepost=1:numel(postvspre_singavsrest_TRvsUTR)
    V = spm_vol(fullfile(postvspre_singavsrest_TRvsUTR(c_prepost).folder,postvspre_singavsrest_TRvsUTR(c_prepost).name)); %load contrast file
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
writecell(datamean_prepost_allsbj,'Brain-beh_singavsrest_TrRvsUTR_BRAVE_FWEccluster_TRvsUTR_N19_prepost_mean.xlsx')
clear c roi 



