function SPM4_Segment(subjects, outdir,varargin)

% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct);
p.addParameter('ses','ses-001', @ischar)
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('prepdir', 'SPM_prepro', @ischar)
p.addParameter('funcdir', 'func', @ischar)
p.addParameter('anatdir', 'anat', @ischar)

p.parse(subjects, varargin{:});
Arg = p.Results;

for sbj = 1:size(subjects, 1)
    disp(subjects(sbj).name)
    sub_path= fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses, Arg.derdir, Arg.prepdir);
    
    %% copy normalised EPIs
    sub_path_func_src= fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses, Arg.derdir, Arg.prepdir);
    sub_path_func_dest= fullfile(outdir, subjects(sbj).name, Arg.ses,Arg.derdir, Arg.prepdir, Arg.funcdir, Arg.smodir);
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
    clear matlabbatch
    if ~strcmp(subjects(sbj).name,'sub-24') && ~strcmp(subjects(sbj).name,'sub-31') && ~strcmp(subjects(sbj).name,'sub-32') && ~strcmp(subjects(sbj).name,'sub-33') && ~strcmp(subjects(sbj).name,'sub-35')
        cr= dir (fullfile(sub_path,Arg.anatdir,'*ro*.nii'));
        for r=1:size(cr,1)
            if contains(cr(r).name,'roT1w')
                cr_T1=cr(r);
            elseif contains(cr(r).name,'roLESION')
                cr_LESION=cr(r);
            end
        end  
        
        % mask out lesion voxels
        matlabbatch{1}.spm.tools.cat.tools.maskimg.data = cellstr([fullfile(sub_path,Arg.anatdir,cr_T1.name) ',1']);
        matlabbatch{1}.spm.tools.cat.tools.maskimg.mask = cellstr([fullfile(sub_path,Arg.anatdir,cr_LESION.name) ',1']);
        matlabbatch{1}.spm.tools.cat.tools.maskimg.bmask = {''};
        matlabbatch{1}.spm.tools.cat.tools.maskimg.recalc = 1;
        matlabbatch{1}.spm.tools.cat.tools.maskimg.prefix = 'msk_';
        spm_jobman ('run', matlabbatch);
        
        % invert lesion mask
        matlabbatch{2}.spm.util.imcalc.input =cellstr([fullfile(sub_path,Arg.anatdir,cr_LESION.name) ',1']);
        matlabbatch{2}.spm.util.imcalc.output =['inv_' cr_LESION.name];
        matlabbatch{2}.spm.util.imcalc.outdir = cellstr(fullfile(sub_path,Arg.anatdir));
        matlabbatch{2}.spm.util.imcalc.expression = '(i1.*-1)+1';
        matlabbatch{2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{2}.spm.util.imcalc.options.mask = 0;
        matlabbatch{2}.spm.util.imcalc.options.interp = 1;
        matlabbatch{2}.spm.util.imcalc.options.dtype = 4;
        spm_jobman ('run', matlabbatch);
        
        % segment        
        matlabbatch{3}.spm.tools.oldseg.data = cellstr([fullfile(sub_path,Arg.anatdir,['msk_' cr_T1.name]) ',1']);
        matlabbatch{3}.spm.tools.oldseg.output.GM = [0 0 1]; %native space
        matlabbatch{3}.spm.tools.oldseg.output.WM = [0 0 1]; %native space
        matlabbatch{3}.spm.tools.oldseg.output.CSF = [0 0 1]; %native space, to calculate TIV
        matlabbatch{3}.spm.tools.oldseg.output.biascor = 1;
        matlabbatch{3}.spm.tools.oldseg.output.cleanup = 1; %light cleanup
        matlabbatch{3}.spm.tools.oldseg.opts.tpm = {
            'C:\Program Files\spm12\toolbox\OldSeg\TPM_00001.nii' %Grey TPM from SPM12 based on the IXI 555 MNI152 extracted with spm_file_split
            'C:\Program Files\spm12\toolbox\OldSeg\TPM_00002.nii' %White TPM from SPM12 based on the IXI 555 MNI152 extracted with spm_file_split
            'C:\Program Files\spm12\toolbox\OldSeg\TPM_00003.nii' %CSF TPM from SPM12 based on the IXI 555 MNI152 extracted with spm_file_split
            };
        matlabbatch{3}.spm.tools.oldseg.opts.ngaus = [2
            2
            2
            4];
        matlabbatch{3}.spm.tools.oldseg.opts.regtype = 'mni';
        matlabbatch{3}.spm.tools.oldseg.opts.warpreg = 1;
        matlabbatch{3}.spm.tools.oldseg.opts.warpco = 25;
        matlabbatch{3}.spm.tools.oldseg.opts.biasreg = 0.01;%medium regularisation
        matlabbatch{3}.spm.tools.oldseg.opts.biasfwhm = 60;
        matlabbatch{3}.spm.tools.oldseg.opts.samp = 3;
        matlabbatch{3}.spm.tools.oldseg.opts.msk = cellstr([fullfile(sub_path,Arg.anatdir,['inv_' cr_LESION.name]) ',1']);
        
        spm_jobman('run',matlabbatch)
 
    else
        cr_T1= dir (fullfile(sub_path,Arg.anatdir,'*ro*.nii'));        
        clear matlabbatch
        matlabbatch{1}.spm.tools.oldseg.data = cellstr([fullfile(sub_path,Arg.anatdir,cr_T1.name) ',1']);
        matlabbatch{1}.spm.tools.oldseg.output.GM = [0 0 1]; %native space
        matlabbatch{1}.spm.tools.oldseg.output.WM = [0 0 1]; %native space
        matlabbatch{1}.spm.tools.oldseg.output.CSF = [0 0 1];%native space, to calculate TIV
        matlabbatch{1}.spm.tools.oldseg.output.biascor = 1;
        matlabbatch{1}.spm.tools.oldseg.output.cleanup = 1; %light cleanup
        matlabbatch{1}.spm.tools.oldseg.opts.tpm = {
            'C:\Program Files\spm12\toolbox\OldSeg\TPM_00001.nii' %Grey TPM from SPM12 based on the IXI 555 MNI152 extracted with spm_file_split
            'C:\Program Files\spm12\toolbox\OldSeg\TPM_00002.nii' %White TPM from SPM12 based on the IXI 555 MNI152 extracted with spm_file_split
            'C:\Program Files\spm12\toolbox\OldSeg\TPM_00003.nii' %CSF TPM from SPM12 based on the IXI 555 MNI152 extracted with spm_file_split
            };
        matlabbatch{1}.spm.tools.oldseg.opts.ngaus = [2
            2
            2
            4];
        matlabbatch{1}.spm.tools.oldseg.opts.regtype = 'mni';
        matlabbatch{1}.spm.tools.oldseg.opts.warpreg = 1;
        matlabbatch{1}.spm.tools.oldseg.opts.warpco = 25;
        matlabbatch{1}.spm.tools.oldseg.opts.biasreg = 0.01;%medium regularisation
        matlabbatch{1}.spm.tools.oldseg.opts.biasfwhm = 60;
        matlabbatch{1}.spm.tools.oldseg.opts.samp = 3;
        matlabbatch{1}.spm.tools.oldseg.opts.msk = {''};
        spm_jobman('run',matlabbatch)        
    end   
       
    
end
