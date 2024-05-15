function [volume, info, niftiData, niftiInfo] = read_dicom_folder(folder,readNifti)
    % Read DICOM Folder
    % This function reads DICOM files from a specified folder and returns the volume data.
    %
    % Inputs:
    %   folder: The path to the folder containing DICOM files.
    %
    % Outputs:
    %   volume: The 3D volume data extracted from DICOM files.
    %   info: Information about the DICOM files.
    %   niftiData: NIfTI format data, if available.
    %   niftiInfo: Additional information about the NIfTI data.
    %
    % Usage:
    % [volume, info, niftiData, niftiInfo] = read_dicom_folder(folder);
    
    dicom_files = dir(fullfile(folder, '*.dcm'));
    num_slices = numel(dicom_files);

    info = dicominfo(fullfile(folder, dicom_files(1).name));
    
    % Preallocate volume array
    volume = zeros(512, 512, num_slices, 'int16');
    
%     % Read rescaling_HU once for all slices
%     rescaling_HU = info.RescaleIntercept;
%     tic
    parfor s = 1:num_slices
        volume(:,:,s) = int16(dicomread(fullfile(folder, dicom_files(s).name)));
    end
%     toc
    
    if readNifti == true
        nifti_file = dir(fullfile(folder, '*.nii'));
        if ~isempty(nifti_file)
            niiName = nifti_file.name;
            niiFile = fullfile(folder, niiName);
            niftiData = niftiread(niiFile);
            niftiInfo = niftiinfo(niiFile);
            niftiData = rot90(niftiData, 1);
            niftiData = flip(niftiData, 3);
        else
            niftiData = 0;
            niftiInfo = []; 
        end
    else
        niftiData = 0;
        niftiInfo = 0;
    end
end