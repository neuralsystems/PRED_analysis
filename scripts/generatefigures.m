function generatefigures(plots_to_gen)
if nargin < 1
    plots_to_gen = 'all';
end

default_options = defaultplotoptions();

% Figure 1
if any(strcmp('fig-1', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-1';
    
    file_name = 'class_vector_chance_level.mat';
    raw_data_1 = load([default_options.folder.data file_name]);
    options_1 = default_options;
    options_1.color{2} = generatecolormap(1:6, 2);
    options_1.color{6} = 2;
    options_1.axis{16} = options_1.axis{16} * 0.55;
    id_metrics_1 = cellfun(@upper, raw_data_1.metrics(1:6), 'UniformOutput', false);
    id_metrics_1(contains(id_metrics_1, 'PRED_CV')) = {'PRED'};
    data_x = repmat(reshape(id_metrics_1, 1, 1, []), raw_data_1.n_range_class, raw_data_1.n_sim);
    data_y = raw_data_1.measure(:, :, 1:6);
    data_lightness = repelem(raw_data_1.range_class.', 1, raw_data_1.n_sim, raw_data_1.n_metric - 3);
    obj_plot(1, 1) = gramm('x', data_x(:), 'y', data_y(:), 'lightness', data_lightness(:));
    obj_plot(1, 1).stat_violin(options_1.stat_violin{:});
    obj_plot(1, 1).set_names('x', '', 'y', 'Similarity between vectors', 'lightness', '');
    obj_plot(1, 1).set_layout_options('position', [0.45 0.45 0.55 0.5], 'legend_position', [0.85 0.55 0.1 0.15]);
    obj_plot(1, 1).set_color_options(options_1.color{:});
    obj_plot(1, 1).set_point_options(options_1.point{:});
    y_lims = getlimoptions('Y', [-0.5 1], 4, '%.1f');
    obj_plot(1, 1).axe_property(y_lims{:}, options_1.axis{:});
    
    file_name = 'class_vector_sim_compare_noise.mat';
    raw_data_2 = load([default_options.folder.data file_name]);
    options_2 = default_options;
    options_2.color{2} = generatecolormap(1:3, 1);
    options_2.color{4} = 3;
    options_2.color{6} = 1;
    options_2.axis{2} = 'off';
    options_2.axis{16} = options_2.axis{16} * 1.5;
    range_left = zeros(raw_data_2.n_range_means, raw_data_2.n_metric);
    range_right = zeros(raw_data_2.n_range_means, raw_data_2.n_metric);
    range_mid = zeros(raw_data_2.n_range_means, raw_data_2.n_metric);
    mean_mid = zeros(raw_data_2.n_range_means, raw_data_2.n_metric);
    var_mid = zeros(raw_data_2.n_range_means, raw_data_2.n_metric);
    for i_mean = 1:raw_data_2.n_range_means
        temp_data = squeeze(raw_data_2.measure(i_mean, :, :, :));
        for i_metric = 1:raw_data_2.n_metric
            [range_left(i_mean, i_metric), range_right(i_mean, i_metric), range_mid(i_mean, i_metric), mean_mid(i_mean, i_metric), var_mid(i_mean, i_metric)] = calculatedrvar(squeeze(temp_data(:, :, i_metric)).', raw_data_2.range_noise);
        end
    end
    i_mean = 6;
    for i_metric = 1:raw_data_2.n_metric
        data_x = repelem(raw_data_2.range_noise.', 1, raw_data_2.n_sim);
        data_y = squeeze(raw_data_2.measure(i_mean, :, :, i_metric));
        options_2.color{2} = generatecolormap(i_metric, 1);
        options_2.color{4} = 1;
        options_2.color{6} = 1;
        obj_plot(1, i_metric + 1) = gramm('x', data_x(:), 'y', data_y(:));
        obj_plot(1, i_metric + 1).stat_summary('type', 'std', 'geom', 'area');
        obj_plot(1, i_metric + 1).geom_vline('xintercept', [range_left(i_mean, i_metric) range_right(i_mean, i_metric)], 'style', {'k--', 'k--'});
        obj_plot(1, i_metric + 1).set_names('x', 'log(Noise SD)', 'y', 'Similarity between vectors', 'color', '', 'column', '');
        obj_plot(1, i_metric + 1).set_layout_options('position', [0.25 * (i_metric - 1) 0 0.25 0.4],  'legend', false);
        obj_plot(1, i_metric + 1).set_color_options(options_2.color{:});
        obj_plot(1, i_metric + 1).axe_property('YLim', [-0.2 1.1], 'YTick', 0:0.5:1, 'YTickLabel', num2str((0:0.5:1).', '%.1f'), 'XTick', -2:3, 'XTickLabel', -2:3, options_2.axis{:});
        obj_plot(1, i_metric + 1).set_point_options(options_2.point{:});
    end
    options_2.color{2} = generatecolormap(1:raw_data_2.n_metric, 1);
    options_2.color{4} = raw_data_2.n_metric;
    options_2.color{6} = 1;
    options_2.point{2} = 15;
    options_2.axis{2} = 'on';
    data_x = var_mid(i_mean, :);
    data_y = range_right(i_mean, :) - range_left(i_mean, :);
    id_metrics_2 = cellfun(@upper, raw_data_2.metrics, 'UniformOutput', false);
    id_metrics_2(contains(id_metrics_2, 'PRED_CV')) = {'PRED'};
    data_color = id_metrics_2;
    data_label = id_metrics_2;
    obj_plot(1, 5) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:), 'label', data_label(:));
    obj_plot(1, 5).geom_point(options_2.geom_point{:});
    obj_plot(1, 5).geom_label();
    obj_plot(1, 5).set_names('x', 'Variability at mid range', 'y', 'Dynamic range');
    obj_plot(1, 5).set_layout_options('position', [0.75 0 0.25 0.4],  'legend', false);
    x_lims = getlimoptions('X', [0.1 0.3], 3, '%.1f');
    y_lims = getlimoptions('Y', [1 2], 3, '%.1f');
    obj_plot(1, 5).axe_property(y_lims{:}, x_lims{:}, 'XGrid', 'on', options_2.axis{:});
    obj_plot(1, 5).set_point_options(options_2.point{:});
    obj_plot(1, 5).set_color_options(options_2.color{:});
    
    obj_plot.set_line_options(options_2.line{:});
    obj_plot.set_text_options(options_2.text{:});
    obj_plot.set_order_options(options_2.order{:});
    
    handle_fig = figure('Position', [0 0 1600 900]);
    rng('default');
    obj_plot.draw();
    
    for i_metric = 1:6
        [~, p] = ttest2(squeeze(raw_data_1.measure(1, :, i_metric)), squeeze(raw_data_1.measure(2, :, i_metric)));
        mu=mean(raw_data_1.measure(:, :, i_metric), 2);
        text(i_metric, 0.8, sprintf('P=%.2g', p), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.extra_text{:});
        text(i_metric - 0.2, 0.7, sprintf('mu=%.4f', mu(1)), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.extra_text{:});
        text(i_metric + 0.2, 0.6, sprintf('mu=%.4f', mu(2)), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.extra_text{:});
        text(i_metric, -0.575, id_metrics_1{i_metric}, 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.xlabels{:});
        obj_plot(1, 1).results.stat_violin(1).point_handle(i_metric).MarkerFaceColor = options_1.color{2}(2 * i_metric - 1, :);
        obj_plot(1, 1).results.stat_violin(1).fill_handle(i_metric).FaceColor = options_1.color{2}(2 * i_metric - 1, :);
        obj_plot(1, 1).results.stat_violin(2).point_handle(i_metric).MarkerFaceColor = options_1.color{2}(2 * i_metric, :);
        obj_plot(1, 1).results.stat_violin(2).fill_handle(i_metric).FaceColor = options_1.color{2}(2 * i_metric, :);
    end
    obj_plot(1, 1).facet_axes_handles.XAxis.Visible = 'off';
    obj_plot(1, 1).legend_axe_handle.Children(3).String = '2 classes';
    obj_plot(1, 1).legend_axe_handle.Children(4).Color = [0.3 0.3 0.3];
    obj_plot(1, 1).legend_axe_handle.Children(4).LineWidth = 6;
    obj_plot(1, 1).legend_axe_handle.Children(1).String = '5 classes';
    obj_plot(1, 1).legend_axe_handle.Children(2).Color = [0.6 0.6 0.6];
    obj_plot(1, 1).legend_axe_handle.Children(2).LineWidth = 6;
    
    options_2.annotation{8} = 16;
    for i_metric = 1:raw_data_2.n_metric
        data_x = repelem(raw_data_2.range_noise(range_mid(i_mean, i_metric)), raw_data_2.n_sim, 1);
        data_y = squeeze(raw_data_2.measure(i_mean, range_mid(i_mean, i_metric), :, i_metric));
        options_2.color{2} = generatecolormap(i_metric, 1);
        options_2.color{4} = 1;
        options_2.color{6} = 1;
        obj_plot(1, i_metric + 1).update('x', data_x(:), 'y', data_y(:));
        obj_plot(1, i_metric + 1).geom_jitter(options_2.geom_point{:});
        obj_plot(1, i_metric + 1).set_color_options(options_2.color{:});
        obj_plot(1, i_metric + 1).draw();
        obj_plot(5).results.geom_label_handle{i_metric}.FontSize = 12;
        annotation(handle_fig, 'textbox', [0.25 * (i_metric - 1) + 0.125 0.4 0.05 0.05], 'String', id_metrics_2{i_metric}, options_2.annotation{:});
    end
    
    annotation(handle_fig, 'textbox', [0.00 0.94 0.05 0.05], 'String', 'a', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.44 0.94 0.05 0.05], 'String', 'b', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.00 0.42 0.05 0.05], 'String', 'c', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.22 0.42 0.05 0.05], 'String', 'd', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.47 0.42 0.05 0.05], 'String', 'e', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.72 0.42 0.05 0.05], 'String', 'f', default_options.annotation{:});
    exportgraph(obj_plot, default_options.folder.plot, plot_name, handle_fig)
    clearvars -except plots_to_gen default_options
end

