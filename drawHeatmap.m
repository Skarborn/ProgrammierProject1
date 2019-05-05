% Oldenburg coords
longitudinal_min = 0;
longitudinal_max = 100;
lateral_min = 0;
lateral_max = 100;
stepWidth = 0.01; % im spaeteren programm abhaengig von zoomLevel

% x und y vektoren in grad
x = longitudinal_min : stepWidth : longitudinal_max;
y = lateral_min : stepWidth : lateral_max;

% meshgrid erstellen
[X,Y] = meshgrid(x,y);

% Formel zur Intesitaetsabnahme anwenden
P = 10; % Leistung

points = [100*rand(1,20) ; 100*rand(1,20)];
F = zeros(length(y),length(x));

for kk = 1:length(points)
    F = F + P./(4*pi*(((X-points(1,kk))).^2+((Y-points(2,kk))).^2));
end

% Limittiereung auf 
F(F>10)=10;
ax = axes;
im = imagesc(ax,10*log10(F/1e-12));
colorbar
im.AlphaData = 0.3;
