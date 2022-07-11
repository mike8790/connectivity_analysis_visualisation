%% script takes the 10 thresholded T-maps showing statistically significant
% connectivity of each of the 10 AP regions - goes voxel by voxel on each
% T-map and identifies which of the contrasts has the highest z-value, i.e.
% the region with the strongest connectivity to that voxel and allocates an
% identity of 1-10 for each voxel (or nan if no connectivity value for that 
% voxel from any region

% cd to main directory containing T-maps for each AP region (AP1-10)
cd ''

%%

% generate a list of T-maps from the directory and select the first 10
% which will be the AP1-10 contrasts
tmaps = dir('spmT_00*_AP*_basicT.nii');
tmaps = struct2cell(tmaps).';
tmaps = tmaps(1:10,1);

for n = 1:length(tmaps)
    tmap = spm_vol(tmaps{n}); % convert .nii file to format readable by Matlab
    % read the volume and output two structures: a = 3D matrix of values, 
    % corresponding to value of each voxel. XYZ = XYZ coord in mm (MNI) for each voxel
    [mask, XYZ] = spm_read_vols(tmap); 
    % turn any zero voxels to NaN
    mask(mask == 0) = NaN;
    % find all non-zero values for T-map 
    mask_ones = find(mask);
    % use mask_ones index to generate nx1 array of all voxel values for 
    % given T-map
    mask_one = mask(mask_ones);
    % add nx1 array to columnar array (nx10, 1 for each t-map) that will 
    % be used to find highest connectivity value for voxel
    comparison_set(:,n) = mask_one; 
end

%%

for ii = 1:length(mask_one)
    % find the max val (amn) and the column id of that val (mmn)
    [amn, mmn] = max(comparison_set(ii,:),[],'linear','omitnan');
    comparison_peak1(ii,:) = amn;
    comparison_peak2(ii,:) = mmn;
end

comparison_peak2(comparison_nan,:) = 0;
% generate a list of all voxels and the identity based on region with max
% connectivity (1-10, or 0 if no connectivity)
mask_all_flat = comparison_peak2;

%%

zz = 1:91:902629;
azz = 91:91:902629;

% loop through all voxels and remap on to a x,y,z /3-D array 
for i  = 1:9919
    wta_complete(i,:) = mask_all_flat(zz(i):azz(i));
end
wta_complete = wta_complete.';
qq = 1:109:9919;
aqq = 109:109:9919;
for ii = 1:91
    wta_complete_mask(:,:,ii) = wta_complete(:,qq(ii):aqq(ii));
end

%% output 3-D structure to .nii that can be read by SPM and suit and mapped 
% on to brain structures
niftiwrite(wta_complete_mask,'wta_complete_mask.nii');