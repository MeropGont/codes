% Compute functional connectivity matrix

clear all;
clc;

PATH_IN = "C:\Users\apizz\Desktop\DCBT\Project\Data\Results\ROIs";
PATH_OUT = fullfile('C:\Users\apizz\Desktop\DCBT\Project\Data\Results\my_FC');

filenames = dir(PATH_IN);
Nsub=10;
Ntime=300;
Nnodes=132;

if ~exist(PATH_OUT, 'dir')
    mkdir(PATH_OUT)
end
Hub_all = zeros(Nsub, Nnodes);

for iterSbj=1:Nsub

    % Loading
    d = load(fullfile(PATH_IN, filenames(iterSbj+2).name));

    % Initializing output
    Data_all = zeros(Ntime, Nnodes);
    Nodes = {};
    FC_struct = struct;

    for iterNodes=1:132

        Data_all(:, iterNodes) = d.data{3+iterNodes};
        Nodes{iterNodes} = d.names{3+iterNodes};
        coord{iterNodes} = d.xyz{3+iterNodes};

    end

    FC_mat = corrcoef(Data_all);

    % Compute 'hub'
    degree_mat = nansum(FC_mat, 2); % sum rows
    [max_degree, idx] = max(degree_mat);
    
    Hub_all(iterSbj, :) = FC_mat(idx, :);
    
    % Save subject-specific result
    FC_struct.data = FC_mat;
    FC_struct.names = Nodes;
    FC_struct.degree = degree_mat;
    FC_struct.Hub = Hub_all;
    FC_struct.XYZ = coord;
    
    % Plot FC
    imagesc(FC_mat);
    colorbar;
    clim([-1 1])
    title(['Functional Connectivity (sub-' num2str(iterSbj) ')' ]);
    xlabel('Nodes', 'FontSize',12)
    ylabel('Nodes', 'FontSize',12)

    saveas(gcf, fullfile(PATH_OUT, ['FC_mat_sub-', num2str(iterSbj)]), 'png');
    save(fullfile(PATH_OUT, strcat('FC_matrix_sbj', num2str(iterSbj))), 'FC_mat');
    save(fullfile(PATH_OUT, strcat('FC_struct_sbj', num2str(iterSbj))), 'FC_struct');


end

% Hub-analysis
x = Hub_all';
SBJ_corr_hub = corrcoef(x);
save(fullfile(PATH_OUT, 'AllSbj_hub_corr'), 'SBJ_corr_hub');
imagesc(SBJ_corr_hub);


