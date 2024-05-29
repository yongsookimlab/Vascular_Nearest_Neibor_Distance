function making_nnd_csv(nnd_distance_map_2,atlas_map,fol_name)


csv_name = '16bit_allen_csv_20200916.csv';


nnd_distance_map_2(nnd_distance_map_2(:)<0) = 0;
nnd_distance_map_2(nnd_distance_map_2(:)>100) = 100;



% [xxx,yyy,zzz] = ind2sub(size(nnd_distance_map_2),  [1:1:length(nnd_distance_map_2(:))]'  );
% 
% 
% flag = xxx >0 & xxx <  crop_size_down_sample(1);
% flag = flag & yyy >0 & yyy <  crop_size_down_sample(2);
% flag = flag & zzz >0 & zzz <  crop_size_down_sample(3);
% 
% vox_ind = sub2ind(crop_size_down_sample,xxx(flag), yyy(flag), zzz(flag));


% [vox_ind_uniq,~,ic] = unique(vox_ind);
% net_down_sample_l = accumarray(ic,S_link.length(flag));

% label = label_OG(vox_ind_uniq);


% net_down_sample_r_l = accumarray(ic,S_link.radii(flag).*S_link.length(flag));
% net_down_sample_r2_l = accumarray(ic,S_link.radii(flag).*S_link.radii(flag).*S_link.length(flag));
% net_down_sample_r4_l = accumarray(ic,S_link.radii(flag).*S_link.radii(flag).*S_link.radii(flag).*S_link.radii(flag).*S_link.length(flag));

label = atlas_map(:);
nnd_distance_map_3 = nnd_distance_map_2(:);




%csv_name = 'ARA2_annotation_structure_info.xlsx';
index_id = 1;
index_parent_id = 8;
index_name = 2;
index_acronym = 3;
index_structure_order = 7;

T = readtable(csv_name);

ROI_table.id = table2array(T(:,index_id));
ROI_table.parent = table2array(T(:,index_parent_id));

ROI_table.idx = find(ROI_table.id);
[~,ROI_table.p_idx]=ismember(ROI_table.parent,ROI_table.id);
ROI_table.name = table2array(T(:,index_name));
ROI_table.acronym = table2array(T(:, index_acronym));
ROI_table.structure_order = table2array(T(:, index_structure_order));

G = digraph(ROI_table.p_idx(2:end), ROI_table.idx(2:end), 1, ROI_table.name);





for NNN = 1:length(ROI_table.idx)
    
    list_of_all_ROI_inside{NNN} = find(~isinf(distances(G,NNN)));
    
end



[logi,loca] = ismember(label,ROI_table.id);

% net_down_sample_l = net_down_sample_l(logi);
% net_down_sample_r_l = net_down_sample_r_l(logi);
% net_down_sample_r2_l = net_down_sample_r2_l(logi);
% net_down_sample_r4_l = net_down_sample_r4_l(logi);
% 

nnd_distance_map_3 = nnd_distance_map_3(logi);





loca = loca(logi);

% net_down_sample_l= accumarray(loca,net_down_sample_l,size(ROI_table.id));
% net_down_sample_r_l= accumarray(loca,net_down_sample_r_l,size(ROI_table.id));
% net_down_sample_r2_l= accumarray(loca,net_down_sample_r2_l,size(ROI_table.id));
% net_down_sample_r4_l= accumarray(loca,net_down_sample_r4_l,size(ROI_table.id));
nnd_distance_map_3= accumarray(loca,nnd_distance_map_3,size(ROI_table.id));




[logi,loca] = ismember(atlas_map,ROI_table.id);

loca = loca(logi);

total_volume= accumarray(loca,1,size(ROI_table.id));

clear total_volume_fin;


for NNN = 1:length(ROI_table.idx)

%     net_down_sample_l_fin(NNN) = sum(net_down_sample_l(list_of_all_ROI_inside{NNN}));
%     net_down_sample_r_l_fin(NNN) = sum(net_down_sample_r_l(list_of_all_ROI_inside{NNN}));
%     net_down_sample_r2_l_fin(NNN) = sum(net_down_sample_r2_l(list_of_all_ROI_inside{NNN}));
%     net_down_sample_r4_l_fin(NNN) = sum(net_down_sample_r4_l(list_of_all_ROI_inside{NNN}));
    nnd_distance_map_3(NNN) = sum(nnd_distance_map_3(list_of_all_ROI_inside{NNN}));
    total_volume_fin(NNN) = sum(total_volume(list_of_all_ROI_inside{NNN}));

end


total_volume_fin = total_volume_fin';

% net_down_sample_l_v_fin = net_down_sample_l_fin./total_volume_fin;
% net_down_sample_r_l_fin = net_down_sample_r_l_fin./net_down_sample_l_fin;
% net_down_sample_r2_l_fin = net_down_sample_r2_l_fin./total_volume_fin;
% net_down_sample_r4_l_fin = net_down_sample_r4_l_fin./total_volume_fin;

nnd_distance_map_3 = nnd_distance_map_3./total_volume_fin;






%net_down_sample_l_fin = net_down_sample_l_fin'./2./1000000;

%length_density = net_down_sample_l_fin./total_volume_fin;


finnal_table = cell2table([num2cell(ROI_table.id), ...
                        ROI_table.name, ...
                        ROI_table.acronym, ...
                        num2cell(nnd_distance_map_3)]);

finnal_table.Properties.VariableNames = {'ROI_id', ...
                                    'ROI_name', ...
                                    'ROI_accronym', ...
                                    'nnd_um'};

% finnal_table = cell2table([num2cell(ROI_table.id), ROI_table.name, ROI_table.acronym, num2cell(ROI_table.structure_order ), num2cell(net_down_sample_r_l_fin'), num2cell(net_down_sample_r2_l_fin'), num2cell(net_down_sample_r4_l_fin')]);                    
% finnal_table.Properties.VariableNames = {'ROI_id', 'ROI_name', 'ROI_accronym', 'Structure_order', 'rl_l_um', 'r2l_l_um2', 'r4l_l_um4'};
                                
                                
finnal_table_file = [fol_name, '_nnd_analysis.csv'];
delete(finnal_table_file);
writetable(finnal_table, finnal_table_file, 'writevariablenames',1);






