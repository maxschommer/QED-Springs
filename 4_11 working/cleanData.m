function data = cleanData(data)
    data(:,1) = data(:,1)-data(100,1);
    for i = 2:6
        data(:,i) = data(:,i)-mean(data(7:20,i));
    end
    
    data = data(150:300,:);
end