function c4AicBic()

% linear is best, quadratic, then cubic

load('def_field_error.mat');

[MODELS, COUCH, CPG] = size(SSD);

aic = zeros(size(SSD));
bic = zeros(size(SSD));

MODEL_NR_PARAMS = [2,3,4];

sigma = error_std_dev;

for m=1:MODELS
  for couch=1:COUCH
    for cpg=1:CPG
      aic(m, couch, cpg) = 2*MODEL_NR_PARAMS(m) + SSD/(sigma(m, couch, cpg)^2);
      bic(m, couch, cpg) = log(nr_data_points(m, couch, cpg))*MODEL_NR_PARAMS(m) + SSD/(sigma(m, couch, cpg)^2);
      
    end
  end
end

end