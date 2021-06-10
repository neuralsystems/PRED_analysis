function runallsimulations(recalculate)
if nargin < 1
    recalculate = false;
end

% [CVCL] Chance level of matrix-type metrics PRED, PC, COS, EUC, MAN, CHEB
file_name = 'data\class_vector_chance_level.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;
    fprintf('Running [CVCL]...');
    n_sim = 1000;
    n_sample = 10;
    range_class = [2 5];
    n_range_class = length(range_class);
    metrics = {'pred_cv', 'pc', 'cos', 'man', 'euc', 'cheb', 'man_o', 'euc_o', 'cheb_o'};
    n_metric = length(metrics);
    measure = zeros(n_range_class, n_sim, n_metric);
    rng(1000);
    for i_class = 1:n_range_class
        for i_sim = 1:n_sim
            data = num2cell(rand(n_sample, range_class(i_class)) * 2 - 1);
            for i_metric = 1:n_metric
                measure(i_class, i_sim, i_metric) = computeultimatemean(computesimilaritymetric(data, metrics{i_metric}));
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'range_*', 'metrics')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CVINCNOISE] Comparison of PRED, PC and COS with increasingly noisy data
file_name = 'data\class_vector_sim_compare_noise.mat';
if ~exist(file_name, 'file')
    t = tic;
    fprintf('Running [CVINCNOISE]...');
    n_sim = 3000;
    metrics = {'pred_cv', 'pc', 'cos'};
    n_metric = length(metrics);
    range_means = 0:10;
    n_range_means = length(range_means);
    range_noise = -2:0.1:3;
    n_range_noise = length(range_noise);
    measure = zeros(n_range_means, n_range_noise, n_sim, n_metric);
    n_sample = 10;
    rng(63);
    for i_mean = 1:n_range_means
        for i_noise = 1:n_range_noise
            for i_sim = 1:n_sim
                data = num2cell(normrnd(repmat([2 4], n_sample, 1) + range_means(i_mean), (10 ^ range_noise(i_noise)) * ones(n_sample, 2)));
                for i_metric = 1:n_metric
                    measure(i_mean, i_noise, i_sim, i_metric) = computeultimatemean(computesimilaritymetric(data, metrics{i_metric}));
                end
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'range_*', 'metrics')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CVEG] Examples for showing scaling & translation, and pattern dependence
file_name = 'data\class_vector_examples.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;
    fprintf('Running [CVEG]...');
    example{1} = num2cell([1 2; 1 2]);
    example{2} = num2cell([1 2; 1 1]);
    example{3} = num2cell([1 2; 2 3]);
    example{4} = num2cell([2 3; 3 4]);
    example{5} = num2cell([2 4; 4 6]);
    example{6} = num2cell([1 2; 2 1]);
    n_example = length(example);
    metrics = {'pred_cv', 'pc', 'cos', 'man', 'euc', 'cheb'};
    n_metric = length(metrics);
    measure = zeros(n_example, n_metric);
    for i_example = 1:n_example
        for i_metric = 1:n_metric
            measure(i_example, i_metric) = computesimilaritymetric(example{i_example}, metrics{i_metric});
        end
    end
    save(file_name, 'example', 'n_*', 'metrics', 'measure');
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CVBEHKER] Behavioral data from Kermen et al 2020, compared with PC
file_name = 'data\class_vector_data_behavioral_kermen.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CVBEHKER]...');
    kermen();
    processed_file = 'data\kermen_2020\processed_data_kermen';
    load(processed_file, 'processed_data', 'behaviors')
    
    n_rand = 1000;
    metrics = {'pred_cv', 'pc'};
    n_metric = length(metrics);
    n_behavior = length(behaviors);
    measure.original = cell(n_behavior, n_metric);
    measure.random = zeros(n_rand, n_behavior, n_metric);
    rng(2267)
    for i_behavior = 1:n_behavior
        temp_data = num2cell(squeeze(nanmean(processed_data(i_behavior, :, :, :), 2)));
        for i_metric = 1:n_metric
            measure.original{i_behavior, i_metric} = computesimilaritymetric(temp_data, metrics{i_metric});
        end
        for i_rand = 1:n_rand
            rand_data = shuffledata(temp_data);
            for i_metric = 1:n_metric
                measure.random(i_rand, i_behavior, i_metric) = computeultimatemean(computesimilaritymetric(rand_data, metrics{i_metric}));
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'metrics', 'behavior*')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CVBEHHON] Time-Individual Behavioral data from Honegger et al. 2019, compared with PC
file_name = 'data\class_vector_data_behavioral_honegger.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;    
    fprintf('Running [CVBEHHON]...');
    load('data\honegger_2019\raw\24h-persist.mat', 'daypersist');
    data = num2cell(daypersist.');
    n_class = size(data, 2);
    n_sim = 20;
    n_rep = 50;
    metrics = {'pred_cv', 'pc'};
    n_metric = length(metrics);
    measure = zeros(n_rep, n_sim, n_metric);
    measure_all = cell(1, n_metric);
    for i_metric = 1:n_metric
        measure_all{i_metric} = computesimilaritymetric(data, metrics{i_metric});
    end
    for i_rep = 1:n_rep
        rng(i_rep)
        for i_sim = 1:n_sim
            temp_data = data(:, randperm(n_class, 70));
            for i_metric = 1:n_metric
                measure(i_rep, i_sim, i_metric) = computeultimatemean(computesimilaritymetric(temp_data, metrics{i_metric}));
            end
        end
    end
    save(file_name, 'measure*', 'n_*', 'metrics')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CVTEMPMAG] Temporal vs Magnitude individual-odor PRED compared to PC
