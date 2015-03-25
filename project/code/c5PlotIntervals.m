function c5PlotIntervals()

NR_PARAMS = [2, 3, 4];

load('MCMC.mat');

parBoot = load('ParBootstrapRes.mat');
resBoot = load('ResBootstrapRes.mat');
wildBoot = load('WildBootstrapRes.mat');

MODELS = 3;

c = 1; % only plot intervals for couch position 1

% MCMC
mcmc_2sigma_model1 = squeeze(two_sigma_model1(c,:,:));
mcmc_conf95_model1 = squeeze(conf_95_model1(c,:,:));
mcmc_2sigma_model2 = squeeze(two_sigma_model2(c,:,:));
mcmc_conf95_model2 = squeeze(conf_95_model2(c,:,:));
mcmc_2sigma_model3 = squeeze(two_sigma_model3(c,:,:));
mcmc_conf95_model3 = squeeze(conf_95_model3(c,:,:));

% Parametric bootstrap
par_2sigma_model1 = squeeze(parBoot.BlinRes(:,3:4,c)); %3-4 are 2sigma ranges
par_conf95_model1 = squeeze(parBoot.BlinRes(:,5:6,c)); % 5-6 are 95% conf
par_2sigma_model2 = squeeze(parBoot.Bpol2Res(:,3:4,c));
par_conf95_model2 = squeeze(parBoot.Bpol2Res(:,5:6,c));
par_2sigma_model3 = squeeze(parBoot.Bpol3Res(:,3:4,c));
par_conf95_model3 = squeeze(parBoot.Bpol3Res(:,5:6,c));

% Residual bootstrap
res_2sigma_model1 = squeeze(resBoot.BlinRes(:,3:4,c)); %3-4 are 2sigma ranges
res_conf95_model1 = squeeze(resBoot.BlinRes(:,5:6,c)); % 5-6 are 95% conf
res_2sigma_model2 = squeeze(resBoot.Bpol2Res(:,3:4,c));
res_conf95_model2 = squeeze(resBoot.Bpol2Res(:,5:6,c));
res_2sigma_model3 = squeeze(resBoot.Bpol3Res(:,3:4,c));
res_conf95_model3 = squeeze(resBoot.Bpol3Res(:,5:6,c));

% Wild bootstrap
wild_2sigma_model1 = squeeze(wildBoot.BlinRes(:,3:4,c)); %3-4 are 2sigma ranges
wild_conf95_model1 = squeeze(wildBoot.BlinRes(:,5:6,c)); % 5-6 are 95% conf
wild_2sigma_model2 = squeeze(wildBoot.Bpol2Res(:,3:4,c));
wild_conf95_model2 = squeeze(wildBoot.Bpol2Res(:,5:6,c));
wild_2sigma_model3 = squeeze(wildBoot.Bpol3Res(:,3:4,c));
wild_conf95_model3 = squeeze(wildBoot.Bpol3Res(:,5:6,c));

boot_types={'mcmc', 'par', 'res', 'wild'};
colours = ['b', 'm', 'k', 'r'];

%% model 1
for m=1:MODELS
  nr_params = NR_PARAMS(m);
  for p=1:nr_params
      h = figure
      alt = 1;
      for type=1:4
        sigma_name = sprintf('%s_2sigma_model%d', boot_types{type}, m);
        sigma = eval(sigma_name);
        spec = sprintf('%s-x', colours(type));
        plot(sigma(p,:), [alt,alt],spec);
        alt = alt + 1;
        hold on
        
        conf_name = sprintf('%s_conf95_model%d', boot_types{type}, m);
        conf = eval(conf_name);
        spec = sprintf('%s-o', colours(type));
        plot(conf(p,:), [alt,alt],spec);
        alt = alt + 1;
        hold on
      end
      
      ylim ([0 alt]);
      h_legend = legend('MCMC 2sigma','MCMC 95% conf', 'Parametric Bootstrap 2sigma', 'Parametric Bootstrap 95% conf',...
        'Residual Bootstrap 2sigma', 'Residual Bootstrap 95% conf',...
        'Wild Bootstrap 2sigma', 'Wild Bootstrap 95% conf', 'Location','NorthOutside');
      set(h_legend,'FontSize',14);
      %set(gca, 'FontName', 'Arial')
      set(gca, 'FontSize', 14)
      %legend('2 sigma Par Bootstrap', '2sigma MCMC', 'conf95ParBoot', 'conf95MCMC', 'location', 'northoutside');
      filename = sprintf('figures/params_uncertainty/c5uncert_model%d_param%d.png', m, p);
      saveas(h, filename, 'png');
  end
end


%  diag cov - 2sigma range
%   -0.166775137824368
%   -0.000000000000000
%   -0.000000000016855
%   -0.000000000018668
%   -0.000000000025459


end