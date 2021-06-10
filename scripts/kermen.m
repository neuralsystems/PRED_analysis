function kermen(recalc)

if nargin < 1
    recalc = false;
end

% Kermen, F. et al. Stimulus-specific behavioral responses of zebrafish to
% a large range of odors exhibit individual variability. BMC Biology 18, 66
% (2020).

% background/odor to calculate the metric changes are:
% 2 min background/ 2 minutes odor for all metrics except freezing
% 2 min background/ 4 min odor for freezing
raw_folder = 'data\kermen_2020\raw\';
file_name = 'data\kermen_2020\processed_data_kermen.mat';
load([raw_folder '12915_2020_801_MOESM6_ESM.mat'], 'ethogram');
if ~exist(file_name, 'file') || recalc
    load([raw_folder '12915_2020_801_MOESM2_ESM.mat'], 'raw_data');
    info_data.id_odor = ethogram.odors;
    info_data.id_odor{12} = 'afw'; % 'afw' is mentioned as 'water' in the ethogram
    info_data.id_odor{16} = 'cs'; % 'cs' is mentioned as 'chond' in the ethogram
  
    index.bg_start = 1200;
    index.bg_end = 2400;
    index.resp_start = 2401;
    index.resp_end = 3600;
    
    rate_sample = 1 / 10;
    min_len_frzng = 5;
    thresh_frzng = 0.4;
    thresh_burst = 1;
    thresh_turn = 90;
    smth_turn = 4;
    
    fn_vel = @(x, y, t) sqrt(diff(x) .^ 2 + diff(y) .^ 2) ./ t;
    
    % Convert data to n_trial x n_individual (brains) x n_odor.
    n_odor = 18;
    n_ind = 10;
    n_trial = 4;
    n_behavior = 7;
    n_index = size(raw_data, 1);
    behaviors = {'velocity', 'freezing', 'verticalposition', 'burstswim', 'abruptturn', 'horizontalswim', 'verticalswim'};
    processed_data = nan(n_behavior, n_trial, n_ind, n_odor);
    
    for i_index = 1:n_index
        i_ind = str2double(raw_data{i_index, 1}(5:end)); % fish index
        i_odor = contains(info_data.id_odor, raw_data{i_index, 2}); % odor index
        for i_trial = 1:n_trial % find current trial index for fish and odor
            if isnan(processed_data(contains(behaviors, 'velocity'), i_trial, i_ind, i_odor))
                break
            end
        end
        
        % speed is a vector containing the fish instantaneous speed. Since
        % the 10Hz recording is a bit of an overkill, Kermen et al used a
        % smoothed vector by taking the median speed value every 10 frames
        % but only to calculate the freezing due to the duration constraint
        % on that parameter
        spd = fn_vel(raw_data{i_index, 3}, raw_data{i_index, 4}, rate_sample); % raw spd
        i_smth = repelem(1:(length(spd) * rate_sample), 1, 1 / rate_sample).';
        spd_smth = accumarray(i_smth, spd, [], @nanmedian).';
        
        % calculate freezing
        i_frzng = find(spd_smth < thresh_frzng);
        % collection of freezing episodes
        last_frame = find(diff(i_frzng) ~= 1);
        consec = diff([0, last_frame, length(i_frzng)]); % this contains as many elements as consecutive frames with zeros
        ep_frzng = mat2cell(i_frzng, 1, consec); % freezing episodes
        % this part gets rid of the freezing episodes which are not long enough
        frzng=[];
        for i_ep = 1:length(ep_frzng)
            if length(ep_frzng{i_ep}) > min_len_frzng
                frzng = cat(2, frzng, ep_frzng{i_ep});
            end
        end
        
        % calculate velocity and positions without freezing episodes
        freezing = zeros(size(spd));% will contain 1 when fish is freezing
        vel = spd;% will be equal to speed if not freezing
        x_sans_frzng = raw_data{i_index, 3};
        y_sans_frzng = raw_data{i_index, 4};
        
        if ~isempty(frzng)
            % just convert freez into freezing at original sampling frequency
            to_remove=[];
            for f=1:size(frzng, 2)
                to_remove = cat(2, to_remove, frzng(1, f) * (1 / rate_sample):frzng(1, f) * (1 / rate_sample) + (1 / rate_sample - 1));
            end
            freezing(1, to_remove) = 1;
            % calculates velocity by removing freezing events
            vel(1, to_remove) = nan;
            x_sans_frzng(1, to_remove) = nan;
            y_sans_frzng(1, to_remove) = nan;
        end
        
        % calculate bursts
        acc = diff(vel);
        burst = double(acc > thresh_burst);
        
        % calculating  the turn angle
        angle = calculateangle([x_sans_frzng.', y_sans_frzng.']);
        
        % calculate horizontal and vertical swimming
        horz = double(abs(angle) < 10) / 4;
        vert = double(abs(angle) > 80) / 4;
        
        % calculate abrupt turns
        turns = calculateturns([x_sans_frzng.', y_sans_frzng.'], smth_turn, thresh_turn) / 4;
        
        % calculate and smooth vertical position
        vert_pos = raw_data{i_index, 4}; % no calculation, just the vertical position measured
        
        % collect data in the required format (average metric when odor
        % given (2min) - average metric before odor (2min)). For freezing 4
        % min is taken after odor
        processed_data(contains(behaviors, 'velocity'), i_trial, i_ind, i_odor) = nanmean(vel(index.resp_start:index.resp_end)) - nanmean(vel(index.bg_start:index.bg_end));
        processed_data(contains(behaviors, 'freezing'), i_trial, i_ind, i_odor) = nanmean(freezing(index.resp_start:end)) - nanmean(freezing(index.bg_start:index.bg_end));
        processed_data(contains(behaviors, 'burstswim'), i_trial, i_ind, i_odor) = nanmean(burst(index.resp_start:index.resp_end)) - nanmean(burst(index.bg_start:index.bg_end));
        processed_data(contains(behaviors, 'abruptturn'), i_trial, i_ind, i_odor) = sum(turns(index.resp_start:index.resp_end)) - sum(turns(index.bg_start:index.bg_end));
        processed_data(contains(behaviors, 'horizontalswim'), i_trial, i_ind, i_odor) = sum(horz(index.resp_start:index.resp_end)) - sum(horz(index.bg_start:index.bg_end));
        processed_data(contains(behaviors, 'verticalswim'), i_trial, i_ind, i_odor) = sum(vert(index.resp_start:index.resp_end)) - sum(vert(index.bg_start:index.bg_end));
        processed_data(contains(behaviors, 'verticalposition'), i_trial, i_ind, i_odor) = nanmean(vert_pos(index.resp_start:index.resp_end)) - nanmean(vert_pos(index.bg_start:index.bg_end));
    end
    
    % check calculated value medians with the medians provided in the paper
    % as supplementary data
    for i_behavior = 1:n_behavior
        checkmedians(nanmedian(squeeze(nanmean(processed_data(i_behavior, :, :, :), 2)), 1), ethogram.(behaviors{i_behavior}).median, behaviors{i_behavior})
    end
    
    % save file
    save(file_name, 'info_data', 'processed_data', 'behaviors', 'info_data');
