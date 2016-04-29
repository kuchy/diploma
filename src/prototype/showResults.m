function showResults (dataset, numOfVideos)
    path = strcat('results/',dataset,'/');
    listing = dir(path{1});
    tests = {};
   

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
        
        notNaN = ~isnan(data.AUROC_score);
        data.AUROC_score(~notNaN) = 0;
        
        notNaN = ~isnan(data.NSS_score);
        data.NSS_score(~notNaN) = 0;
        
        notNaN = ~isnan(data.KLDIV_score);
        data.KLDIV_score(~notNaN) = 0;

    %     calculate and save frame average
        average.AUROC_score = mean(data.AUROC_score);
        average.NSS_score = mean(data.NSS_score);
        average.KLDIV_score = mean(data.KLDIV_score);
        result.(modelName).frameMean(videoNumber) = average;

    %     refresh overall average
        a=mean([result.(modelName).frameMean(:).AUROC_score]);
        result.(modelName).mean.AUROC_score = mean([result.(modelName).frameMean(:).AUROC_score]);
        result.(modelName).mean.KLDIV_score = mean([result.(modelName).frameMean(:).KLDIV_score]);
        result.(modelName).mean.NSS_score = mean([result.(modelName).frameMean(:).NSS_score]);
    end

    %% MIN/MAX definitions
    AUC_max = 1;
    AUC_min = 0.45;
    AUC_random = [0.5 0.5];
    
    NSS_max = 1.7;
    NSS_min = 0;
    
    KLDIV_max = 1.75;
    KLDIV_min = 1.5;

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
    title(strcat('Vysledok pre dataset',dataset));
    bar(1:numOfVideos, graph', 1)
    hold on
    plot(xlim, AUC_random, 'color', [0.5 0.5 0.5])
    axis([0 numOfVideos+6 AUC_min AUC_max])
    set(gca, 'XTick', 1:numOfVideos)
    xlabel('Video');
    ylabel('AUCROC');
    legend(fieldnames(result)');
    clear data;
    clear graph;

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
    title(strcat('Vysledok pre dataset',dataset));
    bar(1:numOfVideos, graph', 1)
    axis([0 numOfVideos+6 KLDIV_min KLDIV_max])
    set(gca, 'XTick', 1:numOfVideos)
    xlabel('Video');
    ylabel('KLDIV');
    legend(fieldnames(result)');
    clear data;
    clear graph;

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
    title(strcat('Vysledok pre dataset',dataset));
    bar(1:numOfVideos, graph', 1)
    axis([0 numOfVideos+6 NSS_min NSS_max])
    set(gca, 'XTick', 1:numOfVideos)
    xlabel('Video');
    ylabel('NSS');
    legend(fieldnames(result)');
    clear data;
    clear graph;
    
    %% plot global result AUCROC
    i = 1;
    for model = fieldnames(result)'   
        modelName = char(model);
        data= extractfield(result.(modelName).mean, 'AUROC_score');    
        graph(i) = data;
        i = i+1;
    end
    
    figure
    subplot(3, 1, 1)
    title(strcat('Vysledok pre dataset',dataset));
    bar(1:i-1, graph', 1)
    hold on
    plot(xlim, AUC_random, 'color', [0.5 0.5 0.5])
    axis([0 i AUC_min AUC_max])
    set(gca, 'XTick', 1:i-1, 'XTickLabel', fieldnames(result))
    ylabel('AUROC');
    clear data;
    clear graph;
    
    %% plot global result KLDIV
    i = 1;
    for model = fieldnames(result)'   
        modelName = char(model);
        data= extractfield(result.(modelName).mean, 'KLDIV_score');    
        graph(i) = data;
        i = i+1;
    end
    
    subplot(3, 1, 2)
    title(strcat('Vysledok pre dataset',dataset));
    bar(1:i-1, graph', 1)
    axis([0 i KLDIV_min KLDIV_max])
    set(gca, 'XTick', 1:i-1, 'XTickLabel', fieldnames(result))
    ylabel('KLDIV');
    clear data;
    clear graph;
    
    %% plot global result NSS
    i = 1;
    for model = fieldnames(result)'   
        modelName = char(model);
        data= extractfield(result.(modelName).mean, 'NSS_score');    
        graph(i) = data;
        i = i+1;
    end
    
    subplot(3, 1, 3)
    title(strcat('Vysledok pre dataset',dataset));
    bar(1:i-1, graph', 1)
    axis([0 i NSS_min NSS_max])
    set(gca, 'XTick', 1:i-1, 'XTickLabel', fieldnames(result))
    ylabel('NSS');
    clear data;
    clear graph;
    
    %% plot only our model by video
    
    graph = extractfield(result.hornSchunckNew.frameMean(:), 'AUROC_score');
    figure
    subplot(3, 1, 1)
    title(strcat('Vysledok pre dataset',dataset));
    bar(1:size(graph,2), graph, 1)
    hold on
    plot(xlim, AUC_random, 'color', [0.5 0.5 0.5])
    axis([0 size(graph,2)+1 AUC_min AUC_max])
    set(gca, 'XTick', 1:size(graph,2))
    ylabel('AUCROC');
    mean(graph)
    clear data;
    clear graph;
    
    graph = extractfield(result.hornSchunckNew.frameMean(:), 'KLDIV_score');
    subplot(3, 1, 2)
    title(strcat('Vysledok pre dataset',dataset));
    bar(1:size(graph,2), graph, 1)    
    axis([0 size(graph,2)+1 KLDIV_min KLDIV_max])
    set(gca, 'XTick', 1:size(graph,2))
    ylabel('KLDIV');
    clear data;
    clear graph;
    
    graph = extractfield(result.hornSchunckNew.frameMean(:), 'NSS_score');
    subplot(3, 1, 3)
    title(strcat('Vysledok pre dataset',dataset));
    bar(1:size(graph,2), graph, 1)
    axis([0 size(graph,2)+1 NSS_min NSS_max])
    set(gca, 'XTick', 1:size(graph,2))
    mean(graph)
    ylabel('NSS');
    clear data;
    clear graph;
    
    
end