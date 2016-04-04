function showResults (dataset)
    path = strcat('results/',dataset,'/');
    listing = dir(path{1});
    tests = {};
    
    numOfVideos = 24;

    %% remove system files
    testNumber = 1;
    % clear system files begining with dot
    for fileIndex=1:1:size(listing,1)
        filename = listing(fileIndex).name;
        if (~strcmp(filename(1),'.'))
           tests{testNumber}=filename;
           testNumber = testNumber+1;
        end
    end

    %% load data
    result = {};
    % get data from all tests
    for i=1:1:size(tests,2)
        videoNumber = str2double(regexp(char(tests(i)),'[0-9]+','match'));
        modelName = regexp(char(tests(i)),'[a-zA-z]+','match');
        modelName = modelName(1);
        modelName = sprintf('%s', modelName{:});

        data = load(fullfile(path{1},char(tests(i))));
        result.(modelName).data(videoNumber) = data;

    %     calculate and save frame average
        average.AUROC_score = mean(data.AUROC_score);
        average.NSS_score = mean(data.NSS_score);
        average.KLDIV_score = mean(data.KLDIV_score);
        result.(modelName).frameMean(videoNumber) = average;

    %     refresh overall average
        result.(modelName).mean.AUROC_score = mean([result.(modelName).frameMean(:).AUROC_score]);
        result.(modelName).mean.KLDIV_score = mean([result.(modelName).frameMean(:).KLDIV_score]);
        result.(modelName).mean.NSS_score = mean([result.(modelName).frameMean(:).NSS_score]);
    end

    %% plot AUROC_score
    i = 1;
    for model = fieldnames(result)'
    %     videos = size(result.(model).frameMean,2); 
        modelName = char(model);
        data= extractfield(result.(modelName).frameMean(:), 'AUROC_score');    
        graph(i,:) = data(:);
        i = i+1;
    end
    figure
    subplot(3, 1, 1)
    title('Results for selected Dataset');
    bar(1:numOfVideos, graph', 1)
    axis([0 numOfVideos+5 0 1])
    set(gca, 'XTick', 1:numOfVideos)
    xlabel('Video');
    ylabel('Score of AUROC_score');
    legend(fieldnames(result)');
    clear data

    %% plot KLDIV_score
    i = 1;
    for model = fieldnames(result)'
    %     videos = size(result.(model).frameMean,2);    
        modelName = char(model);
        data= extractfield(result.(modelName).frameMean(:), 'KLDIV_score');    
        graph(i,:) = data(:);
        i = i+1;
    end
    subplot(3, 1, 2)
    title('Results for selected Dataset');
    bar(1:numOfVideos, graph', 1)
    axis([0 numOfVideos+5 0 3])
    set(gca, 'XTick', 1:numOfVideos)
    xlabel('Video');
    ylabel('Score of KLDIV_score');
    legend(fieldnames(result)');
    clear data

    %% plot NSS_score
    i = 1;
    for model = fieldnames(result)'
    %     videos = size(result.(model).frameMean,2);    
        modelName = char(model);
        data= extractfield(result.(modelName).frameMean(:), 'NSS_score');    
        graph(i,:) = data(:);
        i = i+1;
    end

    % Show graph
    subplot(3, 1, 3)
    title('Results for selected Dataset');
    bar(1:numOfVideos, graph', 1)
    axis([0 numOfVideos+5 -0.8 3])
    set(gca, 'XTick', 1:numOfVideos)
    xlabel('Video');
    ylabel('Score of NSS_score');
    legend(fieldnames(result)');
end