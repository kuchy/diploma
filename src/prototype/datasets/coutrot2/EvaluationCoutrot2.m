
function EvaluationCoutrot2 ( ModelName )
database = load('raw_data/coutrot_database2.mat');

modelFunction = str2func(ModelName);
% todo port to loading from web
    % for each video in the database    
    for video = 5:1:15
%         if (video == 5 || video == 27 || video == 39 || video == 10 || video == 15 || video == 40 || video == 20 || video == 18  || video == 19 )
%             continue;
%         end
%         if (video == 15 || video == 10)
%             continue;
%         end

        resultName = strcat('results/coutrot2/', ModelName ,num2str(video) ,'.mat');
        if ( exist(resultName, 'file') == 2 )
            continue;
        end

    filedName = strcat('clip_',num2str(video));
    videoData = database.Coutrot_Database2.Visual.(filedName);        
    
    se = strel('ball',4,2);
    se1 = strel('rectangle',[12 2]);

    name=strcat('datasets/coutrot2/videos/clip_',num2str(video),'.mp4');
    xyloObj = VideoReader(name);
%     N_frames = xyloObj.NumberOfFrames;
    N_frames = size(videoData.data,2);
    mov = read(xyloObj, 1);
    movOld = zeros(size(mov));

    % for each frame in the video
    for frame = 1:1:N_frames-1

        disp(strcat('Video: ',num2str(video),' -- Frame: ',num2str(frame), '/', num2str(N_frames)))
        mov = read(xyloObj, frame); 

        % Raw_data Reader                
%         Clean data from NaN values
        notNaN = ~isnan(videoData.data);
        videoData.data(~notNaN) = -1;
%         Make integer from values
        videoData.data = round(videoData.data);
        Image = RawData2Image(videoData.data,frame,videoData.info.vidheight, videoData.info.vidwidth);

        Iet = imfilter(imdilate(Image,strel('disk',10)),fspecial('gaussian',60,20),'replicate');
        Iet = (Iet-min(Iet(:)))./(max(Iet(:))-min(Iet(:)));    
        level = 0.7;
        ET = im2bw(Iet,level);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%% Your saliency map %%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      % Please replace here with your own model 
      % ---------------------------------------

        switch nargin(modelFunction)
            case 1
                map = modelFunction(mov);
            case 2
                map = modelFunction(mov, movOld);
        end

      % post processing for fair evaluation
        map = imdilate(map,se);
        map = imdilate(map,se1);
        map = imfilter(map, fspecial('gaussian', [8, 8], 8));



      % Comparison metrics

                    % 1) KL-Div 

                       score = calcKLDivscore(ET,map);
                       KLDIV_score(1,frame) = mean(score);

                    % 2) NSS

                       score1 = calcNSSscore(map,ET);
                       NSS_score(1,frame) = mean(score1);

                    % 3) AUROC

                       Iet1 = reshape(Iet,size(Iet,1)*size(Iet,2),1);

                       map2 = double(imresize(map,size(Iet),'nearest'));
                       map3 = reshape(map2,size(map2,1)*size(map2,2),1);  

                       [A,Aci] = auc([Iet1,map3],0.05,'hanley');
                       AUROC_score(1,frame) = mean(A);
                       
%                        % auc mit
%                        AUC_Judd(map,ET,0,1);
                        movOld =  mov;

    end

    % for each video, the metrics score are saved in a .mat file
    % you can change the .mat name if needed
    name = strcat('results/coutrot2/', ModelName ,num2str(video) ,'.mat');
    savePfor(name, KLDIV_score , NSS_score , AUROC_score);
    

    end
end

        
   


