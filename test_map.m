% Dieses Skript dient dazu, die Map-Klasse und das celldata auszuprobieren,
% um zu gucken, wie man die beiden Elemente verbinden kann. Also fuehlt
% euch frei, etwas zu ergaenzen und kommentiert genau, welchen Zweck ihr
% verfolgt. Ganz unten kann man dann generelle Anmerkungen, Erkenntnisse
% oder Sonstiges schreiben :)

%% Vorgehensweise
% Die Tabelle "celldata.mat" wird in 1) eingelesen und alle Spalten als Vektor
% eingespeichert. Anschliessen wird in 2) festgelegt,nach welchen Kriterien
% wir suchen (Koordinaten, Netzanbieter, ...). Diese Bedingungen werden im
% Anschluss in 3) genutzt, um die relevanten x- und y-Werte
% herauszufiltern. Zudem werden die Koordinaten im Anschluss aufgeteilt, so
% dass Punkte, die nahe am Funkmast sind von fernen getrennt werden. Es
% folgt die E2rstellung der Axes-Handle, der Map und ein Plot.

%% 1) Daten einlesen mit selben Namen wie in table, damit verstaendlich
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

%% 2) Suchkriterien (logcal vectors, die anschliessend eingesetzt werden)

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

% Kombiniere alle Kriterien
relevant_data =  relevant_coords &...
                relevant_networkCode &...
                relevant_network;

%% 3) Alle Punkte, die in Oldenburg liegen herausfiltern
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

%% Map und alle Punkte zeichnen (rot: <=1000m; blau: >1000m)

% Fenster zum Plotten anlegen
window = figure('Name','Fenster');
axes_handle = axes(window);

% figure (Karte vergroessert)
set(gcf,'position',[100 100 1000 800]);
% map anlegen und plotten
my_map = Map(my_coords,'osm',axes_handle);
hold on
plot(x_ol_nah,y_ol_nah,'r.',x_ol_fern,y_ol_fern,'b.')
title(['Suchkriterien: Netzwerk: ',criteria_network,...
    ', Netzwerkcode: ',num2str(criteria_networkCode)])

%% Kommentare und Anmerkungen

%% Aufbau eines zukuenftigen Programms
% Wenn wir das eigentliche Programm schreiben wollen, sollten wir die Werte
% aus den Tabellen nach bestimmten Kriterien filtern, da die Punkte
% ansonsten sehr willkuerlich und nichtssagend sind. Bislang wird in diesem
% Programm nur nach network und networkCode gefiltert. Am besten waere eine
% GUI in der man diese Angaben machen kann, woraufhin die gewuenschten
% Punkte eingezeichnet werden

%% created/updated
% datetime-Objekte. Man koennte Daten nach dem Datum sortieren. Hilft beim
% erstellen des Grundprogramms eher weniger.

%% network
% Art des Netzwerks. Notwendiges Filter-Kriterium

%% countryCode
% Unnoetig, denn alle Punkte liegen in Deutschland.

%% networkCode
% Laesst auf den Netzanbieter schliessen. 1=Telekom, 2=Vodafone, ...
% Gutes Filter-Kriterium.

%% areaCode
% Der areaCode ist fuer jeden Netzanbieter unterschiedlich. Bei allen
% scheint jedoch der areaCode fuer alle hier behandelten Koordinaten gleich
% zu sein.

%% cellCode
% Beim cellCode scheint es sich um einen individuellen Code fuer jedes
% Handy zu handeln. Wird in erster Linie nicht so nuetzlich fuer uns sein,
% aber vielleicht kann man das spaeter bei den Extrafunktionen gebrauchen.

%% distance
% Die Distanzwerte sind ein wenig komisch: alles ueber 1 km wird auf den
% Meter genau angegeben, unter 1 km wird aber wohl aufgerundet, da 1000 m
% der Mindestwert ist. Da muessen wir mal gucken, wie wir damit die
% Position der Sendemasten finden wollen.