function schlegel(recalc)

if nargin < 1
    recalc = false;
end

raw_file = 'data\schlegel_2021\raw\hemibrain_fafb_alpn_lhn_matched_connectivity.csv';
file_name = 'data\schlegel_2021\processed_data_schlegel.mat';
if ~exist(file_name, 'file') || recalc
    
    opts = delimitedTextImportOptions("NumVariables", 9);
    
    % Specify range and delimiter
    opts.DataLines = [2 Inf];
    opts.Delimiter = ",";
    
    % Specify column names and types
    opts.VariableNames = ["VarName1", "glom", "id", "weight", "celltype", "connectivitytype", "dataset", "index", "cell_name"];
    opts.VariableTypes = ["double", "char", "double", "double", "char", "char", "char", "double", "char"];
    
    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    
    % Specify variable properties
    opts = setvaropts(opts, ["glom", "celltype", "connectivitytype", "dataset", "cell_name"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["glom", "celltype", "connectivitytype", "dataset", "cell_name"], "EmptyFieldRule", "auto");
    
    % Import the data
    temp_data = readtable(raw_file, opts);
    
    % Convert to output type
    temp_data = table2cell(temp_data);
    numIdx = cellfun(@(x) ~isnan(str2double(x)), temp_data);
    temp_data(numIdx) = cellfun(@(x) {str2double(x)}, temp_data(numIdx));
    
    id_glom = unique(temp_data(:, 2));
    id_database = unique(temp_data(:, 7));
    id_lhn = unique(temp_data(:, 9));
    id_connectivity = unique(temp_data(:, 6));
    id_celltype = unique(temp_data(:, 5));
    id_tract = unique(cellfun(@(x) x(1:5), id_lhn, 'UniformOutput', false));
    id_region = unique(cellfun(@(x) x(1:4), id_lhn, 'UniformOutput', false));
    id_connectivity_lhn = cellfun(@(x) id_lhn(contains(id_lhn, x)), id_connectivity, 'UniformOutput', false);
    id_tract_lhn = cellfun(@(x) id_lhn(contains(id_lhn, x)), id_tract, 'UniformOutput', false);
    id_region_lhn = cellfun(@(x) id_lhn(contains(id_lhn, x)), id_region, 'UniformOutput', false);
    id_celltype_lhn = cellfun(@(x) id_lhn(contains(id_lhn, x)), id_celltype, 'UniformOutput', false);
    n_glom = length(id_glom);
    n_database = length(id_database);
    n_connectivity = length(id_connectivity);
    n_celltype = length(id_celltype);
    n_tract = length(id_tract);
    n_region = length(id_region);
    n_connectivity_lhn = max(cellfun(@length, id_connectivity_lhn));
    n_tract_lhn = max(cellfun(@length, id_tract_lhn));
    n_region_lhn = max(cellfun(@length, id_region_lhn));
    n_celltype_lhn = max(cellfun(@length, id_celltype_lhn));
    
    % size decided using maximum observed values
    processed_data.full = nan(n_database, n_connectivity_lhn, n_connectivity, n_glom);
    processed_data.celltype = nan(n_database, n_celltype_lhn, n_celltype, n_glom);
    processed_data.tract = nan(n_database, n_tract_lhn, n_tract, n_glom);
    processed_data.region = nan(n_database, n_region_lhn, n_region, n_glom);
    
    for i_cell = 1:size(temp_data, 1)
        i_database = contains(id_database, temp_data{i_cell, 7});
        i_glom = contains(id_glom, temp_data{i_cell, 2});
        i_connectivity = contains(id_connectivity, temp_data{i_cell, 6});
        i_celltype = contains(id_celltype, temp_data{i_cell, 5});
        i_tract = contains(id_tract, temp_data{i_cell, 6}(1:5));
        i_region = contains(id_region, temp_data{i_cell, 6}(1:4));
        i_connectivity_lhn = contains(id_connectivity_lhn{i_connectivity}, temp_data{i_cell, 9});
        i_tract_lhn = contains(id_tract_lhn{i_tract}, temp_data{i_cell, 9});
        i_region_lhn = contains(id_region_lhn{i_region}, temp_data{i_cell, 9});
        i_celltype_lhn = contains(id_celltype_lhn{i_celltype}, temp_data{i_cell, 9});

        processed_data.full(i_database, i_connectivity_lhn, i_connectivity, i_glom) = temp_data{i_cell, 4};
        processed_data.celltype(i_database, i_celltype_lhn, i_celltype, i_glom) = temp_data{i_cell, 4};
        processed_data.tract(i_database, i_tract_lhn, i_tract, i_glom) = temp_data{i_cell, 4};
        processed_data.region(i_database, i_region_lhn, i_region, i_glom) = temp_data{i_cell, 4};
    end
    processed_data.full = squeeze(nanmean(processed_data.full, 2));
    save(file_name, 'processed_data', 'id_*', 'n_*')
end
end