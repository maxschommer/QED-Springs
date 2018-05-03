function dampingExploration()
    init = [0,0,0,0,0,1,0,0,0,0];
    damp = 0;

    data = cleanData(csvread('output.csv'));

    f = figure(1);
    ax = axes('Parent',f,'position',[0.13 0.39  0.77 0.54]);
    [T,X] = runOde([],zeros(1,10),'damp',damp,'init',init);
    plot(T,X)
    
    b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
              'value',damp, 'min',-1, 'max',1);

    b.Callback = @(es,ed) update(es); 


    function update(es)
        [T,X] = runOde([],zeros(1,10),'damp',es.Value,'init',init);
        cla(ax)
        hold on
        plot(T+4.7,X(:,6)*-50)
        plot(data(:,1),data(:,2))
        
    end


end