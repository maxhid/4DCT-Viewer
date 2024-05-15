function get_CircularRoi_information(obj)

        roiData         = obj.RoiCircleData;
        pixelSpacing    = obj.PixelSpacing;
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

                % Calculate size of ROI in pixels
                roiSizePx = sum(roiMask(:));
                px_area   = pixelSpacing(1) * pixelSpacing(2);
                area      = roiSizePx * px_area;
                
                % Calculate the diameter of the circle
                diameter    = roiData.Radius * 2;
                diameter_mm = diameter * pixelSpacing(1);

                % Calculate average pixel value inside the ROI
                avgPixelValue    = mean(roiPixels);
                stdDevPixelValue = std(single(roiPixels));

                disp(['Diameter of Circle ROI in cm: ', num2str(diameter_mm / 10)]);
                disp(['Size of ROI in pixels² in mm: ', num2str(area)]);
                disp(['Size of ROI in pixels² in cm: ', num2str(area / (10^2))]);
                disp(['Average pixel value inside ROI in HU: ', num2str(avgPixelValue)]);
                disp(['Std Dev inside ROI in HU: ', num2str(stdDevPixelValue)]);
            else
                disp('Image data not found.');
            end
        else
            disp('ROI is empty or does not exist.');
        end
    end
