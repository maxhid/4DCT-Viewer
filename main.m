%%initial setup
clc 
clear
close all
addpath 'gui'
addpath 'gui/helperfunctions'
addpath 'gui/helperfunctions/guiInit'
addpath 'gui/measurements'
addpath 'gui/measurements/guiInits'


%% open file

% Check if a parallel pool already exists
existing_pool = gcp('nocreate');

if isempty(existing_pool)
    % If no pool exists, start a new one
    poolobj = parpool('local', 6);
else
    % If a pool already exists, display a message or take any necessary action
    disp('A parallel pool is already active.');
end

volume_viewer();