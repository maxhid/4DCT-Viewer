function [newImg3D, newOrientation] = changeOrientation(data_3D, info, currentOrientation, view) 
    % Change Orientation
    % This function transforms a 3D image dataset to a different orientation based on the desired view.
    %
    % Inputs:
    %   data_3D: The 3D image dataset.
    %   info: Information about the image dataset.
    %   currentOrientation: The current orientation of the dataset.
    %   view: The desired view to which the dataset should be transformed. 
    %         1: Axial, 2: Coronal, 3: Sagittal
    %
    % Outputs:
    %   newImg3D: The transformed 3D image dataset.
    %   newOrientation: The new orientation of the transformed dataset.
    %
    % Usage:
    % [newImg3D, newOrientation] = changeOrientation2(data_3D, info, currentOrientation, view);  

    
    % MH: TODO -> Major performance problem
    % Immer noch nicht die beste Lösung
    
    if contains(info.Filename, '.nii')
        sliceThickness = info.PixelDimensions(3);
        pixelSpacing = info.PixelDimensions(1:2)';
        interpolation = 'nearest';
    else
        sliceThickness = info.SliceThickness;
        pixelSpacing = info.PixelSpacing;
        interpolation = 'bicubic';
    end
    
    %{
%     try 
%         sliceThickness = info.SliceThickness;
%         interpolation = 'bicubic';
%     catch
%         warning('Undefinded.');
%         sliceThickness = 3;
%         interpolation = 'nearest';
%     end
%     
%     try
%         pixelSpacing = info.PixelSpacing;
%     catch
%         warning('undefinded');
%         pixelSpacing = [1.1713; 1.1713];
%     end
    %}
        
    
    % Define orientation matrices
    axialOrientation = eye(3);
    coronalOrientation = [0 0 1; 0 1 0; 1 0 0];
    sagittalOrientation = [0 1 0; 0 0 1; 1 0 0];

    
    
    % Perform transformation based on the desired view
    switch view
        case 1 % Axial
            if isequal(currentOrientation, coronalOrientation)
                [z, x, ~] = size(data_3D);
                new_z = round((z * pixelSpacing(1,1)) / sliceThickness);
                newImg3D = permute(imresize(data_3D, [new_z, x] , interpolation), [3, 2, 1]);
%                 newImg3D = permute(newImg3D, [3, 2, 1]);
            elseif isequal(currentOrientation, sagittalOrientation)
                [z, y, ~] = size(data_3D);
                new_z = round((z * pixelSpacing(2,1)) / sliceThickness);
%                 newImg3D = imresize(data_3D,[new_z, y], interpolation);
                newImg3D = permute(imresize(data_3D, [new_z, y], interpolation), [2, 3, 1]);
%                 newImg3D = permute(newImg3D, [2, 3, 1]);
            else
                newImg3D = data_3D;
            end
            newOrientation = axialOrientation;
            
        case 2 % Coronal
            if isequal(currentOrientation, axialOrientation)
                [~, x, z] = size(data_3D);
                new_z = ((z * sliceThickness) / pixelSpacing(1,1));
%                 newImg3D = permute(data_3D, [3, 2, 1]);
%                 newImg3D = imresize(newImg3D,[new_z, x], interpolation);
                newImg3D = imresize(permute(data_3D, [3, 2, 1]), [new_z, x], interpolation);
            elseif isequal(currentOrientation, sagittalOrientation)
                newImg3D = permute(data_3D, [1, 3, 2]);
            else
                newImg3D = data_3D;
            end
            newOrientation = coronalOrientation;
            
        case 3 % Sagittal
            if isequal(currentOrientation, axialOrientation)
                [y, ~, z] = size(data_3D);
                new_z = ((z * sliceThickness) / pixelSpacing(2,1));
%                 newImg3D = permute(data_3D, [3, 1, 2]);
%                 newImg3D = imresize(newImg3D,[new_z, y], interpolation);
                newImg3D = imresize(permute(data_3D, [3, 1, 2]),[new_z, y], interpolation);
            elseif isequal(currentOrientation, coronalOrientation)
                newImg3D = permute(data_3D, [1, 3, 2]);
            else
                newImg3D = data_3D;
            end
            newOrientation = sagittalOrientation;
    end
    
end