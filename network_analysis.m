% Extract mind-wondering network 
clear all;
clc;

PATH_IN = "C:\Users\apizz\Desktop\DCBT\Project\Data\Results\ROIs";
PATH_OUT = fullfile('C:\Users\apizz\Desktop\DCBT\Project\Data\Results\my_Net');

filenames = dir(PATH_IN);
Nsub=10;
Ntime=300;
Nnodes=132;

if ~exist(PATH_OUT, 'dir')
    mkdir(PATH_OUT)
end



DMN = {'atlas.PC (Cingulate Gyrus, posterior division)', 'atlas.Precuneous (Precuneous Cortex)', 'atlas.MedFC (Frontal Medial Cortex)', ...
    'atlas.aSMG r (Supramarginal Gyrus, anterior division Right)', 'atlas.aSMG l (Supramarginal Gyrus, anterior division Left)',...
    'atlas.AG r (Angular Gyrus Right) ', 'atlas.AG l (Angular Gyrus Left)' };

SOM = {'atlas.MedFC (Frontal Medial Cortex)', 'atlas.AC (Cingulate Gyrus, anterior division)', 'atlas.PaCiG r (Paracingulate Gyrus Right)', ...
    'atlas.PaCiG l (Paracingulate Gyrus Left)', 'atlas.PostCG l (Postcentral Gyrus Left)', 'atlas.PreCG l (Precentral Gyrus Left)'};

AUD = {'atlas.aSTG l (Superior Temporal Gyrus, anterior division Left)', 'atlas.Caudate r', "atlas.HG r (Heschl's Gyrus Right)",...
    'atlas.SFG r (Superior Frontal Gyrus Right)', 'atlas.MidFG r (Middle Frontal Gyrus Right)', 'atlas.MidFG l (Middle Frontal Gyrus Left)', ...
    'atlas.IFG oper r (Inferior Frontal Gyrus, pars opercularis Right)', 'atlas.SFG l (Superior Frontal Gyrus Left)', 'atlas.IFG oper l (Inferior Frontal Gyrus, pars opercularis Left)'};

VIS = {'atlas.FP r (Frontal Pole Right)', 'atlas.FP l (Frontal Pole Left)', 'atlas.SFG r (Superior Frontal Gyrus Right)', ...
    'atlas.MidFG r (Middle Frontal Gyrus Right)', 'atlas.MidFG l (Middle Frontal Gyrus Left)', 'atlas.IFG oper l (Inferior Frontal Gyrus, pars opercularis Left)', ...
    'atlas.IFG oper r (Inferior Frontal Gyrus, pars opercularis Right)', 'atlas.SFG l (Superior Frontal Gyrus Left)', 'atlas.aSTG r (Superior Temporal Gyrus, anterior division Right)'};

NET = {DMN, SOM, AUD, VIS};

AllSbj = {};
for it=1:4
    n_nodes = length(NET{it});
    new_dim = ((n_nodes*n_nodes)-n_nodes)/2;
    AllSbj{it} = zeros(new_dim, Nsub);

end

        

for iterSbj=1:Nsub

    % Load ROI time series
    ROI = load(fullfile(PATH_IN, filenames(iterSbj+2).name));
    ROInames = ROI.names;

    % Loop Network
    for iterNet=1:length(NET)
        n_nodes = length(NET{iterNet});
        DataNet = zeros(Ntime, n_nodes);
        

        % Find nodes
        for iterNode=1:n_nodes
            lab1 = NET{iterNet}{iterNode};

            for iterROI=1:length(ROInames)-3
                lab2 = ROInames{iterROI+3};
                idx = strcmp(lab1, lab2);
                if idx == 1
                    disp(['Found ', num2str(iterROI+3)])
                    DataNet(:,iterNode) = ROI.data{iterROI+3};
                end
            end
        end

        % Compute Network-FC
        FC_mat = corrcoef(DataNet);
        idx = isnan(FC_mat);
        FC_mat(idx) = 0;
        
        % Plot Network-FC
        figure;
        imagesc(FC_mat);
        colorbar;
        clim([-1 1])
        title(['FC-network ', num2str(iterNet)])
        xlabel('Nodes', 'FontSize',12)
        ylabel('Nodes', 'FontSize',12)
        saveas(gcf, fullfile(PATH_OUT, ['Net_FC', num2str(iterNet),'sub-', num2str(iterSbj)]), 'png');

        % Triangulate
        temp = ones(n_nodes, n_nodes);
        utri = triu(temp, 1);
        idx = utri ~= 0;
        t = FC_mat(idx);
        t_vect = t(:);
        
        % Fill in a group matrix
        AllSbj{iterNet}(:, iterSbj) = t_vect;
        
    end

    
end

% Compute Netw-FC correlation across subject
% Load behavioral similarity 
beh = load('C:\Users\apizz\Desktop\DCBT\Project\Data\Results\behavioral_subject_similarity.mat');

FC_dist = {};
label_names = {'DMN', 'Somatosensory awareness', 'Audiotory mental imagery/inner language', 'Visual mental'};

for iterNet=1:4
    FC_dist{iterNet} = corrcoef(AllSbj{iterNet});

    % Save matrices 
    figure;
    imagesc(FC_dist{iterNet});
    colorbar;
    clim([-1 1])
    title(['FC similarity for ', label_names{iterNet}]);
    xlabel('Subj', 'FontSize',12)
    ylabel('Subj', 'FontSize',12)
    saveas(gcf, fullfile(PATH_OUT, ['Sim_Net_FC', num2str(iterNet)]), 'png');


    % Compute last correlation BEH-netFC
    temp = ones(10, 10);
    utri = triu(temp, 1);
    idx = utri ~= 0;

    % net-FC
    t = FC_dist{iterNet}(idx);
    t_vect = t(:);

    % behav
    b = beh.m(idx);
    b_vect = b(:);

    % Compute correlation
    c_val = corr(t_vect, b_vect);
    disp(c_val)

end

