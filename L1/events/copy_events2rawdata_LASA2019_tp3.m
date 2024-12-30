clear all
source_path='/Volumes/LASA/Aphasia_project/tb-fMRI/recordings/LASA2019/Noise_reduction/';
dest_path='/Volumes/LASA/Aphasia_project/tb-fMRI/data/LASA/';
panames=dir(fullfile(source_path,'Tydyy'));
panames(ismember({panames.name},{'.','..','ID135','ID136','ID137','ID148','ID149','ID158','PPA'}))=[];

for n=1:numel(panames)
    if strcmp(panames(n).name,'ID138')==1
        sub=1;
    elseif strcmp(panames(n).name,'ID139')==1
        sub=2;
    elseif strcmp(panames(n).name,'ID140')==1
        sub=3;
    elseif strcmp(panames(n).name,'ID142')==1
        sub=4;
    elseif strcmp(panames(n).name,'ID145')==1
        sub=5;
    elseif strcmp(panames(n).name,'ID146')==1
        sub=6;
    elseif strcmp(panames(n).name,'ID150')==1
        sub=7;
    elseif strcmp(panames(n).name,'ID153')==1
        sub=8;
    end

    if sub<=9
        uulaa_events=strcat('sub-0',num2str(sub),'_ses-003_task-uulaa_acq-multiband_events_check.mat');
        tydyy_events=strcat('sub-0',num2str(sub),'_ses-003_task-tydyy_acq-multiband_events_check.mat');
    else
        uulaa_events=strcat('sub-',num2str(sub),'_ses-003_task-uulaa_acq-multiband_events_check.mat');
        tydyy_events=strcat('sub-',num2str(sub),'_ses-003_task-tydyy_acq-multiband_events_check.mat');
    end
    
    if sub<=9
        sub_path2=fullfile(dest_path, ['sub-0' num2str(sub)],'ses-003','derivatives', 'SPM_prepro','func','events');
    else
        sub_path2=fullfile(dest_path, ['sub-' num2str(sub)],'ses-003','derivatives', 'SPM_prepro','func','events');
    end
    
    sub_path_T=fullfile(source_path, 'Tydyy',panames(n).name, [panames(n).name '_3'], 'func','Triggers');
    cd(sub_path_T)

    Tydyy=dir('*Tydyy*'); Tydyy([1 2])=[];
    for j=1:numel(Tydyy,1)
        tydyy_source= char(regexp(Tydyy(j).name, '.*reg.*', 'match'));
        if ~isempty(tydyy_source)
            break
        end
    end
    copyfile(fullfile(sub_path_T,tydyy_source), fullfile(sub_path2,tydyy_events))
      
    sub_path_U=fullfile(source_path, 'Uulaa',panames(n).name, [panames(n).name '_3'], 'func','Triggers');
    cd(sub_path_U)
    Uulaa=dir('*Uulaa*'); Uulaa([1 2])=[];
    for j=1:numel(Uulaa,1)
        uulaa_source= char(regexp(Uulaa(j).name, '.*reg.*', 'match'));
        if ~isempty(uulaa_source)
            break
        end
    end
    copyfile(fullfile(sub_path_U,uulaa_source), fullfile(sub_path2,uulaa_events))
end
