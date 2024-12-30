function SPM5_Normalize(subjects, varargin)

% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct);
p.addParameter('ses','ses-001', @ischar)
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('prepdir', 'SPM_prepro', @ischar)
p.addParameter('funcdir', 'func', @ischar)
p.addParameter('reo', 'reorient', @ischar)
p.addParameter('norm', 'normalize', @ischar)
p.addParameter('anatdir', 'anat', @ischar)

p.parse(subjects, varargin{:});
Arg = p.Results;

%% Loop for subjects
for sbj =1:size(subjects, 1)
    disp(subjects(sbj).name)
    sub_path= fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses, Arg.derdir, Arg.prepdir);

%% copy realigned & reoriented EPIs
    sub_path_func_src= fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses,Arg.derdir, Arg.prepdir, Arg.funcdir, Arg.reo);
    sub_path_func_dest= fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses,Arg.derdir, Arg.prepdir, Arg.funcdir, Arg.norm);
    srcfile_func= dir(fullfile(sub_path_func_src, 'rorsub*.nii'));
    
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
    roEPI = dir (fullfile(sub_path,Arg.funcdir,Arg.norm,'rorsub*.nii'));
    c1=1; c2=1;
    for r=1:size(roEPI,1)
        if contains(roEPI(r).name,'tydyy')
            roEPI_tydyy(c1,1)=roEPI(r);
            c1=c1+1;
        elseif contains(roEPI(r).name,'uulaa')
            roEPI_uulaa(c2,1)=roEPI(r);
            c2=c2+1;
        end
    end
    
     for i=1:size(roEPI_tydyy)
        fname_roEPI_tydyy{i,1}=fullfile(sub_path,Arg.funcdir,Arg.norm,roEPI_tydyy(i).name);
    end
    
    for j=1:size(roEPI_uulaa)
        fname_roEPI_uulaa{j,1}=fullfile(sub_path,Arg.funcdir,Arg.norm,roEPI_uulaa(j).name);
    end
matrix = spm_select('FPList', fullfile(sub_path, Arg.anatdir), 'seg_sn.*\.mat$');  


%% Run Old normalise
    clear matlabbatch
    matlabbatch{1}.spm.spatial.normalise.write.subj.matname = {matrix};
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = fname_roEPI_tydyy;
    matlabbatch{1}.spm.spatial.normalise.write.roptions.preserve = 0;
    matlabbatch{1}.spm.spatial.normalise.write.roptions.bb =[-78 -112 -65 
                                                              78 76 85];
    matlabbatch{1}.spm.spatial.normalise.write.roptions.vox = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.write.roptions.interp = 1;
    matlabbatch{1}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.normalise.write.roptions.prefix = 'w';
    
    matlabbatch{2}.spm.spatial.normalise.write.subj.matname = {matrix};
    matlabbatch{2}.spm.spatial.normalise.write.subj.resample =fname_roEPI_uulaa;
    matlabbatch{2}.spm.spatial.normalise.write.roptions.preserve = 0;
    matlabbatch{2}.spm.spatial.normalise.write.roptions.bb =[-78 -112 -65 
                                                              78 76 85];
    matlabbatch{2}.spm.spatial.normalise.write.roptions.vox = [2 2 2];
    matlabbatch{2}.spm.spatial.normalise.write.roptions.interp = 1;
    matlabbatch{2}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
    matlabbatch{2}.spm.spatial.normalise.write.roptions.prefix = 'w';     
  
   spm_jobman('run', matlabbatch)
   
   %% Loop to remove raw_data from new per-subject folder
for sbj = 1:size(subjects, 1)
    for rawi = 1:length(subjects(sbj).sourcesfunc)
        rwdt = fullfile(subjects(sbj).sourcesfunc(rawi).folder...
                        , subjects(sbj).sourcesfunc(rawi).name);
        if exist(rwdt, 'file'), delete(rwdt); end
    end
end
   
end

   
end


