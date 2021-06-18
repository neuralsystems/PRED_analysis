function [processed_data, info_data] = gupta(params)

if nargin < 1
    params.n_bin = 10;
    params.len_resp = 2;
    params.resp_start = 2;
    params.resp_end = params.resp_start + params.len_resp;
    params.bg_start = 0;
    params.bg_end = 2;
end

% Gupta, N. & Stopfer, M. A temporal channel for information in sparse
% sensory coding. Curr. Biol. 24, 2247–2256 (2014).
raw_folder = 'data\gupta_2014\raw\';
info_data.id_odor = {'hex_0.1', 'hex_10', 'chx_0.1', 'chx_10', 'oct_0.1', 'oct_10'};

% Convert data to n_cell (mbon) x n_trial x n_individual (brains) x n_odor
n_ind = 6;
n_odor = 6;
n_trial = 11;
n_cell = 1;
processed_data = cell(n_cell, n_trial, n_ind, n_odor); % size decided using maximum observed values

load([raw_folder 'data_0.2s.mat'], 'outputs')
i_ind = 1;
name_cell = outputs{1}.cellName;
for i_data = 1:length(outputs)
    if ~strcmp(name_cell, outputs{i_data}.cellName)
        i_ind = i_ind + 1;
        name_cell = outputs{i_data}.cellName;
    end
    curr_odor = erase(outputs{i_data}.recordingName, '_again');
    curr_odor = erase(curr_odor, '_1s');
    i_odor = contains(info_data.id_odor, curr_odor);
    current_data = outputs{i_data}.spikes.times;
    n_trial = length(current_data);
    temp_data = cellfun(@(x) histcounts(x, linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(x, [params.bg_start params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), current_data, 'un', 0);
    processed_data(1, 1:n_trial, i_ind, i_odor) = temp_data;
end

end