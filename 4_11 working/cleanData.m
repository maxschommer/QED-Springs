function data = cleanData(data)
    data(:,1) = data(:,1)-data(1,1);
    for i = 2:6
        data(:,i) = data(:,i)-mean(data(7:20,i));
    end
    
    data = data(100:200,:);
end