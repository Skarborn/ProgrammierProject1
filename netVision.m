classdef netVision < handle
    properties
        fig
        uifig
        line
        ax
        
        dataBase
        myMap
        
        guiElements
        
        editLongMin
        editLongMax
        editLatMin
        editLatMax
    end
    methods
        function obj = netVision()
            % read in celldata
            obj.dataBase = load("celldata.mat");

            % generate figure and grid used for GUI
            obj.uifig = uifigure("Name","netVision");
            obj.uifig.Position = [0 100 700 700];
            grid = uigridlayout(obj.uifig, [8, 8]);
            
            % generate axes handle and map
            obj.fig = figure();
            obj.fig.Position = [700 100 700 700];
            obj.ax = axes(obj.fig);
            
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
            
            obj.myMap = Map(initialCoords,'hot',obj.ax);
            hold on
            
            % generate GUI elements
            % edit fields for entering coordinates
            guiElements = struct();
            
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
            
            
            % generate button to apply all changes
            applyChanges = uibutton(grid);
            applyChanges.Text = "Apply Changes";
            applyChanges.Layout.Row = 8;
            applyChanges.Layout.Column = [7 8];
            applyChanges.ButtonPushedFcn = @obj.apply;
            
        end
        
        function apply(obj, source, ~)
            if (source.Text == "Apply Changes")
                obj.myMap.coords = struct(...
                    "minLon", obj.guiElements.editLongMin.Value, ...
                    "maxLon", obj.guiElements.editLongMax.Value, ...
                    "minLat", obj.guiElements.editLatMin.Value, ...
                    "maxLat", obj.guiElements.editLatMax.Value);
            end
            % if checkbox == true -> draw Dots
            obj.drawDots()
        end
        
        function drawDots(obj)
            lon = obj.dataBase.celldata.lon;
            lat = obj.dataBase.celldata.lat;
            created = obj.dataBase.celldata.created;
            updated = obj.dataBase.celldata.updated;
            network = obj.dataBase.celldata.network;
            countryCode = obj.dataBase.celldata.countryCode;
            networkCode = obj.dataBase.celldata.networkCode;
            areaCode = obj.dataBase.celldata.areaCode;
            cellCode = obj.dataBase.celldata.cellCode;
            distanceInM = obj.dataBase.celldata.distanceInM;
            
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
            
            obj.line = plot(obj.ax,lonCurrent,latCurrent,...
                'r.','MarkerSize',18);
        end
    end
end