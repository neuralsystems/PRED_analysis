function measure = computesimilaritymetric(data, metric, distance)

%**********************************************************************%
% Author: Aarush Mohit Mittal
% Contact: aarush (dot) mohit (at) gmail (dot) com
%**********************************************************************%

if nargin < 3
    distance = 'squaredeuclidean';
end

[n_sample, n_class] = size(data);

switch metric
    
    case 'pred_cv'
        measure = pred(data, 'distance', distance);
        
    case 'pred_cs'
        measure = pred(data, {}, 'distance', distance);
        
    case 'pc'
        data = cell2mat(data);
        % find all sample pairs
        pair_sample = nchoosek(1:n_sample, 2);
        n_pair_sample = size(pair_sample, 1);
        measure = zeros(n_pair_sample, 1);
        for i_pair_sample = 1:n_pair_sample
            measure(i_pair_sample) = corr(data(pair_sample(i_pair_sample, 1), :).', data(pair_sample(i_pair_sample, 2), :).', 'Type', 'Pearson', 'rows', 'complete');
        end % for i_pair_sample
    
    case 'cos'
        data = cell2mat(data);
        % find all sample pairs
        pair_sample = nchoosek(1:n_sample, 2);
        n_pair_sample = size(pair_sample, 1);
        measure = zeros(n_pair_sample, 1);
        for i_pair_sample = 1:n_pair_sample
            measure(i_pair_sample) = 1 - pdist([data(pair_sample(i_pair_sample, 1), :); data(pair_sample(i_pair_sample, 2), :)], 'cosine');
        end % for i_pair_sample
        
    case 'man'
        data = cell2mat(data);
        % find all sample pairs
        pair_sample = nchoosek(1:n_sample, 2);
        n_pair_sample = size(pair_sample, 1);
        measure = zeros(n_pair_sample, 1);
        for i_pair_sample = 1:n_pair_sample
            measure(i_pair_sample) = pdist([data(pair_sample(i_pair_sample, 1), :); data(pair_sample(i_pair_sample, 2), :)], 'cityblock');
        end % for i_pair_sample
        measure = exp(-nanmean(measure));
        
    case 'cheb'
        data = cell2mat(data);
        % find all sample pairs
        pair_sample = nchoosek(1:n_sample, 2);
        n_pair_sample = size(pair_sample, 1);
        measure = zeros(n_pair_sample, 1);
        for i_pair_sample = 1:n_pair_sample
            measure(i_pair_sample) = pdist([data(pair_sample(i_pair_sample, 1), :); data(pair_sample(i_pair_sample, 2), :)], 'chebychev');
        end % for i_pair_sample
        measure = exp(-nanmean(measure));
        
    case 'euc'
        data = cell2mat(data);
        % find all sample pairs
        pair_sample = nchoosek(1:n_sample, 2);
        n_pair_sample = size(pair_sample, 1);
        measure = zeros(n_pair_sample, 1);
        for i_pair_sample = 1:n_pair_sample
            measure(i_pair_sample) = pdist([data(pair_sample(i_pair_sample, 1), :); data(pair_sample(i_pair_sample, 2), :)], 'euclidean');
        end % for i_pair_sample
        measure = exp(-nanmean(measure));
        
    case 'man_o'
        data = cell2mat(data);
        % find all sample pairs
        pair_sample = nchoosek(1:n_sample, 2);
        n_pair_sample = size(pair_sample, 1);
        measure = zeros(n_pair_sample, 1);
        for i_pair_sample = 1:n_pair_sample
            measure(i_pair_sample) = pdist([data(pair_sample(i_pair_sample, 1), :); data(pair_sample(i_pair_sample, 2), :)], 'cityblock');
        end % for i_pair_sample
        measure = nanmean(measure);
        
    case 'cheb_o'
        data = cell2mat(data);
        % find all sample pairs
        pair_sample = nchoosek(1:n_sample, 2);
        n_pair_sample = size(pair_sample, 1);
        measure = zeros(n_pair_sample, 1);
        for i_pair_sample = 1:n_pair_sample
            measure(i_pair_sample) = pdist([data(pair_sample(i_pair_sample, 1), :); data(pair_sample(i_pair_sample, 2), :)], 'chebychev');
        end % for i_pair_sample
        measure = nanmean(measure);
        
    case 'euc_o'
        data = cell2mat(data);
        % find all sample pairs
        pair_sample = nchoosek(1:n_sample, 2);
        n_pair_sample = size(pair_sample, 1);
        measure = zeros(n_pair_sample, 1);
        for i_pair_sample = 1:n_pair_sample
            measure(i_pair_sample) = pdist([data(pair_sample(i_pair_sample, 1), :); data(pair_sample(i_pair_sample, 2), :)], 'euclidean');
        end % for i_pair_sample
        measure = nanmean(measure);
    
    case 'sil'
        data = cell2mat(data(:));
        clust = repelem((1:n_class).', n_sample, 1);
        evaluation = evalclusters(data, clust, 'Silhouette');
        measure = evaluation.CriterionValues(evaluation.InspectedK == n_class);
        
    case 'etm'
        measure = zeros(n_sample, n_class);
        for i_sample = 1:n_sample
            for i_class = 1:n_class
                template = arrayfun(@(x) nanmean(cell2mat(data(:, x)), 1), 1:n_class, 'UniformOutput', false);
                template{1, i_class} = nanmean(cell2mat(data(setdiff(1:n_sample, i_sample), i_class)), 1);
                % define the test class for current test
                test_set = data{i_sample, i_class};
                % find euclidean distance of test class from training classes
                if ~isempty(test_set)
                    dist_template = arrayfun(@(x) pdist([test_set; template{x}]), 1:n_class);
                    n_match = sum(dist_template == dist_template(i_class));
                    if min(dist_template) == dist_template(i_class) % correct template matched
                        measure(i_sample, i_class) = 1 / n_match;
                    end % if dist_template
                end
            end % for i_class
        end % for i_sample
        measure = mean(measure(:));
    
    case 'dbi'
        data = cell2mat(data(:));
        clust = repelem((1:n_class).', n_sample, 1);
        evaluation = evalclusters(data, clust, 'DaviesBouldin');
        measure = evaluation.CriterionValues(evaluation.InspectedK == n_class);
        
    case 'dunn'
        data = cell2mat(data(:));
        clust = repelem((1:n_class).', n_sample, 1);
        measure = indexDN(data, clust, 'squaredeuclidean');
    
    case 'ch'
        data = cell2mat(data(:));
        clust = repelem((1:n_class).', n_sample, 1);
        evaluation = evalclusters(data , clust, 'CalinskiHarabasz');
        measure = evaluation.CriterionValues(evaluation.InspectedK == n_class);
end