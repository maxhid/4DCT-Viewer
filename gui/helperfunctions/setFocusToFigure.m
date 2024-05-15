function setFocusToFigure(fig, obj)
%SETFOCUSTOFIGURE Summary of this function goes here
%   Detailed explanation goes here
set(obj, 'Enable', 'off');
drawnow;
figure(fig);
pause(0.01);
set(obj, 'Enable', 'on');
end
