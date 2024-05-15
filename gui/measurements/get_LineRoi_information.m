function get_LineRoi_information(obj)

        roiData         = obj.RoiLineData;
        if ~isempty(roiData)
            % Get the handle of the image
            imgHandle = findobj(get(roiData, 'Parent'), 'Type', 'image');

            if ~isempty(imgHandle)
                % Get image data
                imgData = get(imgHandle, 'CData');

                % Create a binary mask from the ROI
                roiMask = createMask(roiData, imgHandle);

                % Extract pixel values within the ROI using the mask
                roiPixels = imgData(roiMask);

                start_position = [500, 100, 1024, 768];
                measurement_figure = figure('Name', 'Line Plot', ...
                    'Position', start_position, ...
                    'MenuBar', 'figure', ...
                    'ToolBar', 'figure'...
                    );
                
                x_lin = 1:numel(roiPixels);
                plot(x_lin, roiPixels),
                xlabel('Position');
                ylabel('HU Values');
                
                set(measurement_figure, 'NumberTitle', 'off');
                set(measurement_figure, 'Resize', 'off');
                
                
            else
                disp('Image data not found.');
            end
        else
            disp('ROI is empty or does not exist.');
        end
    end
