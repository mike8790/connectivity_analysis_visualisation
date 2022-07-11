# connectivity_analysis_visualisation
Sample of scripts use to visualise data from a rsfMRI analysis

A project where I used a form of fMRI analysis called resting-state fMRI (rsfMRI) which is used to analyse the functional connectivity between 'seed' regions 
and other voxels of the brain.
In this project I divided the frontal cortex in to seeds forming a grid - on the basis of anterior-posterior position (AP1-10) and major anatomical structures of the 
frontal cortex. Then analysed the connectivity of these seed regions to the cerebellum.

To visualise results - created 2-D plots of the cerebellum showing organisation of connectivition from individual seed (or groups of seeds on the same AP plane) 
accross the cerebellar surface ('plot_connectivitymaps_to_cerebellar_surface.m' & 'winner_takes_all.m'

Calculated parameter estimates from multiple regression analyses to show relationship between activity in each seeds to selected voxels within the cerebellum. Then 
plotted PE for each seed region/ voxel relationship as a colour scaled matrix to demonstrate similarity/ difference of connectivity profiles of different seeds at a glance ('plot_parameterestimates_to_connectivity_matrix.m')