file_name = 'data\class_vector_data_temporal_vs_magnitude.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CVTEMPMAG]...');
    range_n_bin = [1 10];
    n_range_nbin = length(range_n_bin);
    metrics = {'pred_cv', 'pc'};
    n_metric = length(metrics);
    measure.gupta = cell(n_range_nbin, n_metric);
    measure.shimizu = cell(n_range_nbin, n_metric, 4);
    params.bg_start = 0;
    params.bg_end = 2;
    params.resp_start = 2;
    params.len_resp = 2;
    params.resp_end = params.resp_start + params.len_resp;
    for i_bin = 1:n_range_nbin
        params.n_bin = range_n_bin(i_bin);
        % Gupta 2014
        processed_data = gupta(params);
        [~, ~, n_sample, n_class] = size(processed_data);
        [X, Y] = ndgrid(1:n_sample, 1:n_class);
        temp_data = removeallemptydims(arrayfun(@(x, y) nanmean(cell2mat(processed_data(:, :, x, y).'), 1), X, Y, 'UniformOutput', false));
        for i_metric = 1:n_metric
            measure.gupta{i_bin, i_metric} = nanmean(computesimilaritymetric(temp_data, metrics{i_metric}), 2);
        end
        % Shimizu 2017
        processed_data = shimizu(params);
        [n_cell, ~, n_sample, n_class] = size(processed_data);
        [X, Y] = ndgrid(1:n_sample, 1:n_class);
        for i_cell = 1:n_cell
            temp_data = removeallemptydims(arrayfun(@(x, y) nanmean(cell2mat(processed_data(i_cell, :, x, y).'), 1), X, Y, 'un', 0));
            for i_metric = 1:n_metric
                measure.shimizu{i_bin, i_metric, i_cell} = nanmean(computesimilaritymetric(temp_data, metrics{i_metric}), 2);
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'range_*', 'metrics', 'params')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CVTEMPBIN] Temporal individual-odor PRED compared to PC, & COS with
% increasing numbers of bins (with fixed bin-size)
file_name = 'data\class_vector_data_temporal_increase_bin.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CVTEMPBIN]...');
    range_n_bin = 0:10;
    n_range_nbin = length(range_n_bin);
    metrics = {'pred_cv', 'pc'};
    n_metric = length(metrics);
    measure.gupta = zeros(n_range_nbin, n_metric);
    measure.shimizu = zeros(n_range_nbin, n_metric, 4);
    params.bg_start = 0;
    params.bg_end = 2;
    params.resp_start = 2;
    for i_bin = 1:n_range_nbin
        params.n_bin = 10 + range_n_bin(i_bin);
        params.len_resp = params.n_bin * 0.2;
        params.resp_end = params.resp_start + params.len_resp;
        % Gupta 2014
        processed_data = gupta(params);
        [~, ~, n_sample, n_class] = size(processed_data);
        [X, Y] = ndgrid(1:n_sample, 1:n_class);
        temp_data = removeallemptydims(arrayfun(@(x, y) nanmean(cell2mat(processed_data(:, :, x, y).'), 1), X, Y, 'UniformOutput', false));
        for i_metric = 1:n_metric
            measure.gupta(i_bin, i_metric) = computeultimatemean(computesimilaritymetric(temp_data, metrics{i_metric}));
        end
        % Shimizu 2017
        processed_data = shimizu(params);
        [n_cell, ~, n_sample, n_class] = size(processed_data);
        [X, Y] = ndgrid(1:n_sample, 1:n_class);
        for i_cell = 1:n_cell
            temp_data = removeallemptydims(arrayfun(@(x, y) nanmean(cell2mat(processed_data(i_cell, :, x, y).'), 1), X, Y, 'un', 0));
            for i_metric = 1:n_metric
                measure.shimizu(i_bin, i_metric, i_cell) = computeultimatemean(computesimilaritymetric(temp_data, metrics{i_metric}));
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'range_*', 'metrics', 'params')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CVTEMPSIM] Simulate temporal code with all active bins, additive bins
% (each time one extra bin gets added), noise level is same for normal and
% extra bins.
file_name = 'data\class_vector_sim_temporal_increase_bin.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CVTEMPSIM]...');
    rng(10)
    range_n_bin = 0:10;
    n_range_nbin = length(range_n_bin);
    metrics = {'pred_cv', 'pc'};
    n_metric = length(metrics);
    n_sim = 100;
    measure = zeros(n_range_nbin, n_sim, n_metric);
    n_sample = 10;
    n_class = 2;
    n_bin = 10;
    range_resp = [10 30];
    noise = 1;
    for i_sim = 1:n_sim
        data = cell(n_sample, n_class);
        for i_class = 1:n_class
            temp_resp = zeros(1, n_bin);
            temp_resp(randperm(n_bin, n_bin)) = randi(round(range_resp / n_bin), 1, n_bin);
            for i_sample = 1:n_sample
                data{i_sample, i_class} = temp_resp + normrnd(0, noise, 1, n_bin);
            end
        end
        for i_bin = 1:n_range_nbin
            if range_n_bin(i_bin) > 0
                data = cellfun(@(x) [x normrnd(0, noise)], data, 'UniformOutput', false);
            end
            for i_metric = 1:n_metric
                measure(i_bin, i_sim, i_metric) = computeultimatemean(computesimilaritymetric(data, metrics{i_metric}));
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'range_*', 'metrics', 'noise')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CVTEMPSIM0] Simulate temporal code with all active bins, additive bins
% (each time one extra bin gets added), noise level is 0 for all bins.
file_name = 'data\class_vector_sim_temporal_increase_bin_0_noise.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CVTEMPSIM0]...');
    rng(10)
    range_n_bin = 0:10;
    n_range_nbin = length(range_n_bin);
    metrics = {'pred_cv', 'pc'};
    n_metric = length(metrics);
    n_sim = 100;
    measure = zeros(n_range_nbin, n_sim, n_metric);
    n_sample = 10;
    n_class = 2;
    n_bin = 10;
    range_resp = [10 30];
    noise = 1;
    for i_sim = 1:n_sim
        data = cell(n_sample, n_class);
        for i_class = 1:n_class
            temp_resp = zeros(1, n_bin);
            temp_resp(randperm(n_bin, n_bin)) = randi(round(range_resp / n_bin), 1, n_bin);
            for i_sample = 1:n_sample
                data{i_sample, i_class} = temp_resp + normrnd(0, noise, 1, n_bin);
            end
        end
        for i_bin = 1:n_range_nbin
            if range_n_bin(i_bin) > 0
                data = cellfun(@(x) [x normrnd(0, 0)], data, 'UniformOutput', false);
            end
            for i_metric = 1:n_metric
                measure(i_bin, i_sim, i_metric) = computeultimatemean(computesimilaritymetric(data, metrics{i_metric}));
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'range_*', 'metrics', 'noise')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CVPOPBAD] Population level individual-odor PRED for data from Badel et
% al 2016
file_name = 'data\class_vector_data_population_badel.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CVPOPBAD]...');
    badel(recalculate);
    processed_file = 'data\badel_2016\processed_data_badel.mat';
    load(processed_file, 'processed_data')
    temp_data = squeeze(nanmean(processed_data(:, :, :, [1:6, 43:72]), 2)); % only monomolecular odors
    [n_cell, n_ind, n_odor] = size(temp_data);
    metrics = {'pred_cv'};
    n_metric = length(metrics);
    % vector of cells
    all_data = cell(n_ind, n_odor);
    for i_ind = 1:n_ind
        for i_odor = 1:n_odor
            all_data{i_ind, i_odor} = reshape(temp_data(:, i_ind, i_odor), 1, []);
        end
    end
    all_data = removeallemptydims(all_data);
    for i_metric = 1:n_metric
        measure.vector{i_metric} = computesimilaritymetric(all_data, metrics{i_metric});
    end
    % sum over all cells
    all_data = cell(n_ind, n_odor);
    for i_ind = 1:n_ind
        for i_odor = 1:n_odor
            all_data{i_ind, i_odor} = sum(temp_data(:, i_ind, i_odor), 1);
        end
    end
    all_data = removeallemptydims(all_data);
    for i_metric = 1:n_metric
        measure.sum{i_metric} = computesimilaritymetric(all_data, metrics{i_metric});
    end
    % each cell separately
    for i_cell = 1:n_cell
        curr_data = num2cell(squeeze(temp_data(i_cell, :, :)));
        for i_metric = 1:n_metric
            measure.separate{i_cell, i_metric} = computesimilaritymetric(curr_data, metrics{i_metric});
        end
    end
    save(file_name, 'measure', 'n_*', 'metrics')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CSCHK] Check applicability of PRED to vector-type data
file_name = 'data\class_sample_check_pred.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CSCHK]...');
    metrics = {'pred_cs', 'etm', 'sil', 'dunn', 'dbi', 'ch'};
    n_metric = length(metrics);
    params.bg_start = 0;
    params.bg_end = 2;
    params.resp_start = 2;
    params.n_bin = 2;
    params.len_resp = 2;
    params.resp_end = params.resp_start + params.len_resp;
    % Gupta 2014
    processed_data = gupta(params);
    measure.gupta = analysenormaldata(processed_data, metrics);
    % Shimizu 2017
    processed_data = shimizu(params);
    measure.shimizu = analysenormaldata(processed_data, metrics);
    
    save(file_name, 'measure', 'n_*', 'metrics')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CSCOMPFASTEX] Compare fast and exhaustive PRED
file_name = 'data\class_sample_compare_fast_exhaustive.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CSCOMPFASTEX]...');
    n_sim = 1000;
    metrics = {'fast', 'exhaustive'};
    n_metric = length(metrics);
    range_sample = 2:25;
    n_range_sample = length(range_sample);
    n_class = 2;
    n_dim = 2;
    params.dist = 0.1;
    params.radius = 0.05;
    params.range = [-1 1];
    params.noise = 0.4;
    measure = zeros(n_sim, n_range_sample, n_metric);
    rng(31);
    for i_sample = 1:n_range_sample
        for i_sim = 1:n_sim
            temp_data = generateclustereddata(range_sample(i_sample), n_class, n_dim, params.range, params.dist, params.radius);
            data = cellfun(@(x) x + normrnd(0, params.noise, 1, n_dim), temp_data, 'UniformOutput', false);
            for i_metric = 1:n_metric
                measure(i_sim, i_sample, i_metric) = computeultimatemean(pred(data, {}, 'type', metrics{i_metric}));
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'range_*', 'metrics', 'params')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CSCL] Chance level of vector-type metrics PRED, ETM, SIL, DUNN, DBI, CH
file_name = 'data\class_sample_chance_level.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CSCL]...');
    n_sim = 1000;
    n_sample = 10;
    range_class = [2 5];
    n_range_class = length(range_class);
    metrics = {'pred_cs', 'etm', 'sil', 'dunn', 'dbi', 'ch'};
    n_metric = length(metrics);
    measure = zeros(n_range_class, n_sim, n_metric);
    params.n_dim = 2;
    params.dist = 0;
    params.radius = 0.05;
    params.range = [-1 1];
    params.noise = 50;
    rng(2000);
    for i_class = 1:n_range_class
        for i_sim = 1:n_sim
            temp_data = generateclustereddata(n_sample, range_class(i_class), params.n_dim, params.range, params.dist, params.radius);
            data = cellfun(@(x) x + normrnd(0, params.noise, 1, params.n_dim), temp_data, 'UniformOutput', false);
            for i_metric = 1:n_metric
                measure(i_class, i_sim, i_metric) = computeultimatemean(computesimilaritymetric(data, metrics{i_metric}));
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'range_*', 'metrics', 'params')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CSINCCLS] Comparison of vector-type metrics with increasing number of
% classes
file_name = 'data\class_sample_increasing_n_class.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CSINCCLS]...');
    n_sim = 100;
    metrics = {'pred_cs', 'etm', 'dunn', 'sil', 'dbi', 'ch'};
    n_metric = length(metrics);
    range_class = 2:10;
    n_range_class = length(range_class);
    n_sample = 10;
    params.n_dim = 2;
    params.dist = 0;
    params.radius = 0.05;
    params.range = [-1 1];
    params.noise = 0.4;
    measure = zeros(n_sim, n_range_class, n_metric);
    rng(789);
    for i_class = 1:n_range_class
        for i_sim = 1:n_sim
            temp_data = generateclustereddata(n_sample, range_class(i_class), params.n_dim, params.range, params.dist, params.radius);
            data = cellfun(@(x) x + normrnd(0, params.noise, 1, params.n_dim), temp_data, 'UniformOutput', false);
            for i_metric = 1:n_metric
                measure(i_sim, i_class, i_metric) = computeultimatemean(computesimilaritymetric(data, metrics{i_metric}));
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'range_*', 'metrics', 'params')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CSINCCLS2SAMP] Comparison of vector-type metrics with increasing number of
% classes and 2 samples
file_name = 'data\class_sample_increasing_n_class_2samp.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CSINCCLS2SAMP]...');
    n_sim = 100;
    metrics = {'pred_cs', 'etm', 'dunn', 'sil', 'dbi', 'ch'};
    n_metric = length(metrics);
    range_class = 2:10;
    n_range_class = length(range_class);
    n_sample = 2;
    params.n_dim = 2;
    params.dist = 0;
    params.radius = 0.05;
    params.range = [-1 1];
    params.noise = 0.4;
    measure = zeros(n_sim, n_range_class, n_metric);
    rng(789);
    for i_class = 1:n_range_class
        for i_sim = 1:n_sim
            temp_data = generateclustereddata(n_sample, range_class(i_class), params.n_dim, params.range, params.dist, params.radius);
            data = cellfun(@(x) x + normrnd(0, params.noise, 1, params.n_dim), temp_data, 'UniformOutput', false);
            for i_metric = 1:n_metric
                measure(i_sim, i_class, i_metric) = computeultimatemean(computesimilaritymetric(data, metrics{i_metric}));
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'range_*', 'metrics', 'params')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CSINCSAMP] Comparison of vector-type metrics with increasing number of
% samples
file_name = 'data\class_sample_increasing_n_sample.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CSINCSAMP]...');
    n_sim = 100;
    metrics = {'pred_cs', 'etm', 'dunn', 'sil', 'dbi', 'ch'};
    n_metric = length(metrics);
    range_sample = 2:2:20;
    n_range_sample = length(range_sample);
    n_class = 2;
    n_dim = 2;
    params.dist = 0.1;
    params.radius = 0.05;
    params.range = [-1 1];
    params.noise = 0.4;
    measure = zeros(n_sim, n_range_sample, n_metric);
    rng(321);
    for i_sample = 1:n_range_sample
        for i_sim = 1:n_sim
            temp_data = generateclustereddata(range_sample(i_sample), n_class, n_dim, params.range, params.dist, params.radius);
            data = cellfun(@(x) x + normrnd(0, params.noise, 1, n_dim), temp_data, 'UniformOutput', false);
            for i_metric = 1:n_metric
                measure(i_sim, i_sample, i_metric) = computeultimatemean(computesimilaritymetric(data, metrics{i_metric}));
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'range_*', 'metrics', 'params')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CSINCNOISE] Comparison of vector-type metrics with increasing noise
file_name = 'data\class_sample_increasing_noise.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CSINCNOISE]...');
    n_sim = 3000;
    metrics = {'pred_cs', 'etm', 'dunn', 'sil', 'dbi', 'ch'};
    n_metric = length(metrics);
    range_noise = -3:0.1:3;
    n_noise = length(range_noise);
    params.n_sample = 10;
    params.n_class = 2;
    params.dist = 0;
    params.radius = 0.05;
    params.n_dim = 2;
    params.range = [-1, 1];
    measure = zeros(n_sim, n_noise, n_metric);
    rng(861);
    for i_sim = 1:n_sim
        temp_data = generateclustereddata(params.n_sample, params.n_class, params.n_dim, params.range, params.dist, params.radius);
        for i_noise = 1:n_noise
            data = cellfun(@(x) x + normrnd(0, 10 ^ range_noise(i_noise), 1, params.n_dim), temp_data, 'UniformOutput', false);
            for i_metric = 1:n_metric
                measure(i_sim, i_noise, i_metric) = computeultimatemean(computesimilaritymetric(data, metrics{i_metric}));
            end
        end
    end
    save(file_name, 'measure', 'n_*', 'range_*', 'metrics', 'params')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CSDATANOISE] Compare PRED to other vector metrics with noisy
