function c1()

addpath NIFTI_20110921

limits=[66,76;
        55,65;
        44,54;
        34,43;
        23,33];
    
COUCH_POS = 5;
VOLUMES = 10;

for c=1:COUCH_POS
    for v=0:VOLUMES-1
        for slice_nr=limits(c,1):limits(c,2)
            [c,v,slice_nr]
            ct_filename = sprintf('../data/%dpos_data_couch/ct_couch_pos%d_cine0%d.nii',c,c,v);
            ct = load_nii(ct_filename);
            
            reg1_filename = sprintf('../data/%dpos_data_couch/reg1_couch_pos%d_cine0%d_image.nii',c,c,v);
            reg1 = load_nii(reg1_filename);
            
            reg2_filename = sprintf('../data/%dpos_data_couch/reg2_couch_pos%d_cine0%d_image.nii',c,c,v);    
            reg2 = load_nii(reg2_filename);
            
            figure(1)
            dispNiiSliceColourOverlay(ct, reg1, 'z', slice_nr);
            figure(2)
            dispNiiSliceColourOverlay(ct, reg2, 'z', slice_nr);
            
%             figure(1)
%             h1 = dispNiiSlice(ct1_00, 'z', slice_nr);
%             figure(2)
%             h2 = dispNiiSlice(reg1, 'z', slice_nr);
%             figure(3)
%             h3 = dispNiiSlice(reg2, 'z', slice_nr);
        end
    end

end

% good registrations

% just take the first images you see

% bad registrations

[c1,v1,slice1] = deal([1,1,76])
[c2,v2,slice21] = deal([4,1,34])
[c3,v3,slice31] = deal([4,6,34])
[c4,v4,slice41] = deal([5,1,23])
[c4,v4,slice41] = deal([5,6,23])


end

