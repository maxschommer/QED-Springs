function data = cleanData(D)
    data = D(1:end,:);
    data(:,1) = data(:,1)-data(1,1);
    for i = 2:4
        data(:,i) = data(:,i)-mean(data(7:20,i));
    end
end