% experimental data
file_name = 'data\class_sample_data_noise.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CSDATANOISE]...');
    n_sim = 100;
    range_noise = -1:0.1:4;
    n_range_noise = length(range_noise);
    metrics = {'pred_cs', 'etm', 'dunn', 'sil', 'dbi', 'ch'};
    n_metric = length(metrics);
    params.bg_start = 0;
    params.bg_end = 2;
    params.resp_start = 2;
    params.n_bin = 2;
    params.len_resp = 2;
    params.resp_end = params.resp_start + params.len_resp;
    % Gupta 2014
    processed_data = gupta(params);
    seed = 2014;
    measure.gupta = analysenoisydata(processed_data, range_noise, n_sim, metrics, seed);
    
    % Shimizu 2017
    processed_data = shimizu(params);
    seed = 2017;
    measure.shimizu = analysenoisydata(processed_data, range_noise, n_sim, metrics, seed);
    
    save(file_name, 'n_*', 'measure', 'metrics', 'range_*', 'params')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CSBEHKER] Behavioral data from Kermen et al 2020, trial-individual PRED
file_name = 'data\class_sample_data_behavioral_kermen.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;     
    fprintf('Running [CSBEHKER]...');
    kermen(recalculate);
    processed_file = 'data\kermen_2020\processed_data_kermen';
    load(processed_file, 'processed_data', 'info_data')
    metrics = {'pred_cs'};
    n_metric = length(metrics);
    [n_behavior, n_trial, n_ind, n_odor] = size(processed_data);
    measure = cell(n_odor, n_metric);
    for i_odor = 1:n_odor
        temp_data = squeeze(mat2cell(permute(processed_data(:, :, :, i_odor), [2, 1, 3]), ones(1, n_trial), n_behavior, ones(1, n_ind)));
        for i_metric = 1:n_metric
            measure{i_odor, i_metric} = computesimilaritymetric(temp_data, metrics{i_metric});
        end
    end
    save(file_name, 'measure*', 'n_*', 'metrics', 'info_data')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CSNEUHON] 
