clear all
% Load the Excel file with extracted ROI data
file_path = 'Brain-beh_singavsrest_TrRvsUTR_BRAVE_FWEccluster_TRvsUTR_N19_prepost_mean.xlsx';
raw = readcell(file_path);

% Extract data
mean_vals = cell2mat(raw(:,1));          % column 1: mean beta
roi_labels = raw(:,2);                   % column 2: ROI name
group = cell2mat(raw(:,3));              % column 3: group ID (1 = Uulaa, 2 = Tydyy)

% Get list of unique ROIs
[unique_rois, ~, roi_idx] = unique(roi_labels);

% Initialize results
cohens_d = zeros(length(unique_rois),1);
roi_names_out = cell(length(unique_rois),1);

for r = 1:length(unique_rois)
    roi_name = unique_rois{r};
    vals = mean_vals(strcmp(roi_labels, roi_name));
    
    % Compute Cohen's d (one-sample, Post > Pre)
    mean_val = mean(vals);
    sd_val = std(vals);
    d = mean_val / sd_val;
    
    % Store results
    cohens_d(r) = d;
    roi_names_out{r} = roi_name;
    
    fprintf('ROI: %-40s | Mean: %.4f | SD: %.4f | Cohen''s d: %.3f\n', roi_name, mean_val, sd_val, d);
end

% Write to CSV
T = table(roi_names_out, cohens_d, 'VariableNames', {'ROI', 'Cohens_d'});
writetable(T, fullfile(fileparts(file_path), 'EffectSizes_singavsrest_TRvsUTR_BRAVEFWECcluster_trvsutr.csv'));
