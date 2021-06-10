function honegger(recalc)

if nargin < 1
    recalc = false;
end

% Honegger, K. S., Smith, M. A.-Y., Churgin, M. A., Turner, G. C. & Bivort,
% B. L. de. Idiosyncratic neural coding and neuromodulation of olfactory
% individuality in Drosophila. PNAS 201901623 (2019)
raw_folder = 'data\honegger_2019\raw\';
% all odor data
file_name = 'data\honegger_2019\processed_data_honegger.mat';
if ~exist(file_name, 'file') || recalc
    raw_data = load([raw_folder 'controlFlyTimeCourse.mat']);
    info_data.id_odor = raw_data.flyTimeCourse{1}{2, 2}(:, 1).';
    gloms_to_include = [1:13, 15]; % glomeruli to include as indicated by Honegger et al. 14th glomerulus has no data
    info_data.id_glomerulus = raw_data.flyTimeCourse{1}(gloms_to_include + 1, 1).';
    
    % Convert data to n_cell (pn) x n_trial x n_individual (brains) x n_odor. Sum over the time frames
    n_ind = length(raw_data.flyTimeCourse);
    n_cell = length(gloms_to_include);
    n_odor = size(raw_data.flyTimeCourse{1}{2, 2}, 1);
    n_trial = 2;
    relevant_data_frames = 7:13;
    
    processed_data.control = nan(n_cell, n_trial, n_ind, n_odor); % size decided using maximum observed values
    for i_ind = 1:n_ind
        for i_cell = 1:n_cell
            for i_odor = 1:n_odor
                if ~(i_ind == 6 && i_odor > 8) % Individual 6 only has 8 odors in the second trial. The last 4 odors are absent
                    for iTrial = 1:n_trial
                        processed_data.control(i_cell, iTrial, i_ind, i_odor) = sum(raw_data.flyTimeCourse{i_ind}{gloms_to_include(i_cell) + 1, iTrial + 1}{i_odor, 2}(relevant_data_frames));
                    end
                end
            end
        end
    end
    
    raw_data = load([raw_folder 'amwFlyTimeCourse.mat']);
    n_ind = length(raw_data.flyTimeCourse);
    processed_data.amw = nan(n_cell, n_trial, n_ind, n_odor); % size decided using maximum observed values
    for i_ind = 1:n_ind
        for i_cell = 1:n_cell
            for i_odor = 1:n_odor
                if ~(i_ind == 6 && i_odor > 8) % Individual 6 only has 8 odors in the second trial. The last 4 odors are absent
                    for iTrial = 1:n_trial
                        processed_data.amw(i_cell, iTrial, i_ind, i_odor) = sum(raw_data.flyTimeCourse{i_ind}{gloms_to_include(i_cell) + 1, iTrial + 1}{i_odor, 2}(relevant_data_frames));
                    end
                end
            end
        end
    end
    % save file
    save(file_name, 'info_data', 'processed_data');
end
end