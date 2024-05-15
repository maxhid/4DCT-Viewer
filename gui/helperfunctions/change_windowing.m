function window = change_windowing(windowing_popup)
    % Change Windowing
    % This function changes the windowing settings based on the selected option.
    %
    % Inputs:
    %   windowing_popup: Handle to the popup menu containing windowing options.
    %
    % Outputs:
    %   window: Updated windowing settings.
    %
    % Supported Windowing Options:
    %   - standard
    %   - full dynamic
    %   - abdomen
    %   - angio
    %   - bone
    %   - brain
    %   - chest
    %   - lung
    %
    % Usage:
    % window = change_windowing(windowing_popup);
    windowing_options =  {'standard', 'full dynamic', 'abdomen', 'angio', 'bone', 'brain', 'chest', 'lung'};
    selected_option = windowing_options{get(windowing_popup, 'Value')};
    window = setWindow(selected_option);
%     disp(['Windowing setting changed to: ', selected_option]);
end
