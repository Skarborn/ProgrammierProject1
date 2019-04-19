% Karte mit Sendemasten finden und gucken, wie man diese bestimmen kann!

load('celldata.mat')
x = celldata.lon;
y = celldata.lat;
dist = celldata.distanceInM;

window = figure('Name','Fenster');
axes_ding = axes(window);

% Oldenburg coords
longitudinal_min = 8.18;
longitudinal_max = 8.28;
lateral_min = 53.11;
lateral_max = 53.18;

% Alle Punkte, die in Oldenburg liegen herausfiltern
x_ol = x(       longitudinal_min <= x & longitudinal_max >= x & ...
                lateral_min <= y & lateral_max >= y );
y_ol = y(       longitudinal_min <= x & longitudinal_max >= x & ...
                lateral_min <= y & lateral_max >= y );
dist_ol = dist( longitudinal_min <= x & longitudinal_max >= x & ...
                lateral_min <= y & lateral_max >= y );

x_ol_nah = x_ol(dist_ol<=1000);
x_ol_fern = x_ol(dist_ol>1000);
y_ol_nah = y_ol(dist_ol<=1000);
y_ol_fern = y_ol(dist_ol>1000);

my_coords = struct(...
                    "minLon", longitudinal_min, ...
                    "maxLon", longitudinal_max, ...
                    "minLat", lateral_min, ...
                    "maxLat", lateral_max);

%% Map und alle Punkte zeichnen (blau: <=1000m; rot: >1000m)
my_map = Map(my_coords,'osm',axes_ding);
hold on
plot(x_ol_nah,y_ol_nah,'b.',x_ol_fern,y_ol_fern,'c.')