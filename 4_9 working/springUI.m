 function springUI
    width = 5;
    height = 5;
 
    f = figure('Visible','off');
    set(f, 'Position', [0 0 (width+1)*100 (height+1)*100])
    
    for i = 1:width
       for j = 1:height
        btn(i,j) = uicontrol('Style', 'togglebutton',...
        'Position', [-50+100*i -50+100*j 100 100],...
        'Callback', @togglebutton_Callback);
       end
    end
    
    ToggleButtons = findall(gcf,'Style','togglebutton');
    set(ToggleButtons,'Backgroundcolor','r');
    f.Visible = 'on';

    function togglebutton_Callback(hObject, eventdata, handles)
        if hObject.Value == 1
            set(gcbo,'Backgroundcolor','g');
        else
            set(gcbo, 'Backgroundcolor','r');
        end
    end

end