file_name = 'data\class_sample_data_neural_honegger.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;
    fprintf('Running [CSNEUHON]...');
    honegger(recalculate)
    load('data\honegger_2019\processed_data_honegger.mat', 'processed_data', 'info_data');
    [n_glom, ~, ~, n_odor] = size(processed_data.control);
    metrics = {'pred_cs'};
    n_metric = length(metrics);
    measure.control = cell(n_glom, n_odor, n_metric);
    measure.amw = cell(n_glom, n_odor, n_metric);
    for i_glom = 1:n_glom
        for i_odor = 1:n_odor
            temp_data.control = num2cell(squeeze(processed_data.control(i_glom, :, :, i_odor)));
            temp_data.amw = num2cell(squeeze(processed_data.amw(i_glom, :, :, i_odor)));
            for i_metric = 1:n_metric
                measure.control{i_glom, i_odor, i_metric} = computesimilaritymetric(temp_data.control, metrics{i_metric});
                measure.amw{i_glom, i_odor, i_metric} = computesimilaritymetric(temp_data.amw, metrics{i_metric});
            end
        end
    end
    save(file_name, 'measure*', 'n_*', 'metrics', 'info_data')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate

% [CSCVCONN]
file_name = 'data\class_sample_vector_data_conn_schlegel.mat';
if ~exist(file_name, 'file') || recalculate
    t = tic;
    fprintf('Running [CSCVCONN]...');
    schlegel(recalculate)
    load('data\schlegel_2021\processed_data_schlegel.mat', 'processed_data', 'id_*', 'n_*');
    measure.full = computesimilaritymetric(processed_data.full, 'pred_cv');
    for i_database = 1:n_database
        measure.connectivity{i_database} = computesimilaritymetric(squeeze(processed_data.connectivity(i_database, :, :, :)), 'pred_cs');
        measure.celltype{i_database} = computesimilaritymetric(squeeze(processed_data.celltype(i_database, :, :, :)), 'pred_cs');
        measure.tract{i_database} = computesimilaritymetric(squeeze(processed_data.tract(i_database, :, :, :)), 'pred_cs');
        measure.region{i_database} = computesimilaritymetric(squeeze(processed_data.region(i_database, :, :, :)), 'pred_cs');
    end
    measure.by_connectivity = nan(1, n_connectivity);
    for i_connectivity = 1:n_connectivity
        temp_data = removeallnandims(squeeze(processed_data.connectivity(:, :, i_connectivity, :)));
        if size(temp_data, 1) >= 2 && size(temp_data, 2) >= 2
            measure.by_connectivity(i_connectivity) = computesimilaritymetric(temp_data, 'pred_cv');
        end
    end
    measure.by_celltype = nan(1, n_celltype);
    for i_celltype = 1:n_celltype
        temp_data = removeallnandims(squeeze(processed_data.celltype(:, :, i_celltype, :)));
        if size(temp_data, 1) >= 2 && size(temp_data, 2) >= 2
            measure.by_celltype(i_celltype) = computesimilaritymetric(temp_data, 'pred_cv');
        end
    end
    measure.by_tract = nan(1, n_tract);
    for i_tract = 1:n_tract
        temp_data = removeallnandims(squeeze(processed_data.tract(:, :, i_tract, :)));
        if size(temp_data, 1) >= 2 && size(temp_data, 2) >= 2
            measure.by_tract(i_tract) = computesimilaritymetric(temp_data, 'pred_cv');
        end
    end
    measure.by_region = nan(1, n_region);
    for i_region = 1:n_region
        temp_data = removeallnandims(squeeze(processed_data.region(:, :, i_region, :)));
        if size(temp_data, 1) >= 2 && size(temp_data, 2) >= 2
            measure.by_region(i_region) = computesimilaritymetric(temp_data, 'pred_cv');
        end
    end
    save(file_name, 'measure*', 'n_*', 'id_*')
    fprintf('Done!! Time: %s\n', duration([0, 0, toc(t)]));
