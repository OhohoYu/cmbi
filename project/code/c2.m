function c2()

addpath NIFTI_20110921

limits=[66,76;
        55,65;
        44,54;
        34,43;
        23,33];
    
COUCH_POS = 5;
VOLUMES = 10;
CPGS = 40;


cp_disp = zeros(COUCH_POS,CPGS,88,68,41,1,3);
surrogate_signal = zeros(6,40);
surrogate_phase = zeros(6,40);
surrogate_gradient = zeros(6,40);

% read the surrogate data and the control point displacements
for c=1:COUCH_POS
    surrogate_file = sprintf('../data/Respiratory_surrogate_data/resp_surr_couch_pos%d.mat', c);
    matdata = load(surrogate_file);
    surrogate_signal(c,:) = matdata.signal';
    surrogate_phase(c,:) = matdata.phase';
    surrogate_gradient(c,:) = matdata.gradient';
    
    for cpg=0:CPGS-1
        cp_filename = sprintf('../data/%dpos_data_couch/reg_couch_pos%d_cine%.2d_cpg.nii',c,c,cpg);
        cp = load_nii(cp_filename);
        cp_disp(c,cpg+1,:,:,:,:,:) = cp.img;
    end
end

% fit the linear model for one voxel

% fit just the given voxels for each couch position, plots the data
%fit1Vox(surrogate_signal, cp_disp,CPGS,COUCH_POS);

% fits all the voxels for every couch position using 1st order model
%fitAllVoxSlow(surrogate_signal, cp_disp, @getSOrder1);

% same but for second order
%fitAllVoxSlow(surrogate_signal, cp_disp, @getSOrder2);

% same but for third order
fitAllVoxSlow(surrogate_signal, cp_disp, @getSOrder3);

end

function fit1Vox(surrogate_signal, cp_disp,CPGS,COUCH_POS)
couch_indices = [30,40,33,1,3;
                 30,40,28,1,3;
                 30,40,23,1,3;
                 30,45,18,1,3;
                 30,45,13,1,3];
             
             
cp_disp_vox = zeros(COUCH_POS, CPGS);
for c=1:COUCH_POS
    cp_disp_vox(c,:) = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
    
    S = [surrogate_signal(c,:)' ones(CPGS,1)];
    C = pinv(S' * S)*S'*cp_disp_vox(c,:)';
    Dpred = S*C;
    
    figure
    scatter(surrogate_signal(c,:), cp_disp_vox(c,:));
    hold on
    plot(surrogate_signal(c,:), Dpred);
end
%(couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5))
             
end


function fitAllVoxSlow(surrogate_signal, cp_disp, orderFunc)


[COUCH_POS,CPGS,Xsize, Ysize, Zsize, ~ , Dsize] = size(cp_disp);

Dpred = zeros(COUCH_POS,CPGS,Xsize, Ysize, Zsize, Dsize);
for c=1:COUCH_POS
    c
    S = orderFunc(surrogate_signal(c,:)');  % surrogate signals (inputs)
    invSSS = pinv(S' * S)*S';
    for x=1:Xsize
        for y=1:Ysize
            for z=1:Zsize
                for d=1:Dsize

                D = cp_disp(c,:,x,y,z,1,d); % displacements (observations)

                C = invSSS*D'; % model parameters
                Dpred(c,:,x,y,z,d) = S*C; % predictions from the model

                figure
                scatter(surrogate_signal(c,:), D);
                hold on
                plot(surrogate_signal(c,:), Dpred(c,:,x,y,z,d));
                
                end
            end
        end
    end
end

end

% first order surrogate signal
function S = getSOrder1(surrogate_signal)

S = [surrogate_signal  ones(size(surrogate_signal))];
    
end

% second order surrogate signal
function S = getSOrder2(surrogate_signal)

S = [surrogate_signal.^2  surrogate_signal  ones(size(surrogate_signal))];
    
end

% third order surrogate signal
function S = getSOrder3(surrogate_signal)

S = [surrogate_signal.^3 surrogate_signal.^2  surrogate_signal  ones(size(surrogate_signal))];
    
end