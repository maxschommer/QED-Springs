function data = cleanData(data)
    start = 1;
    data(:,1) = data(:,1)-data(start,1);
    for i = 2:6
        data(:,i) = data(:,i)-mean(data(7:20,i));
    end
end