% Figure 2
if any(strcmp('fig-2', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-2';
    
    file_name = 'class_vector_data_behavioral_honegger.mat';
    raw_data_1 = load([default_options.folder.data file_name]);
    options_2 = default_options;
    options_2.axis{16} = options_2.axis{16} * 1.5;
    id_metrics = cellfun(@upper, raw_data_1.metrics, 'UniformOutput', false);
    id_metrics(contains(id_metrics, 'PRED_CV')) = {'PRED'};
    data_x = repelem(id_metrics, raw_data_1.n_sim, 1);
    data_y = squeeze(raw_data_1.measure(1, :, :));
    data_color = data_x;
    coeff_var = std(data_y, [], 1) ./ mean(data_y, 1);
    mu=mean(data_y, 1);
    sigma = std(data_y, [], 1);
    [~, tt] = arrayfun(@(x) ttest(data_y(:, x), 0), 1:2);
    obj_plot(1, 1) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
    obj_plot(1, 1).stat_violin(options_2.stat_violin{:});
    obj_plot(1, 1).set_names('y', 'Similarity between time-points', 'x', '');
    obj_plot(1, 1).set_layout_options('position', [0.33 0 0.33 0.95],  'legend', false);
    obj_plot(1, 1).set_color_options(options_2.color{:});
    obj_plot(1, 1).set_point_options(options_2.point{:});
    y_lims = getlimoptions('Y', [0 0.6], 3, '%.1f');
    obj_plot(1, 1).axe_property(y_lims{:}, options_2.axis{:});
    obj_plot(1, 1).set_line_options(options_2.line{:});
    obj_plot(1, 1).set_text_options(options_2.text{:});
    obj_plot(1, 1).set_order_options(options_2.order{:});
    
    options_3 = default_options;
    options_3.color{2} = [0 0 0];
    options_3.color{4} = 1;
    options_3.color{6} = 1;
    options_3.point{2} = 15;
    data_x = repelem(id_metrics, raw_data_1.n_rep, 1);
    data_y = squeeze(std(raw_data_1.measure, [], 2) ./ mean(raw_data_1.measure, 2));
    data_group = repelem((1:raw_data_1.n_rep).', 1, 2);
    obj_plot(1, 2) = gramm('x', data_x(:), 'y', data_y(:), 'group', data_group(:));
    obj_plot(1, 2).geom_point(options_3.geom_point{:});
    obj_plot(1, 2).geom_line(options_3.geom_line{:});
    obj_plot(1, 2).set_names('x', '', 'y', 'Coefficient of variation');
    obj_plot(1, 2).set_layout_options('position', [0.66 0 0.34 0.95],  'legend', false);
    obj_plot(1, 2).set_color_options(options_3.color{:});
    obj_plot(1, 2).set_point_options(options_3.point{:});
    y_lims = getlimoptions('Y', [0.1 0.4], 4, '%.1f');
    obj_plot(1, 2).axe_property(y_lims{:}, 'XLim', [0.8 2.2], options_3.axis{:});
    obj_plot(1, 2).set_line_options(options_3.line{:});
    obj_plot(1, 2).set_text_options(options_3.text{:});
    obj_plot(1, 2).set_order_options(options_3.order{:});
    
    handle_fig = figure('Position', [0 0 1200 450]);
    rng('default');
    obj_plot.draw();
    
    obj_plot(1, 1).facet_axes_handles.XAxis.Visible = 'off';
    for i_metric = 1:2
        text(i_metric, 0.55, sprintf('COV = %.4f', coeff_var(i_metric)), 'Parent', obj_plot(1, 1).facet_axes_handles, options_2.extra_text{:});
        text(i_metric, 0.5, sprintf('%.4f±%.4f\nP=%.2g', mu(i_metric), sigma(i_metric), tt(i_metric)), 'Parent', obj_plot(1, 1).facet_axes_handles, options_2.extra_text{:});
        text(i_metric, -0.03, id_metrics{i_metric}, 'Parent', obj_plot(1, 1).facet_axes_handles, options_2.xlabels{:});
    end
    
    [~, p] = ttest(data_y(:, 1), data_y(:, 2));
    text(1.5, 0.35, sprintf('Paired ttest, P=%.2g', p), 'Parent', obj_plot(1, 2).facet_axes_handles, options_3.extra_text{:});
    obj_plot(1, 2).facet_axes_handles.XAxis.Visible = 'off';
    for i_metric = 1:2
        text(i_metric, 0.085, id_metrics{i_metric}, 'Parent', obj_plot(1, 2).facet_axes_handles, options_3.xlabels{:});
    end
    options_3.color{2} = generatecolormap(1:2, 1);
    options_3.color{4} = 2;
    options_3.color{6} = 1;
    options_3.line{2} = 4;
    means = mean(data_y);
    len_mean = 0.1;
    data_x = [1 - len_mean, 1 + len_mean, nan, 2 - len_mean, 2 + len_mean, nan];
    data_y = [means(1) means(1) nan means(2) means(2) nan];
    data_color = [1 1 1 2 2 2];
    obj_plot(1, 2).update('x', data_x, 'y', data_y, 'color', data_color);
    obj_plot(1, 2).geom_line();
    obj_plot(1, 2).set_color_options(options_3.color{:});
    obj_plot(1, 2).set_line_options(options_3.line{:});
    obj_plot(1, 2).no_legend();
    obj_plot(1, 2).draw();
    
    annotation(handle_fig, 'textbox', [0.00 0.97 0.05 0.05], 'String', 'a', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.32 0.97 0.05 0.05], 'String', 'b', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.65 0.97 0.05 0.05], 'String', 'c', default_options.annotation{:});
    exportgraph(obj_plot, default_options.folder.plot, plot_name, handle_fig)
    clearvars -except plots_to_gen default_options
end

% Figure 3
if any(strcmp('fig-3', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-3';
    
    file_name = 'class_vector_data_temporal_vs_magnitude.mat';
    raw_data_1 = load([default_options.folder.data file_name]);
    options_1 = default_options;
    options_1.color{2} = generatecolormap(1:2, 2);
    options_1.color{6} = 2;
    n_data_points = length(raw_data_1.measure.gupta{1});
    id_metrics = cellfun(@upper, raw_data_1.metrics, 'UniformOutput', false);
    id_metrics(contains(id_metrics, 'PRED_CV')) = {'PRED'};
    data_x = repelem(id_metrics, n_data_points * 2, 1);
    data_y = cell2mat(raw_data_1.measure.gupta);
    mu=cellfun(@mean, raw_data_1.measure.gupta);
    [~, p] = arrayfun(@(x) ttest(raw_data_1.measure.gupta{1, x}, raw_data_1.measure.gupta{2, x}), 1:2);
    data_lightness = repmat(repelem({'unbinned'; '10-bins'}, n_data_points, 1), 1, 2);
    obj_plot(1, 1) = gramm('x', data_x(:), 'y', data_y(:), 'lightness', data_lightness(:));
    obj_plot(1, 1).stat_violin(options_1.stat_violin{:});
    obj_plot(1, 1).set_names('x', '', 'y', 'Similarity between individuals', 'lightness', '');
    obj_plot(1, 1).set_layout_options('position', [0.65 0.45 0.35 0.53], 'legend_position', [0.88 0.55 0.1 0.1]);
    obj_plot(1, 1).set_color_options(options_1.color{:});
    obj_plot(1, 1).set_point_options(options_1.point{:});
    obj_plot(1, 1).set_line_options(options_1.line{:});
    obj_plot(1, 1).set_text_options(options_1.text{:});
    obj_plot(1, 1).set_order_options(options_1.order{:});
    y_lims = getlimoptions('Y', [0 1], 3, '%.1f');
    obj_plot(1, 1).axe_property(y_lims{:}, options_1.axis{:});
    
    file_name = 'class_vector_data_temporal_increase_bin.mat';
    raw_data_2 = load([default_options.folder.data file_name]);
    options_2 = default_options;
    data_x = repelem(raw_data_2.range_n_bin.', 1, raw_data_2.n_metric);
    data_y = raw_data_2.measure.gupta;
    data_color = repelem(id_metrics, raw_data_2.n_range_nbin, 1);
    obj_plot(1, 2) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
    obj_plot(1, 2).geom_point();
    obj_plot(1, 2).geom_line();
    obj_plot(1, 2).set_names('x', 'Number of noise bins', 'y', 'Similarity between individuals', 'color', '');
    obj_plot(1, 2).set_layout_options('position', [0 0 0.28 0.43], 'legend_position', [0.17 0.32 0.1 0.1]);
    obj_plot(1, 2).set_color_options(options_2.color{:});
    obj_plot(1, 2).set_point_options(options_2.point{:});
    obj_plot(1, 2).set_line_options(options_2.line{:});
    obj_plot(1, 2).set_text_options(options_2.text{:});
    obj_plot(1, 2).set_order_options(options_2.order{:});
    y_lims = getlimoptions('Y', [0 1], 3, '%.1f');
    obj_plot(1, 2).axe_property(y_lims{:}, options_2.axis{:});
    
    file_name = 'class_vector_sim_temporal_increase_bin.mat';
    raw_data_3 = load([default_options.folder.data file_name]);
    options_3 = default_options;
    data_x = repmat(raw_data_3.range_n_bin.', 1, raw_data_3.n_sim, raw_data_3.n_metric);
    data_y = raw_data_3.measure;
    data_color = repmat(reshape(id_metrics, 1, 1, []), raw_data_3.n_range_nbin, raw_data_3.n_sim, 1);
    obj_plot(1, 3) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
    obj_plot(1, 3).stat_summary('type', 'sem', 'geom', {'line', 'point', 'errorbar'});
    obj_plot(1, 3).set_names('x', 'Number of noise bins', 'y', 'Similarity between vectors', 'color', '');
    obj_plot(1, 3).set_layout_options('position', [0.28 0 0.28 0.43], 'legend_position', [0.47 0.32 0.1 0.1]);
    obj_plot(1, 3).set_color_options(options_3.color{:});
    obj_plot(1, 3).set_point_options(options_3.point{:});
    obj_plot(1, 3).set_line_options(options_3.line{:});
    obj_plot(1, 3).set_text_options(options_3.text{:});
    obj_plot(1, 3).set_order_options(options_3.order{:});
    y_lims = getlimoptions('Y', [0 1], 3, '%.1f');
    obj_plot(1, 3).axe_property(y_lims{:}, options_3.axis{:});
    
    file_name = 'class_vector_data_population_badel.mat';
    raw_data_4 = load([default_options.folder.data file_name]);
    options_4 = default_options;
    data_x = repelem({'separate'}, raw_data_4.n_cell, 1);
    data_y = cellfun(@(x) nanmean(x(:)), raw_data_4.measure.separate(:, 1));
    obj_plot(1, 4) = gramm('x', data_x(:), 'y', data_y(:));
    obj_plot(1, 4).stat_violin(options_4.stat_violin{:});
    y = nanmean(raw_data_4.measure.vector{1}(:));
    obj_plot(1, 4).set_layout_options('position', [0.82 0 0.18 0.43], 'legend', false);
    obj_plot(1, 4).set_names('x', '', 'y', 'Similarity between individuals', 'color', '');
    obj_plot(1, 4).set_color_options(options_4.color{:});
    obj_plot(1, 4).set_point_options(options_4.point{:});
    obj_plot(1, 4).set_line_options(options_4.line{:});
    obj_plot(1, 4).set_text_options(options_4.text{:});
    obj_plot(1, 4).set_order_options(options_4.order{:});
    y_lims = getlimoptions('Y', [0 0.6], 3, '%.2f');
    obj_plot(1, 4).axe_property(y_lims{:}, options_4.axis{:});
    
    handle_fig = figure('Position', [0 0 1600 1200]);
    rng('default');
    obj_plot.draw();
    
    for i_metric = 1:2
        text(i_metric, 0.8, sprintf('P=%.2g', p(i_metric)), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.xlabels{:});
        text(i_metric - 0.2, 0.7, sprintf('mu=%.4f', mu(1, i_metric)), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.xlabels{:});
        text(i_metric + 0.2, 0.6, sprintf('mu=%.4f', mu(2, i_metric)), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.xlabels{:});
        text(i_metric, -0.05, id_metrics{i_metric}, 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.xlabels{:});
        obj_plot(1, 1).results.stat_violin(1).point_handle(i_metric).MarkerFaceColor = options_1.color{2}(2 * i_metric - 1, :);
        obj_plot(1, 1).results.stat_violin(1).fill_handle(i_metric).FaceColor = options_1.color{2}(2 * i_metric - 1, :);
        obj_plot(1, 1).results.stat_violin(2).point_handle(i_metric).MarkerFaceColor = options_1.color{2}(2 * i_metric, :);
        obj_plot(1, 1).results.stat_violin(2).fill_handle(i_metric).FaceColor = options_1.color{2}(2 * i_metric, :);
    end
    obj_plot(1, 1).facet_axes_handles.XAxis.Visible = 'off';
    
    for i_axis = 1:3
        obj_plot(1, i_axis).legend_axe_handle.Children(4).LineWidth = 6;
        obj_plot(1, i_axis).legend_axe_handle.Children(2).LineWidth = 6;
    end
    obj_plot(1, 1).legend_axe_handle.Children(4).Color = [0.3 0.3 0.3];
    obj_plot(1, 1).legend_axe_handle.Children(2).Color = [0.6 0.6 0.6];
    
    obj_plot(1, 4).facet_axes_handles.XAxis.Visible = 'off';
    text(1, -0.03, 'separate', 'Parent', obj_plot(1, 4).facet_axes_handles, options_4.xlabels{:});
    [~, p] = ttest(data_y, y);
    text(1, 0.58, sprintf('P (vs vector) = %.2g', p), 'Parent', obj_plot(1, 4).facet_axes_handles, options_4.extra_text{:});
    [~, p] = ttest(data_y, 0);
    text(1, 0.53, sprintf('P (vs 0) = %.2g', p), 'Parent', obj_plot(1, 4).facet_axes_handles, options_4.extra_text{:});
    text(1, 0.48, sprintf('%.4f±%.4f', mean(data_y), std(data_y)), 'Parent', obj_plot(1, 4).facet_axes_handles, options_4.extra_text{:});
    data_x = [0.7 1.3 nan];
    data_y = [y y nan];
    obj_plot(1, 4).update('x', data_x, 'y', data_y);
    obj_plot(1, 4).geom_line();
    obj_plot(1, 4).set_line_options('styles', {'--'});
    obj_plot(1, 4).draw();
    text(1.2, y + 0.02, 'vector', 'Parent', obj_plot(1, 4).facet_axes_handles, options_4.xlabels{:}, 'Color', options_4.color{2}(1, :));
    text(0.8, y + 0.02, sprintf('mu=%.4f', y), 'Parent', obj_plot(1, 4).facet_axes_handles, options_4.xlabels{:}, 'Color', options_4.color{2}(1, :));
    
    annotation(handle_fig, 'textbox', [0.00 0.97 0.05 0.05], 'String', 'a', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.64 0.97 0.05 0.05], 'String', 'b', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.00 0.44 0.05 0.05], 'String', 'c', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.27 0.44 0.05 0.05], 'String', 'd', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.55 0.44 0.05 0.05], 'String', 'e', default_options.annotation{:});
    exportgraph(obj_plot, default_options.folder.plot, plot_name, handle_fig)
    clearvars -except plots_to_gen default_options
end

% Figure 4
if any(strcmp('fig-4', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-4';
    
    file_name = 'class_sample_check_pred.mat';
    raw_data_1 = load([default_options.folder.data file_name]);
    options_1 = default_options;
    options_1.color{2} = [0 0 0];
    options_1.color{4} = 1;
    options_1.color{6} = 1;
    options_1.point{2} = 12;
    id_metrics = cellfun(@upper, raw_data_1.metrics, 'UniformOutput', false);
    id_metrics(contains(id_metrics, 'PRED_CS')) = {'PRED'};
    temp_data = raw_data_1.measure.gupta;
    means = nanmean(reshape(temp_data, [], raw_data_1.n_metric), 1);
    for i_metric = 2:raw_data_1.n_metric
        data_x = temp_data(:, :, 1);
        data_y = temp_data(:, :, i_metric);
        [stats.pc(i_metric - 1), stats.p(i_metric - 1)] = corr(data_x(:), data_y(:), 'rows', 'complete');
        obj_plot(1, i_metric - 1) = gramm('x', data_x(:), 'y', data_y(:));
        obj_plot(1, i_metric - 1).geom_point(options_1.geom_point{:});
        obj_plot(1, i_metric - 1).set_names('x', 'PRED', 'y', id_metrics{i_metric});
        x_lims = getlimoptions('X', [0.5 0.7], 3, '%.1f');
        obj_plot(1, i_metric - 1).axe_property(x_lims{:}, options_1.axis{:});
        obj_plot(1, i_metric - 1).set_layout_options('position', [0.25 + 0.15 * (i_metric - 2) 0.55 0.145 0.4]);
        obj_plot(1, i_metric - 1).set_color_options(options_1.color{:});
        obj_plot(1, i_metric - 1).set_point_options(options_1.point{:});
        obj_plot(1, i_metric - 1).set_line_options(options_1.line{:});
        obj_plot(1, i_metric - 1).set_text_options(options_1.text{:});
        obj_plot(1, i_metric - 1).set_order_options(options_1.order{:});
    end
    
    file_name = 'class_sample_chance_level.mat';
    raw_data_2 = load([default_options.folder.data file_name]);
    options_2 = default_options;
    mu=squeeze(mean(raw_data_2.measure, 2));
    for i_metric = 1:6
        data_x = repmat(reshape(id_metrics(i_metric), 1, 1, []), raw_data_2.n_range_class, raw_data_2.n_sim);
        data_y = raw_data_2.measure(:, :, i_metric);
        data_lightness = repelem(raw_data_2.range_class.', 1, raw_data_2.n_sim, 1);
        options_2.color{2} = generatecolormap(i_metric, 2);
        options_2.color{4} = 1;
        options_2.color{6} = 2;
        obj_plot(1, i_metric + 5) = gramm('x', data_x(:), 'y', data_y(:), 'lightness', data_lightness(:));
        obj_plot(1, i_metric + 5).stat_violin(options_2.stat_violin{:});
        obj_plot(1, i_metric + 5).set_names('x', '', 'y', '', 'lightness', '');
        obj_plot(1, i_metric + 5).set_color_options(options_2.color{:});
        obj_plot(1, i_metric + 5).set_layout_options('position', [0.17 * (i_metric - 1) 0 0.16 0.48], 'legend', false);
        obj_plot(1, i_metric + 5).set_point_options(options_2.point{:});
        obj_plot(1, i_metric + 5).set_line_options(options_2.line{:});
        obj_plot(1, i_metric + 5).set_text_options(options_2.text{:});
        obj_plot(1, i_metric + 5).set_order_options(options_2.order{:});
        obj_plot(1, i_metric + 5).axe_property(options_2.axis{:});
    end
    obj_plot(1, 6).set_layout_options('position', [0 0 0.17 0.48], 'legend_position', [0.6 0.3 0.1 0.15]);
    obj_plot(1, 6).set_names('x', '', 'y', 'Separability across classes', 'lightness', '');
    
    handle_fig = figure('Position', [0 0 2000 900]);
    rng('default');
    obj_plot.draw();
    
    for i_metric = 2:raw_data_1.n_metric
        text(means(1), means(i_metric), sprintf('r = %.2f\nP = %.2g', stats.pc(i_metric - 1), stats.p(i_metric - 1)), 'Parent', obj_plot(1, i_metric - 1).facet_axes_handles, options_1.extra_text{:});
    end
    y_lims = getlimoptions('Y', [0.5 0.9], 3, '%.1f');
    set(obj_plot(1, 1).facet_axes_handles, y_lims{:})
    y_lims = getlimoptions('Y', [0.1 0.5], 3, '%.1f');
    set(obj_plot(1, 2).facet_axes_handles, y_lims{:})
    y_lims = getlimoptions('Y', [-0.001 0.005], 3, '%g');
    set(obj_plot(1, 3).facet_axes_handles, y_lims{1:4})
    y_lims = getlimoptions('Y', [0 10], 3, '%d');
    set(obj_plot(1, 4).facet_axes_handles, y_lims{:})
    y_lims = getlimoptions('Y', [20 90], 3, '%d');
    set(obj_plot(1, 5).facet_axes_handles, y_lims{:})
    
    for i_metric = 1:6
        obj_plot(1, i_metric + 5).facet_axes_handles.XAxis.Visible = 'off';
    end
    text(1, -0.33, id_metrics{1}, 'Parent', obj_plot(1, 6).facet_axes_handles, options_2.xlabels{:});
    text(1 - 0.2, -0.2, sprintf('mu=%.4f', mu(1, 1)), 'Parent', obj_plot(1, 6).facet_axes_handles, options_2.xlabels{:});
    text(1 + 0.2, -0.25, sprintf('mu=%.4f', mu(2, 1)), 'Parent', obj_plot(1, 6).facet_axes_handles, options_2.xlabels{:});
    y_lims = getlimoptions('Y', [-0.3 0.3], 3, '%.1f');
    set(obj_plot(1, 6).facet_axes_handles, y_lims{:});
    [~, p] = ttest2(squeeze(raw_data_2.measure(1, :, 1)), squeeze(raw_data_2.measure(2, :, 1)));
    text(1, 0.25, sprintf('P=%.2g', p), 'Parent', obj_plot(1, 6).facet_axes_handles, options_2.extra_text{:});
    obj_plot(1, 6).legend_axe_handle.Children(3).String = '2 classes';
    obj_plot(1, 6).legend_axe_handle.Children(4).Color = [0.3 0.3 0.3];
    obj_plot(1, 6).legend_axe_handle.Children(4).LineWidth = 6;
    obj_plot(1, 6).legend_axe_handle.Children(1).String = '5 classes';
    obj_plot(1, 6).legend_axe_handle.Children(2).Color = [0.6 0.6 0.6];
    obj_plot(1, 6).legend_axe_handle.Children(2).LineWidth = 6;
    
    text(1, -0.05, id_metrics{2}, 'Parent', obj_plot(1, 7).facet_axes_handles, options_2.xlabels{:});
    text(1 - 0.2, 0.2, sprintf('mu=%.4f', mu(1, 2)), 'Parent', obj_plot(1, 7).facet_axes_handles, options_2.xlabels{:});
    text(1 + 0.2, 0.15, sprintf('mu=%.4f', mu(2, 2)), 'Parent', obj_plot(1, 7).facet_axes_handles, options_2.xlabels{:});
    y_lims = getlimoptions('Y', [0 1], 3, '%.1f');
    set(obj_plot(1, 7).facet_axes_handles, y_lims{:});
    [~, p] = ttest2(squeeze(raw_data_2.measure(1, :, 2)), squeeze(raw_data_2.measure(2, :, 2)));
    text(1, 0.9, sprintf('P=%.2g', p), 'Parent', obj_plot(1, 7).facet_axes_handles, options_2.extra_text{:});
    
    text(1, -0.44, id_metrics{3}, 'Parent', obj_plot(1, 8).facet_axes_handles, options_2.xlabels{:});
    text(1 - 0.2, -0.2, sprintf('mu=%.4f', mu(1, 3)), 'Parent', obj_plot(1, 8).facet_axes_handles, options_2.xlabels{:});
    text(1 + 0.2, -0.25, sprintf('mu=%.4f', mu(2, 3)), 'Parent', obj_plot(1, 8).facet_axes_handles, options_2.xlabels{:});
    y_lims = getlimoptions('Y', [-0.4 0.4], 3, '%.1f');
    set(obj_plot(1, 8).facet_axes_handles, y_lims{:});
    [~, p] = ttest2(squeeze(raw_data_2.measure(1, :, 3)), squeeze(raw_data_2.measure(2, :, 3)));
    text(1, 0.35, sprintf('P=%.2g', p), 'Parent', obj_plot(1, 8).facet_axes_handles, options_2.extra_text{:});
    
    text(1, -0.002, id_metrics{4}, 'Parent', obj_plot(1, 9).facet_axes_handles, options_2.xlabels{:});
    text(1 - 0.2, 0.005, sprintf('mu=%.4f', mu(1, 4)), 'Parent', obj_plot(1, 9).facet_axes_handles, options_2.xlabels{:});
    text(1 + 0.2, 0.003, sprintf('mu=%.4f', mu(2, 4)), 'Parent', obj_plot(1, 9).facet_axes_handles, options_2.xlabels{:});
    y_lims = getlimoptions('Y', [0 0.04], 3, '%.2f');
    set(obj_plot(1, 9).facet_axes_handles, y_lims{:});
    [~, p] = ttest2(squeeze(raw_data_2.measure(1, :, 4)), squeeze(raw_data_2.measure(2, :, 4)));
    text(1, 0.028, sprintf('P=%.2g', p), 'Parent', obj_plot(1, 9).facet_axes_handles, options_2.extra_text{:});
    
    text(1, -5, id_metrics{5}, 'Parent', obj_plot(1, 10).facet_axes_handles, options_2.xlabels{:});
    text(1 - 0.2, 15, sprintf('mu=%.4f', mu(1, 5)), 'Parent', obj_plot(1, 10).facet_axes_handles, options_2.xlabels{:});
    text(1 + 0.2, 10, sprintf('mu=%.4f', mu(2, 5)), 'Parent', obj_plot(1, 10).facet_axes_handles, options_2.xlabels{:});
    y_lims = getlimoptions('Y', [0 100], 3, '%d');
    set(obj_plot(1, 10).facet_axes_handles, y_lims{:});
    [~, p] = ttest2(squeeze(raw_data_2.measure(1, :, 5)), squeeze(raw_data_2.measure(2, :, 5)));
    text(1, 80, sprintf('P=%.2g', p), 'Parent', obj_plot(1, 10).facet_axes_handles, options_2.extra_text{:});
    
    text(1, -0.4, id_metrics{6}, 'Parent', obj_plot(1, 11).facet_axes_handles, options_2.xlabels{:});
    text(1 - 0.2, 2, sprintf('mu=%.4f', mu(1, 6)), 'Parent', obj_plot(1, 11).facet_axes_handles, options_2.xlabels{:});
    text(1 + 0.2, 1.5, sprintf('mu=%.4f', mu(2, 6)), 'Parent', obj_plot(1, 11).facet_axes_handles, options_2.xlabels{:});
    y_lims = getlimoptions('Y', [0 8], 3, '%d');
    set(obj_plot(1, 11).facet_axes_handles, y_lims{:});
    [~, p] = ttest2(squeeze(raw_data_2.measure(1, :, 6)), squeeze(raw_data_2.measure(2, :, 6)));
    text(1, 7.5, sprintf('P=%.2g', p), 'Parent', obj_plot(1, 11).facet_axes_handles, options_2.extra_text{:});
    
    annotation(handle_fig, 'textbox', [0.00 0.97 0.05 0.05], 'String', 'a', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.24 0.97 0.05 0.05], 'String', 'b', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.39 0.97 0.05 0.05], 'String', 'c', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.54 0.97 0.05 0.05], 'String', 'd', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.69 0.97 0.05 0.05], 'String', 'e', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.84 0.97 0.05 0.05], 'String', 'f', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.00 0.52 0.05 0.05], 'String', 'g', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.15 0.52 0.05 0.05], 'String', 'h', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.32 0.52 0.05 0.05], 'String', 'i', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.49 0.52 0.05 0.05], 'String', 'j', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.66 0.52 0.05 0.05], 'String', 'k', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.82 0.52 0.05 0.05], 'String', 'l', default_options.annotation{:});
    exportgraph(obj_plot, default_options.folder.plot, plot_name, handle_fig)
    clearvars -except plots_to_gen default_options
