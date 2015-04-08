function advPlotAll()

load('def_field_error2.mat');

MODELS = [1:6,8];
COUCH = 5;

for c=1:COUCH
  figure
  for m=MODELS
    plot(squeeze(error_mean(m,c,:)));%, error_std_dev(m,c,:));
    hold on
  end

  legend('linear', 'quadratic', 'cubic', 'linear - phase separation', ...
  'quadratic - phase separation', 'cubic - phase separation', 'B-spline', ...
  '2D linear', '2D quadratic', 'Location', 'northoutside')
  xlabel('Couch position');
  ylabel('Mean error');
end




end