function clusters = generateclustereddata(n_sample, n_class, n_dim, range, min_dist, max_radius)
if isscalar(max_radius)
    max_radius = ones(n_class, 1) * max_radius;
end
cluster_means = generateclustermeans(n_class, n_dim, range, min_dist);
clusters = cell(n_sample, n_class);
for i_class = 1:n_class
    temp = cluster_means(i_class, :) + rand(n_sample, n_dim) * max_radius(i_class) * 2 - max_radius(i_class);
    clusters(:, i_class) = num2cell(temp, 2);
end
end

function means = generateclustermeans(n_point, n_dim, range, min_dist)
means = rand(1, n_dim) * diff(range) + range(1);
i_point = 1;
while i_point < n_point
    temp = rand(1, n_dim) * diff(range) + range(1);
    if all(pdist([means; temp]) > min_dist)
        means = [means; temp];
        i_point = i_point + 1;
    end
end
end