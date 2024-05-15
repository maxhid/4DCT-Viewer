function phasefolders = sortPhases(phasefolders)
    % Sort Phases
    % This function sorts the phase folders based on the percentage indicated in their names.
    %
    % Inputs:
    %   phasefolders: Array of structures representing phase folders.
    %
    % Outputs:
    %   phasefolders: Sorted array of structures representing phase folders.
    %
    % Usage:
    % phasefolders = sortPhases(phasefolders);
    
    % Extract and sort based on the last two characters
    percentages = zeros(numel(phasefolders), 1);
    for i = 1:numel(phasefolders)
        folder_name = phasefolders(i).name;
        % Find the position of "_SORT_"
        sort_idx = strfind(folder_name, '_SORT_');
        if isempty(sort_idx)
            error('No _SORT_ found in folder name');
        end
        % Extract the percentage substring
        percentage_str = folder_name(sort_idx+6:end-1); % +6 to skip "_SORT_"
        % Convert the percentage substring to numeric value
        percentages(i) = str2double(percentage_str);
    end

    % Sort phasefolders based on percentages
    [~, idx] = sort(percentages);
    phasefolders = phasefolders(idx);
end

