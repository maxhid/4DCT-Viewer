function distance_mm = get_LineMeasurement(obj)

        roiData = obj.RoiLineData;
        pixelSpacing = obj.PixelSpacing;
        if ~isempty(roiData)
            % Get the handle of the image
            pos = roiData.Position;
            sx = pos(1,1);
            sy = pos(1,2);
            ex = pos(2,1);
            ey = pos(2,2);
            
            distance_px = sqrt((ex - sx)^2 + (ey - sy)^2);
            distance_mm = sqrt(((ex - sx) * pixelSpacing(1))^2 + ((ey - sy) * pixelSpacing(2))^2);
            
            disp(['Length in pixels: ', num2str(distance_px)]);
            disp(['Length in mm: ', num2str(distance_mm)]);
            disp(['Length in cm: ', num2str(distance_mm / 10)]);
        else
            disp('ROI is empty or does not exist.');
        end
    end
