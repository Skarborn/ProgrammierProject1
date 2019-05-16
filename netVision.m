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
            
            % DROPDOWNS
            obj.guiElements.dropdownNetwork = uidropdown(grid);
            obj.guiElements.dropdownNetwork.Items = {'GSM','UMTS','LTE'};
            obj.guiElements.dropdownNetwork.Value = 'GSM';
            obj.guiElements.dropdownNetwork.Layout.Row = 10;
            obj.guiElements.dropdownNetwork.Layout.Column = [1 2];
            
            obj.guiElements.dropdownNetworkCode = uidropdown(grid);
            obj.guiElements.dropdownNetworkCode.Items =...
                {'Telekom','Vodafone','EPlus','Telefonica'};
            obj.guiElements.dropdownNetworkCode.Value = 'Telekom';
            obj.guiElements.dropdownNetworkCode.Layout.Row = 11;
            obj.guiElements.dropdownNetworkCode.Layout.Column = [1 2];
            
            % BUTTONS
            applyChanges = uibutton(grid);
            applyChanges.Text = "Apply Changes";
            applyChanges.Layout.Row = [14 15];
            applyChanges.Layout.Column = [1 4];
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
            
            % delete current overlays
            obj.dotMap.XData = [];
            obj.dotMap.YData = [];
            obj.heatMap.AlphaData = 0;
            
            % if checkbox is ticked, plot dots
            if obj.guiElements.checkboxDots.Value == true
                obj.drawDots()
            end
            
            % if checkbox is ticked, plot heatmap
            if obj.guiElements.checkboxHeatmap.Value == true                
                obj.drawHeatmap()
            end
            
        end
        
        function relevantData = getRelevantData(obj)
            % generate logical vector for filtering purposes
            networkProvider = struct('Telekom',1,'Vodafone',2,...
                'EPlus',3,'Telefonica',7);
            
            relevantCoords = ...
                obj.guiElements.editLongMin.Value <= obj.dataBase.celldata.lon &...
                obj.guiElements.editLongMax.Value >= obj.dataBase.celldata.lon & ...
                obj.guiElements.editLatMin.Value <= obj.dataBase.celldata.lat &...
                obj.guiElements.editLatMax.Value >= obj.dataBase.celldata.lat ;
            relevantNetwork = (obj.dataBase.celldata.network==...
                obj.guiElements.dropdownNetwork.Value);
            relevantNetworkCode = (obj.dataBase.celldata.networkCode ==...
                networkProvider.(obj.guiElements.dropdownNetworkCode.Value));
            
            
            % combine logical vectors for filtering purposes
            relevantData =  relevantCoords & relevantNetwork & relevantNetworkCode;

        end
        
        function drawDots(obj)
            
            % generate current vectors
            
            
            lonCurrent = obj.dataBase.celldata.lon(obj.getRelevantData());
            latCurrent = obj.dataBase.celldata.lat(obj.getRelevantData());
            networkCurrent = ...
                obj.dataBase.celldata.networkCode(obj.getRelevantData());
            if networkCurrent == 1
                obj.dotMap = plot(obj.ax,lonCurrent,latCurrent,...
                    'm.','MarkerSize',15);
            
            elseif networkCurrent == 2
                obj.dotMap = plot(obj.ax,lonCurrent,latCurrent,...
                    'r.','MarkerSize', 15);
            
            elseif networkCurrent == 3
                obj.dotMap = plot(obj.ax,lonCurrent,latCurrent,...
                    '.', 'Color', [0, 0.5, 0],'MarkerSize', 15);
            
            elseif networkCurrent == 7
                obj.dotMap = plot(obj.ax,lonCurrent,latCurrent,...
                    'b.','MarkerSize', 15);
                
            else
                obj.dotMap = plot(obj.ax,lonCurrent,latCurrent,...
                    'k.','MarkerSize', 15);
            end
        end
        
        function drawHeatmap(obj)
            
            % generate current vectors
            lonCurrent = obj.dataBase.celldata.lon(obj.getRelevantData());
            latCurrent = obj.dataBase.celldata.lat(obj.getRelevantData());
            
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