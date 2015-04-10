function c4PlotLandmark()

load('landmark_errors2.mat');

MODELS = 1:9;
COUCH = 5;
linestyle = {'-*','-*','-*','-+','-+','-+','-o','-o','-o',};

plotLegend = 0;

for c=1:COUCH
  h = figure;
  for m=MODELS
    plot(squeeze(land_error(m,c,:)),'LineWidth',2);
    hold on
  end
  plot(squeeze(land_error_orig_reg(c,:)), 'k-x','LineWidth',2);

  set(h, 'Position', [0 0 600 250]);
  if(plotLegend == 1)
    set(h, 'Position', [0 0 900 250]);
    h_legend = legend('linear', 'quadratic', 'cubic', 'linear - phase separation', ...
    'quadratic - phase separation', 'cubic - phase separation', 'B-spline', ...
    '2D linear', '2D quadratic','original registration', 'Location', 'eastoutside');
    set(h_legend,'Box','off');
  end
  
  
  set(gca,'FontSize',13,'FontName','cmr');
  xlabel('Cine CT volume');
  ylabel('Landmark Error');
  axis tight
  ax = gca;
  %ax.XTick = 1:2;40
  if (plotLegend == 1)
    figname = sprintf('../report/figures/task4/landmark_error_legend.eps');
  else
    figname = sprintf('../report/figures/task4/landmark_error_couch%d.eps', c);
  end

  hgexport(h, figname);
end

end