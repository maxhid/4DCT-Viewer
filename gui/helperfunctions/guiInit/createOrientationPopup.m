function orientationPop = createOrientationPopup(parentNode, pos_x, pos_y, callbackFnc)
    orientationPop = uicontrol('Parent', parentNode, 'Style', 'popupmenu', 'String', {'Axial', 'Coronal', 'Sagittal'}, ...
        'Position', [pos_x, pos_y, 100, 30], 'Callback', callbackFnc);
end

