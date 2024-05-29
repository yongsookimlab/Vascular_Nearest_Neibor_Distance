function nnd_distance_map_2 = nnd_distance_map(skeleton_data, radii_data,target_resolution, atlas_resoultion, atlas_size)

asd = ones(atlas_size);

asd_x = asd .* [1:1:atlas_size(1)]'.* atlas_resoultion;
asd_y = asd .* [1:1:atlas_size(2)].* atlas_resoultion;
asd_z = asd .* permute([1:1:atlas_size(3)], [1,3,2]).* atlas_resoultion;


nnd_distance_map_2 = {};

jj = 5;
% tic
for ii = 1:atlas_size(1)
% for ii = 500
    flag_xx = (skeleton_data(:,1)> asd_x(ii,1,1)-jj.*atlas_resoultion )&(skeleton_data(:,1)< asd_x(ii,1,1)+jj.*atlas_resoultion );
    skeleton_data_xx = skeleton_data(flag_xx,:);
    radii_data_xxx = radii_data(flag_xx,:);
    
    nnd_distance_map_t = {};
    
    for ll = 1:atlas_size(2)
        
        
        flag_yy = (skeleton_data_xx(:,2)> asd_y(1,ll,1)-jj.*atlas_resoultion )&(skeleton_data_xx(:,2)< asd_y(1,ll,1)+jj.*atlas_resoultion );
        
        
        skeleton_data_xx_yy = skeleton_data_xx(flag_yy,:);
        radii_data_xxx_yyy = radii_data_xxx(flag_yy,:);
        
        nnd_distance_map_tt = ones([1, 1 , atlas_size(3)] ).* jj.*atlas_resoultion;
        
        %         for mm = 1:atlas_size(3)
        for  oo = 1:ceil(atlas_size(3)./20)
            mm2 = (oo-1).*20 +1;
            mm3 = (oo-1).*20 +20;
            if mm3>atlas_size(3)
                mm3 = atlas_size(3);
            end
            flagg_zz1 = (skeleton_data_xx_yy(:,3)> asd_z(1,1,mm2)-jj.*atlas_resoultion );
            flagg_zz2 = (skeleton_data_xx_yy(:,3)< asd_z(1,1,mm3)+jj.*atlas_resoultion );
            skeleton_data_xyz = skeleton_data_xx_yy(flagg_zz1&flagg_zz2,:);
            radii_data_xyz = radii_data_xxx_yyy(flagg_zz1&flagg_zz2,:);
            
            for nn = 1:20
                mm = (oo-1).*20 + nn;
                
                
                
                if ((~isempty(skeleton_data_xyz)) & mm<=atlas_size(3))
                    
                    flagg_zz1 = (skeleton_data_xyz(:,3)> asd_z(1,1,mm)-jj.*atlas_resoultion );
                    flagg_zz2 = (skeleton_data_xyz(:,3)< asd_z(1,1,mm)+jj.*atlas_resoultion );
                    
                    
                    skeleton_data_crop = skeleton_data_xyz(flagg_zz1&flagg_zz2,:);
                    radii_data_crop = radii_data_xyz(flagg_zz1&flagg_zz2,:);
                    
                    
                    
                    asdasd = ceil(atlas_resoultion./target_resolution);
                    distance_map_c = ones([asdasd,asdasd,asdasd]).* jj.*atlas_resoultion;
                    
                    if ~isempty(skeleton_data_crop)
                        
                        for kk = 1:length(distance_map_c(:))
                            
                            [sub_x, sub_y, subz] = ind2sub(size(distance_map_c),kk);
                            
                            sub_x = asd_x(ii,ll,mm) + sub_x.* (atlas_resoultion./asdasd) - 0.5.*atlas_resoultion;
                            sub_y = asd_y(ii,ll,mm) + sub_y.* (atlas_resoultion./asdasd) - 0.5.*atlas_resoultion;
                            subz = asd_z(ii,ll,mm) + subz.* (atlas_resoultion./asdasd) - 0.5.*atlas_resoultion;
                            
                            dis__tt = (skeleton_data_crop - [sub_x, sub_y ,subz]).*(skeleton_data_crop - [sub_x, sub_y ,subz]);
                            dis__tt = sqrt(sum(dis__tt,2)) - radii_data_crop;
                            
                            distance_map_c(kk) = min(dis__tt);
                            
                        end
                        
                    end
                    
                    nnd_distance_map_tt(1,1,mm) = mean(distance_map_c(:));
                    
                    
                end
                
            end
        end
        
        
        nnd_distance_map_t{1,ll,1} = nnd_distance_map_tt;
        
    end
    
    
    nnd_distance_map_t = cell2mat(nnd_distance_map_t);
    nnd_distance_map_2{ii,1,1} = nnd_distance_map_t;
end

nnd_distance_map_2 = cell2mat(nnd_distance_map_2);

% toc
% nnd_distance_map_2 = permute(nnd_distance_map_2,[2 3 1]);
% imshow(nnd_distance_map_2/100);







