window = figure('Name','Fenster');
axes_ding = axes(window);
set(gcf,'position',[100 100 1000 800]);

% Oldenburg coords
longitudinal_min = 8.18;
longitudinal_max = 8.28;
lateral_min = 53.11;
lateral_max = 53.18;

my_coords = struct(...
                    "minLon", longitudinal_min, ...
                    "maxLon", longitudinal_max, ...
                    "minLat", lateral_min, ...
                    "maxLat", lateral_max);

my_map = Map(my_coords,'osm',axes_ding);