
for i=1:1:15
    
    load(strcat('/Users/kuchy/skola/diplomovka/src/prototype/results/coutrot2/AttentionSimpleLocalContrast',num2str(i),'.mat'))
    
    notNaN = isnan(AUROC_score);
    if (notNaN(length(notNaN))==1)
        AUROC_score = AUROC_score(1:length(AUROC_score)-1);
    end

    notNaN = isnan(KLDIV_score);
    if (notNaN(length(notNaN))==1)
        KLDIV_score = KLDIV_score(1:length(KLDIV_score)-1);
    end

    notNaN = isnan(NSS_score);
    if (notNaN(length(notNaN))==1)
        NSS_score = NSS_score(1:length(NSS_score)-1);
    end
    
    save(strcat('/Users/kuchy/skola/diplomovka/src/prototype/results/coutrot2/AttentionSimpleLocalContrast',num2str(i),'.mat'),'KLDIV_score','NSS_score','AUROC_score');
end