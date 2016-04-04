
meanAUC = [];
meanKLDIV = [];
meanNSS = [];

for video = 1:1:60
    
%     name = strcat('hornSchunckNew',num2str(video),'.mat');
%     if ( exist(name, 'file') == 2 )
%        load(name);
%        meanAUC(size(meanKLDIV,2)+1) = mean(AUROC_score);
%        meanKLDIV(size(meanKLDIV,2)+1) = mean(KLDIV_score);
%        meanNSS(size(meanNSS,2)+1) = mean(NSS_score);
%     end
   
%     REMOVING unused dimensions
    name = strcat('FES',num2str(video),'.mat');
    if ( exist(name, 'file') ~= 2 )
            continue;
    end
    
    load(name);
    AUROC_score = AUROC_score(1,:);
    KLDIV_score = KLDIV_score(1,:);
    NSS_score = NSS_score(1,:);
    
    newName = strcat('FES',num2str(video),'.mat');
    save(newName,'KLDIV_score','NSS_score','AUROC_score');
%     
%     clear AUROC_score;
%     clear KLDIV_score;
%     clear NSS_score;
end 
% disp('AUC')
% mean(meanAUC)
% disp('KLDIV')
% mean(meanKLDIV)
% disp('NSS')
% mean(meanNSS)
