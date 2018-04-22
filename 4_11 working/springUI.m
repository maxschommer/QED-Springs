 function springUI 
    width = 1;
    height = 5;
    stateInfo = load('StateInfo5M');
    stateMatrix = -1*ones(height, width);
    KExec = zeros(width, size(stateInfo.Ks, 2));
    f = figure('Visible','off');
    set(f, 'Position', [0 0 (width+1)*100 (height+1.5)*100])
    
    for i = 1:width
       for j = 1:height
        btn(i,j) = uicontrol('Style', 'togglebutton',...
        'Position', [-50+100*i 100*j 100 100],...
        'Callback', @togglebutton_Callback, 'UserData', [height-j+1,i]);
       end
    end
    
    execBtn = uicontrol('Style', 'pushbutton', ...
        'Position', [50 50 width*100 50],...
        'Callback', @execButton_Callback, 'String', 'Execute');
    
    ToggleButtons = findall(gcf,'Style','togglebutton');
    set(ToggleButtons,'Backgroundcolor','r');
    f.Visible = 'on';
    
    function execButton_Callback(~, ~, ~)
         for k = 1:width
             
             S = stateInfo.States(:, height+1:end);
             V = stateMatrix(: , k)';
             index = find(ismember(S,V,'rows'), 1, 'first'); 
             KExec(k, :) = stateInfo.Ks(index, :);
         end
         
         moveOneServo(KExec(1, :))
    end
    
    function togglebutton_Callback(hObject, eventdata, ~)
        uVal = eventdata.Source.UserData;
        if hObject.Value == 1
            stateMatrix(uVal(1), uVal(2)) = 1;
            
            set(gcbo,'Backgroundcolor','g');
        else
            
            stateMatrix(uVal(1), uVal(2)) = -1;
            set(gcbo, 'Backgroundcolor','r');
        end
    end

end