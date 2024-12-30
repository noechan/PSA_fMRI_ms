function SPM6_Smoothing(subjects, varargin)

% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct);
p.addParameter('ses','ses-001', @ischar)
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('prepdir', 'SPM_prepro', @ischar)
p.addParameter('funcdir', 'func', @ischar)
p.addParameter('anatdir', 'anat', @ischar)
p.addParameter('norm', 'normalize', @ischar)
p.addParameter('smo', 'smoothing', @ischar)

p.parse(subjects, varargin{:});
Arg = p.Results;

%% Loop for subjects
for sbj = 1:size(subjects, 1)
    disp(subjects(sbj).name)
    sub_path= fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses, Arg.derdir, Arg.prepdir);
    
    %% copy normalised EPIs
    sub_path_func_src= fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses,Arg.derdir, Arg.prepdir, Arg.funcdir, Arg.norm);
    sub_path_func_dest= fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses,Arg.derdir, Arg.prepdir, Arg.funcdir, Arg.smo);
    srcfile_func= dir(fullfile(sub_path_func_src, 'wrorsub*.nii'));
    
    
            % Copy func scans
            if ~isfolder(sub_path_func_dest)
                mkdir(sub_path_func_dest)
            end
            for sf = 1:length(srcfile_func)
                if ~exist(fullfile(sub_path_func_dest, srcfile_func(sf).name), 'file')
                    copyfile(fullfile(srcfile_func(sf).folder, srcfile_func(sf).name), sub_path_func_dest)
                end
            end
            [srcfile_func.folder] = deal(sub_path_func_dest);
            subjects(sbj).sourcesfunc = srcfile_func;  
    
 %% Specify inputs   
    wroEPI = dir (fullfile(sub_path,Arg.funcdir,Arg.norm,'wrorsub*.nii'));
    c1=1; c2=1;
    for r=1:size(wroEPI,1)
        if contains(wroEPI(r).name,'tydyy')
            wroEPI_tydyy(c1,1)=wroEPI(r);
            c1=c1+1;
        elseif contains(wroEPI(r).name,'uulaa')
            wroEPI_uulaa(c2,1)=wroEPI(r);
            c2=c2+1;
        end
    end
    
     for i=1:size(wroEPI_tydyy)
        fname_wroEPI_tydyy{i,1}=fullfile(sub_path,Arg.funcdir,Arg.smo,wroEPI_tydyy(i).name);
    end
    
    for j=1:size(wroEPI_uulaa)
        fname_wroEPI_uulaa{j,1}=fullfile(sub_path,Arg.funcdir,Arg.smo,wroEPI_uulaa(j).name);
    end


    clear matlabbatch
    matlabbatch{1}.spm.spatial.smooth.data = fname_wroEPI_tydyy;
    matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';
    matlabbatch{2}.spm.spatial.smooth.data = fname_wroEPI_uulaa;
    matlabbatch{2}.spm.spatial.smooth.fwhm = [8 8 8];
    matlabbatch{2}.spm.spatial.smooth.dtype = 0;
    matlabbatch{2}.spm.spatial.smooth.im = 0;
    matlabbatch{2}.spm.spatial.smooth.prefix = 's';

    spm_jobman ('run', matlabbatch)
    
       
   %% Loop to remove raw_data from new per-subject folder
for sbj = 1:size(subjects, 1)
    for rawi = 1:length(subjects(sbj).sourcesfunc)
        rwdt = fullfile(subjects(sbj).sourcesfunc(rawi).folder...
                        , subjects(sbj).sourcesfunc(rawi).name);
        if exist(rwdt, 'file'), delete(rwdt); end
    end
end

end

