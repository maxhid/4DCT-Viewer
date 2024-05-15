function scrollbar = updateScrollbar(scrollbar, num_slices)
%UPDATESCROLLBAR Summary of this function goes here
    set(scrollbar, 'Max', num_slices);
    % Optionally, update SliderStep if needed
    set(scrollbar, 'SliderStep', [1/(num_slices-1) 10/(num_slices-1)]);
    set(scrollbar, 'Value', floor(num_slices / 2));
end
