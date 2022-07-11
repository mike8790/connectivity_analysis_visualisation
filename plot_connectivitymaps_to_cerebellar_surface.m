%% script takes thresholded T-maps from results directory and maps the 
% connectivity results on to a cerebellar flatmaps using 'suit' SPM plugin,
% allowing quick and easy visualisation of connectivity from source region
% to the cerebellum

% cd to results diectory
cd '';

% generate list of each of the contrasts/ T-maps so they can be loaded in
% to 'suit' and mapped on the cerebellum, use title of each contrast to
% generate a save name to save each flatmap as a jpg
tmaps = dir('spmT*basicT.nii');
for n = 1:69
    tmap{n,:} = (tmaps(n).name);
end
savnam2 = erase(tmap, '.nii');
savnam2 = extractAfter(savnam2, 10);
savnam = erase(savnam2, 'AP_grid.');

% loop through each of the T-maps, map to cerebellar surface map and save
% in different folder
for n = 1:69
    % cd to results directory where T-maps are stored
    cd '';
    % use function from 'suit' to map 3-D volume image (tmap) as
    % 2-D cerebellar surface
    Data = suit_map2surf(tmap(n),'space','SPM','stats',@mean);
    q = figure(101)
    set(gca, 'Color','k', 'XColor','w', 'YColor','w');
    set(gcf, 'Color','k');
    % plot surface map on to cerebellar surface image
    suit_plotflatmap(Data,'cmap',jet);
    % cd to directory where jpg's are to be saved
    cd ''
    saveas(q, savnam{n});
end
