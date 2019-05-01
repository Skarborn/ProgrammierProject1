classdef netVision < handle
    properties
        fig
        uifig
        line
        ax
        
        dataBase
        myMap
        
        editLongMin
        editLongMax
        editLatMin
        editLatMax
        
        checkbox
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
            
            % edit fields for entering coordinates
            obj.editLongMin = uieditfield(grid,"numeric");
            obj.editLongMin.Limits = [0 360];
            obj.editLongMin.Value = longitudinalMin;
            obj.editLongMin.Layout.Row = 1;
            obj.editLongMin.Layout.Column = 1;
            obj.editLongMin.Tooltip = "min longitudinal";
            
            obj.editLongMax = uieditfield(grid,"numeric");
            obj.editLongMax.Limits = [0 360];
            obj.editLongMax.Value = longitudinalMax;
            obj.editLongMax.Layout.Row = 1;
            obj.editLongMax.Layout.Column = 2;
            obj.editLongMax.Tooltip = "max longitudinal";
            
            obj.editLatMin = uieditfield(grid,"numeric");
            obj.editLatMin.Limits = [0 360];
            obj.editLatMin.Value = lateralMin;
            obj.editLatMin.Layout.Row = 2;
            obj.editLatMin.Layout.Column = 1;
            obj.editLatMin.Tooltip = "min lateral";
            
            obj.editLatMax = uieditfield(grid,"numeric");
            obj.editLatMax.Limits = [0 360];
            obj.editLatMax.Value = lateralMax;
            obj.editLatMax.Layout.Row = 2;
            obj.editLatMax.Layout.Column = 2;
            obj.editLatMax.Tooltip = "max lateral";
            
            obj.checkbox = uicheckbox(grid);
            obj.checkbox.Text = "Funkmasten";
            obj.checkbox.Value = 0;
            obj.checkbox.Layout.Row = 5;
            obj.checkbox.Layout.Column = 7;

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
                    "minLon", obj.editLongMin.Value, ...
                    "maxLon", obj.editLongMax.Value, ...
                    "minLat", obj.editLatMin.Value, ...
                    "maxLat", obj.editLatMax.Value);
            end
            if obj.checkbox.Value == true %-> draw Dots
                obj.drawDots()
            else 
                obj.line.XData = [];
                obj.line.YData = [];
            end
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
                obj.editLongMin.Value <= lon &...
                obj.editLongMax.Value >= lon & ...
                obj.editLatMin.Value <= lat &...
                obj.editLatMax.Value >= lat ;
            
            % combine logical vectors for filtering purposes
            relevantData =  relevantCoords;
            
            lonCurrent = lon(relevantData);
            latCurrent = lat(relevantData);
            
            obj.line = plot(obj.ax,lonCurrent,latCurrent,...
                'r.','MarkerSize',18)
        end
    end
end