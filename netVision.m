classdef netVision < handle
    properties
        fig
        uifig
        ax
        
        dataBase
        
        myMap
        heatMap
        
        dotMapTelekom
        dotMapVodafone
        dotMapEPlus
        dotMapTelefonica
        dotMapElse
        
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
            text_lonCoord = 'Longitudinal Koordinaten:';
            label_lonCoord = uilabel(obj.uifig,'Text',...
                text_lonCoord,'Position',[12 720 150 50]);
            
            % NAMES FOR CONTROL ELEMENTS
            obj.guiElements.label_lonCoord = uilabel(grid);
            obj.guiElements.label_lonCoord.Text = ...
                'Longitudinal Koordinaten: ';
            obj.guiElements.label_lonCoord.Layout.Row = 1;
            obj.guiElements.label_lonCoord.Layout.Column = [1 4];
            
            obj.guiElements.label_lonCoord = uilabel(grid);
            obj.guiElements.label_lonCoord.Text = ...
                'Lateral Koordinaten: ';
            obj.guiElements.label_lonCoord.Layout.Row = 3;
            obj.guiElements.label_lonCoord.Layout.Column = [1 4];
            
            obj.guiElements.label_lonCoord = uilabel(grid);
            obj.guiElements.label_lonCoord.Text = ...
                'Anzeigeoptionen: ';
            obj.guiElements.label_lonCoord.Layout.Row = 5;
            obj.guiElements.label_lonCoord.Layout.Column = [1 4];
            
            obj.guiElements.label_lonCoord = uilabel(grid);
            obj.guiElements.label_lonCoord.Text = ...
                'Karten Typ: ';
            obj.guiElements.label_lonCoord.Layout.Row = 6;
            obj.guiElements.label_lonCoord.Layout.Column = [3 4];
            
            obj.guiElements.label_lonCoord = uilabel(grid);
            obj.guiElements.label_lonCoord.Text = ...
                'Netzwerkanbieter: ';
            obj.guiElements.label_lonCoord.Layout.Row = 8;
            obj.guiElements.label_lonCoord.Layout.Column = [1 4];
            
            obj.guiElements.label_lonCoord = uilabel(grid);
            obj.guiElements.label_lonCoord.Text = ...
                'Netzwerkart: ';
            obj.guiElements.label_lonCoord.Layout.Row = 12;
            obj.guiElements.label_lonCoord.Layout.Column = [1 4];
            
            obj.guiElements.label_lonCoord = uilabel(grid);
            obj.guiElements.label_lonCoord.Text = ...
                'Deckkraft der Heatmap: ';
            obj.guiElements.label_lonCoord.Layout.Row = 14;
            obj.guiElements.label_lonCoord.Layout.Column = [1 4];
            
            
            % EDIT COORDS
            obj.guiElements.editLongMin = uieditfield(grid,"numeric");
            obj.guiElements.editLongMin.Limits = [0 360];
            obj.guiElements.editLongMin.Value = longitudinalMin;
            obj.guiElements.editLongMin.Layout.Row = 2;
            obj.guiElements.editLongMin.Layout.Column = 1;
            obj.guiElements.editLongMin.Tooltip = "min longitudinal";
            
            obj.guiElements.editLongMax = uieditfield(grid,"numeric");
            obj.guiElements.editLongMax.Limits = [0 360];
            obj.guiElements.editLongMax.Value = longitudinalMax;
            obj.guiElements.editLongMax.Layout.Row = 2;
            obj.guiElements.editLongMax.Layout.Column = 2;
            obj.guiElements.editLongMax.Tooltip = "max longitudinal";           
            
            obj.guiElements.editLatMin = uieditfield(grid,"numeric");
            obj.guiElements.editLatMin.Limits = [0 360];
            obj.guiElements.editLatMin.Value = lateralMin;
            obj.guiElements.editLatMin.Layout.Row = 4;
            obj.guiElements.editLatMin.Layout.Column = 1;
            obj.guiElements.editLatMin.Tooltip = "min lateral";
            
            obj.guiElements.editLatMax = uieditfield(grid,"numeric");
            obj.guiElements.editLatMax.Limits = [0 360];
            obj.guiElements.editLatMax.Value = lateralMax;
            obj.guiElements.editLatMax.Layout.Row = 4;
            obj.guiElements.editLatMax.Layout.Column = 2;
            obj.guiElements.editLatMax.Tooltip = "max lateral";
            
            % CHECKBOXES 
                        
            obj.guiElements.checkboxDots = uicheckbox(grid);
            obj.guiElements.checkboxDots.Text = "Funktürme";
            obj.guiElements.checkboxDots.Value = 0;
            obj.guiElements.checkboxDots.Layout.Row = 6;
            obj.guiElements.checkboxDots.Layout.Column = [1 2];
            
            obj.guiElements.checkboxHeatmap = uicheckbox(grid);
            obj.guiElements.checkboxHeatmap.Text = "Heatmap";
            obj.guiElements.checkboxHeatmap.Value = 0;
            obj.guiElements.checkboxHeatmap.Layout.Row = 7;
            obj.guiElements.checkboxHeatmap.Layout.Column = [1 2];
            
            % NETWORK CODES
            obj.guiElements.checkboxTelekom = uicheckbox(grid);
            obj.guiElements.checkboxTelekom.Text = "Telekom";
            obj.guiElements.checkboxTelekom.Value = 0;
            obj.guiElements.checkboxTelekom.Layout.Row = 9;
            obj.guiElements.checkboxTelekom.Layout.Column = [1 2];
            
            obj.guiElements.checkboxVodafone = uicheckbox(grid);
            obj.guiElements.checkboxVodafone.Text = "Vodafone";
            obj.guiElements.checkboxVodafone.Value = 0;
            obj.guiElements.checkboxVodafone.Layout.Row = 9;
            obj.guiElements.checkboxVodafone.Layout.Column = [3 4];
            
            obj.guiElements.checkboxEPlus = uicheckbox(grid);
            obj.guiElements.checkboxEPlus.Text = "E-Plus";
            obj.guiElements.checkboxEPlus.Value = 0;
            obj.guiElements.checkboxEPlus.Layout.Row = 10;
            obj.guiElements.checkboxEPlus.Layout.Column = [3 4];
            
            obj.guiElements.checkboxTelefonica = uicheckbox(grid);
            obj.guiElements.checkboxTelefonica.Text = "Telefonica";
            obj.guiElements.checkboxTelefonica.Value = 0;
            obj.guiElements.checkboxTelefonica.Layout.Row = 10;
            obj.guiElements.checkboxTelefonica.Layout.Column = [1 2];
            
            obj.guiElements.checkboxElse = uicheckbox(grid);
            obj.guiElements.checkboxElse.Text = "Alle anderen Anbieter";
            obj.guiElements.checkboxElse.Value = 0;
            obj.guiElements.checkboxElse.Layout.Row = 11;
            obj.guiElements.checkboxElse.Layout.Column = [1 2];
            
            % NETWORKS
            obj.guiElements.checkboxLTE = uicheckbox(grid);
            obj.guiElements.checkboxLTE.Text = "LTE";
            obj.guiElements.checkboxLTE.Value = 0;
            obj.guiElements.checkboxLTE.Layout.Row = 13;
            obj.guiElements.checkboxLTE.Layout.Column = [1 2];
            
            obj.guiElements.checkboxGSM = uicheckbox(grid);
            obj.guiElements.checkboxGSM.Text = "GSM";
            obj.guiElements.checkboxGSM.Value = 0;
            obj.guiElements.checkboxGSM.Layout.Row = 13;
            obj.guiElements.checkboxGSM.Layout.Column = [3 4];
            
            obj.guiElements.checkboxUMTS = uicheckbox(grid);
            obj.guiElements.checkboxUMTS.Text = "UMTS";
            obj.guiElements.checkboxUMTS.Value = 0;
            obj.guiElements.checkboxUMTS.Layout.Row = 13;

            obj.guiElements.checkboxUMTS.Layout.Column = [5 6];            
            
            % SLIDER FOR HEATMAP INTENSITY
            obj.guiElements.SliderIntensity = uislider(grid);
            obj.guiElements.SliderIntensity.Limits = [0 1];
            obj.guiElements.SliderIntensity.Value = 0.3;
            obj.guiElements.SliderIntensity.Layout.Row = 15;
            obj.guiElements.SliderIntensity.Layout.Column = [1 4];
            obj.guiElements.SliderIntensity.ValueChangedFcn = ...
                @obj.setAlphaData;
            
            % DROPDOWN FOR MAP TYPE
            obj.guiElements.DropdownMapType = uidropdown(grid);
            obj.guiElements.DropdownMapType.Items = ...
                {'hot', 'osm', 'ocm', 'opm', 'landscape', 'outdoors'};
            obj.guiElements.DropdownMapType.Value = 'hot';
            obj.guiElements.DropdownMapType.ValueChangedFcn = ...
                @obj.setMapType;
            obj.guiElements.DropdownMapType.Layout.Row = 7;
            obj.guiElements.DropdownMapType.Layout.Column = [3 4];


            % BUTTONS
            applyChanges = uibutton(grid);
            applyChanges.Text = "Apply Changes";
            applyChanges.Layout.Row = [16];
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
            obj.eraseOverlays()
            
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
            relevantNetwork = zeros(length(relevantCoords),1);
            relevantNetworkType = zeros(length(relevantCoords),1);
            
            if obj.guiElements.checkboxTelekom.Value == true
                relevantNetwork = relevantNetwork |...
                    (obj.dataBase.celldata.networkCode == 1);
            end
            if obj.guiElements.checkboxVodafone.Value == true
                relevantNetwork = relevantNetwork |...
                    (obj.dataBase.celldata.networkCode == 2);
            end
            if obj.guiElements.checkboxEPlus.Value == true
                relevantNetwork = relevantNetwork | ...
                    (obj.dataBase.celldata.networkCode == 3);
            end
            if obj.guiElements.checkboxTelefonica.Value == true
                relevantNetwork = relevantNetwork |...
                    (obj.dataBase.celldata.networkCode == 7);
            end
            if obj.guiElements.checkboxElse.Value == true
                relevantNetwork = relevantNetwork |...
                    ((obj.dataBase.celldata.networkCode > 3) &...
                    (obj.dataBase.celldata.networkCode < 7) &...
                    (obj.dataBase.celldata.networkCode > 7));
            end
            
            if obj.guiElements.checkboxLTE.Value == true
                relevantNetworkType = (relevantNetworkType | ...
                    obj.dataBase.celldata.network == 'LTE');
            end
            if obj.guiElements.checkboxGSM.Value == true
                relevantNetworkType = (relevantNetworkType | ...
                    obj.dataBase.celldata.network == 'GSM');
            end
            if obj.guiElements.checkboxUMTS.Value == true
                relevantNetworkType = (relevantNetworkType | ...
                    obj.dataBase.celldata.network == 'UMTS');
            end
            
            % combine logical vectors for filtering purposes
            relevantData =  relevantCoords & relevantNetwork & relevantNetworkType;
        end
        
        function drawDots(obj)

            % generate current vectors
            if obj.guiElements.checkboxTelekom.Value == true
                obj.dotMapTelekom = plot(obj.ax,...
                    obj.dataBase.celldata.lon(obj.getRelevantData()&obj.dataBase.celldata.networkCode==1),...
                    obj.dataBase.celldata.lat(obj.getRelevantData()&obj.dataBase.celldata.networkCode==1),...
                    'm.','MarkerSize',15);
            end
                
            if obj.guiElements.checkboxVodafone.Value == true
                obj.dotMapVodafone = plot(obj.ax,...
                    obj.dataBase.celldata.lon(obj.getRelevantData()&obj.dataBase.celldata.networkCode==2),...
                    obj.dataBase.celldata.lat(obj.getRelevantData()&obj.dataBase.celldata.networkCode==2),...
                    'r.','MarkerSize', 15);
            end
                
            if obj.guiElements.checkboxEPlus.Value == true
                obj.dotMapEPlus = plot(obj.ax,...
                    obj.dataBase.celldata.lon(obj.getRelevantData()&obj.dataBase.celldata.networkCode==3),...
                    obj.dataBase.celldata.lat(obj.getRelevantData()&obj.dataBase.celldata.networkCode==3),...
                    '.', 'Color', [0, 0.5, 0],'MarkerSize', 15);
            end
                
            if obj.guiElements.checkboxTelefonica.Value == true
                obj.dotMapTelefonica = plot(obj.ax,...
                    obj.dataBase.celldata.lon(obj.getRelevantData()&obj.dataBase.celldata.networkCode==7),...
                    obj.dataBase.celldata.lat(obj.getRelevantData()&obj.dataBase.celldata.networkCode==7),...
                    'b.','MarkerSize', 15);
            end
            
            if obj.guiElements.checkboxElse.Value == true
                obj.dotMapElse = plot(obj.ax,...
                    obj.dataBase.celldata.lon((obj.guiElements.checkboxTelefonica.Value ~= 1 &...
                    obj.guiElements.checkboxTelefonica.Value ~= 2 &...
                    obj.guiElements.checkboxTelefonica.Value ~= 3 &...
                    obj.guiElements.checkboxTelefonica.Value ~= 7)&obj.getRelevantData()),...
                    obj.dataBase.celldata.lat((obj.guiElements.checkboxTelefonica.Value ~= 1 &...
                    obj.guiElements.checkboxTelefonica.Value ~= 2 &...
                    obj.guiElements.checkboxTelefonica.Value ~= 3 &...
                    obj.guiElements.checkboxTelefonica.Value ~= 7)&obj.getRelevantData()),...
                    'k.','MarkerSize', 15);
            end
            
        end
        function setAlphaData(obj, event, ~)
            obj.guiElements.SliderIntensity.Value = event.Value;
            obj.heatMap.AlphaData = obj.guiElements.SliderIntensity.Value;
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
            colormap(obj.ax, 'jet');
            obj.heatMap.CDataMapping = 'scaled';
            
        end
        
        function eraseOverlays(obj)
            delete(obj.heatMap);
            delete(obj.dotMapTelekom);
            delete(obj.dotMapVodafone);
            delete(obj.dotMapEPlus);
            delete(obj.dotMapTelefonica);
            delete(obj.dotMapElse);
        end
        
    end
end