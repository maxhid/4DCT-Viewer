function num_slices = getNumberSlices(volumes)
    % Get Number of Slices
    % This function calculates the number of slices in each volume within the provided cell array.
    %
    % Inputs:
    %   volumes: Cell array containing DICOM volumes.
    %
    % Outputs:
    %   num_slices: Cell array containing the number of slices for each volume.
    %
    % Usage:
    % num_slices = getNumberSlices(volumes);
    num_slices = cellfun(@(x) size(x, 3), volumes, 'UniformOutput', false);
end

