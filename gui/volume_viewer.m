function volume_viewer()
    % Summary: This function creates a graphical interface for viewing and
    % interacting with volumetric medical image data. It allows users to
    % load image volumes, adjust windowing settings, change the viewing
    % orientation, toggle segmentation overlays, scroll through slices and
    % volumes, and rate the displayed volumes. The interface includes
    % buttons, dropdown menus, a scrollbar, and supports mouse and keyboard
    % interactions for navigation and interaction.

    % Input:
    %   None

    % Output:
    %   None

    % Usage:
    %   Call this function to launch the volume viewer interface.

    % Details:
    %   - The function initializes a graphical user interface (GUI) with a figure window named "Volume Viewer" and various UI elements for user interaction.
    %   - Users can load image volumes by selecting folders containing DICOM or NIfTI files. The loaded volumes are displayed in the viewer.
    %   - Windowing settings can be adjusted to control the contrast and brightness of the displayed images.
    %   - Users can switch between different viewing orientations (axial, coronal, sagittal) to examine the image volumes from different perspectives.
    %   - Segmentation overlays can be toggled on or off to visualize segmented regions within the image volumes.
    %   - Navigation through slices and volumes is supported via scrollbar, mouse wheel scrolling, and keyboard shortcuts.
    %   - Users can rate the displayed volumes using rating buttons, and the ratings are stored for each volume.

    % Functions:
    %   - select_foldersClicked: Callback function for selecting folders containing image volumes.
    %   - change_windowingClicked: Callback function for adjusting windowing settings.
    %   - change_viewClicked: Callback function for changing the viewing orientation.
    %   - change_segmentation: Callback function for toggling segmentation overlays.
    %   - display_slice: Function to display the current slice of the selected volume.
    %   - cineMode: Function to enable continuous playback of volumes like a cine loop.
    %   - scroll_slice: Callback function for scrolling through slices using the scrollbar.
    %   - key_press: Callback function for handling key press events (e.g., shift, spacebar).
    %   - key_release: Callback function for handling key release events.
    %   - scroll_wheel: Callback function for mouse wheel scrolling to navigate through slices and volumes.
    %   - rate_volume: Callback function for rating the displayed volume.

    % Dependencies:
    %   - This function relies on several helper functions for UI creation
    %   and volume manipulation, including createFolderSelection,
    %   createWindowingPopup, createOrientationPopup,
    %   createSegmentationRadio, createButtonsGUI, and changeOrientation.

    % Author:
    %   Maximilian Heider

    % Date:
    %   07.05.2024

    % Example:
    %   volume_viewer();
    
    
    % Create figure and axis
    % Create figure and axis
    start_position = [100, 100, 1280, 800];
    viewer = figure('Name', 'CT Viewer', ...
        'Position', start_position, ...
        'MenuBar', 'none', ...
        'ToolBar', 'none'...
        );
    set(viewer, 'NumberTitle', 'off');
    set(viewer, 'Resize', 'off')
   
    axViewer = axes('Parent', viewer, 'Position', [0.15, 0.2, 0.7, 0.7]);
    
    % Initialize variables
    volumes         = {};
    infos           = {}; 
    volumes_nifti   = {};
    nii_infos       = {};
    
    % Generate example volume data (checkerboard images)
    num_slices = 100;

    % Initialize current volume and slice and standard window
    current_volume = 1;
    current_slice = 1;
    window = [-160, 240]; % WC: 40, WW: 400 
    
    % Initialize variable for current view
    current_view = 1; % Default to axial view
    axialOrientation = eye(3);
    coronalOrientation = [0 0 1; 0 1 0; 1 0 0];
    sagittalOrientation = [0 1 0; 0 0 1; 1 0 0];
    orientations = {axialOrientation, coronalOrientation, sagittalOrientation}; 
    orientation = {};
    orientation_nii = {};
    
    
     % Buttons and scrollbar init
    pos     = viewer.Position;
    viewer_width = pos(3);
    viewer_height = pos(4);
    pos_x   = 0.9000 * pos(3);
    
    % Add "Select Folders" button
    select_folders_btn = createFolderSelection(viewer, 10, viewer_height * 0.93, @select_foldersClicked);
    
    % Add dropdown menu for windowing settings
    windowing_popup     = createWindowingPopup(viewer, pos_x, viewer_height * 0.93, @change_windowingClicked);
    
    % Create scrollbar
    scrollbar           = createScrollbar(viewer, num_slices, viewer_width * 0.95, 275, @scroll_slice);
   
    % Add dropdown menu for volume views
    view_popup          = createOrientationPopup(viewer, pos_x, (viewer_height * 0.93) - 30, @change_viewClicked);
    
    % Create Segmentation button
    segmentation_radio  = createSegmentationRadio(viewer, 10, (viewer_height * 0.93) - 30, 0, @change_segmentation);
    
    % Create Measurements button
    measurements_btn    = createMeasurementButton(viewer, pos_x - 40, (viewer_height * 0.93) - 60, @measurement_clicked);
    
    
    % Create Rating Buttons
    % rating_btns         = createButtonsGUI(viewer, 5, @rate_volume);
                      
    % Display initial slice
    display_slice();

    % Set up mouse wheel scrolling
    set(gcf, 'WindowScrollWheelFcn', @scroll_wheel);
    set(gcf, 'KeyPressFcn', @key_press);
    set(gcf, 'KeyReleaseFcn', @key_release);
    
    % Initialize a variable to track whether the Shift key is pressed
    spacebar_pressed    = false;
    
    dimX = 0;
    dimY = 0;
    dimZ = 0;
    
    sliceThickness  = 0;
    pixelSpacing    = 0;
    rescaling_HU    = 0;

