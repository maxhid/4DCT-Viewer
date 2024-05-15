function [volumes, infos, nifti, niiInfo, originalOrientation] = select_folders(main_folder, readNifti)
% Select Folders
% This function prompts the user to select a folder and loads DICOM volumes from
% specific subfolders within the selected directory.
%
% Outputs:
%   volumes: A cell array containing DICOM volumes loaded from each selected subfolder.
%   infos: A cell array containing information about each DICOM volume.
%   nifti: A cell array containing NIfTI format data of the loaded volumes.
%   niiInfo: A cell array containing additional information about the NIfTI volumes.
%   originalOrientation: A cell array containing orientation information for each loaded volume.
%
% Usage:
% [volumes, infos, nifti, niiInfo, originalOrientation] = select_folders();


% List all subfolders within the selected folder
subfolders = dir(main_folder);
subfolders = subfolders([subfolders.isdir]); % Keep only directories
%         num_subfolders = numel(subfolders);
%         phasefolders = cell(1, numel(1, 10));

count = 0;
phasefolders = repmat(subfolders(1), 1, 10);
for i = 1:numel(subfolders)
   if contains(subfolders(i).name, '_Atmungsbewegung') && contains(subfolders(i).name, '_3.00')
       if contains(subfolders(i).name, 't-MaxIP')
           continue;
       end
       count = count + 1;
       phasefolders(count) = subfolders(i);
   end
end


phasefolders = sortPhases(phasefolders);
num_phasefolders = numel(phasefolders);
% Preallocate volumes cell array
volumes = cell(num_phasefolders, 1);
infos = cell(num_phasefolders, 1);
originalOrientation = cell(num_phasefolders, 1);

if readNifti == true
    nifti   = cell(num_phasefolders, 1);
    niiInfo = cell(num_phasefolders, 1);
else
    nifti   = 0;
    niiInfo = 0;
end


% Load volumes in parallel
for i = 1:num_phasefolders
    [volumes{i}, infos{i}, ~, ~] = read_dicom_folder(fullfile(main_folder, phasefolders(i).name), readNifti);
    originalOrientation{i} = eye(3);
end

% % Create parallel computing job
% tic
% futures = cell(1, num_phasefolders);
% futures(numel(num_phasefolders), 1) = parallel.FevalFuture;
% for i = 1:num_phasefolders
%     futures(i) = parfeval(@read_dicom_folder, 4, fullfile(main_folder, phasefolders(i).name), rescaling_HU,readNifti);
% end
% 
% % Retrieve results as they become available
% for i = 1:num_phasefolders
%     [volumes{i}, ~, ~, ~] = fetchOutputs(futures(i));
%     originalOrientation{i} = eye(3);
% end
% toc
end