function defaults = defaultplotoptions()
defaults.folder.data = 'data\';
defaults.folder.plot = 'plots\';
% set_color_options
defaults.color = {'map', generatecolormap(1:6, 9), 'n_color', 6, 'n_lightness', 9, 'legend', 'separate_gray'};
% set_point_options
defaults.point = {'base_size', 8};
% set_line_options
defaults.line = {'base_size', 2};
% set_order_options
defaults.order = {'x', 0, 'color', 0, 'lightness', 0, 'row', 0, 'column', 0};
% set annotation defaults
defaults.annotation = {'BackgroundColor', 'none', 'Color', 'k', 'LineStyle', 'none', 'FontSize', 35, 'FontWeight', 'bold', 'HorizontalAlignment', 'center'};
% set_text_options
defaults.text = {'font', 'Helvetica', 'interpreter', 'none', 'base_size', 16, 'label_scaling', 1, 'legend_scaling', 1, 'legend_title_scaling', 1, 'facet_scaling', 1, 'title_scaling', 0.8, 'big_title_scaling', 0.8};
% text function for extra labels
defaults.extra_text = {'FontSize', 12, 'FontName', 'Helvetica', 'interpreter', 'none', 'HorizontalAlignment', 'center'};
% for custom xlabels (instead of the ones generated automatically)
defaults.xlabels = {'FontSize', 16, 'FontName', 'Helvetica', 'interpreter', 'none', 'HorizontalAlignment', 'center'};
% set_axe_property
defaults.axis = {'YGrid', 'on', 'Color', 'none', 'XColor', [0 0 0], 'YColor', [0 0 0], 'GridColor', [0 0 0], 'GridAlpha', 0.3, 'GridLineStyle', '--', 'TickLength', [0.01 0.025], 'TickDir', 'out', 'LineWidth', 1, 'TickLabelInterpreter', 'none', 'FontName', 'Helvetica'};
% stat_violin
defaults.stat_violin = {'normalization', 'width', 'fill', 'transparent', 'width', 0.5, 'dodge', 0.7};
% geom_point
defaults.geom_point = {'alpha', 0.4};
% geom_line
defaults.geom_line = {'alpha', 0.4};
end