function rating_btns = createButtonsGUI(parentNode, numOfButtons, callbackFcn)
    rating_btns = cell(1, numOfButtons);
    rating_labels = {'1', '2', '3', '4', '5'};
    
    for i = 1:5
        rating_btns{i} = uicontrol('Parent', parentNode, 'Style', 'pushbutton', ...
            'String', rating_labels{i}, 'Position', [350 + (i-1)*45, 50, 45, 45], ...
            'Callback', {callbackFcn, i});
    end
end