end

% Figure 5
if any(strcmp('fig-5', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-5';
    
    file_name = 'class_sample_increasing_n_class_2samp.mat';
    raw_data_1 = load([default_options.folder.data file_name]);
    options_1 = default_options;
    id_metrics = cellfun(@upper, raw_data_1.metrics, 'UniformOutput', false);
    id_metrics(contains(id_metrics, 'PRED_CS')) = {'PRED'};
    data_x = repelem(raw_data_1.range_class, raw_data_1.n_sim, 1, raw_data_1.n_metric);
    data_y = zeros(size(raw_data_1.measure));
    for i_metric = 1:raw_data_1.n_metric
        data_y(:, :, i_metric) = raw_data_1.measure(:, :, i_metric) ./ max(nanmean(raw_data_1.measure(:, :, i_metric), 1));
    end
    data_color = repelem(reshape(id_metrics, 1, 1, []), raw_data_1.n_sim, raw_data_1.n_range_class, 1);
    obj_plot(1, 1) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
    obj_plot(1, 1).stat_summary('geom', {'line', 'point', 'errorbar'});
    obj_plot(1, 1).stat_glm('geom', 'line');
    obj_plot(1, 1).set_names('x', 'Number of classes', 'y', 'Separability across classes', 'color', '');
    obj_plot(1, 1).set_layout_options('position', [0 0 0.32 0.95], 'legend_position', [0.96 0.25 0.1 0.5]);
    obj_plot(1, 1).set_color_options(options_1.color{:});
    obj_plot(1, 1).set_point_options(options_1.point{:});
    obj_plot(1, 1).set_line_options(options_1.line{:});
    obj_plot(1, 1).set_text_options(options_1.text{:});
    obj_plot(1, 1).set_order_options(options_1.order{:});
    y_lims = getlimoptions('Y', [-0.5 2], 6, '%.1f');
    obj_plot(1, 1).axe_property(y_lims{:}, options_1.axis{:});
    
    file_name = 'class_sample_increasing_n_class.mat';
    raw_data_3 = load([default_options.folder.data file_name]);
    options_3 = default_options;
    data_x = repelem(raw_data_3.range_class, raw_data_3.n_sim, 1, raw_data_3.n_metric);
    data_y = zeros(size(raw_data_3.measure));
    for i_metric = 1:raw_data_3.n_metric
        data_y(:, :, i_metric) = raw_data_3.measure(:, :, i_metric) ./ max(nanmean(raw_data_3.measure(:, :, i_metric), 1));
    end
    data_color = repelem(reshape(id_metrics, 1, 1, []), raw_data_3.n_sim, raw_data_3.n_range_class, 1);
    obj_plot(1, 3) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
    obj_plot(1, 3).stat_summary('geom', {'line', 'point', 'errorbar'});
    obj_plot(1, 3).stat_glm('geom', 'line');
    obj_plot(1, 3).set_names('x', 'Number of classes', 'y', 'Separability across classes', 'color', '');
    obj_plot(1, 3).set_layout_options('position', [0.32 0 0.32 0.95], 'legend', false);
    obj_plot(1, 3).set_color_options(options_3.color{:});
    obj_plot(1, 3).set_point_options(options_3.point{:});
    obj_plot(1, 3).set_line_options(options_3.line{:});
    obj_plot(1, 3).set_text_options(options_3.text{:});
    obj_plot(1, 3).set_order_options(options_3.order{:});
    y_lims = getlimoptions('Y', [-0.5 2], 6, '%.1f');
    obj_plot(1, 3).axe_property(y_lims{:}, options_3.axis{:});
    
    file_name = 'class_sample_increasing_n_sample.mat';
    raw_data_2 = load([default_options.folder.data file_name]);
    options_2 = default_options;
    data_x = repelem(raw_data_2.range_sample, raw_data_2.n_sim, 1, raw_data_2.n_metric);
    data_y = zeros(size(raw_data_2.measure));
    for i_metric = 1:raw_data_2.n_metric
        data_y(:, :, i_metric) = raw_data_2.measure(:, :, i_metric) ./ max(nanmean(raw_data_2.measure(:, :, i_metric), 1));
    end
    data_color = repelem(reshape(id_metrics, 1, 1, []), raw_data_2.n_sim, raw_data_2.n_range_sample, 1);
    obj_plot(1, 2) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
    obj_plot(1, 2).stat_summary('geom', {'line', 'point', 'errorbar'});
    obj_plot(1, 2).stat_glm('geom', 'line');
    obj_plot(1, 2).set_names('x', 'Number of samples', 'y', 'Separability across classes', 'color', '');
    obj_plot(1, 2).set_layout_options('position', [0.64 0 0.32 0.95], 'legend', false);
    obj_plot(1, 2).set_color_options(options_2.color{:});
    obj_plot(1, 2).set_point_options(options_2.point{:});
    obj_plot(1, 2).set_line_options(options_2.line{:});
    obj_plot(1, 2).set_text_options(options_2.text{:});
    obj_plot(1, 2).set_order_options(options_2.order{:});
    y_lims = getlimoptions('Y', [-0.5 2], 6, '%.1f');
    obj_plot(1, 2).axe_property(y_lims{:}, options_2.axis{:});
    
    handle_fig = figure('Position', [0 0 1800 450]);
    rng('default');
    obj_plot.draw();
    
    for i_metric = 1:raw_data_1.n_metric
        obj_plot(1, 1).results.stat_glm(i_metric).line_handle.Visible = 'off';
        dev = devianceTest(obj_plot(1, 1).results.stat_glm(i_metric).model);
        [~, p] = ttest2(raw_data_1.measure(:, 1, i_metric), raw_data_1.measure(:, end, i_metric));
        text(6, 1.8 - 0.1 * i_metric, sprintf('%s P=%.2g, linfit p = %.2g', id_metrics{i_metric}, p, dev.pValue(2)), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.extra_text{:});
        obj_plot(1, 1).legend_axe_handle.Children(i_metric * 2).LineWidth = 6;
    end
    text(6, 1.9, '2 samples', 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.extra_text{:});
    
    for i_metric = 1:raw_data_3.n_metric
        obj_plot(1, 3).results.stat_glm(i_metric).line_handle.Visible = 'off';
        dev = devianceTest(obj_plot(1, 3).results.stat_glm(i_metric).model);
        [~, p] = ttest2(raw_data_3.measure(:, 1, i_metric), raw_data_3.measure(:, end, i_metric));
        text(4, 1.8 - 0.1 * i_metric, sprintf('%s P=%.2g, linfit p = %.2g', id_metrics{i_metric}, p, dev.pValue(2)), 'Parent', obj_plot(1, 3).facet_axes_handles, options_3.extra_text{:});
    end
    text(6, 1.9, '10 samples', 'Parent', obj_plot(1, 3).facet_axes_handles, options_1.extra_text{:});
    
    for i_metric = 1:raw_data_2.n_metric
        obj_plot(1, 2).results.stat_glm(i_metric).line_handle.Visible = 'off';
        dev = devianceTest(obj_plot(1, 2).results.stat_glm(i_metric).model);
        [~, p] = ttest2(raw_data_2.measure(:, 1, i_metric), raw_data_2.measure(:, end, i_metric));
        text(10, 1.8 - 0.1 * i_metric, sprintf('%s P=%.2g, linfit p = %.2g', id_metrics{i_metric}, p, dev.pValue(2)), 'Parent', obj_plot(1, 2).facet_axes_handles, options_2.extra_text{:});
    end
    
    annotation(handle_fig, 'textbox', [0.00 0.99 0.05 0.05], 'String', 'a', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.63 0.99 0.05 0.05], 'String', 'b', default_options.annotation{:});
    exportgraph(obj_plot, default_options.folder.plot, plot_name, handle_fig)
    clearvars -except plots_to_gen default_options
end

% Figure 6
if any(strcmp('fig-6', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-6';
    
    file_name = 'class_sample_increasing_noise.mat';
    raw_data_1 = load([default_options.folder.data file_name]);
    temp_data = raw_data_1.measure;
    range_left = zeros(raw_data_1.n_metric, 1);
    range_right = zeros(raw_data_1.n_metric, 1);
    range_mid = zeros(raw_data_1.n_metric, 1);
    mean_mid = zeros(raw_data_1.n_metric, 1);
    var_mid = zeros(raw_data_1.n_metric, 1);
    for i_metric = 1:raw_data_1.n_metric
        [range_left(i_metric), range_right(i_metric), range_mid(i_metric), mean_mid(i_metric), var_mid(i_metric)] = calculatedrvar(squeeze(temp_data(:, :, i_metric)), raw_data_1.range_noise);
    end
    options_1 = default_options;
    options_1.axis{2} = 'off';
    id_metrics = cellfun(@upper, raw_data_1.metrics, 'UniformOutput', false);
    id_metrics(contains(id_metrics, 'PRED_CS')) = {'PRED'};
    for i_metric = 1:raw_data_1.n_metric
        data_x = repelem(raw_data_1.range_noise, raw_data_1.n_sim, 1, 1);
        data_y = raw_data_1.measure(:, :, i_metric);
        options_1.color{2} = generatecolormap(i_metric, 1);
        options_1.color{4} = 1;
        options_1.color{6} = 1;
        [x, y] = ind2sub([2 3], i_metric);
        obj_plot(1, i_metric) = gramm('x', data_x(:), 'y', data_y(:));
        obj_plot(1, i_metric).stat_summary('type', 'std', 'geom', 'area');
        obj_plot(1, i_metric).geom_vline('xintercept', [range_left(i_metric) range_right(i_metric)], 'style', {'k--', 'k--'});
        obj_plot(1, i_metric).set_names('x', 'log(Noise SD)', 'y', id_metrics{i_metric}, 'color', '', 'column', '');
        obj_plot(1, i_metric).set_layout_options('position', [0.25 * (y - 1), 1 - 0.5 * x, 0.24, 0.45], 'legend', false);
        obj_plot(1, i_metric).set_color_options(options_1.color{:});
        obj_plot(1, i_metric).axe_property('XTick', -3:3, 'XTickLabel', -3:3, options_1.axis{:});
        obj_plot(1, i_metric).set_point_options(options_1.point{:});
    end
    options_1.color{2} = generatecolormap(1:6, 1);
    options_1.color{4} = 6;
    options_1.color{6} = 1;
    options_1.point{2} = 15;
    options_1.axis{2} = 'on';
    obj_plot(1, 7) = gramm('x', var_mid, 'y', range_right - range_left, 'color', id_metrics, 'label', id_metrics);
    obj_plot(1, 7).geom_point(options_1.geom_point{:});
    obj_plot(1, 7).geom_label();
    obj_plot(1, 7).set_names('x', 'Variability at mid range', 'y', 'Dynamic range');
    obj_plot(1, 7).set_layout_options('position', [0.74, 0.25, 0.25, 0.5], 'legend', false);
    obj_plot(1, 7).set_color_options(options_1.color{:});
    obj_plot(1, 7).set_point_options(options_1.point{:});
    x_lims = getlimoptions('X', [0 0.8], 3, '%.1f');
    y_lims = getlimoptions('Y', [1.7 2.3], 3, '%.1f');
    obj_plot(1, 7).axe_property(y_lims{:}, x_lims{:}, 'XGrid', 'on', options_1.axis{:});
    obj_plot.set_line_options(options_1.line{:});
    obj_plot.set_text_options(options_1.text{:});
    obj_plot.set_order_options(options_1.order{:});
    
    handle_fig = figure('Position', [0 0 1800 900], 'PaperPositionMode', 'auto');
    rng('default');
    obj_plot.draw();
    
    options_1.annotation{8} = 16;
    for i_metric = 1:raw_data_1.n_metric
        data_x = repelem(raw_data_1.range_noise(range_mid(i_metric)), raw_data_1.n_sim, 1);
        data_y = squeeze(raw_data_1.measure(:, range_mid(i_metric), i_metric));
        options_1.color{2} = generatecolormap(i_metric, 1);
        options_1.color{4} = 1;
        options_1.color{6} = 1;
        obj_plot(1, i_metric).update('x', data_x(:), 'y', data_y(:));
        obj_plot(1, i_metric).geom_jitter(options_1.geom_point{:});
        obj_plot(1, i_metric).no_legend();
        obj_plot(1, i_metric).set_color_options(options_1.color{:});
        obj_plot(1, i_metric).draw();
        obj_plot(1, 7).results.geom_label_handle{i_metric}.FontSize = 12;
        [x, y] = ind2sub([2 3], i_metric);
        annotation(handle_fig, 'textbox', [0.25 * (y - 1) + 0.125, 1.45 - 0.5 * x 0.05 0.05], 'String', id_metrics{i_metric}, options_1.annotation{:});
    end
    y_lims = getlimoptions('Y', [0 1], 3, '%.1f');
    set(obj_plot(1, 1).facet_axes_handles, 'YLim', [-0.1 1.1], y_lims{3:end});
    y_lims = getlimoptions('Y', [0 1], 3, '%.1f');
    set(obj_plot(1, 2).facet_axes_handles, 'YLim', [-0.05 1.1], y_lims{3:end});
    y_lims = getlimoptions('Y', [0 300], 3, '%d');
    set(obj_plot(1, 3).facet_axes_handles, 'YLim', [-10 300], y_lims{3:end});
    y_lims = getlimoptions('Y', [0 1], 3, '%.1f');
    set(obj_plot(1, 4).facet_axes_handles, 'YLim', [-0.15 1.1], y_lims{3:end});
    y_lims = getlimoptions('Y', [-10 50], 3, '%d');
    set(obj_plot(1, 5).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 1.25e4], 3, '%d');
    set(obj_plot(1, 6).facet_axes_handles, 'YLim', [-300 1.25e4], y_lims{3:end});
    obj_plot(1, 7).results.geom_label_handle{1}.Position(1) = 0.16;

    annotation(handle_fig, 'textbox', [0.00 0.97 0.05 0.05], 'String', 'a', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.24 0.97 0.05 0.05], 'String', 'b', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.49 0.97 0.05 0.05], 'String', 'c', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.00 0.47 0.05 0.05], 'String', 'd', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.24 0.47 0.05 0.05], 'String', 'e', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.49 0.47 0.05 0.05], 'String', 'f', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.73 0.80 0.05 0.05], 'String', 'g', default_options.annotation{:});
    exportgraph(obj_plot, default_options.folder.plot, plot_name, handle_fig)
    clearvars -except plots_to_gen default_options
