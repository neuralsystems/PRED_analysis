function data = removeallemptydims(data)
nDims = ndims(data);
    function allemptydims = findalldim(data, dims)
        if isempty(dims)
            allemptydims = data;
        else
            allemptydims = findalldim(all(data, dims(1)), dims(2:end));
        end
    end
for iDim = 1:nDims
    subs_data = repelem({':'}, 1, nDims);
    subs_data{iDim} = ~findalldim(cellfun(@isempty, data), setdiff(1:nDims, iDim));
    data = subsref(data, substruct('()', subs_data));
end
end