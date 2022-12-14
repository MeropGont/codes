clear all;
clc;

PATH_IN = "C:\Users\apizz\Desktop\DCBT\Project\Data\Results\ROIs";
PATH_OUT = fullfile('C:\Users\apizz\Desktop\DCBT\Project\Data\Results\my_FC');
filenames = dir(PATH_IN);
Nsub=10;
Ntime=300;
Nnodes=132;

% check FC matrices computed by conn
for iterSbj=1:Nsub

    if iterSbj < 10        
        file1 = strcat('resultsROI_Subject00', num2str(iterSbj), '_Condition001.mat');
        file2 = strcat('ROI_Subject00', num2str(iterSbj), '_Session001.mat');
    else
        file1 = strcat('resultsROI_Subject010_Condition001.mat');
        file2 = strcat('ROI_Subject010_Session001.mat');
    end


    FCconn = load(fullfile(PATH_IN, '1stAnalysisROIss', file1));
    Data = load(fullfile(PATH_IN, 'ROIs', file2));
    
    % compute in-house FC
    Data_all = zeros(Ntime, Nnodes);
        
    Nodes = {};
    FC_struct = struct;
    
    for iterNodes=1:Nnodes
    
        Data_all(:, iterNodes) = Data.data{3+iterNodes};
        Nodes{iterNodes} = Data.names{3+iterNodes};
    
    end
    
    FC_mat = corrcoef(Data_all);
    
    % Extract FC from conn
    
    FC_conn = FCconn.Z(:, 1:Nnodes);
    
    % Plot results
    figure(1);
    imagesc(FC_mat);
    title("In-house FC")
    colorbar;
    
    figure(2);
    FC_conn(FC_conn > 1) = 1;
    FC_conn(FC_conn < -1) = -1;

    imagesc(FC_conn);
    title("CONN FC")
    colorbar;
    
    % compute difference
    diff = FC_mat-FC_conn;
    figure(3);
    imagesc(diff);
    title("in-house FC - CONN FC")
    colorbar;
    
    % Check if the values are correlated in some way
    vFC_mat = FC_mat(:);
    vFC_conn = FC_conn(:);

    idx = isnan(vFC_mat);
    vFC_mat(idx) = 0;

    idx = isnan(vFC_conn);
    vFC_conn(idx) = 0;
    
    % Scatterplot
    figure(4);
    c = corr(vFC_mat, vFC_conn);
    plot(vFC_mat);
    hold on
    plot(vFC_conn, 'r');
    title(['Correlation ' num2str(c)])

    % pause;

    

end


