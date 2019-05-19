classdef netVision < handle
%NETVISION visualizes the network coverage in Germany
%   NETVISION uses MAP for plotting a map. The data necessary to
%   visualize the network coverage is drawn from celldata.mat, which
%   can be downloaded from https://opencellid.org.
%
%   The user can specify, what will be shown on the map.
%   As long as at least one network provider and one network type
%   is selected, a heatmap and/or a map showing the position of
%   transmitter towers can be drawn. Transmitter tower will be
%   colored according to the network provider (Telekom = pink,
%   Vodafone = red, EPlus = green, Telefonica = blue, else = black).
%   The user can also set the transparency of the heatmap to
%   his/her liking.
%
%   Some settings will change the properties of the MAP.
%   Coordinates will be changed as specified in the edit fields.
%   The MAP style can also be changed in a dropdown.
%
%   NETVISION() creates a uifigure containing the axis the MAP is
%   drawn on. The initial coordinates point to Oldenburg.
%   Since no input parameters are required, NETVISION can be run
%   just like a script.

%   Copyright (c) 2019,
%   Martin Berdau, Johannes Ruesing, Tammo Sander
%   This code is public domain
    
    properties
        ax % axis object used for MAP
        
        dataBase % contains celldata
        
        myMap   % contains MAP
        heatMap % contains image of heatmap
        
        % line objects of transmitter towers
        dotMapTelekom
        dotMapVodafone
        dotMapEPlus
        dotMapTelefonica
        dotMapElse
        
        guiElements % contains all GUI elements
    end
    
    methods
        function obj = netVision()
        %NETVISION initialises the application
        
            % read in celldata
            obj.dataBase = load("celldata.mat");
            
            % generate figure and grid used for GUI
            uifig = uifigure("Name","netVision");
            uifig.Position = [0 100 1000 800];
            grid = uigridlayout(uifig, [16, 20]);
            
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
            
            % GENERATE GUI ELEMENTS            
            guiElements = struct();
            
            % NAMES FOR CONTROL ELEMENTS
            obj.guiElements.labels = uilabel(grid);
            obj.guiElements.labels.Text = ...
                'Longitudinal Koordinaten: ';
            obj.guiElements.labels.Layout.Row = 1;
            obj.guiElements.labels.Layout.Column = [1 4];
            obj.guiElements.labels.FontWeight = 'bold';
            
            obj.guiElements.labels = uilabel(grid);
            obj.guiElements.labels.Text = ...
                'Lateral Koordinaten: ';
            obj.guiElements.labels.Layout.Row = 3;
            obj.guiElements.labels.Layout.Column = [1 4];
            obj.guiElements.labels.FontWeight = 'bold';
            
            obj.guiElements.labels = uilabel(grid);
            obj.guiElements.labels.Text = ...
                'Anzeigeoptionen: ';
            obj.guiElements.labels.Layout.Row = 5;
            obj.guiElements.labels.Layout.Column = [1 4];
            obj.guiElements.labels.FontWeight = 'bold';
            
            obj.guiElements.labels = uilabel(grid);
            obj.guiElements.labels.Text = ...
                'Kartentyp: ';
            obj.guiElements.labels.Layout.Row = 6;
            obj.guiElements.labels.Layout.Column = [3 4];
            obj.guiElements.labels.FontWeight = 'bold';
            
            obj.guiElements.labels = uilabel(grid);
            obj.guiElements.labels.Text = ...
                'Netzwerkanbieter: ';
            obj.guiElements.labels.Layout.Row = 8;
            obj.guiElements.labels.Layout.Column = [1 4];
            obj.guiElements.labels.FontWeight = 'bold';
            
            obj.guiElements.labels = uilabel(grid);
            obj.guiElements.labels.Text = ...
                'Netzwerkart: ';
            obj.guiElements.labels.Layout.Row = 12;
            obj.guiElements.labels.Layout.Column = [1 4];
            obj.guiElements.labels.FontWeight = 'bold';
            
            obj.guiElements.labels = uilabel(grid);
            obj.guiElements.labels.Text = ...
                'Deckkraft der Heatmap: ';
            obj.guiElements.labels.Layout.Row = 14;
            obj.guiElements.labels.Layout.Column = [1 4];
            obj.guiElements.labels.FontWeight = 'bold';
            
            
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
            obj.guiElements.checkboxElse.Layout.Column = [1 4];
            
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
            obj.guiElements.SliderIntensity.Enable = 'off';
            obj.guiElements.SliderIntensity.ValueChangedFcn = ...
                @obj.setAlphaData;
            
            % DROPDOWN FOR MAP TYPE
            obj.guiElements.DropdownMapType = uidropdown(grid);
            obj.guiElements.DropdownMapType.Items = ...
                {'hot', 'osm', 'ocm', 'opm', 'landscape', 'outdoors'};
            obj.guiElements.DropdownMapType.Value = 'hot';
            obj.guiElements.DropdownMapType.Layout.Row = 7;
            obj.guiElements.DropdownMapType.Layout.Column = [3 4];
            
            
            % BUTTONS
            applyChanges = uibutton(grid);
            applyChanges.Text = "Änderungen annehmen";
            applyChanges.Layout.Row = 16;
            applyChanges.Layout.Column = [1 4];
            applyChanges.ButtonPushedFcn = @obj.apply;
            
        end
        
        function apply(obj, ~, ~)
        %APPLY changes the coords, draws transmitter tower positions
        % and a heatmap depending on the settings made in the GUI.
        
            obj.myMap.coords = struct(...
                "minLon", obj.guiElements.editLongMin.Value, ...
                "maxLon", obj.guiElements.editLongMax.Value, ...
                "minLat", obj.guiElements.editLatMin.Value, ...
                "maxLat", obj.guiElements.editLatMax.Value);
            
            % change the style of the map if choosed
            obj.myMap.style = obj.guiElements.DropdownMapType.Value;
            % delete current overlays
            obj.eraseOverlays()
            
            % if checkbox is ticked, plot dots
            if obj.guiElements.checkboxDots.Value == true
                obj.drawDots()
            end
            
            % if checkbox is ticked, plot heatmap
            if obj.guiElements.checkboxHeatmap.Value == true
                obj.drawHeatmap()
                obj.guiElements.SliderIntensity.Enable = 'on';
            else
                obj.guiElements.SliderIntensity.Enable = 'off';
            end
            
            
        end
        
        function relevantData = getRelevantData(obj)
        %RELEVANTDATA hands back a logical vector specifying
        % which values from the celldata are relevant according
        % to the settings made in the GUI.
            
            relevantCoords = ...
                obj.guiElements.editLongMin.Value <= ...
                obj.dataBase.celldata.lon & ...
                obj.guiElements.editLongMax.Value >= ...
                obj.dataBase.celldata.lon & ...
                obj.guiElements.editLatMin.Value <= ...
                obj.dataBase.celldata.lat &...
                obj.guiElements.editLatMax.Value >= ...
                obj.dataBase.celldata.lat;
            
            relevantNetwork = zeros(length(relevantCoords),1);
            relevantNetworkType = zeros(length(relevantCoords),1);
            
            % Filtering according to network provider. Multiple
            % providers can be selected at the same time
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
            
            % Filtering according to network type. Multiple
            % types can be selected at the same time.
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
            
            % combining all logical vectors
            relevantData =  relevantCoords & relevantNetwork & ...
                relevantNetworkType;
        end
        
        function drawDots(obj)
        %DRAWDOTS plots relevant transmitter towers in different
        % colors according to network provider.
            
            % plotting Telekom transmitter towers
            if obj.guiElements.checkboxTelekom.Value == true
                obj.dotMapTelekom = plot(obj.ax,...
                    obj.dataBase.celldata.lon(obj.getRelevantData() & ...
                    obj.dataBase.celldata.networkCode==1), ...
                    obj.dataBase.celldata.lat(obj.getRelevantData() & ...
                    obj.dataBase.celldata.networkCode==1), ...
                    'm.','MarkerSize',15);
            end
            
            % plotting Vodafone transmitter towers
            if obj.guiElements.checkboxVodafone.Value == true
                obj.dotMapVodafone = plot(obj.ax,...
                    obj.dataBase.celldata.lon(obj.getRelevantData() & ...
                    obj.dataBase.celldata.networkCode==2), ...
                    obj.dataBase.celldata.lat(obj.getRelevantData() & ...
                    obj.dataBase.celldata.networkCode==2), ...
                    'r.','MarkerSize', 15);
            end
            
            % plotting EPlus transmitter towers
            if obj.guiElements.checkboxEPlus.Value == true
                obj.dotMapEPlus = plot(obj.ax,...
                    obj.dataBase.celldata.lon(obj.getRelevantData() & ...
                    obj.dataBase.celldata.networkCode==3), ...
                    obj.dataBase.celldata.lat(obj.getRelevantData() & ...
                    obj.dataBase.celldata.networkCode==3), ...
                    '.', 'Color', [0, 0.5, 0],'MarkerSize', 15);
            end
            
            % plotting Telefonica transmitter towers
            if obj.guiElements.checkboxTelefonica.Value == true
                obj.dotMapTelefonica = plot(obj.ax,...
                    obj.dataBase.celldata.lon(obj.getRelevantData() & ...
                    obj.dataBase.celldata.networkCode==7), ...
                    obj.dataBase.celldata.lat(obj.getRelevantData() & ...
                    obj.dataBase.celldata.networkCode==7), ...
                    'b.','MarkerSize', 15);
            end
            
            % plotting other transmitter towers
            if obj.guiElements.checkboxElse.Value == true
                obj.dotMapElse = plot(obj.ax, ...
                    obj.dataBase.celldata.lon(( ...
                    obj.guiElements.checkboxTelefonica.Value ~= 1 & ...
                    obj.guiElements.checkboxTelefonica.Value ~= 2 & ...
                    obj.guiElements.checkboxTelefonica.Value ~= 3 & ...
                    obj.guiElements.checkboxTelefonica.Value ~= 7) & ...
                    obj.getRelevantData()),...
                    obj.dataBase.celldata.lat(( ...
                    obj.guiElements.checkboxTelefonica.Value ~= 1 & ...
                    obj.guiElements.checkboxTelefonica.Value ~= 2 & ...
                    obj.guiElements.checkboxTelefonica.Value ~= 3 & ...
                    obj.guiElements.checkboxTelefonica.Value ~= 7) & ...
                    obj.getRelevantData()), ...
                    'k.','MarkerSize', 15);
            end
            
        end
        function setAlphaData(obj, event, ~)
        %SETALPHADATA reacts to heatmap slider controling the
        % transparency of the heatmap
        
            obj.guiElements.SliderIntensity.Value = event.Value;
            obj.heatMap.AlphaData = obj.guiElements.SliderIntensity.Value;
        end
        
        function drawHeatmap(obj)
        %DRAWHEATMAP draws a heatmap according to the relevant data.

            % get relevant coordinates of transmitter towers
            lonCurrent = obj.dataBase.celldata.lon(obj.getRelevantData());
            latCurrent = obj.dataBase.celldata.lat(obj.getRelevantData());
            
            % get current size of axis in pixels
            xPixelWidth = obj.ax.Position(3);
            yPixelWidth = obj.ax.Position(4);
            
            % calculate width of current axis in degree
            long_width = obj.guiElements.editLongMax.Value -...
                obj.guiElements.editLongMin.Value;
            lat_width = obj.guiElements.editLatMax.Value -...
                obj.guiElements.editLatMin.Value;
            
            % calculate width of one pixel in degree
            degProPixLon = long_width/xPixelWidth;
            degProPixLat = lat_width/yPixelWidth;
            
            % x and y vectors with step size of one pixel in degree
            x = obj.guiElements.editLongMin.Value : ...
                degProPixLon : obj.guiElements.editLongMax.Value;
            y = obj.guiElements.editLatMax.Value : ...
                -degProPixLat : obj.guiElements.editLatMin.Value;
            
            % generate meshgrid
            [X,Y] = meshgrid(x,y);
            
            % P is the estimated power of average transmitter tower.
            % source: https://www.emf.ethz.ch/de/emf-info/themen/
            % technik/basisstationsantennen/
            % sendestaerke-von-basisstationen/
            P = 7;
            
            % determining limit for intensity, since values close to
            % transmitter tower will go up to infinity
            intensityLimit = 1e-5;
            
            % converting degree to meters applying to following source:
            % http://www.iaktueller.de/exx.php
            metersPerDegLong = 71.44e3;
            metersPerDegLat = 111.13e3;
            
            % matrix that will contain intensity values
            F = zeros(length(y),length(x));
            
            for kk = 1:length(lonCurrent)
                % calculating intensity around transmitter tower
                A = P./(4*pi*((metersPerDegLong*(X-lonCurrent(kk))).^2+ ...
                    (metersPerDegLat*(Y-latCurrent(kk))).^2));
                
                % values close to tower go up to infinity -> set limit
                A(A>intensityLimit)=intensityLimit;
                
                % add matrixes of all towers
                F = F + A;
            end
            
            % generate heatmap as image and set colormap to jet
            obj.heatMap = image(obj.ax,x,y,10*log10(F/1e-12));
            colormap(obj.ax, 'jet');
            obj.heatMap.AlphaData =...
                obj.guiElements.SliderIntensity.Value;
            obj.heatMap.CDataMapping = 'scaled';
            
        end
        
        function eraseOverlays(obj)
        %ERASEOVERLAYS deletes existing overlays, so they won't stay
        % on axis and new ones can be generated.
        
            delete(obj.heatMap);
            delete(obj.dotMapTelekom);
            delete(obj.dotMapVodafone);
            delete(obj.dotMapEPlus);
            delete(obj.dotMapTelefonica);
            delete(obj.dotMapElse);
        end
        
    end
end