clear all;
PATH_IN = "C:\Users\apizz\Desktop\DCBT\Project\Data\Data\BOLD"; 
PATH_OUT = "C:\Users\apizz\Desktop\DCBT\Project\Data\Data\MOCO";

subj_list={'sub-01_ses-1_task-rest_acq-fullbrain_run-1_bold.nii', 'sub-02_ses-1_task-rest_acq-fullbrain_run-1_bold.nii'}; 
nTR=300;

if ~exist(PATH_OUT, 'dir')
       mkdir(PATH_OUT)
end

Dataprefix=strcat(PATH_OUT, '\moco_');

cd(PATH_IN)

for itersbj=1:length(subj_list)
    disp(["Working on"  subj_list{itersbj}])
    
    % Creating input 
    allVol = [];
    base=subj_list{itersbj};
    
    for TR= 1:nTR
        inst={strcat(base, ',', num2str(TR))};
        allVol=[allVol; inst];
    end
    
    % Creating batchfile
    matlabbatch{1}.spm.spatial.realign.estwrite.data{1} = allVol;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 1.2;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 1;
    % if you want to use the first, use rtm = 0, if you want to use the mean use rtm = 1
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = Dataprefix;

    spm('defaults','FMRI')
    spm_jobman('initcfg');
    spm_jobman('run', matlabbatch);


end