end
clearvars -except recalculate
end

function data = shuffledata(data)
[n_vector, n_class] = size(data);
for i_vec = 1:n_vector
    data(i_vec, :) = data(i_vec, randperm(n_class, n_class));
end
end

function measure = analysenormaldata(processed_data, metrics)
[n_cell, ~, n_ind, ~] = size(processed_data);
n_metric = length(metrics);
measure = nan(n_cell, n_ind, n_metric);
for i_cell = 1:n_cell
    for i_ind = 1:n_ind
        all_data = removeallemptydims(squeeze(processed_data(i_cell, :, i_ind, :)));
        n_trial = min(sum(~cellfun(@isempty, all_data), 1));
        if n_trial ~= 0
            all_data = all_data(1:n_trial, :);
            for i_metric = 1:n_metric
                measure(i_cell, i_ind, i_metric) = computeultimatemean(computesimilaritymetric(all_data, metrics{i_metric}));
            end
        end
    end
end
end

function measure = analysenoisydata(processed_data, range_noise, n_sim, metrics, seed)
[n_cell, ~, n_ind, ~] = size(processed_data);
n_metric = length(metrics);
n_range_noise = length(range_noise);
n_bin = size(processed_data{1}, 2);
mean_rate = mean(cell2mat(removeallemptydims(processed_data(:))));
measure = nan(n_range_noise, n_sim, n_cell, n_ind, n_metric);
rng(seed)
for i_noise = 1:n_range_noise
    sd_noise = (10 ^ range_noise(i_noise)) * mean_rate * 0.01;
    for i_sim = 1:n_sim
        noisy_data = processed_data;
        for i_data = 1:numel(processed_data)
            if ~isempty(noisy_data{i_data})
                noisy_data{i_data} = noisy_data{i_data} + normrnd(0, sd_noise, 1, n_bin);
            end
        end
        for i_cell = 1:n_cell
            for i_ind = 1:n_ind
                all_data = removeallemptydims(squeeze(noisy_data(i_cell, :, i_ind, :)));
                n_trial = min(sum(~cellfun(@isempty, all_data), 1));
                if n_trial ~= 0
                    all_data = all_data(1:n_trial, :);
                    for i_metric = 1:n_metric
                        measure(i_noise, i_sim, i_cell, i_ind, i_metric) = computeultimatemean(computesimilaritymetric(all_data, metrics{i_metric}));
                    end
                end
            end
        end
    end
end
end

function data = removeallnandims(data)
n_dims = ndims(data);
    function all_nan_dims = findalldim(data, dims)
        if isempty(dims)
            all_nan_dims = data;
        else
            all_nan_dims = findalldim(all(data, dims(1)), dims(2:end));
        end
    end
for i_dim = 1:n_dims
    subs_data = repelem({':'}, 1, n_dims);
    subs_data{i_dim} = ~findalldim(isnan(data), setdiff(1:n_dims, i_dim));
    data = subsref(data, substruct('()', subs_data));
end
end