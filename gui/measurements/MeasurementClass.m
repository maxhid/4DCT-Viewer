classdef MeasurementClass
    %MEASUREMENT Summary of this class goes here
    
    properties
        Figure1
        Axes
        PixelSpacing
        AddROIMeasurementButton
        LinePlotButton
        LineMeasurementButton
        RoiCircleData
        RoiLineData
    end
    
    methods
        function obj = MeasurementClass(axes, pixelSpacing)
            obj.Figure1 = createMeasurementFigure;
            obj.Axes    = axes;
            obj.PixelSpacing    = pixelSpacing;
            obj.AddROIMeasurementButton = uicontrol('Style', 'pushbutton', ...
                'String', 'Add ROI Measurement', ...
                'Position', [10, 730, 200, 30], ...
                'Callback', @(src, event) addROIMeasurement(obj));
            obj.LinePlotButton = uicontrol('Style', 'pushbutton', ...
                'String', 'Line Plot', ...
                'Position', [10, 730 - 30, 200, 30], ...
                'Callback', @(src, event) plotLine(obj));
            obj.LineMeasurementButton = uicontrol('Style', 'pushbutton', ...
                'String', 'Line Measurement', ...
                'Position', [10, 730 - 60, 200, 30], ...
                'Callback', @(src, event) measureLine(obj));
            obj.RoiCircleData = struct('roi', []);
            obj.RoiLineData = struct('roi', []);
        end
        
        function obj = addROIMeasurement(obj)
            % Method for adding ROI measurement
            disp('Adding ROI Measurement...');
            obj.RoiCircleData = drawcircle(obj.Axes);
            get_CircularRoi_information(obj);
        end
        
        function plotLine(obj)
            % Method for plotting line
            disp('Plotting Line...');
            obj.RoiLineData = drawline(obj.Axes);
            get_LineRoi_information(obj);
        end
        
        function measureLine(obj)
            % Method for measuring line
            disp('Measuring Line...');
            obj.RoiLineData = drawline(obj.Axes);
            distance_mm = get_LineMeasurement(obj);
            obj.RoiLineData.Label = [num2str(distance_mm) ' mm'];
            obj.RoiLineData.LabelVisible = 'hover';
        end
        
    end
end
