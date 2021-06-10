function badel(recalc)
if nargin < 1
    recalc = false;
end
% Badel, L., Ohta, K., Tsuchimoto, Y. & Kazama, H. Decoding of
% Context-Dependent Olfactory Behavior in Drosophila. Neuron 91, 155–167
% (2016).
raw_folder = 'data\badel_2016\raw\';
file_name = 'data\badel_2016\processed_data_badel.mat';
if ~exist(file_name, 'file') || recalc
    raw_data = load([raw_folder 'imagingData.mat']);
    info_data.id_odor = raw_data.odorID(1:end-1);
    info_data.id_glomerulus = raw_data.glomerulusName.';
    
    % Original data storage: glomerulus number, time frame, odor number, trial number, brain number
    % Convert data to n_cell (pn) x n_trial x n_individual (brains) x n_odor. Sum over the time frames
    % Excluding last odor in the dataset as it is mineral oil
    relevant_data_frames = 10:17;
    processed_data = permute(squeeze(sum(raw_data.imagingData(:, relevant_data_frames, 1:end-1, :, :), 2)), [1 3 4 2]);
    
    % save file
    save(file_name, 'info_data', 'processed_data');
end
end