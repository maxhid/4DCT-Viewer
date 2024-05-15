function metaData = createMetaData(exam_info)
    % Create Metadata
    % This function manages the creation and loading of metadata for exam information.
    %
    % Inputs:
    %   exam_info: Structure containing information about the exam.
    %
    % Outputs:
    %   metaData: Metadata structure containing information about the exam.
    %
    % Usage:
    % metaData = createMetaData(exam_info);
    
    % Check if the directory for metadata exists, if not, create it
    if ~exist('/home/heidermn/Documents/4DViewer/resultsData', 'dir')
        mkdir('metadata');
    end
    
    field_names = fieldnames(exam_info);
    exam_info1 = exam_info.(field_names{1});

    
    % Check if a file for the examiner ID already exists
    filename = sprintf('metadata/rater_%s.json', exam_info1.id);
    if exist(filename, 'file')
        % Load existing metadata
        fid = fopen(filename, 'r');
        jsonData = fread(fid, '*char')';
        fclose(fid);
        metaData = jsondecode(jsonData);
    else
        % Create new metadata
        metaData                    = struct();
        metaData.id                 = exam_info1.id;
        metaData.studydescription   = exam_info1.studydescription;
        metaData.orientation        = exam_info1.orientation;
        metaData.cases              = exam_info1.cases;
        metaData.ratings            = {};
        % Add any other metadata fields as needed
    end
end

