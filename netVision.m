classdef netVision < handle
    properties
        fig
        x_lim
        y_lim
        network
        networkCode
        dataBase
        my_map
        
        editLongMin
        editLongMax
        editLatMin
        editLatMax
    end
    methods
        function obj = netVision()
            obj.dataBase = load("celldata.mat");
            
            longitudinal_min = 8.18;
            longitudinal_max = 8.28;
            lateral_min = 53.11;
            lateral_max = 53.18;
            my_coords = struct(...
                "minLon", longitudinal_min, ...
                "maxLon", longitudinal_max, ...
                "minLat", lateral_min, ...
                "maxLat", lateral_max);
            
            obj.fig = uifigure("Name","netVision");
            grid = uigridlayout(obj.fig, [8, 8]);
            ax = uiaxes(grid);
            ax.Layout.Row = [1 6];
            ax.Layout.Column = [3 8];
            obj.my_map = Map(my_coords,'osm',ax);
            
            obj.editLongMin = uieditfield(grid,"numeric");
            obj.editLongMin.Limits = [0 360];
            obj.editLongMin.Value = longitudinal_min;
            obj.editLongMin.ValueChangedFcn = @obj.changeCoords;
            obj.editLongMin.Layout.Row = 1;
            obj.editLongMin.Layout.Column = 1;
            obj.editLongMin.Tooltip = "min longitudinal";
            
            obj.editLongMax = uieditfield(grid,"numeric");
            obj.editLongMax.Limits = [0 360];
            obj.editLongMax.Value = longitudinal_max;
            obj.editLongMax.ValueChangedFcn = @obj.changeCoords;
            obj.editLongMax.Layout.Row = 1;
            obj.editLongMax.Layout.Column = 2;
            obj.editLongMax.Tooltip = "max longitudinal";
            
            obj.editLatMin = uieditfield(grid,"numeric");
            obj.editLatMin.Limits = [0 360];
            obj.editLatMin.Value = lateral_min;
            obj.editLatMin.ValueChangedFcn = @obj.changeCoords;
            obj.editLatMin.Layout.Row = 2;
            obj.editLatMin.Layout.Column = 1;
            obj.editLatMin.Tooltip = "min lateral";
            
            obj.editLatMax = uieditfield(grid,"numeric");
            obj.editLatMax.Limits = [0 360];
            obj.editLatMax.Value = lateral_max;
            obj.editLatMax.ValueChangedFcn = @obj.changeCoords;
            obj.editLatMax.Layout.Row = 2;
            obj.editLatMax.Layout.Column = 2;
            obj.editLatMax.Tooltip = "max lateral";
        end
        
        function changeCoords(obj, source, ~)
            obj.my_map.coords = struct(...
                    "minLon", obj.editLongMin.Value, ...
                    "maxLon", obj.editLongMax.Value, ...
                    "minLat", obj.editLatMin.Value, ...
                    "maxLat", obj.editLatMax.Value);
        end
    end
end