%---------Reaction Functions---------------------------------------------
    
    
    function select_foldersClicked(src, ~)
        main_folder = uigetdir('', 'Select a folder');
        if main_folder == 0
            return; % User canceled selection
        end
       [volumes, infos, volumes_nifti, nii_infos, orientation] = select_folders(main_folder, false);
       orientation_nii = orientation;
       
       [dimX, dimY, dimZ] = size(volumes{current_volume});
       sliceThickness       = infos{current_volume}.SliceThickness;
       pixelSpacing         = infos{current_volume}.PixelSpacing;
%        set(axViewer, 'UserData', 'pixelSpacing', pixelSpacing);
       rescaling_HU         = int16(infos{current_volume}.RescaleIntercept);
       
       scrollbar       = updateScrollbar(scrollbar, num_slices);
       current_slice   = scrollbar.Value;
       
       setFocusToFigure(viewer, src);
       
       display_slice();
    end 

    function change_windowingClicked(src, ~)
        window = change_windowing(windowing_popup);
        caxis(axViewer, window);
        setFocusToFigure(viewer, src);
    end

    function change_viewClicked(src, ~)
        current_view = src.Value;
        
        if current_view == 1
            num_slices  = dimZ;
        elseif current_view == 2
            num_slices = dimY;
        else
            num_slices = dimX;
        end
        
        scrollbar       = updateScrollbar(scrollbar, num_slices);
        current_slice   = scrollbar.Value;
        setFocusToFigure(viewer, src);
        axis(axViewer, 'auto');
        display_slice;
    end
    
    function change_segmentation(~, ~)
%         display_slice;
        if segmentation_radio.Value == 0 && ~isempty(volumes_nifti)
            clear h;
        end
        display_slice;
    end


%--------Displaying Slice-------------------------------------------------


