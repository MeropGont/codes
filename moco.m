clear 

total_subject=1;
epi_bold="C:\Users\apizz\Desktop\DCBT\Project\Data\Data\sub-01_ses-1_task-rest_acq-fullbrain_run-1_bold.nii";
Dataprefix='test';
nTR=300;

% Preparation input
files=dir([epi_bold]);

allVol=[]
base=files(1).name;

for TR= 1:nTR
    inst={[base ',' num2str(TR)]};
    allVol=[allVol; inst];
end
% allVol = allVol(:,:);  % odd matrix
% allVol=allVol;


% cfg = config()

matlabbatch{1}.spm.spatial.realign.estwrite.data{1} = allVol;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 1.2;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 1;
% if you want to use the first, use rtm = 0, if you want to use the mean use rtm = 1
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 0;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 4; %% 4
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
%     matlabbatch{bases}.spm.spatial.realign.estwrite.eoptions.weight = {'moma.nii'};
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4; %% 4
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
%     matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = Dataprefix;


% inputs=cell(0,1)
spm('defaults','FMRI')
spm_jobman('initcfg');
% spm_jobman('interactive','matlabbatch');
spm_jobman('run', matlabbatch);
% 
% 
% a = load('rp_data.txt')
% subplot(1,2,1)
% plot(a(:,1:3))
% subplot(1,2,2)
% plot(a(:,4:6))