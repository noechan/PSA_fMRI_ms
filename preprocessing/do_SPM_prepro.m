%% Initialise inputs, pathnames 
rawdir = 'G:\Aphasia_project\data\raw_data';
subjects = build_dataset(rawdir);
outdir = 'G:\Aphasia_project\data\raw_data';

%% Build datasets for multiple sessions
s1=1;s2=1;s3=1;
for sbji = 1:size(subjects, 1)
    sub_path=fullfile(subjects(sbji).folder, subjects(sbji).name);
    ses=dirflt(sub_path);
    if numel(ses)==3
        if ismember({ses(1).name}, {'ses-001'})
            Idx_s1(s1,1)=sbji; 
            s1=s1+1;
        end
        if ismember({ses(2).name}, {'ses-002'})
            Idx_s2(s2,1)=sbji; 
            s2=s2+1;
        end
        if ismember({ses(3).name}, {'ses-003'})
            Idx_s3(s3,1)=sbji;
            s3=s3+1;
        end
    end
    if numel(ses)==2
        if ismember({ses(1).name}, {'ses-001'})
            Idx_s1(s1,1)=sbji; 
            s1=s1+1;
        end
        if ismember({ses(2).name}, {'ses-002'})
            Idx_s2(s2,1)=sbji; 
            s2=s2+1;
        end
        if ismember({ses(2).name}, {'ses-003'})
            Idx_s3(s3,1)=sbji; 
            s3=s3+1;
        end
    end
    if numel(ses)==1
        if ismember({ses(1).name}, {'ses-001'})
            Idx_s1(s1,1)=sbji; 
            s1=s1+1;
        end
    end
end
   
subjects_s1=subjects(Idx_s1); subjects_s2=subjects(Idx_s2); subjects_s3=subjects(Idx_s3); 
%sub4 ses-001 incomplete Tydyy task
   
% Do preprocess
SPM_prepro_wrapper(subjects_s1(24),outdir)