end

% Figure 7
if any(strcmp('fig-7', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-7';
    
    file_name = 'class_sample_data_behavioral_kermen.mat';
    raw_data_1 = load([default_options.folder.data file_name]);
    options_1 = default_options;
    data_x = repelem(raw_data_1.info_data.id_odor.', numel(raw_data_1.measure{1}), 1);
    data_y = cell2mat(cellfun(@(x) x(:), raw_data_1.measure, 'UniformOutput', false));
    [~, id_sorted] = sort(cellfun(@computeultimatemean, raw_data_1.measure), 'descend');
    id_odor_sorted = raw_data_1.info_data.id_odor(id_sorted);
    options_1.order{2} = id_odor_sorted;
    obj_plot(1, 1) = gramm('x', data_x(:), 'y', data_y(:));
    obj_plot(1, 1).stat_violin(options_1.stat_violin{:});
    obj_plot(1, 1).set_names('x', '', 'y', 'Separability across individuals');
    obj_plot(1, 1).set_color_options(options_1.color{:});
    obj_plot(1, 1).set_point_options(options_1.point{:});
    obj_plot(1, 1).set_line_options(options_1.line{:});
    obj_plot(1, 1).set_text_options(options_1.text{:});
    obj_plot(1, 1).set_order_options(options_1.order{:});
    y_lims = getlimoptions('Y', [-0.5 1], 4, '%.1f');
    obj_plot(1, 1).axe_property(y_lims{:}, options_1.axis{:});
    obj_plot(1, 1).set_layout_options('position', [0.2 0.48 0.8 0.48]);
    
    obj_plot(1, 2) = gramm('x', 0, 'y', 0);
    obj_plot(1, 2).geom_point();
    obj_plot(1, 2).set_layout_options('position', [0 0 0 0]);
    
    handle_fig = figure('Position', [0 0 1400 1200]);
    rng('default');
    obj_plot.draw();
    
    [~, p] = cellfun(@(x) ttest(x(:), 0), raw_data_1.measure);
    p = p(id_sorted);
    n_x = cellfun(@(x) sum(~isnan(x)), raw_data_1.measure);
    n_x = n_x(id_sorted);
    means = cellfun(@nanmean, raw_data_1.measure);
    sigmas = cellfun(@nanstd, raw_data_1.measure);
    means = means(id_sorted);
    sigmas = sigmas(id_sorted);
    for i_odor = 1:raw_data_1.n_odor
        text(i_odor, means(i_odor) + (-1) ^ mod(i_odor, 2) * 0.3, sprintf('P=%.2g,n=%d', p(i_odor), n_x(i_odor)), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.extra_text{:});
        text(i_odor, means(i_odor) + (-1) ^ mod(i_odor, 2) * 0.2, sprintf('%.4f±%.4f', means(i_odor), sigmas(i_odor)), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.extra_text{:});
        text(i_odor, -0.575, id_odor_sorted{i_odor}, 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.xlabels{:});
    end
    obj_plot(1, 1).facet_axes_handles.XAxis.Visible = 'off';
    
    obj_plot(1, 2).facet_axes_handles.Visible = 'off';
    obj_plot(1, 2).facet_axes_handles.Children.Visible = 'off';
    
    file_name = 'class_sample_data_neural_honegger.mat';
    raw_data_2 = load([default_options.folder.data file_name]);
    options_2 = default_options;
    options_2.axis{16} = [0 0];
    colors = [generatecolormap(1, 1); 1 1 1; generatecolormap(3, 1)];
    handle_ax = subplot('position', [0.1 0.1 0.38 0.42], 'Parent', handle_fig);
    data_z = cellfun(@computeultimatemean, raw_data_2.measure.control).';
    data_sig = cellfun(@(x) ttest(x(~isnan(x)), 0), raw_data_2.measure.control).';
    data_sig(isnan(data_sig)) = 0;
    data_sig = logical(data_sig);
    data_z(data_z > 0 & data_sig) = 0.8;
    data_z(data_z < 0 & data_sig) = 0;
    data_z(~data_sig) = 0;
    imagesc(handle_ax, data_z, [-1 1])
    set(handle_ax, 'FontSize', 16, 'YTick', 1:raw_data_2.n_odor, 'YTickLabel', raw_data_2.info_data.id_odor, 'YTickLabelRotation', 0, 'XTick', 1:raw_data_2.n_glom, 'XTickLabel', raw_data_2.info_data.id_glomerulus, 'XTickLabelRotation', 90, options_2.axis{3:end})
    text(5, 5, sprintf('n = %d/%d = %.2f%%', sum(data_z(:) > 0), length(data_z(:)), sum(data_z(:) > 0) * 100 / length(data_z(:))), 'Parent', handle_ax, options_2.extra_text{:});
    colormap(colors)
    
    handle_ax = subplot('position', [0.6 0.1 0.38 0.42], 'Parent', handle_fig);
    data_z = cellfun(@computeultimatemean, raw_data_2.measure.amw).';
    data_sig = cellfun(@(x) ttest(x(~isnan(x)), 0), raw_data_2.measure.amw).';
    data_sig(isnan(data_sig)) = 0;
    data_sig = logical(data_sig);
    data_z(data_z > 0 & data_sig) = 0.8;
    data_z(data_z < 0 & data_sig) = 0;
    data_z(~data_sig) = 0;
    imagesc(handle_ax, data_z, [-1 1])
    set(handle_ax, 'FontSize', 16, 'YTick', 1:raw_data_2.n_odor, 'YTickLabel', raw_data_2.info_data.id_odor, 'YTickLabelRotation', 0, 'XTick', 1:raw_data_2.n_glom, 'XTickLabel', raw_data_2.info_data.id_glomerulus, 'XTickLabelRotation', 90, options_2.axis{3:end})
    text(5, 5, sprintf('n = %d/%d = %.2f%%', sum(data_z(:) > 0), length(data_z(:)), sum(data_z(:) > 0) * 100 / length(data_z(:))), 'Parent', handle_ax, options_2.extra_text{:});
    colormap(colors)
    
    options_2.annotation{8} = 16;
    annotation(handle_fig, 'textbox', [0.26 0.52 0.05 0.05], 'String', 'control', options_2.annotation{:});
    annotation(handle_fig, 'textbox', [0.78 0.52 0.05 0.05], 'String', 'serotonin-blocked', options_2.annotation{:});
    
    annotation(handle_fig, 'textbox', [0.19 0.97 0.05 0.05], 'String', 'b', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.00 0.54 0.05 0.05], 'String', 'd', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.52 0.54 0.05 0.05], 'String', 'e', default_options.annotation{:});
    export_fig(handle_fig, [default_options.folder.plot, 'png\', plot_name], '-png', '-opengl', '-r300', '-nocrop', '-transparent');
    export_fig(handle_fig, [default_options.folder.plot, 'pdf\', plot_name], '-pdf', '-painters', '-r300', '-nocrop', '-transparent');
    close(handle_fig)
    clearvars -except plots_to_gen default_options
end

% Figure 8
if any(strcmp('fig-8', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-8';
    
    file_name = 'class_sample_vector_data_conn_schlegel.mat';
    raw_data_1 = load([default_options.folder.data file_name]);
    options_1 = default_options;
    options_1.color{2} = generatecolormap(1:2, 2);
    options_1.color{6} = 2;
    % per cell type across databases
    data_x = repelem({'Connectivity type', 'Cell type', 'Tract', 'Region'}, [length(raw_data_1.measure.full), length(raw_data_1.measure.by_celltype_avg), length(raw_data_1.measure.by_tract_avg), length(raw_data_1.measure.by_region_avg)]);
    data_y = [raw_data_1.measure.full, raw_data_1.measure.by_celltype_avg, raw_data_1.measure.by_tract_avg, raw_data_1.measure.by_region_avg];
    
    obj_plot(1, 1) = gramm('x', data_x(:), 'y', data_y(:));
    obj_plot(1, 1).stat_violin(options_1.stat_violin{:});
    obj_plot(1, 1).set_names('x', '', 'y', 'class-vector PRED');
    obj_plot(1, 1).set_layout_options('position', [0 0 0.4 0.5]);
    obj_plot(1, 1).set_color_options(options_1.color{:});
    obj_plot(1, 1).set_point_options(options_1.point{:});
    obj_plot(1, 1).set_line_options(options_1.line{:});
    obj_plot(1, 1).set_text_options(options_1.text{:});
    obj_plot(1, 1).set_order_options(options_1.order{:});
    y_lims = getlimoptions('Y', [-0.5 1], 4, '%.1f');
    obj_plot(1, 1).axe_property(y_lims{:}, options_1.axis{:});
    
    % per database across neurons
    n_x = cellfun(@length, raw_data_1.measure.connectivity);
    data_x = repelem({'Connectivity type'}, 1, sum(n_x));
    data_y = cell2mat(raw_data_1.measure.connectivity);
    data_lightness = repelem(raw_data_1.id_database, n_x);
    
    n_x = cellfun(@length, raw_data_1.measure.celltype);
    data_x = [data_x, repelem({'Cell type'}, 1, sum(n_x))];
    data_y = [data_y, cell2mat(raw_data_1.measure.celltype)];
    data_lightness = [data_lightness; repelem(raw_data_1.id_database, n_x)];
    
    n_x = cellfun(@length, raw_data_1.measure.tract);
    data_x = [data_x, repelem({'Tract'}, 1, sum(n_x))];
    data_y = [data_y, cell2mat(raw_data_1.measure.tract)];
    data_lightness = [data_lightness; repelem(raw_data_1.id_database, n_x)];
    
    n_x = cellfun(@length, raw_data_1.measure.region);
    data_x = [data_x, repelem({'Region'}, 1, sum(n_x))];
    data_y = [data_y, cell2mat(raw_data_1.measure.region)];
    data_lightness = [data_lightness; repelem(raw_data_1.id_database, n_x)];
    
    obj_plot(1, 2) = gramm('x', data_x(:), 'y', data_y(:), 'lightness', data_lightness(:));
    obj_plot(1, 2).stat_violin(options_1.stat_violin{:});
    obj_plot(1, 2).set_names('x', '', 'y', 'class-sample PRED', 'lightness', '');
    obj_plot(1, 2).set_layout_options('position', [0.4 0 0.6 0.5], 'legend_position', [0.9 0.25 0.1 0.2]);
    obj_plot(1, 2).set_color_options(options_1.color{:});
    obj_plot(1, 2).set_point_options(options_1.point{:});
    obj_plot(1, 2).set_line_options(options_1.line{:});
    obj_plot(1, 2).set_text_options(options_1.text{:});
    obj_plot(1, 2).set_order_options(options_1.order{:});
    y_lims = getlimoptions('Y', [-0.5 1], 4, '%.1f');
    obj_plot(1, 2).axe_property(y_lims{:}, options_1.axis{:});
    
    handle_fig = figure('Position', [0 0 1500 900]);
    rng('default');
    obj_plot.draw();
    
    id_group = {'Connectivity Type', 'Cell Type', 'Tract', 'Region'};
    id_group_sub = {'full', 'by_celltype_avg', 'by_tract_avg', 'by_region_avg'};
    for i_group = 1:length(id_group)
        [~, p] = ttest(raw_data_1.measure.(id_group_sub{i_group})(:), 0);
        n = sum(~isnan(raw_data_1.measure.(id_group_sub{i_group})));
        mu = nanmean(raw_data_1.measure.(id_group_sub{i_group}));
        sigma = nanstd(raw_data_1.measure.(id_group_sub{i_group}));
        text(i_group, 0.9, sprintf('P=%.2g,n=%d', p, n), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.extra_text{:});
        text(i_group, 0.8, sprintf('%.4f±%.4f', mu, sigma), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.extra_text{:});
        text(i_group, -0.575, id_group{i_group}, 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.xlabels{:});
    end
    obj_plot(1, 1).facet_axes_handles.XAxis.Visible = 'off';
    
    id_group_sub = {'connectivity', 'celltype', 'tract', 'region'};
    for i_group = 1:length(id_group)
        for i_database = 1:length(raw_data_1.id_database)
            [~, p] = ttest(raw_data_1.measure.(id_group_sub{i_group}){i_database}(:), 0);
            n = sum(~isnan(raw_data_1.measure.(id_group_sub{i_group}){i_database}));
            mu = nanmean(raw_data_1.measure.(id_group_sub{i_group}){i_database}(:));
            sigma = nanstd(raw_data_1.measure.(id_group_sub{i_group}){i_database}(:));
            text(i_group + 0.2 * ((-1) ^ i_database), -0.3 + 0.2 * (i_database - 1), sprintf('P=%.2g,n=%d', p, n), 'Parent', obj_plot(1, 2).facet_axes_handles, options_1.extra_text{:});
            text(i_group + 0.2 * ((-1) ^ i_database), -0.4 + 0.2 * (i_database - 1), sprintf('%.4f±%.4f', mu, sigma), 'Parent', obj_plot(1, 2).facet_axes_handles, options_1.extra_text{:});
        end
        text(i_group, -0.575, id_group{i_group}, 'Parent', obj_plot(1, 2).facet_axes_handles, options_1.xlabels{:});
    end
    obj_plot(1, 2).facet_axes_handles.XAxis.Visible = 'off';
    obj_plot(1, 2).legend_axe_handle.Children(4).LineWidth = 6;
    obj_plot(1, 2).legend_axe_handle.Children(2).LineWidth = 6;

    annotation(handle_fig, 'textbox', [0.00 0.98 0.05 0.05], 'String', 'a', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.39 0.98 0.05 0.05], 'String', 'b', default_options.annotation{:});

    exportgraph(obj_plot, default_options.folder.plot, plot_name, handle_fig)
    clearvars -except plots_to_gen default_options
end

% Supplementary Figure 1
if any(strcmp('fig-s1', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-s1';
    
    file_name = 'class_vector_chance_level.mat';
    raw_data_1 = load([default_options.folder.data file_name]);
    id_metrics_1 = cellfun(@upper, raw_data_1.metrics, 'UniformOutput', false);
    id_metrics_1(contains(id_metrics_1, 'MAN_O')) = {'MAN*'};
    id_metrics_1(contains(id_metrics_1, 'EUC_O')) = {'EUC*'};
    id_metrics_1(contains(id_metrics_1, 'CHEB_O')) = {'CHEB*'};
    options_1 = default_options;
    options_1.color{2} = generatecolormap(4:6, 2);
    options_1.color{4} = 3;
    options_1.color{6} = 2;
    data_x = repmat(reshape(id_metrics_1(7:end), 1, 1, []), raw_data_1.n_range_class, raw_data_1.n_sim);
    data_y = raw_data_1.measure(:, :, 7:end);
    data_lightness = repelem(raw_data_1.range_class.', 1, raw_data_1.n_sim, 3);
    obj_plot(1, 1) = gramm('x', data_x(:), 'y', data_y(:), 'lightness', data_lightness(:));
    obj_plot(1, 1).stat_violin(options_1.stat_violin{:});
    obj_plot(1, 1).set_names('x', '', 'y', 'Similarity between vectors', 'lightness', '');
    obj_plot(1, 1).set_layout_options('position', [0 0 0.25 0.4], 'legend', false);
    obj_plot(1, 1).set_color_options(options_1.color{:});
    obj_plot(1, 1).set_point_options(options_1.point{:});
    obj_plot(1, 1).set_line_options(options_1.line{:});
    obj_plot(1, 1).set_text_options(options_1.text{:});
    obj_plot(1, 1).set_order_options(options_1.order{:});
    y_lims = getlimoptions('Y', [0 5], 3, '%.1f');
    obj_plot(1, 1).axe_property(y_lims{:}, options_1.axis{:});
    
    data_y_n = raw_data_1.measure(:, :, 7:end);
    data_y_n(:, :, contains(id_metrics_1(7:end), 'MAN')) = data_y_n(:, :, contains(id_metrics_1(7:end), 'MAN')) ./ raw_data_1.range_class.';
    data_y_n(:, :, contains(id_metrics_1(7:end), 'EUC')) = data_y_n(:, :, contains(id_metrics_1(7:end), 'EUC')) ./ sqrt(raw_data_1.range_class.');
    data_lightness = repelem(raw_data_1.range_class.', 1, raw_data_1.n_sim, 3);
    obj_plot(1, 2) = gramm('x', data_x(:), 'y', data_y_n(:), 'lightness', data_lightness(:));
    obj_plot(1, 2).stat_violin(options_1.stat_violin{:});
    obj_plot(1, 2).set_names('x', '', 'y', 'Similarity between vectors', 'lightness', '');
    obj_plot(1, 2).set_layout_options('position', [0.25 0 0.25 0.4], 'legend_position', [0.15 0.31 0.1 0.1]);
    obj_plot(1, 2).set_color_options(options_1.color{:});
    obj_plot(1, 2).set_point_options(options_1.point{:});
    obj_plot(1, 2).set_line_options(options_1.line{:});
    obj_plot(1, 2).set_text_options(options_1.text{:});
    obj_plot(1, 2).set_order_options(options_1.order{:});
    y_lims = getlimoptions('Y', [0 2], 3, '%.1f');
    obj_plot(1, 2).axe_property(y_lims{:}, options_1.axis{:});
    
    file_name = 'class_vector_sim_compare_noise.mat';
    raw_data_2 = load([default_options.folder.data file_name]);
    range_left = zeros(raw_data_2.n_range_means, raw_data_2.n_metric);
    range_right = zeros(raw_data_2.n_range_means, raw_data_2.n_metric);
    range_mid = zeros(raw_data_2.n_range_means, raw_data_2.n_metric);
    mean_mid = zeros(raw_data_2.n_range_means, raw_data_2.n_metric);
    var_mid = zeros(raw_data_2.n_range_means, raw_data_2.n_metric);
    for i_mean = 1:raw_data_2.n_range_means
        temp_data = squeeze(raw_data_2.measure(i_mean, :, :, :));
        for i_metric = 1:raw_data_2.n_metric
            [range_left(i_mean, i_metric), range_right(i_mean, i_metric), range_mid(i_mean, i_metric), mean_mid(i_mean, i_metric), var_mid(i_mean, i_metric)] = calculatedrvar(squeeze(temp_data(:, :, i_metric)).', raw_data_2.range_noise);
        end
    end
    options_2 = default_options;
    id_metrics_2 = cellfun(@upper, raw_data_2.metrics, 'UniformOutput', false);
    id_metrics_2(contains(id_metrics_2, 'PRED_CV')) = {'PRED'};
    data_x = repelem(raw_data_2.range_means.', 1, raw_data_2.n_metric);
    data_y = range_right - range_left;
    data_color = repelem(id_metrics_2, raw_data_2.n_range_means, 1);
    obj_plot(1, 3) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
    obj_plot(1, 3).geom_line();
    obj_plot(1, 3).geom_point();
    y_lims = getlimoptions('Y', [1 2], 3, '%.1f');
    obj_plot(1, 3).axe_property(y_lims{:}, options_2.axis{:});
    obj_plot(1, 3).set_names('x', 'Base mean', 'y', 'Dynamic range', 'color', '');
    obj_plot(1, 3).set_layout_options('position', [0.5 0 0.25 0.4], 'legend', false);
    obj_plot(1, 3).set_color_options(options_2.color{:});
    obj_plot(1, 3).set_point_options(options_2.point{:});
    obj_plot(1, 3).set_line_options(options_2.line{:});
    obj_plot(1, 3).set_text_options(options_2.text{:});
    obj_plot(1, 3).set_order_options(options_2.order{:});
    
    data_y = var_mid;
    obj_plot(1, 4) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
    obj_plot(1, 4).geom_line();
    obj_plot(1, 4).geom_point();
    y_lims = getlimoptions('Y', [0.1 0.3], 3, '%.1f');
    obj_plot(1, 4).axe_property(y_lims{:}, options_2.axis{:});
    obj_plot(1, 4).set_names('x', 'Base mean', 'y', 'Variability at mid range', 'color', '');
    obj_plot(1, 4).set_layout_options('position', [0.75 0 0.25 0.4], 'legend_position', [0.9 0.08 0.1 0.12]);
    obj_plot(1, 4).set_color_options(options_2.color{:});
    obj_plot(1, 4).set_point_options(options_2.point{:});
    obj_plot(1, 4).set_line_options(options_2.line{:});
    obj_plot(1, 4).set_text_options(options_2.text{:});
    obj_plot(1, 4).set_order_options(options_2.order{:});
    
    handle_fig = figure('Position', [0 0 1350 1200]);
    rng('default');
    obj_plot.draw();
    
    for i_metric = 1:3
        [~, p] = ttest2(squeeze(raw_data_1.measure(1, :, i_metric + 6)), squeeze(raw_data_1.measure(2, :, i_metric + 6)));
        text(i_metric, 4.5, sprintf('P=%.2g', p), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.extra_text{:});
        mu=mean(raw_data_1.measure(:, :, i_metric + 6), 2);
        text(i_metric - 0.2, 3.8, sprintf('mu=%.4f', mu(1)), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.extra_text{:});
        text(i_metric + 0.2, 4, sprintf('mu=%.4f', mu(2)), 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.extra_text{:});
        text(i_metric, -0.2, id_metrics_1{i_metric + 6}, 'Parent', obj_plot(1, 1).facet_axes_handles, options_1.xlabels{:});
        obj_plot(1, 1).results.stat_violin(1).point_handle(i_metric).MarkerFaceColor = options_1.color{2}(2 * i_metric - 1, :);
        obj_plot(1, 1).results.stat_violin(1).fill_handle(i_metric).FaceColor = options_1.color{2}(2 * i_metric - 1, :);
        obj_plot(1, 1).results.stat_violin(2).point_handle(i_metric).MarkerFaceColor = options_1.color{2}(2 * i_metric, :);
        obj_plot(1, 1).results.stat_violin(2).fill_handle(i_metric).FaceColor = options_1.color{2}(2 * i_metric, :);
        
        [~, p] = ttest2(squeeze(data_y_n(1, :, i_metric)), squeeze(data_y_n(2, :, i_metric)));
        text(i_metric, 1.8, sprintf('P=%.2g', p), 'Parent', obj_plot(1, 2).facet_axes_handles, options_1.extra_text{:});
        mu = mean(data_y_n(:, :, i_metric), 2);
        text(i_metric - 0.2, 1.6, sprintf('mu=%.4f', mu(1)), 'Parent', obj_plot(1, 2).facet_axes_handles, options_1.extra_text{:});
        text(i_metric + 0.2, 1.4, sprintf('mu=%.4f', mu(2)), 'Parent', obj_plot(1, 2).facet_axes_handles, options_1.extra_text{:});
        text(i_metric, -0.1, id_metrics_1{i_metric + 6}, 'Parent', obj_plot(1, 2).facet_axes_handles, options_1.xlabels{:});
        obj_plot(1, 2).results.stat_violin(1).point_handle(i_metric).MarkerFaceColor = options_1.color{2}(2 * i_metric - 1, :);
        obj_plot(1, 2).results.stat_violin(1).fill_handle(i_metric).FaceColor = options_1.color{2}(2 * i_metric - 1, :);
        obj_plot(1, 2).results.stat_violin(2).point_handle(i_metric).MarkerFaceColor = options_1.color{2}(2 * i_metric, :);
        obj_plot(1, 2).results.stat_violin(2).fill_handle(i_metric).FaceColor = options_1.color{2}(2 * i_metric, :);
    end
    obj_plot(1, 1).facet_axes_handles.XAxis.Visible = 'off';
    obj_plot(1, 2).facet_axes_handles.XAxis.Visible = 'off';
    obj_plot(1, 2).legend_axe_handle.Children(3).String = '2 classes';
    obj_plot(1, 2).legend_axe_handle.Children(4).Color = [0.3 0.3 0.3];
    obj_plot(1, 2).legend_axe_handle.Children(4).LineWidth = 6;
    obj_plot(1, 2).legend_axe_handle.Children(1).String = '5 classes';
    obj_plot(1, 2).legend_axe_handle.Children(2).Color = [0.6 0.6 0.6];
    obj_plot(1, 2).legend_axe_handle.Children(2).LineWidth = 6;
    
    obj_plot(1, 4).legend_axe_handle.Children(2).LineWidth = 6;
    obj_plot(1, 4).legend_axe_handle.Children(4).LineWidth = 6;
    obj_plot(1, 4).legend_axe_handle.Children(6).LineWidth = 6;
    
    annotation(handle_fig, 'textbox', [0.00 0.97 0.05 0.05], 'String', 'a', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.00 0.41 0.05 0.05], 'String', 'b', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.24 0.41 0.05 0.05], 'String', 'c', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.49 0.41 0.05 0.05], 'String', 'd', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.74 0.41 0.05 0.05], 'String', 'e', default_options.annotation{:});
    exportgraph(obj_plot, default_options.folder.plot, plot_name, handle_fig)
    clearvars -except plots_to_gen default_options
end

% Supplementary Figure 2
if any(strcmp('fig-s2', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-s2';
    
    file_name = 'class_vector_data_temporal_vs_magnitude.mat';
    raw_data_1 = load([default_options.folder.data file_name]);
    id_metrics = cellfun(@upper, raw_data_1.metrics, 'UniformOutput', false);
    id_metrics(contains(id_metrics, 'PRED_CV')) = {'PRED'};
    options_1 = default_options;
    options_1.color{2} = generatecolormap(1:6, 2);
    options_1.color{6} = 2;
    mu=cellfun(@mean, raw_data_1.measure.shimizu);
    p = zeros(raw_data_1.n_metric, raw_data_1.n_cell);
    for i_cell = 1:raw_data_1.n_cell
        n_data_points = length(raw_data_1.measure.shimizu{1, 1, i_cell});
        data_x = reshape(repelem(id_metrics, n_data_points * 2, 1), [], 1);
        data_y = reshape(cell2mat(raw_data_1.measure.shimizu(:, :, i_cell)), [], 1);
        data_lightness = reshape(repmat(repelem({'unbinned'; '10-bins'}, n_data_points, 1), 1, 2), [], 1);
        [~, p(:, i_cell)] = arrayfun(@(x) ttest(raw_data_1.measure.shimizu{1, x, i_cell}, raw_data_1.measure.shimizu{2, x, i_cell}), 1:2);
        obj_plot(1, i_cell) = gramm('x', data_x(:), 'y', data_y(:), 'lightness', data_lightness(:));
        obj_plot(1, i_cell).stat_violin(options_1.stat_violin{:});
        obj_plot(1, i_cell).set_names('x', '', 'y', '', 'lightness', '');
        obj_plot(1, i_cell).set_layout_options('position', [0.18 * (i_cell - 1) 0.5 0.2 0.45], 'legend', false);
        obj_plot(1, i_cell).set_color_options(options_1.color{:});
        obj_plot(1, i_cell).set_point_options(options_1.point{:});
        obj_plot(1, i_cell).set_line_options(options_1.line{:});
        obj_plot(1, i_cell).set_text_options(options_1.text{:});
        obj_plot(1, i_cell).set_order_options(options_1.order{:});
        y_lims = getlimoptions('Y', [0 1], 3, '%.1f');
        obj_plot(1, i_cell).axe_property(y_lims{:}, options_1.axis{:});
    end
    obj_plot(1, 1).set_names('x', '', 'y', 'Similarity between individuals', 'lightness', '');
    obj_plot(1, 3).set_layout_options('position', [0.36 0.5 0.2 0.45], 'legend_position', [0.48 0.58 0.1 0.15]);
    
    file_name = 'class_vector_sim_temporal_increase_bin_0_noise.mat';
    raw_data_2 = load([default_options.folder.data file_name]);
    options_2 = default_options;
    data_x = repmat(raw_data_2.range_n_bin.', 1, raw_data_2.n_sim, raw_data_2.n_metric);
    data_y = raw_data_2.measure;
    data_color = repmat(reshape(id_metrics, 1, 1, []), raw_data_2.n_range_nbin, raw_data_2.n_sim, 1);
    obj_plot(1, 5) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
    obj_plot(1, 5).stat_summary('type', 'sem', 'geom', {'line', 'point', 'errorbar'});
    obj_plot(1, 5).set_names('x', 'Number of noise bins', 'y', 'Similarity between vectors', 'color', '');
    obj_plot(1, 5).set_layout_options('position', [0.73 0.5 0.27 0.45], 'legend_position', [0.93 0.84 0.1 0.15]);
    obj_plot(1, 5).set_color_options(options_2.color{:});
    obj_plot(1, 5).set_point_options(options_2.point{:});
    obj_plot(1, 5).set_line_options(options_2.line{:});
    obj_plot(1, 5).set_text_options(options_2.text{:});
    obj_plot(1, 5).set_order_options(options_2.order{:});
    y_lims = getlimoptions('Y', [0 1], 3, '%.1f');
    obj_plot(1, 5).axe_property(y_lims{:}, options_2.axis{:});
    
    file_name = 'class_vector_data_temporal_increase_bin.mat';
    raw_data_3 = load([default_options.folder.data file_name]);
    options_3 = default_options;
    for i_cell = 1:raw_data_3.n_cell
        data_x = repelem(raw_data_3.range_n_bin.', 1, raw_data_3.n_metric);
        data_y = raw_data_3.measure.shimizu(:, :, i_cell);
        data_color = repelem(id_metrics, raw_data_3.n_range_nbin, 1);
        obj_plot(1, i_cell + 5) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
        obj_plot(1, i_cell + 5).geom_point();
        obj_plot(1, i_cell + 5).geom_line();
        obj_plot(1, i_cell + 5).set_layout_options('position', [0.24 * (i_cell - 1) 0 0.27 0.45], 'legend', false);
        obj_plot(1, i_cell + 5).set_names('x', 'Number of noise bins', 'y', 'Similarity between individuals', 'color', '');
        obj_plot(1, i_cell + 5).set_color_options(options_3.color{:});
        obj_plot(1, i_cell + 5).set_point_options(options_3.point{:});
        obj_plot(1, i_cell + 5).set_line_options(options_3.line{:});
        obj_plot(1, i_cell + 5).set_text_options(options_3.text{:});
        obj_plot(1, i_cell + 5).set_order_options(options_3.order{:});
        y_lims = getlimoptions('Y', [0 1], 3, '%.1f');
        obj_plot(1, i_cell + 5).axe_property(y_lims{:}, options_3.axis{:});
    end
    obj_plot(1, 6).set_layout_options('position', [0 0 0.27 0.45], 'legend_position', [0.93 0.25 0.1 0.15]);
    
    
    handle_fig = figure('Position', [0 0 1600 900]);
    rng('default');
    obj_plot.draw();
    
    for i_cell = 1:raw_data_1.n_cell
        for i_metric = 1:2
            text(i_metric, 0.8, sprintf('P=%.2g', p(i_metric, i_cell)), 'Parent', obj_plot(1, i_cell).facet_axes_handles, options_1.xlabels{:});
            text(i_metric - 0.2, 0.7, sprintf('mu=%.4f', mu(1, i_metric, i_cell)), 'Parent', obj_plot(1, i_cell).facet_axes_handles, options_1.xlabels{:});
            text(i_metric + 0.2, 0.6, sprintf('mu=%.4f', mu(2, i_metric, i_cell)), 'Parent', obj_plot(1, i_cell).facet_axes_handles, options_1.xlabels{:});
            text(i_metric, -0.05, id_metrics{i_metric}, 'Parent', obj_plot(i_cell).facet_axes_handles, options_1.xlabels{:});
            obj_plot(i_cell).results.stat_violin(1).point_handle(i_metric).MarkerFaceColor = options_1.color{2}(2 * i_metric - 1, :);
            obj_plot(i_cell).results.stat_violin(1).fill_handle(i_metric).FaceColor = options_1.color{2}(2 * i_metric - 1, :);
            obj_plot(i_cell).results.stat_violin(2).point_handle(i_metric).MarkerFaceColor = options_1.color{2}(2 * i_metric, :);
            obj_plot(i_cell).results.stat_violin(2).fill_handle(i_metric).FaceColor = options_1.color{2}(2 * i_metric, :);
        end
        obj_plot(i_cell).facet_axes_handles.XAxis.Visible = 'off';
    end
    for i_axis = [2:4, 7:9]
        obj_plot(1, i_axis).facet_axes_handles.YTickLabel = [];
        obj_plot(1, i_axis).facet_axes_handles.YLabel.Visible = 'off';
    end
    for i_axis = [3, 5, 6]
        obj_plot(1, i_axis).legend_axe_handle.Children(4).LineWidth = 6;
        obj_plot(1, i_axis).legend_axe_handle.Children(2).LineWidth = 6;
    end
    obj_plot(1, 3).legend_axe_handle.Children(4).Color = [0.3 0.3 0.3];
    obj_plot(1, 3).legend_axe_handle.Children(2).Color = [0.6 0.6 0.6];
    
    annotation(handle_fig, 'textbox', [0.00 0.97 0.05 0.05], 'String', 'a', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.17 0.97 0.05 0.05], 'String', 'b', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.35 0.97 0.05 0.05], 'String', 'c', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.53 0.97 0.05 0.05], 'String', 'd', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.72 0.97 0.05 0.05], 'String', 'e', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.00 0.47 0.05 0.05], 'String', 'f', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.24 0.47 0.05 0.05], 'String', 'g', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.49 0.47 0.05 0.05], 'String', 'h', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.73 0.47 0.05 0.05], 'String', 'i', default_options.annotation{:});
    exportgraph(obj_plot, default_options.folder.plot, plot_name, handle_fig)
    clearvars -except plots_to_gen default_options
end

% Supplementary Figure 3
if any(strcmp('fig-s3', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-s3';
    
    file_name = 'class_sample_check_pred.mat';
    raw_data_1 = load([default_options.folder.data file_name]);options_1 = default_options;
    id_metrics = cellfun(@upper, raw_data_1.metrics, 'UniformOutput', false);
    id_metrics(contains(id_metrics, 'PRED_CS')) = {'PRED'};
    options_1.color{2} = [0 0 0];
    options_1.color{4} = 1;
    options_1.color{6} = 1;
    options_1.point{2} = 12;
    temp_data = raw_data_1.measure.shimizu;
    means = nanmean(reshape(temp_data, [], raw_data_1.n_metric), 1);
    for i_metric = 2:raw_data_1.n_metric
        data_x = temp_data(:, :, 1);
        data_y = temp_data(:, :, i_metric);
        obj_plot(1, i_metric - 1) = gramm('x', data_x(:), 'y', data_y(:));
        obj_plot(1, i_metric - 1).geom_point('alpha', 0.4);
        obj_plot(1, i_metric - 1).set_names('x', 'PRED', 'y', id_metrics{i_metric});
        x_lims = getlimoptions('X', [0.3 1], 3, '%.2f');
        obj_plot(1, i_metric - 1).axe_property(x_lims{:}, options_1.axis{:});
        obj_plot(1, i_metric - 1).set_layout_options('position', [0.2 * (i_metric - 2) 0.5 0.2 0.45]);
        obj_plot(1, i_metric - 1).set_color_options(options_1.color{:});
        obj_plot(1, i_metric - 1).set_point_options(options_1.point{:});
        obj_plot(1, i_metric - 1).set_line_options(options_1.line{:});
        obj_plot(1, i_metric - 1).set_text_options(options_1.text{:});
        obj_plot(1, i_metric - 1).set_order_options(options_1.order{:});
        obj_plot(1, i_metric - 1).axe_property(options_1.axis{:});
        [stats.pc(i_metric - 1), stats.p(i_metric - 1)] = corr(data_x(:), data_y(:), 'rows', 'complete');
    end
    
    options_2 = default_options;
    options_2.point{2} = 12;
    options_2.color{2} = generatecolormap(1:3, 1);
    options_2.color{4} = 3;
    options_2.color{6} = 1;
    n_class = 3;
    n_sample = 10;
    n_dim = 2;
    range = [-1 1];
    dist = 0;
    rng(764)
    radius = 0.2;
    temp_data = generateclustereddata(n_sample, n_class, n_dim, range, dist, radius);
    noise = 0.005;
    noise_data = cellfun(@(x) x + normrnd(0, noise, 1, n_dim), temp_data, 'UniformOutput', false);
    data_x = cellfun(@(x) x(1), noise_data);
    data_y = cellfun(@(x) x(2), noise_data);
    data_color = repelem(1:n_class, n_sample, 1);
    centers{1} = [mean(data_x).' mean(data_y).'];
    for i_class = 1:n_class
        radii{1}(i_class, 1) = max(cellfun(@(x) pdist([centers{1}(i_class, :); x]), noise_data(:, i_class)));
    end
    obj_plot(1, 6) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
    obj_plot(1, 6).geom_point(options_2.geom_point{:});
    obj_plot(1, 6).set_layout_options('position', [0 0 0.33 0.45], 'legend', false);
    obj_plot(1, 6).set_names('x', '', 'y', '', 'color', '');
    obj_plot(1, 6).set_color_options(options_2.color{:});
    obj_plot(1, 6).set_point_options(options_2.point{:});
    obj_plot(1, 6).set_line_options(options_2.line{:});
    obj_plot(1, 6).set_text_options(options_2.text{:});
    obj_plot(1, 6).set_order_options(options_2.order{:});
    x_lims = getlimoptions('X', [-2 2], 5, '%d');
    y_lims = getlimoptions('Y', [-2 2], 5, '%d');
    obj_plot(1, 6).axe_property(y_lims{:}, x_lims{:}, 'XGrid', 'on', options_2.axis{:});
    
    noise = 0.3;
    noise_data = cellfun(@(x) x + normrnd(0, noise, 1, n_dim), temp_data, 'UniformOutput', false);
    data_x = cellfun(@(x) x(1), noise_data);
    data_y = cellfun(@(x) x(2), noise_data);
    data_color = repelem(1:n_class, n_sample, 1);
    centers{2} = [mean(data_x).' mean(data_y).'];
    for i_class = 1:n_class
        radii{2}(i_class, 1) = max(cellfun(@(x) pdist([centers{2}(i_class, :); x]), noise_data(:, i_class)));
    end
    obj_plot(1, 7) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
    obj_plot(1, 7).geom_point(options_2.geom_point{:});
    obj_plot(1, 7).set_layout_options('position', [0.335 0 0.33 0.45], 'legend', false);
    obj_plot(1, 7).set_names('x', '', 'y', '', 'color', '');
    obj_plot(1, 7).set_color_options(options_2.color{:});
    obj_plot(1, 7).set_point_options(options_2.point{:});
    obj_plot(1, 7).set_line_options(options_2.line{:});
    obj_plot(1, 7).set_text_options(options_2.text{:});
    obj_plot(1, 7).set_order_options(options_2.order{:});
    obj_plot(1, 7).axe_property(y_lims{:}, x_lims{:}, 'XGrid', 'on', options_2.axis{:});
    
    noise = 0.6;
    noise_data = cellfun(@(x) x + normrnd(0, noise, 1, n_dim), temp_data, 'UniformOutput', false);
    data_x = cellfun(@(x) x(1), noise_data);
    data_y = cellfun(@(x) x(2), noise_data);
    data_color = repelem(1:n_class, n_sample, 1);
    centers{3} = [mean(data_x).' mean(data_y).'];
    for i_class = 1:n_class
        radii{3}(i_class, 1) = max(cellfun(@(x) pdist([centers{3}(i_class, :); x]), noise_data(:, i_class)));
    end
    obj_plot(1, 8) = gramm('x', data_x(:), 'y', data_y(:), 'color', data_color(:));
    obj_plot(1, 8).geom_point(options_2.geom_point{:});
    obj_plot(1, 8).set_layout_options('position', [0.67 0 0.33 0.45], 'legend', false);
    obj_plot(1, 8).set_names('x', '', 'y', '', 'color', '');
    obj_plot(1, 8).set_color_options(options_2.color{:});
    obj_plot(1, 8).set_point_options(options_2.point{:});
    obj_plot(1, 8).set_line_options(options_2.line{:});
    obj_plot(1, 8).set_text_options(options_2.text{:});
    obj_plot(1, 8).set_order_options(options_2.order{:});
    obj_plot(1, 8).axe_property(y_lims{:}, x_lims{:}, 'XGrid', 'on', options_2.axis{:});
    
    handle_fig = figure('Position', [0 0 1800 900]);
    rng('default');
    obj_plot.draw();
    
    for i_metric = 2:raw_data_1.n_metric
        text(means(1), means(i_metric), sprintf('r = %.2f\nP = %.2g', stats.pc(i_metric - 1), stats.p(i_metric - 1)), 'Parent', obj_plot(1, i_metric - 1).facet_axes_handles, options_1.extra_text{:});
    end
    y_lims = getlimoptions('Y', [0.6 1], 3, '%.1f');
    set(obj_plot(1, 1).facet_axes_handles, y_lims{:})
    y_lims = getlimoptions('Y', [0.2 1], 3, '%.1f');
    set(obj_plot(1, 2).facet_axes_handles, y_lims{:})
    y_lims = getlimoptions('Y', [-2 8], 3, '%d');
    set(obj_plot(1, 3).facet_axes_handles, y_lims{:})
    y_lims = getlimoptions('Y', [0 2], 3, '%d');
    set(obj_plot(1, 4).facet_axes_handles, y_lims{:})
    y_lims = getlimoptions('Y', [-100 900], 3, '%d');
    set(obj_plot(1, 5).facet_axes_handles, y_lims{:})
    
    for i_axis = 6:8
        for i_class = 1:n_class
            rectangle(obj_plot(1, i_axis).facet_axes_handles, 'Position', [centers{i_axis - 5}(i_class, :) - radii{i_axis - 5}(i_class), radii{i_axis - 5}(i_class) * 2 * ones(1, 2)], 'Curvature', [1 1], 'EdgeColor', options_2.color{2}(i_class, :), 'LineStyle', '--', 'LineWidth', 2);
        end
        set(obj_plot(1, i_axis).facet_axes_handles, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin', 'XTickLabel', [], 'YTickLabel', [])
    end

    annotation(handle_fig, 'textbox', [0.00 0.97 0.05 0.05], 'String', 'a', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.19 0.97 0.05 0.05], 'String', 'b', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.39 0.97 0.05 0.05], 'String', 'c', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.59 0.97 0.05 0.05], 'String', 'd', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.79 0.97 0.05 0.05], 'String', 'e', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.00 0.47 0.05 0.05], 'String', 'f', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.32 0.47 0.05 0.05], 'String', 'g', default_options.annotation{:});
    annotation(handle_fig, 'textbox', [0.66 0.47 0.05 0.05], 'String', 'h', default_options.annotation{:});
    exportgraph(obj_plot, default_options.folder.plot, plot_name, handle_fig)
    clearvars -except plots_to_gen default_options
end
    
% Supplementary Figure 4
if any(strcmp('fig-s4', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-s4';
    
    file_name = 'class_sample_data_noise.mat';
    raw_data_1 = load([default_options.folder.data file_name]);
    id_metrics = cellfun(@upper, raw_data_1.metrics, 'UniformOutput', false);
    id_metrics(contains(id_metrics, 'PRED_CS')) = {'PRED'};
    options_1 = default_options;
    options_1.axis{2} = 'off';
    options_1.axis{16} = [0.01 0.025];
    temp_data = squeeze(nanmean(raw_data_1.measure.gupta, 4));
    range_left.gupta = zeros(raw_data_1.n_metric, 1);
    range_right.gupta = zeros(raw_data_1.n_metric, 1);
    range_mid.gupta = zeros(raw_data_1.n_metric, 1);
    mean_mid.gupta = zeros(raw_data_1.n_metric, 1);
    var_mid.gupta = zeros(raw_data_1.n_metric, 1);
    for i_metric = 1:raw_data_1.n_metric
        [range_left.gupta(i_metric), range_right.gupta(i_metric), range_mid.gupta(i_metric), mean_mid.gupta(i_metric), var_mid.gupta(i_metric)] = calculatedrvar(squeeze(temp_data(:, :, i_metric)).', raw_data_1.range_noise);
    end
    for i_metric = 1:raw_data_1.n_metric
        data_x = repelem(raw_data_1.range_noise.', 1, raw_data_1.n_sim);
        data_y = temp_data(:, :, i_metric);
        options_1.color{2} = generatecolormap(i_metric, 1);
        options_1.color{4} = 1;
        options_1.color{6} = 1;
        obj_plot(1, i_metric) = gramm('x', data_x(:), 'y', data_y(:));
        obj_plot(1, i_metric).stat_summary('type', 'std', 'geom', 'area');
        obj_plot(1, i_metric).geom_vline('xintercept', [range_left.gupta(i_metric) range_right.gupta(i_metric)], 'style', {'k--', 'k--'});
        obj_plot(1, i_metric).set_names('x', 'log(Noise SD)', 'y', 'Odor separability', 'color', '', 'column', '');
        obj_plot(1, i_metric).set_layout_options('position', [0.02 + 0.14 * (i_metric - 1), 0.8, 0.14, 0.19], 'legend', false);
        obj_plot(1, i_metric).set_color_options(options_1.color{:});
        obj_plot(1, i_metric).axe_property('XTick', -1:4, 'XTickLabel', -1:4, options_1.axis{:});
        obj_plot(1, i_metric).set_point_options(options_1.point{:});
    end
    options_1.color{2} = generatecolormap(1:6, 1);
    options_1.color{4} = 6;
    options_1.color{6} = 1;
    options_1.point{2} = 15;
    options_1.axis{2} = 'on';
    obj_plot(1, 7) = gramm('x', var_mid.gupta, 'y', range_right.gupta - range_left.gupta, 'color', id_metrics, 'label', id_metrics);
    obj_plot(1, 7).geom_point(options_1.geom_point{:});
    obj_plot(1, 7).geom_label();
    obj_plot(1, 7).set_names('x', 'Variability', 'y', 'Dynamic range');
    obj_plot(1, 7).set_layout_options('position', [0.86, 0.8, 0.14, 0.19], 'legend', false);
    obj_plot(1, 7).set_color_options(options_1.color{:});
    obj_plot(1, 7).set_point_options(options_1.point{:});
    obj_plot(1, 7).axe_property('XGrid', 'on', options_1.axis{:});
    
    options_1 = default_options;
    options_1.axis{16} = [0.01 0.025];
    temp_data = squeeze(nanmean(raw_data_1.measure.shimizu, 4));
    n_cell = size(temp_data, 3);
    range_left.shimizu = zeros(raw_data_1.n_metric, n_cell);
    range_right.shimizu = zeros(raw_data_1.n_metric, n_cell);
    range_mid.shimizu = zeros(raw_data_1.n_metric, n_cell);
    mean_mid.shimizu = zeros(raw_data_1.n_metric, n_cell);
    var_mid.shimizu = zeros(raw_data_1.n_metric, n_cell);
    for i_cell = 1:n_cell
        for i_metric = 1:raw_data_1.n_metric
            [range_left.shimizu(i_metric, i_cell), range_right.shimizu(i_metric, i_cell), range_mid.shimizu(i_metric, i_cell), mean_mid.shimizu(i_metric, i_cell), var_mid.shimizu(i_metric, i_cell)] = calculatedrvar(squeeze(temp_data(:, :, i_cell, i_metric)).', raw_data_1.range_noise);
        end
    end
    for i_cell = 1:n_cell
        options_1.axis{2} = 'off';
        for i_metric = 1:raw_data_1.n_metric
            data_x = repelem(raw_data_1.range_noise.', 1, raw_data_1.n_sim);
            data_y = temp_data(:, :, i_cell, i_metric);
            options_1.color{2} = generatecolormap(i_metric, 1);
            options_1.color{4} = 1;
            options_1.color{6} = 1;
            obj_plot(i_cell + 1, i_metric) = gramm('x', data_x(:), 'y', data_y(:));
            obj_plot(i_cell + 1, i_metric).stat_summary('type', 'std', 'geom', 'area');
            obj_plot(i_cell + 1, i_metric).geom_vline('xintercept', [range_left.shimizu(i_metric, i_cell) range_right.shimizu(i_metric, i_cell)], 'style', {'k--', 'k--'});
            obj_plot(i_cell + 1, i_metric).set_names('x', 'log(Noise SD)', 'y', 'Odor separability', 'color', '', 'column', '');
            obj_plot(i_cell + 1, i_metric).set_layout_options('position', [0.02 + 0.14 * (i_metric - 1), 0.2 * (4 - i_cell), 0.14, 0.19], 'legend', false);
            obj_plot(i_cell + 1, i_metric).set_color_options(options_1.color{:});
            obj_plot(i_cell + 1, i_metric).axe_property('XTick', -1:4, 'XTickLabel', -1:4, options_1.axis{:});
            obj_plot(i_cell + 1, i_metric).set_point_options(options_1.point{:});
        end
        options_1.color{2} = generatecolormap(1:6, 1);
        options_1.color{4} = 6;
        options_1.color{6} = 1;
        options_1.point{2} = 15;
        options_1.axis{2} = 'on';
        obj_plot(i_cell + 1, 7) = gramm('x', var_mid.shimizu(:, i_cell), 'y', range_right.shimizu(:, i_cell) - range_left.shimizu(:, i_cell), 'color', id_metrics, 'label', id_metrics);
        obj_plot(i_cell + 1, 7).geom_point(options_1.geom_point{:});
        obj_plot(i_cell + 1, 7).geom_label();
        obj_plot(i_cell + 1, 7).set_names('x', 'Variability', 'y', 'Dynamic range');
        obj_plot(i_cell + 1, 7).set_layout_options('position', [0.86, 0.2 * (4 - i_cell), 0.14, 0.19], 'legend', false);
        obj_plot(i_cell + 1, 7).set_color_options(options_1.color{:});
        obj_plot(i_cell + 1, 7).set_point_options(options_1.point{:});
        obj_plot(i_cell + 1, 7).axe_property('XGrid', 'on', options_1.axis{:});
    end
    obj_plot.set_line_options(options_1.line{:});
    obj_plot.set_text_options(options_1.text{:});
    obj_plot.set_order_options(options_1.order{:});
    
    handle_fig = figure('Position', [0 0 2200 1800]);
    rng('default');
    obj_plot.draw();
    
    options_1 = default_options;
    temp_data = squeeze(nanmean(raw_data_1.measure.gupta, 4));
    for i_metric = 1:raw_data_1.n_metric
        data_x = repelem(raw_data_1.range_noise(range_mid.gupta(i_metric)), raw_data_1.n_sim, 1);
        data_y = squeeze(temp_data(range_mid.gupta(i_metric), :, i_metric));
        options_1.color{2} = generatecolormap(i_metric, 1);
        options_1.color{4} = 1;
        options_1.color{6} = 1;
        obj_plot(1, i_metric).update('x', data_x(:), 'y', data_y(:));
        obj_plot(1, i_metric).geom_jitter(options_1.geom_point{:});
        obj_plot(1, i_metric).no_legend();
        obj_plot(1, i_metric).set_color_options(options_1.color{:});
        obj_plot(1, i_metric).set_point_options(options_1.point{:});
        obj_plot(1, i_metric).draw();
    end
    
    temp_data = squeeze(nanmean(raw_data_1.measure.shimizu, 4));
    for i_cell = 1:n_cell
        for i_metric = 1:raw_data_1.n_metric
            data_x = repelem(raw_data_1.range_noise(range_mid.shimizu(i_metric, i_cell)), raw_data_1.n_sim, 1);
            data_y = squeeze(temp_data(range_mid.shimizu(i_metric, i_cell), :, i_cell, i_metric));
            options_1.color{2} = generatecolormap(i_metric, 1);
            options_1.color{4} = 1;
            options_1.color{6} = 1;
            obj_plot(i_cell + 1, i_metric).update('x', data_x(:), 'y', data_y(:));
            obj_plot(i_cell + 1, i_metric).geom_jitter(options_1.geom_point{:});
            obj_plot(i_cell + 1, i_metric).no_legend();
            obj_plot(i_cell + 1, i_metric).set_color_options(options_1.color{:});
            obj_plot(i_cell + 1, i_metric).set_point_options(options_1.point{:});
            obj_plot(i_cell + 1, i_metric).draw();
        end
    end
    
    for i_row = 1:4
        for i_col = 1:6
            obj_plot(i_row, i_col).facet_axes_handles.XTickLabel = [];
            obj_plot(i_row, i_col).facet_axes_handles.XLabel.Visible = 'off';
        end
        obj_plot(i_row, 7).facet_axes_handles.XLabel.Visible = 'off';
    end
    for i_row = 1:5
        for i_col = 2:6
            obj_plot(i_row, i_col).facet_axes_handles.YLabel.Visible = 'off';
        end
    end
    y_lims = getlimoptions('Y', [-0.1 0.7], 3, '%.1f');
    set(obj_plot(1, 1).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 0.8], 3, '%.1f');
    set(obj_plot(1, 2).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 4e-3], 3, '%.3f');
    set(obj_plot(1, 3).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [-0.4 0.4], 3, '%.1f');
    set(obj_plot(1, 4).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 30], 3, '%d');
    set(obj_plot(1, 5).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [-10 50], 3, '%d');
    set(obj_plot(1, 6).facet_axes_handles, y_lims{:});
    x_lims = getlimoptions('X', [0 0.4], 3, '%.1f');
    y_lims = getlimoptions('Y', [1.5 3.5], 3, '%.1f');
    set(obj_plot(1, 7).facet_axes_handles, x_lims{:}, y_lims{:});
    
    y_lims = getlimoptions('Y', [-0.1 0.9], 3, '%.1f');
    set(obj_plot(2, 1).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 0.8], 3, '%.1f');
    set(obj_plot(2, 2).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 4e-3], 3, '%.3f');
    set(obj_plot(2, 3).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [-0.4 0.4], 3, '%.1f');
    set(obj_plot(2, 4).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 30], 3, '%d');
    set(obj_plot(2, 5).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [-10 220], 3, '%d');
    set(obj_plot(2, 6).facet_axes_handles, y_lims{:});
    x_lims = getlimoptions('X', [0 0.5], 3, '%.1f');
    y_lims = getlimoptions('Y', [1 4], 3, '%.1f');
    set(obj_plot(2, 7).facet_axes_handles, x_lims{:}, y_lims{:});
    
    y_lims = getlimoptions('Y', [-0.1 0.7], 3, '%.1f');
    set(obj_plot(3, 1).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0.4 1], 3, '%.1f');
    set(obj_plot(3, 2).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 3], 3, '%.1f');
    set(obj_plot(3, 3).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [-0.1 0.7], 3, '%.1f');
    set(obj_plot(3, 4).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 12], 3, '%d');
    set(obj_plot(3, 5).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [-10 90], 3, '%d');
    set(obj_plot(3, 6).facet_axes_handles, y_lims{:});
    x_lims = getlimoptions('X', [0 0.4], 3, '%.1f');
    y_lims = getlimoptions('Y', [1 3], 3, '%d');
    set(obj_plot(3, 7).facet_axes_handles, x_lims{:}, y_lims{:});
    
    y_lims = getlimoptions('Y', [-0.1 0.9], 3, '%.1f');
    set(obj_plot(4, 1).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0.2 1], 3, '%.1f');
    set(obj_plot(4, 2).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 0.2], 3, '%.1f');
    set(obj_plot(4, 3).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [-0.2 0.8], 3, '%.1f');
    set(obj_plot(4, 4).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 16], 3, '%d');
    set(obj_plot(4, 5).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [-10 180], 3, '%d');
    set(obj_plot(4, 6).facet_axes_handles, y_lims{:});
    x_lims = getlimoptions('X', [0 0.14], 3, '%.2f');
    y_lims = getlimoptions('Y', [1 3], 3, '%d');
    set(obj_plot(4, 7).facet_axes_handles, x_lims{:}, y_lims{:});
    
    y_lims = getlimoptions('Y', [-0.1 0.9], 3, '%.1f');
    set(obj_plot(5, 1).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0.2 1], 3, '%.1f');
    set(obj_plot(5, 2).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 0.4], 3, '%.1f');
    set(obj_plot(5, 3).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [-0.2 0.8], 3, '%.1f');
    set(obj_plot(5, 4).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [0 16], 3, '%d');
    set(obj_plot(5, 5).facet_axes_handles, y_lims{:});
    y_lims = getlimoptions('Y', [-20 350], 3, '%d');
    set(obj_plot(5, 6).facet_axes_handles, y_lims{:});
    x_lims = getlimoptions('X', [0 0.4], 3, '%.1f');
    y_lims = getlimoptions('Y', [1 4], 3, '%.1f');
    set(obj_plot(5, 7).facet_axes_handles, x_lims{:}, y_lims{:});
    
    options_1.annotation{8} = 20;
    annotation(handle_fig, 'textbox', [0 0.98 0.05 0.05], 'String', 'a  (i)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0 0.78 0.05 0.05], 'String', 'b  (i)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0 0.58 0.05 0.05], 'String', 'c  (i)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0 0.38 0.05 0.05], 'String', 'd  (i)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0 0.18 0.05 0.05], 'String', 'e  (i)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.13 0.98 0.05 0.05], 'String', '(ii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.13 0.78 0.05 0.05], 'String', '(ii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.13 0.58 0.05 0.05], 'String', '(ii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.13 0.38 0.05 0.05], 'String', '(ii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.13 0.18 0.05 0.05], 'String', '(ii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.27 0.98 0.05 0.05], 'String', '(iii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.27 0.78 0.05 0.05], 'String', '(iii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.27 0.58 0.05 0.05], 'String', '(iii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.27 0.38 0.05 0.05], 'String', '(iii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.27 0.18 0.05 0.05], 'String', '(iii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.41 0.98 0.05 0.05], 'String', '(iv)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.41 0.78 0.05 0.05], 'String', '(iv)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.41 0.58 0.05 0.05], 'String', '(iv)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.41 0.38 0.05 0.05], 'String', '(iv)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.41 0.18 0.05 0.05], 'String', '(iv)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.55 0.98 0.05 0.05], 'String', '(v)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.55 0.78 0.05 0.05], 'String', '(v)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.55 0.58 0.05 0.05], 'String', '(v)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.55 0.38 0.05 0.05], 'String', '(v)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.55 0.18 0.05 0.05], 'String', '(v)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.69 0.98 0.05 0.05], 'String', '(vi)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.69 0.78 0.05 0.05], 'String', '(vi)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.69 0.58 0.05 0.05], 'String', '(vi)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.69 0.38 0.05 0.05], 'String', '(vi)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.69 0.18 0.05 0.05], 'String', '(vi)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.83 0.98 0.05 0.05], 'String', '(vii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.83 0.78 0.05 0.05], 'String', '(vii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.83 0.58 0.05 0.05], 'String', '(vii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.83 0.38 0.05 0.05], 'String', '(vii)', options_1.annotation{:});
    annotation(handle_fig, 'textbox', [0.83 0.18 0.05 0.05], 'String', '(vii)', options_1.annotation{:});
    exportgraph(obj_plot, default_options.folder.plot, plot_name, handle_fig)
    clearvars -except plots_to_gen default_options
