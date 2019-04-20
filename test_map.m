%% rumprobieren
% Karte mit Sendemasten finden und gucken, wie man diese bestimmen kann!

% Daten einlesen mit selben Namen wie in table, damit verstaendlich
load('celldata.mat')
lon = celldata.lon;
lat = celldata.lat;
created = celldata.created;
updated = celldata.updated;
network = celldata.network;
countryCode = celldata.countryCode;
networkCode = celldata.networkCode;
areaCode = celldata.areaCode;
cellCode = celldata.cellCode;
distanceInM = celldata.distanceInM;

% Suchkriterien (logcal vectors, die anschliessend eingesetzt werden)

% Oldenburg coords
longitudinal_min = 8.18;
longitudinal_max = 8.28;
lateral_min = 53.11;
lateral_max = 53.18;

criteria_network = input('Netz eingeben (GSM, UMTS, LTE): ');
criteria_networkCode = input(...
['Netzwerkcode eingeben (1 -> Telekom, 2 -> Vodafone, ',...
'3 -> E-Plus, 7 -> Telefonica): ']);


% Nach Suchkriterien relevante Daten
relevant_coords = longitudinal_min <= lon & longitudinal_max >= lon & ...
                lateral_min <= lat & lateral_max >= lat ;
relevant_network = (network==criteria_network);
relevant_networkCode = (networkCode == criteria_networkCode);
relevant_data =  relevant_coords &...
                relevant_networkCode &...
                relevant_network;

% Alle Punkte, die in Oldenburg liegen herausfiltern
x_ol = lon(relevant_data);
y_ol = lat(relevant_data);
dist_ol = distanceInM(relevant_data);

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

% Fenster zum Plotten anlegen
window = figure('Name','Fenster');
axes_ding = axes(window);

% map anlegen und plotten
my_map = Map(my_coords,'osm',axes_ding);
hold on
plot(x_ol_nah,y_ol_nah,'b.',x_ol_fern,y_ol_fern,'c.')
title(['Suchkriterien: Netzwerk: ',criteria_network,...
    ', Netzwerkcode: ',num2str(criteria_networkCode)])