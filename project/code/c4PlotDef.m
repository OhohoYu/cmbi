function c4PlotDef()

load('def_field_error2.mat');

MODELS = 1:9;
COUCH = 5;

linestyle = {'-*','-*','-*','-+','-+','-+','-o','-o','-o',};

for c=1:COUCH
  h = figure;
  for m=MODELS
    plot(squeeze(error_mean(m,c,:)), linestyle{m},'LineWidth',1.5);
    hold on
  end

  set(h, 'Position', [0 0 600 400]);
  h_legend = legend('linear', 'quadratic', 'cubic', 'linear - phase separation', ...
  'quadratic - phase separation', 'cubic - phase separation', 'B-spline', ...
  '2D linear', '2D quadratic', 'Location', 'northoutside');
  set(h_legend,'Box','off');
  set(gca,'FontSize',13,'FontName','cmr');
  xlabel('Cine CT volume');
  ylabel('Error mean');
  axis tight
  ax = gca;
  ax.XTick = 1:10;
  figname = sprintf('../report/figures/task4/def_mean_error_couch%d.eps', c);
  hgexport(h, figname);
end

for c=1:COUCH
  h = figure;
  for m=MODELS
    plot(squeeze(error_mean(m,c,:)), linestyle{m},'LineWidth',1.5);
    hold on
  end

  set(h, 'Position', [0 0 600 400]);
  h_legend = legend('linear', 'quadratic', 'cubic', 'linear - phase separation', ...
  'quadratic - phase separation', 'cubic - phase separation', 'B-spline', ...
  '2D linear', '2D quadratic', 'Location', 'northoutside');
  set(h_legend,'Box','off');
  set(gca,'FontSize',13,'FontName','cmr');
  xlabel('Cine CT volume');
  ylabel('Error std-dev');
  axis tight
  ax = gca;
  ax.XTick = 1:10;
  figname = sprintf('../report/figures/task4/def_stddev_error_couch%d.eps', c);
  hgexport(h, figname);
end

end