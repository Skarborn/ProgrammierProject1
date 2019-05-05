% vorher test_map ausfuehren
x_width = 755;
y_width = 652;
metersPerDeg = 9e6;

long_width = longitudinal_max-longitudinal_min;
lat_width = lateral_max-lateral_min;

degProPix_lat = lat_width/y_width;
degProPix_lon = long_width/x_width;

% x und y vektoren in grad
x = longitudinal_min : degProPix_lon : longitudinal_max;
y = lateral_max : -degProPix_lat : lateral_min;

% meshgrid erstellen
[X,Y] = meshgrid(x,y);

% Formel zur Intesitaetsabnahme anwenden
P = 10; % Leistung

F = zeros(length(y),length(x));

for kk = 1:length(x_ol)
    F = F + P./(4*pi*((metersPerDeg*(X-x_ol(kk))).^2+(metersPerDeg*(Y-y_ol(kk))).^2));
end

% Limittiereung auf 
F(F>10)=10;
fig = figure();
ax = axes(fig);
im = imagesc(ax,10*log10(F/1e-12));
colorbar
im.AlphaData = 1;
