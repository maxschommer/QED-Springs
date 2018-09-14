function loadingBar(percentage, varargin)
    p = inputParser;
    addRequired(p,'percentage');
    addParameter(p, 'title', 'Loading...');
    addParameter(p, 'length', 40);
    parse(p, percentage, varargin{:});

    title = p.Results.title;
    length = p.Results.length;
    
    disp(title)
    disp(strcat('<', repmat('*', [1, round(length*(percentage))]),...
        repmat('_', [1, round(length*(1-(percentage)))]), '>'))
end