end

% Supplementary Figure 5
if any(strcmp('fig-s5', plots_to_gen)) || any(strcmp('all', plots_to_gen))
    plot_name = 'fig-s5';
    
    file_name = 'class_sample_compare_fast_exhaustive.mat';
    raw_data_1 = load([default_options.folder.data file_name]);
    options_1 = default_options;
    diff_metrics = abs(diff(raw_data_1.measure, 1, 3));
    
    data_y = diff_metrics ./ mean(raw_data_1.measure(:, :, 2)) * 100;
    data_x = repmat(raw_data_1.range_sample, raw_data_1.n_sim, 1);
    obj_plot(1, 1) = gramm('x', data_x(:), 'y', data_y(:));
    obj_plot(1, 1).stat_summary('type', 'std', 'geom', {'area'});
    obj_plot(1, 1).set_names('x', 'Number of samples', 'y', {'%age difference between', 'fast and exhaustive PRED'});
    obj_plot(1, 1).set_color_options(options_1.color{:});
    obj_plot(1, 1).set_point_options(options_1.point{:});
    obj_plot(1, 1).set_line_options(options_1.line{:});
    obj_plot(1, 1).set_text_options(options_1.text{:});
    obj_plot(1, 1).set_order_options(options_1.order{:});
    x_lims = getlimoptions('X', [0 max(raw_data_1.range_sample)], 6, '%d');
    y_lims = getlimoptions('Y', [0 40], 5, '%d');
    obj_plot(1, 1).axe_property(x_lims{:}, y_lims{:}, options_1.axis{:});
    
    handle_fig = figure('Position', [0 0 450 450], 'PaperPositionMode', 'auto');
    rng('default');
    obj_plot.draw();
    
    set(obj_plot(1, 1).facet_axes_handles, 'YLim', [-5 40]);
    exportgraph(obj_plot, default_options.folder.plot, plot_name, handle_fig)
    clearvars -except plots_to_gen default_options
end

end

function [range_left, range_right, range_mid, mean_mid, sd_mid] = calculatedrvar(data, range_noise)
fn_mid = @(x,y) (x + y) / 2;
data_means = nanmean(data, 1);
means.left = mean(data_means(1:5));
means.right = mean(data_means(end-4:end));
range_measure = abs(means.left - means.right);
if means.left > means.right
    h_left = data_means < means.left - range_measure * 0.01;
    h_right = data_means < means.right + range_measure * 0.01;
else
    h_left = data_means > means.left + range_measure * 0.01;
    h_right = data_means > means.right - range_measure * 0.01;
end
range_left = range_noise(find(h_left, 1, 'first'));
range_right = range_noise(find(h_right, 1, 'first'));
range_mid = find(round(range_noise, 1) == round(fn_mid(range_left, range_right), 1));
sd_mid = std(data(:, range_mid), [], 1) / range_measure;
mean_mid = data_means(range_mid);
end

function options = getlimoptions(axis, lims, steps, format)
ticks = linspace(lims(1), lims(2), steps);
options = {sprintf('%sLim', axis), lims, sprintf('%sTick', axis), ticks, sprintf('%sTickLabel', axis), num2str(ticks(:), format)};
end