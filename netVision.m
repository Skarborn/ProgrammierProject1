classdef netVision < handle
    properties
        fig
        uifig
        ax
        
        dataBase
        
        myMap
        dotMap
        heatMap
        
        guiElements
    end
    methods
        function obj = netVision()
            % read in celldata
            obj.dataBase = load("celldata.mat");
            
            % generate figure and grid used for GUI
            obj.uifig = uifigure("Name","netVision");
            obj.uifig.Position = [0 100 1000 800];
            grid = uigridlayout(obj.uifig, [16, 20]);
            
            % generate axes handle and map
            %obj.fig = figure();
            %obj.fig.Position = [700 100 700 700];
            obj.ax = uiaxes(grid);
            obj.ax.Layout.Row = [1 16];
            obj.ax.Layout.Column = [5 20];
            
            % generate Map of Oldenburg
            longitudinalMin = 8.18;
            longitudinalMax = 8.28;
            lateralMin = 53.11;
            lateralMax = 53.18;
            
            initialCoords = struct(...
                "minLon", longitudinalMin, ...
                "maxLon", longitudinalMax, ...
                "minLat", lateralMin, ...
                "maxLat", lateralMax);
            
            obj.myMap = Map(initialCoords,'hot',obj.ax,-2);
            %hold on
            
            % GENERATE GUI ELEMENTS
            
            % edit fields for entering coordinates

            guiElements = struct();
            
            
            % EDIT FIELDS
            obj.guiElements.editLongMin = uieditfield(grid,"numeric");
            obj.guiElements.editLongMin.Limits = [0 360];
            obj.guiElements.editLongMin.Value = longitudinalMin;
            obj.guiElements.editLongMin.Layout.Row = 1;
            obj.guiElements.editLongMin.Layout.Column = 1;
            obj.guiElements.editLongMin.Tooltip = "min longitudinal";
            
            obj.guiElements.editLongMax = uieditfield(grid,"numeric");
            obj.guiElements.editLongMax.Limits = [0 360];
            obj.guiElements.editLongMax.Value = longitudinalMax;
            obj.guiElements.editLongMax.Layout.Row = 1;
            obj.guiElements.editLongMax.Layout.Column = 2;
            obj.guiElements.editLongMax.Tooltip = "max longitudinal";
            
            obj.guiElements.editLatMin = uieditfield(grid,"numeric");
            obj.guiElements.editLatMin.Limits = [0 360];
            obj.guiElements.editLatMin.Value = lateralMin;
            obj.guiElements.editLatMin.Layout.Row = 2;
            obj.guiElements.editLatMin.Layout.Column = 1;
            obj.guiElements.editLatMin.Tooltip = "min lateral";
            
            obj.guiElements.editLatMax = uieditfield(grid,"numeric");
            obj.guiElements.editLatMax.Limits = [0 360];
            obj.guiElements.editLatMax.Value = lateralMax;
            obj.guiElements.editLatMax.Layout.Row = 2;
            obj.guiElements.editLatMax.Layout.Column = 2;
            obj.guiElements.editLatMax.Tooltip = "max lateral";
            
            % CHECKBOXES
            obj.guiElements.checkboxDots = uicheckbox(grid);
            obj.guiElements.checkboxDots.Text = "Punkte";
            obj.guiElements.checkboxDots.Value = 0;
            obj.guiElements.checkboxDots.Layout.Row = 5;
            obj.guiElements.checkboxDots.Layout.Column = [1 2];
            
            obj.guiElements.checkboxHeatmap = uicheckbox(grid);
            obj.guiElements.checkboxHeatmap.Text = "Heatmap";
            obj.guiElements.checkboxHeatmap.Value = 0;
            obj.guiElements.checkboxHeatmap.Layout.Row = 6;
            obj.guiElements.checkboxHeatmap.Layout.Column = [1 2];
            
            % BUTTONS
            applyChanges = uibutton(grid);
            applyChanges.Text = "Apply Changes";
            applyChanges.Layout.Row = 8;
            applyChanges.Layout.Column = [1 2];
            applyChanges.ButtonPushedFcn = @obj.apply;
            
        end
        
        function apply(obj, source, ~)
            % Button "Apply Changes" causes update of axis
            if (source.Text == "Apply Changes")
                obj.myMap.coords = struct(...
                    "minLon", obj.guiElements.editLongMin.Value, ...
                    "maxLon", obj.guiElements.editLongMax.Value, ...
                    "minLat", obj.guiElements.editLatMin.Value, ...
                    "maxLat", obj.guiElements.editLatMax.Value);
            end
            
            % if checkbox is ticked, plot dots, otherwise delete dots
            if obj.guiElements.checkboxDots.Value == true
                obj.drawDots()
            else
                obj.dotMap.XData = [];
                obj.dotMap.YData = [];
            end
            
            % if checkbox is ticked, plot heatmap
            if obj.guiElements.checkboxHeatmap.Value == true
                obj.heatMap.AlphaData = 0;
                obj.drawHeatmap()
            else
                obj.heatMap.AlphaData = 0;
            end
            
        end
        
        function drawDots(obj)
            
            % generate logical vector for filtering purposes
            relevantCoords = ...
                obj.guiElements.editLongMin.Value <= obj.dataBase.celldata.lon &...
                obj.guiElements.editLongMax.Value >= obj.dataBase.celldata.lon & ...
                obj.guiElements.editLatMin.Value <= obj.dataBase.celldata.lat &...
                obj.guiElements.editLatMax.Value >= obj.dataBase.celldata.lat ;
            
            % combine logical vectors for filtering purposes
            relevantData =  relevantCoords;
            
            % generate current vectors
            lonCurrent = obj.dataBase.celldata.lon(relevantData);
            latCurrent = obj.dataBase.celldata.lat(relevantData);
            
            obj.dotMap = plot(obj.ax,lonCurrent,latCurrent,...
                'r.','MarkerSize',18);
        end
        
        function drawHeatmap(obj)
            
            % generate logical vector for filtering purposes
            relevantCoords = ...
                obj.guiElements.editLongMin.Value <= obj.dataBase.celldata.lon &...
                obj.guiElements.editLongMax.Value >= obj.dataBase.celldata.lon & ...
                obj.guiElements.editLatMin.Value <= obj.dataBase.celldata.lat &...
                obj.guiElements.editLatMax.Value >= obj.dataBase.celldata.lat ;
            relevantNetwork = (obj.dataBase.celldata.network=='LTE');
            relevantNetworkCode = (obj.dataBase.celldata.networkCode == 1);
            
            
            % combine logical vectors for filtering purposes
            relevantData =  relevantCoords & relevantNetwork & relevantNetworkCode;
            
            % generate current vectors
            lonCurrent = obj.dataBase.celldata.lon(relevantData);
            latCurrent = obj.dataBase.celldata.lat(relevantData);
            
            xPixelWidth = obj.ax.Position(3);
            yPixelWidth = obj.ax.Position(4);
            
            % width of current axis in degree
            long_width = obj.guiElements.editLongMax.Value -...
                obj.guiElements.editLongMin.Value;
            lat_width = obj.guiElements.editLatMax.Value -...
                obj.guiElements.editLatMin.Value;
            
            % width of pixel in degree
            degProPixLon = long_width/xPixelWidth;
            degProPixLat = lat_width/yPixelWidth;
            
            % x und y vektoren in grad-abstaenden
            x = obj.guiElements.editLongMin.Value :...
                degProPixLon : obj.guiElements.editLongMax.Value;
            y = obj.guiElements.editLatMax.Value :...
                -degProPixLat : obj.guiElements.editLatMin.Value;
            
            % generate meshgrid
            [X,Y] = meshgrid(x,y);
            
            % P is the estimated power of average transmitter tower.
            % source: https://www.emf.ethz.ch/de/emf-info/themen/
            % technik/basisstationsantennen/
            % sendestaerke-von-basisstationen/
            P = 7;
            
            % determine limit for intensity, since values close to
            % transmitter tower will go up to infinity
            intensityLimit = 1e-5;
            
            % converting degree to meters applying to following source:
            % http://www.iaktueller.de/exx.php
            metersPerDegLong = 71.44e3;
            metersPerDegLat = 111.13e3;
            
            % matrix that will contain intensity values
            F = zeros(length(y),length(x));
            
            for kk = 1:length(lonCurrent)
                % Intensitaetsabfall fuer einen Punkt auf der Map
                A = P./(4*pi*((metersPerDegLong*(X-lonCurrent(kk))).^2+...
                    (metersPerDegLat*(Y-latCurrent(kk))).^2));
                
                % Limittieren, da Intensitaet nahe Masten extrem hoch, wodurch die
                % heatmap-rabge zu gross wird
                A(A>intensityLimit)=intensityLimit;
                
                % Addieren aller Sendemasten
                F = F + A;
            end

            obj.heatMap = image(obj.ax,x,y,10*log10(F/1e-12));
            colormap jet
            obj.heatMap.AlphaData = 0.3;
            obj.heatMap.CDataMapping = 'scaled';
            
        end
        
    end
end