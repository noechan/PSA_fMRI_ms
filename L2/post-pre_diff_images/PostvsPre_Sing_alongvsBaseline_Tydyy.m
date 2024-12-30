function PostvsPre_Sing_alongvsBaseline_Tydyy(subjects, outdir, varargin)
%PostvsPre_Sing_alongvsBaseline_Tydyy
%----------------------------------------------------------------------------------------
% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct);
p.addRequired('outdir', @ischar);
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('L1dir', 'SPM_first_level', @ischar)
p.addParameter('L1folder', 'L1_dur0_explbase_microres72_art_explmask_TU_missed', @ischar)
p.addParameter('outfolder', 'Sing_along>Baseline', @ischar)

p.parse(subjects, outdir, varargin{:});
Arg = p.Results;

%Select pair of scans for each group
n=1; a=1;
for sbj = 1:size(subjects, 1)
    disp(subjects(sbj).name)
    if subjects(sbj).group==1
        ses_pre='ses-001'; ses_post='ses-002';
        sub_path_pre= fullfile(subjects(sbj).folder, subjects(sbj).name, ses_pre, Arg.derdir,Arg.L1dir, Arg.L1folder);
        cd(sub_path_pre), load('SPM.mat')
        con_idx_pre=find(ismember({SPM.xCon.name}, {'Sing_along>baseline Tydyy'}));
        if ~isempty(con_idx_pre)
            if con_idx_pre >9
                con_pre{sbj,1}=spm_select('List', fullfile(sub_path_pre),['^con_00' num2str(con_idx_pre) '.*\.nii$']);
            elseif con_idx_pre <10
                con_pre{sbj,1}=spm_select('List', fullfile(sub_path_pre),['^con_000' num2str(con_idx_pre) '.*\.nii$']);
            end
            con_fnames_pre{sbj,1}=fullfile(sub_path_pre, con_pre{sbj,1});
        end
        clear SPM
        sub_path_post= fullfile(subjects(sbj).folder, subjects(sbj).name, ses_post, Arg.derdir,Arg.L1dir, Arg.L1folder);
        cd(sub_path_post)
        load('SPM.mat')
        con_idx_post=find(ismember({SPM.xCon.name}, {'Sing_along>baseline Tydyy'}));
        if ~isempty(con_idx_post)
            if con_idx_post >9
                con_post{sbj,1}=spm_select('List', fullfile(sub_path_post),['^con_00' num2str(con_idx_post) '.*\.nii$']);
            elseif con_idx_post <10
                con_post{sbj,1}=spm_select('List', fullfile(sub_path_post),['^con_000' num2str(con_idx_post) '.*\.nii$']);
            end
            con_fnames_post{sbj,1}=fullfile(sub_path_post, con_post{sbj,1});
        end
        clear SPM
    elseif subjects(sbj).group==2
        ses_pre='ses-002'; ses_post='ses-003';
        sub_path_pre= fullfile(subjects(sbj).folder, subjects(sbj).name, ses_pre, Arg.derdir,Arg.L1dir, Arg.L1folder);
        cd(sub_path_pre), load('SPM.mat')
        con_idx_pre=find(ismember({SPM.xCon.name}, {'Sing_along>baseline Tydyy'}));
        if ~isempty(con_idx_pre)
            if con_idx_pre >9
                con_pre{sbj,1}=spm_select('List', fullfile(sub_path_pre),['^con_00' num2str(con_idx_pre) '.*\.nii$']);
            elseif ~isempty(con_idx_pre) && con_idx_pre <10
                con_pre{sbj,1}=spm_select('List', fullfile(sub_path_pre),['^con_000' num2str(con_idx_pre) '.*\.nii$']);
            end
            con_fnames_pre{sbj,1}=fullfile(sub_path_pre, con_pre{sbj,1});
        end
        clear SPM
        sub_path_post= fullfile(subjects(sbj).folder, subjects(sbj).name, ses_post, Arg.derdir,Arg.L1dir, Arg.L1folder);
        cd (sub_path_post), load('SPM.mat')
        con_idx_post=find(ismember({SPM.xCon.name}, {'Sing_along>baseline Tydyy'}));
        if ~isempty(con_idx_post)
            if con_idx_post >9
                con_post{sbj,1}=spm_select('List', fullfile(sub_path_post),['^con_00' num2str(con_idx_post) '.*\.nii$']);
            elseif con_idx_post <10
                con_post{sbj,1}=spm_select('List', fullfile(sub_path_post),['^con_000' num2str(con_idx_post) '.*\.nii$']);
            end
            con_fnames_post{sbj,1}=fullfile(sub_path_post, con_post{sbj,1});
        end
        clear SPM
    end
    
    if ~isempty(con_idx_pre) && ~isempty(con_idx_post)
        matlabbatch{n}.spm.util.imcalc.input = vertcat(con_fnames_pre(sbj,1), con_fnames_post(sbj,1));
        matlabbatch{n}.spm.util.imcalc.output =['Sing_along>baseline_Tydyy_Post>Pre_' subjects(sbj).name];
        matlabbatch{n}.spm.util.imcalc.outdir = {fullfile(outdir, Arg.outfolder)};
        matlabbatch{n}.spm.util.imcalc.expression = 'i2-i1';
        matlabbatch{n}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{n}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{n}.spm.util.imcalc.options.mask = 0;
        matlabbatch{n}.spm.util.imcalc.options.interp = 1;
        matlabbatch{n}.spm.util.imcalc.options.dtype = 4;
        n=n+1;
    else
        exclude_sbj{a,1}= subjects(sbj).name;
        a=a+1;
    end
end

spm_jobman ('interactive', matlabbatch)
