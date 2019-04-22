classdef netVision < handle
    properties
        fig
        x_lim
        y_lim
        network
        networkCode
        dataBase
        
        edit1
        edit2
        edit3
        edit4
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
            my_map = Map(my_coords,'osm',ax);
            
            obj.edit1 = uieditfield(grid,"numeric");
            obj.edit1.Limits = [0 360];
            obj.edit1.Value = longitudinal_min;
            obj.edit1.ValueChangedFcn = @obj.changeCoords;
            obj.edit1.Layout.Row = 1;
            obj.edit1.Layout.Column = 1;
            obj.edit1.Tooltip = "min longitudinal";
            
            obj.edit2 = uieditfield(grid,"numeric");
            obj.edit2.Limits = [0 360];
            obj.edit2.Value = longitudinal_max;
            obj.edit2.ValueChangedFcn = @obj.changeCoords;
            obj.edit2.Layout.Row = 1;
            obj.edit2.Layout.Column = 2;
            obj.edit2.Tooltip = "max longitudinal";
            
            obj.edit3 = uieditfield(grid,"numeric");
            obj.edit3.Limits = [0 360];
            obj.edit3.Value = lateral_min;
            obj.edit3.ValueChangedFcn = @obj.changeCoords;
            obj.edit3.Layout.Row = 2;
            obj.edit3.Layout.Column = 1;
            obj.edit3.Tooltip = "min lateral";
            
            obj.edit4 = uieditfield(grid,"numeric");
            obj.edit4.Limits = [0 360];
            obj.edit4.Value = lateral_max;
            obj.edit4.ValueChangedFcn = @obj.changeCoords;
            obj.edit4.Layout.Row = 2;
            obj.edit4.Layout.Column = 2;
            obj.edit4.Tooltip = "max lateral";
        end
        
        function changeCoords(obj, source, ~)
            disp(obj.edit1.Value * obj.edit2.Value);
        end
    end
end