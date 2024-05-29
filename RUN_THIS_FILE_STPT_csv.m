clear

dir_root = {...
%     'Z:/Yongsoo_Kim_Lab/STP_processed/2019_optical/20191212_UC_U504_C57J_FITC-fill_M_p67_optical';
%     'Z:/Yongsoo_Kim_Lab_2/STP_processed/2020_optical/20200220_UC_U547_C57J_FITC-fill_M_p559_optical';
%     'Z:/Yongsoo_Kim_Lab_2/STP_processed/2020_optical/20200227_UC_U548_C57J_FITC-fill_M_p559_optical';
%     'Z:/Yongsoo_Kim_Lab_2/STP_processed/2020_optical/20200319_HB_U549_C57J_FITC-fill_M_p63_optical';
%     'Z:/Yongsoo_Kim_Lab_2/STP_processed/2020_optical/20200324_YK_U533_C57J_FITC-fill_F_p56_optical';
%     'Z:/Yongsoo_Kim_Lab_2/STP_processed/2020_optical/20200407_UC_U581_C57J_FITC-fill_F_p557_optical';
%     'Z:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200402_YK_U554_C57J_FITC-fill_F_p56_optical';
%     'Z:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200412_YK_U550_C57J_FITC-fill_M_p63_optical';
%     'Z:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200424_UC_U582_C57J_FITC-fill_F_p557_optical';
%     'Z:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200501_UC_U598_C57J_FITC-fill_F_p69_optical';
%     'Z:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200515_UC_U583_C57J_FITC-fill_F_p557_optical';
%     'Z:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200328_YK_U573_QZ719_C57J_FITC-fill_F_24mo_optical';
%     'Z:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200725_HB_U584_C57J_FITC-fill_F_p558_optical';
%     'Z:/Yongsoo_Kim_Lab_2/STP_processed/2020_optical/20200123_HB_HB106_PA5xFAD_WT_FITC-rat_optical';
%     'Z:/Yongsoo_Kim_Lab_2/STP_processed/2020_optical/20200109_HB_HB107_PA5xFAD_MUT_FITC-rat_optical';
%     'Z:/Yongsoo_Kim_Lab_2/STP_processed/2020_optical/20200312_HB_HB125_PA5xFAD_MUT_P72_FITC-fill_optical';
%     'Z:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200522_HB_HB130_5xFAD_FITC-filll_F_MUT_p236_optical';
%     'Z:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200529_HB_HB131_5xFAD_FITC-fill_F_WT_p236_optical';
'Z:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200729_HB_U601_C57J_FITC-fill_F_p56_optical';
% 'Z:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200803_HB_U602_C57J_FITC-fill_F_p56_optical';
'Z:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200814_YK_U585_C57J_FITC-fill_F_18mo_optical';
% 'Z:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200827_HB_U605_C57J_FITC-fill_M_p56_optical';


    };



target_resolution = 10;
atlas_resoultion = 20;
atlas_resize = 0.5;
og_resolution = [1,1,1];
    
    for ii = 1:length(dir_root)
%     ii = 1
        
        fol_name  = strsplit(dir_root{ii},'/');
        fol_name = fol_name{end};
        fol_name  = strsplit(fol_name,'\');
        fol_name = fol_name{end};
        atlas_map = [dir_root{ii},'/rev_registraion/result.nii'];
        atlas_map = niftiread(atlas_map);
        atlas_map = imresize3(atlas_map,atlas_resize,'nearest');        

        
        
        skeleton_data = [dir_root{ii}, '/all_link_data.mat'];
        skeleton_data = load(skeleton_data);
        radii_data = skeleton_data.S_radii;
        [skeleton_data_x, skeleton_data_y, skeleton_data_z] = ind2sub(skeleton_data.CropSize,skeleton_data.S_skel);
        
        og_size = skeleton_data.CropSize;
        skeleton_data = [skeleton_data_y, skeleton_data_x, skeleton_data_z];
        skeleton_data = skeleton_data.*og_resolution;
        
        
        inddd = repmat([1;2;3;4],[ceil(size(skeleton_data,1)./4) 1]);
        inddd = inddd(1:size(skeleton_data,1));
        inddd = inddd ==1;
        
        
        skeleton_data = skeleton_data(inddd,:);
        radii_data = radii_data(inddd,:);
        
        og_size = og_size.*og_resolution;

        atlas_size = size(atlas_map);
        nnd_distance_map_2 = nnd_distance_map(skeleton_data, radii_data,target_resolution, atlas_resoultion, atlas_size);
        
        niftiwrite(nnd_distance_map_2, [fol_name, '_nnd_map.nii'])

        




        nnd_distance_map_2 = niftiread( [fol_name, '_nnd_map.nii']);
        making_nnd_csv(nnd_distance_map_2,atlas_map,fol_name);
        
        
        
    end
    
    
    
    
