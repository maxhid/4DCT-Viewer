function studyData = readJson()
    % Read JSON
    % This function reads JSON data from a file and decodes it into a MATLAB structure.
    %
    % Outputs:
    %   studyData: MATLAB structure containing the decoded JSON data.
    %
    % Usage:
    % studyData = readJson();
    
    fid = fopen('/home/heidermn/Documents/4DViewer/studyData/startup.json', 'r');
    jsonData = fread(fid, '*char')';
    fclose(fid);

    studyData = jsondecode(jsonData);
end

