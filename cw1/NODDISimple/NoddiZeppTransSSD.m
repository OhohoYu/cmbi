function [sumRes, S] = NoddiZeppTransSSD(x, Avox, bvals, qhat)

x = NoddiZeppTrans(x);
[sumRes, S] = NoddiZeppSSD(x, Avox, bvals, qhat);

end