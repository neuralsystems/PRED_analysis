function [processed_data, info_data] = shimizu(params)

if nargin < 1
    params.n_bin = 10;
    params.len_resp = 2;
    params.resp_start = 2;
    params.resp_end = params.resp_start + params.len_resp;
    params.bg_start = 0;
    params.bg_end = 2;
end

% Shimizu, K. & Stopfer, M. A Population of Projection Neurons that
% Inhibits the Lateral Horn but Excites the Antennal Lobe through Chemical
% Synapses in Drosophila. Front. Neural Circuits 11, (2017).
raw_folder = 'data\shimizu_2017\raw\';

info_data.id_odor = {'benzaldehyde', '2-octanone', 'ethyl acetate', 'pentylacetate', 'ethyl butyrate'};
info_data.id_glomerulus = {'VC4', 'DL2v', 'VM5v', 'VC3'};

% Convert data to n_cell (pn) x n_trial x n_individual (brains) x n_odor. Sum over the time frames
n_ind = 6;
n_odor = 5;
n_trial = 10;
n_cell = 4;
processed_data = cell(n_cell, n_trial, n_ind, n_odor); % size decided using maximum observed values

% vc4 data
i_pn = 1;
relevant_odors = 1:5;

load([raw_folder '130211.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:35, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 8 15 22 29];
id_odor_end = [7 14 21 28 35];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 1, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '130214.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:32, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 7 13 19 26];
id_odor_end = [6 12 18 25 32];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 2, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

% dl2v data
i_pn = 2;
relevant_odors = [1 5];

load([raw_folder '151225.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:17, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 8];
id_odor_end = [7 17];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 1, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160101.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:21, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 15];
id_odor_end = [7 21];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 2, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160105-1.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:21, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 15];
id_odor_end = [7 21];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 3, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '151101.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:14, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 8];
id_odor_end = [7 14];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 4, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160116-2.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:28, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 22];
id_odor_end = [7 28];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 5, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160118.mat'], 'spikeTMatrix')
current_data = spikeTMatrix;
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 29];
id_odor_end = [7 35];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 6, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

% vm5v data
i_pn = 3;
relevant_odors = [2 4 5];

load([raw_folder '151226-1.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:21, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 8 15];
id_odor_end = [7 14 21];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 1, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '151229.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:21, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 8 15];
id_odor_end = [7 14 21];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 2, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160104-2.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:21, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 8 15];
id_odor_end = [7 14 21];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 3, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160105-2.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:21, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 8 15];
id_odor_end = [7 14 21];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 4, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160331.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:21, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 8 15];
id_odor_end = [7 14 21];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 5, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160404.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:21, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 8 15];
id_odor_end = [7 14 21];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 6, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

% vc3 data
i_pn = 4;
relevant_odors = [1 4 5];

load([raw_folder '160329.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:28, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [22 1 8];
id_odor_end = [28 7 14];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 1, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160506-2.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:21, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 8 15];
id_odor_end = [7 14 21];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 2, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160420-2.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:21, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [8 1 15];
id_odor_end = [14 7 21];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 3, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160430.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:21, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [8 1 15];
id_odor_end = [14 7 21];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 4, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160116-1.mat'], 'spikeTMatrix')
current_data = spikeTMatrix;
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 29 36];
id_odor_end = [7 35 42];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 5, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

load([raw_folder '160119-1.mat'], 'spikeTMatrix')
current_data = spikeTMatrix(1:21, :);
temp_data = arrayfun(@(x) histcounts(current_data(x, :), linspace(params.resp_start, params.resp_end, params.n_bin + 1)) / (params.resp_end - params.resp_start) - histcounts(current_data(x, :), [params.bg_start + eps params.bg_end - eps]) / ((params.bg_end - params.bg_start) * params.n_bin), (1:1:size(current_data, 1)).', 'un', 0);
id_odor_start = [1 8 15];
id_odor_end = [7 14 21];
for iOdor = 1:length(id_odor_start)
    processed_data(i_pn, 1:(id_odor_end(iOdor) - id_odor_start(iOdor) + 1), 6, relevant_odors(iOdor)) = temp_data(id_odor_start(iOdor):id_odor_end(iOdor), 1);
end

end