%   Function to display current slice
    function display_slice()
        cla(axViewer);
        
        if ~isempty(volumes)
            
            axesLimits = cat(2, axViewer.XLim, axViewer.YLim);
            
            slice = current_slice;
            if current_view == 1
                resize_img   = volumes{current_volume}(:,:, slice) + int16(rescaling_HU);
            elseif current_view == 2
                slice_img   = rot90(flip(squeeze(volumes{current_volume}(slice,:, :)) + int16(rescaling_HU), 1), 3);
                new_z       = ((dimZ * sliceThickness) / pixelSpacing(1,1));
                resize_img  = imresize(slice_img, [new_z, dimX], 'bicubic');
            else
                slice_img   = rot90(flip(squeeze(volumes{current_volume}(:,slice, :)) + int16(rescaling_HU), 1), 3);
                new_z       = ((dimZ * sliceThickness) / pixelSpacing(1,1));
                resize_img  = imresize(slice_img, [new_z, dimY], 'bicubic');           
            end
            
            imshow(resize_img, window, 'Parent', axViewer);
            
            if axesLimits ~= 0
                axViewer.XLim = axesLimits(1:2);
                axViewer.YLim = axesLimits(3:4);
            end
            
            
            series_description = infos{current_volume}.SeriesDescription;
            series_description = replace(series_description, '_', ' ');
            series_description = extractAfter(series_description, 'S3');
            ww = (window(2) - window(1));
            wc = window(1) + ww / 2;
            title(axViewer, sprintf('Phase: %s, Slice: %d, Window: [C: %d, W: %d]', series_description, current_slice, wc, ww));
            
            % Check if segmentation toggle is activated
            if segmentation_radio.Value == 1 && ~isempty(volumes_nifti)
                hold on;
                segmented_slice = volumes_nifti{current_volume}(:,:,current_slice);
                % Create a binary mask excluding the background label (0)
                mask = segmented_slice ~= 0;
                colored_segmentation = label2rgb(segmented_slice, 'hsv', 'k', 'shuffle');
                h = imshow(colored_segmentation);
                set(h, 'AlphaData', mask * 0.5);
                hold off;
            end
            
        else
            title(axViewer, 'No volumes loaded');
        end
    end

    function cineMode()
        n_phases = numel(volumes);
        
        while(spacebar_pressed == true)
            new_volume = current_volume + 1;
            % Ensure volume index stays within range
            if new_volume > n_phases
                new_volume = 0;
            end
            
            new_volume = min(max(new_volume, 1), numel(volumes));
            
            if new_volume ~= current_volume
                current_volume = new_volume;
                display_slice;
            end
            pause(0.25);
        end
    end

% ----- Actual call back functions-------------------------------


    % Callback function for scrollbar
    function scroll_slice(src, ~)
        current_slice = round(src.Value);
        display_slice();
    end

    % Callback function for key press
    function key_press(~, event)
        switch event.Key
            case 'shift'
                disp("Zoom on");
                zoom on;
                hManager = uigetmodemanager(viewer);
                try
                    set(hManager.WindowListenerHandles, 'Enable', 'off');  % HG1
                catch
                    [hManager.WindowListenerHandles.Enabled] = deal(false);  % HG2
                end
                set(viewer, 'WindowKeyPressFcn', []);
                set(viewer, 'KeyPressFcn', @key_press);
                set(viewer, 'WindowKeyPressFcn', []);
                set(viewer, 'KeyReleaseFcn', @key_release);

            case 'space'
                if ~spacebar_pressed
                    spacebar_pressed = true;
                    cineMode();
                end

            case 'escape'
                axis(axViewer, 'auto');
                display_slice;
                
        end
    end

    % Callback function for key release
    function key_release(~, event)
        switch event.Key
            case 'shift'
                disp("Zoom off");
                zoom off;
            case 'space'
                spacebar_pressed = false;
            otherwise
                % Handle other key releases if needed
        end
    end
    
    % Callback function for mouse wheel scrolling
    function scroll_wheel(~, event)
        % Scroll through slices
        new_value = round(scrollbar.Value - event.VerticalScrollCount);
        % Ensure scrollbar value stays within range
        new_value = min(max(new_value, 1), num_slices);
        scrollbar.Value = new_value;
        scroll_slice(scrollbar, []);
    end


    function measurement_clicked(src, ~)
%         measure_figure = createMeasurementFigure();
        axViewer = gca;
        measurement = MeasurementClass(axViewer, pixelSpacing);
        
        setFocusToFigure(measurement.Figure1, src);
    end

    
end