else
    load(file_name, 'processed_data', 'behaviors');
    n_odor = 18;
end

if recalc
    data_x = repmat(1:n_odor, 1, 2);
    data_marker = repelem({'calculated', 'supplementary'}, 1 , n_odor);
    for i_behavior = 1:n_behavior
        [x, y] = ind2sub([2, 4], i_behavior);
        obj_plot(x, y) = gramm('x', data_x, 'y', [nanmedian(squeeze(nanmean(processed_data(i_behavior, :, :, :), 2)), 1), ethogram.(behaviors{i_behavior}).median], 'marker', data_marker, 'color', data_marker);
        obj_plot(x, y).geom_point('alpha', 0.5);
        obj_plot(x, y).set_title(behaviors{i_behavior});
        obj_plot(x, y).no_legend();
    end
    obj_plot(2, 3).set_layout_options('legend_position', [0.8 0.2 0.2 0.2]);
    obj_plot.set_names('x', '', 'y', '', 'marker', '');
    obj_plot.set_color_options('legend', 'merge');
    obj_plot.set_point_options('markers', {'o', 'd'}, 'base_size', 10);
    handle_fig = figure('Position', [0 0 900 450], 'PaperPositionMode', 'auto');
    obj_plot.draw();
    obj_plot.export('file_name', 'data\kermen_2020\compare_extraction', 'file_type', 'png');
    close(handle_fig)
    clear obj_plot
end
end

function angles = calculateangle(data)
angles = nan(size(data, 1) - 1, 1);
angle_fn = @(dx, dy) rad2deg(acos(abs(dy) ./ sqrt(dx .^ 2 + dy .^ 2)));
value_angle = angle_fn(diff(data(:, 1)), diff(data(:, 2)));
ind = data(1:end-1, 2) > data(2:end, 2);
angles(ind) = value_angle(ind) - 90;
angles(~ind) = 90 - value_angle(~ind);
end

function angles = calculateturnangle(data)
angles = zeros(size(data, 1), 1);
vec_angle=atan2(diff(data(:,2)), diff(data(:,1)));
% vec_angle(isnan(vec_angle),1)=0;  %for the cases dx=dy=0
angles(2:end-1) = rad2deg(diff(vec_angle));
index = angles > 180;
angles(index) = 360 - angles(index);
index = angles < -180;
angles(index) = 360 + angles(index);
end

function turns = calculateturns(data, smoothing_f, thresh_turn)
filtered = symplifyPoly(smoothing_f, data);
angles = calculateturnangle(filtered); % two first columns are X and Y positions
% remove the flat angles likely to be false detections (>160)
angles(abs(angles) > 178) = nan;
% set a filter for pointing only the big turns..
turns = abs(angles) > thresh_turn;
% angles_threshold = angles(turns);
end

function checkmedians(calc, supp, name)
if isequal(calc, supp)
    fprintf("%s matches\n", name)
else
    fprintf('%s doesn''t match:\n', name)
    disp([calc; supp])
end
end