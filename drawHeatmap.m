% vorher test_map ausfuehren

% groesse der axes in Pixel
xPixelWidth = 755;
yPixelWidth = 652;

% Umrechenfaktoren von Grad in Meter
metersPerDegLong = 71.44e3;
metersPerDegLat = 111.13e3;
intensityLimit = 1e-5;

% Groesse der Axes in Grad
long_width = longitudinal_max-longitudinal_min;
lat_width = lateral_max-lateral_min;

% Groesse eines Pixels in Grad
degProPix_lat = lat_width/yPixelWidth;
degProPix_lon = long_width/xPixelWidth;

% x und y vektoren in grad-abstaenden
x = longitudinal_min : degProPix_lon : longitudinal_max;
y = lateral_max : -degProPix_lat : lateral_min;

% meshgrid erstellen
[X,Y] = meshgrid(x,y);

% Formel zur Intesitaetsabnahme anwenden
P = 7; % Leistung

F = zeros(length(y),length(x));


for kk = 1:length(x_ol)
    % Intensitaetsabfall fuer einen Punkt auf der Map
    A = P./(4*pi*((metersPerDegLong*(X-x_ol(kk))).^2+...
        (metersPerDegLat*(Y-y_ol(kk))).^2));
    
    % Limittieren, da Intensitaet nahe Masten extrem hoch, wodurch die
    % heatmap-rabge zu gross wird
    A(A>intensityLimit)=intensityLimit;
    
    % Addieren aller Sendemasten
    F = F + A;
end

% Limittiereung auf 
hold on
%im = imagesc(ax,10*log10(F/1e-12));
im = image('XData',x,'YData',y,'CData',10*log10(F/1e-12));
colormap jet
im.AlphaData = 0.4;
im.CDataMapping = 'scaled';