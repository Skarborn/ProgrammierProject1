classdef netVision < handle
    properties
        fig
        uifig
        line
        
        dataBase
        my_map
        
        editLongMin
        editLongMax
        editLatMin
        editLatMax
    end
    methods
        function obj = netVision()
            % read in celldata
            obj.dataBase = load("celldata.mat");
            
            % coords to generate map
            longitudinal_min = 8.18;
            longitudinal_max = 8.28;
            lateral_min = 53.11;
            lateral_max = 53.18;
            my_coords = struct(...
                "minLon", longitudinal_min, ...
                "maxLon", longitudinal_max, ...
                "minLat", lateral_min, ...
                "maxLat", lateral_max);
            
            % generate figure and grid used for GUI
            obj.uifig = uifigure("Name","netVision");
            obj.uifig.Position = [0 100 700 700];
            grid = uigridlayout(obj.uifig, [8, 8]);
            
            % generate axes handle and map
            obj.fig = figure();
            obj.fig.Position = [700 100 700 700];
            ax = axes(obj.fig);
            obj.my_map = Map(my_coords,'hot',ax);
            
            % edit fields for entering coordinates
            obj.editLongMin = uieditfield(grid,"numeric");
            obj.editLongMin.Limits = [0 360];
            obj.editLongMin.Value = longitudinal_min;
            obj.editLongMin.Layout.Row = 1;
            obj.editLongMin.Layout.Column = 1;
            obj.editLongMin.Tooltip = "min longitudinal";
            
            obj.editLongMax = uieditfield(grid,"numeric");
            obj.editLongMax.Limits = [0 360];
            obj.editLongMax.Value = longitudinal_max;
            obj.editLongMax.Layout.Row = 1;
            obj.editLongMax.Layout.Column = 2;
            obj.editLongMax.Tooltip = "max longitudinal";
            
            obj.editLatMin = uieditfield(grid,"numeric");
            obj.editLatMin.Limits = [0 360];
            obj.editLatMin.Value = lateral_min;
            obj.editLatMin.Layout.Row = 2;
            obj.editLatMin.Layout.Column = 1;
            obj.editLatMin.Tooltip = "min lateral";
            
            obj.editLatMax = uieditfield(grid,"numeric");
            obj.editLatMax.Limits = [0 360];
            obj.editLatMax.Value = lateral_max;
            obj.editLatMax.Layout.Row = 2;
            obj.editLatMax.Layout.Column = 2;
            obj.editLatMax.Tooltip = "max lateral";
            
            % generate button to apply all changes
            applyChanges = uibutton(grid);
            applyChanges.Text = "Apply Changes";
            applyChanges.Layout.Row = 8;
            applyChanges.Layout.Column = [7 8];
            applyChanges.ButtonPushedFcn = @obj.apply;
        end
        
        function apply(obj, source, ~)
            if (source.Text == "Apply Changes")
                obj.my_map.coords = struct(...
                    "minLon", obj.editLongMin.Value, ...
                    "maxLon", obj.editLongMax.Value, ...
                    "minLat", obj.editLatMin.Value, ...
                    "maxLat", obj.editLatMax.Value);
            end
        end     
    end
end