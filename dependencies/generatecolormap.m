function custcolormap = generatecolormap(order, n_light)
n_col = length(order);
max_col = 6;
max_light = 9;
if n_light > max_light || n_col > max_col || any(order > max_col)
    print('Unsupported colors. Returning default matlab scheme')
    custcolormap = hsv(n_col * n_light);
else
    if n_light == 2
        id_light = [1 7];
    elseif n_light == 3
        id_light = [1 4 7];
    else
        id_light = 1:n_light;
    end
    filename = 'dependencies\colors.txt';
    formatSpec = '%s%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'char',  'ReturnOnError', false);
    dataArray{1} = strtrim(dataArray{1});
    fclose(fileID);
    hexcolors = dataArray{1};
    hex2rgb = @(str) sscanf(str(2:end), '%2x%2x%2x', [1 3]) / 255;
    rgbcolors = zeros(length(hexcolors), 3);
    for i_color = 1:length(hexcolors)
        rgbcolors(i_color, :) = hex2rgb(hexcolors{i_color});
    end
    custcolormap = zeros(n_col * n_light, 3);
    for i_col = 1:n_col
        custcolormap((n_light * (i_col - 1) + 1):n_light * i_col, :) = rgbcolors(max_light * (order(i_col) - 1) + id_light, :);
    end
end
end