clc;
clear;

load('result.mat')

load('coutrot_AUCROC.mat')
resultM(1,:) = graph;
load('coutrot2_AUCROC.mat')
resultM(2,:) = graph;
load('ACCV2012_database_AUCROC.mat')
resultM(3,:) = graph;
ResultGraph = mean(resultM);

AUC_random = [0.5 0.5];
figure;
subplot(3, 1, 1)
title(strcat('celkovy vysledok benchmarku'));
bar(1:7, graph', 1)
hold on
plot(xlim, AUC_random, 'color', [0.5 0.5 0.5])
axis([0 8 0 1])
set(gca, 'XTick', 1:7, 'XTickLabel', fieldnames(result))
ylabel('AUCROC');
clear data;
clear graph;
clear resultM;

load('coutrot_KLDIV.mat')
resultM(1,:) = graph;
load('coutrot2_KLDIV.mat')
resultM(2,:) = graph;
load('ACCV2012_database_KLDIV.mat')
resultM(3,:) = graph;
ResultGraph = mean(resultM);

subplot(3, 1, 2)
title(strcat('celkovy vysledok benchmarku'));
bar(1:7, graph', 1)
axis([0 8 1.45 1.65])
set(gca, 'XTick', 1:7, 'XTickLabel', fieldnames(result))
ylabel('KLDIV');
clear data;
clear graph;
clear resultM;

load('coutrot_NSS.mat')
resultM(1,:) = graph;
load('coutrot2_NSS.mat')
resultM(2,:) = graph;
load('ACCV2012_database_NSS.mat')
resultM(3,:) = graph;
ResultGraph = mean(resultM);

subplot(3, 1, 3)
title(strcat('celkovy vysledok benchmarku'));
bar(1:7, graph', 1)
axis([0 8 0 1.2])
set(gca, 'XTick', 1:7, 'XTickLabel', fieldnames(result))
ylabel('NSS');
clear data;
clear graph;