function window = setWindow(window_parameter)
    % Set Window
    % This function sets the windowing parameters based on the specified window parameter.
    %
    % Inputs:
    %   window_parameter: String indicating the desired windowing parameter.
    %
    % Outputs:
    %   window: Array containing the window level and window width.
    %
    % Supported Window Parameters:
    %   - lung2
    %   - soft tissue
    %   - default == chest
    %   - full dynamic
    %   - abdomen
    %   - angio
    %   - bone
    %   - brain
    %   - chest == default
    %   - lung
    %
    % Usage:
    % window = setWindow(window_parameter);
    
    if nargin < 1
        window_parameter = "default";
    end
    
    if window_parameter == "lung2"
        window_level = -890;
        window_width = 2220;
    elseif window_parameter == "soft tissue"
        window_level = 20;
        window_width = 400;
    elseif window_parameter == "default"
        window_level = 40;
        window_width = 400;
    elseif window_parameter == "full dynamic"
        window_level = 29;
        window_width = 2145;
    elseif window_parameter == "abdomen"
        window_level = 60;
        window_width = 400;
    elseif window_parameter == "angio"
        window_level = 300;
        window_width = 600;
    elseif window_parameter == "bone"
        window_level = 300;
        window_width = 1500;
    elseif window_parameter == "brain"
        window_level = 40;
        window_width = 80;
    elseif window_parameter == "chest"
        window_level = 40;
        window_width = 400;
    elseif window_parameter == "lung"
        window_level = -600;
        window_width = 1200;
    else
        window_level = 40;
        window_width = 400;
    end
    
        
    disp_low = window_level - (window_width / 2);
    disp_high = window_level + (window_width / 2);
    window = [disp_low,  disp_high];
end