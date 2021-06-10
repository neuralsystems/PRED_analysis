function exportgraph(obj_plot, plot_folder, plot_name, handle_fig)
obj_plot.export('file_name', [plot_folder, 'png\', plot_name], 'file_type', 'png');
set(handle_fig, 'PaperPositionMode', 'auto');
print(handle_fig, '-painters', '-dpdf', '-fillpage', [plot_folder, 'pdf\', plot_name]);
close(handle_fig)
end