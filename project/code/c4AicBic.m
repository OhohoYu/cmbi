function c4AicBic()

% linear is best, quadratic, then cubic

load('def_field_error2.mat');
%load('landmark_errors2.mat');

[MODELS, COUCH, CPG] = size(SSD);

aic = zeros(MODELS, COUCH, CPG);
bic = zeros(MODELS, COUCH, CPG);

MODEL_NR_PARAMS = [2,3,4,4,6,8,4,3,6];

sigma = error_std_dev;

ssdNoise = SSD ./ (sigma.^2);
sumSSD = sum(squeeze(sum(ssdNoise, 2)),2);

data_points = sum(squeeze(sum(nr_data_points, 2)),2);
aic = 2*MODEL_NR_PARAMS' + sumSSD
bic = log(data_points).*MODEL_NR_PARAMS' + sumSSD
mean_def_error = mean(squeeze(mean(error_mean,2)),2);
%mean_land_error = mean(squeeze(mean(land_error,2)),2);

labels = {'linear', 'quadratic', 'cubic', 'linear - phase separation', ...
  'quadratic - phase separation', 'cubic - phase separation', 'B-spline', ...
  '2D linear', '2D quadratic'};

[~, indices_sorted] = sort(aic);
labels(indices_sorted)'

[aic, bic]

for i=1:MODELS
  m = indices_sorted(i);
  display(sprintf('%s & %.0f & %.0f & %.3f\\\\', labels{m}, aic(m), bic(m), mean_def_error(m)));
end

end