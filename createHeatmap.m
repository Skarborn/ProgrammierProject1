x_width = 755;
y_width = 652;
P = 10;
heatMap = zeros(755,652);

longitudinal_min = 8.18;
longitudinal_max = 8.28;
lateral_min = 53.11;
lateral_max = 53.18;

long_width = longitudinal_max-longitudinal_min;
lat_width = lateral_max-lateral_min;

degProPix_lat = lat_width/y_width;
degProPix_lon = long_width/x_width;

xidx = floor((x_ol-longitudinal_min)/degProPix_lon)+1;
yidx = floor((y_ol-lateral_min)/degProPix_lat)+1;

for kk = 0:y_width-1
    for ll = 0:x_width-1
        isInTile=(x_ol > longitudinal_min + kk*degProPix_lon & ...
        x_ol < longitudinal_min + (kk+1)*degProPix_lon & ...
        y_ol < lateral_max - ll*degProPix_lat & ...
        y_ol > lateral_max - (ll+1)*degProPix_lat);
    intensity = P*sum(isInTile);    
    heatMap(kk+1,ll+1) = intensity;
    end
end

heatMap(heatMap == 0) = NaN;
contourf(heatMap)
