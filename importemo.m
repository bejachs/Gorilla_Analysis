%%%import CSV files produced in gorilla 
clear all
%Emostroop
cd C:/Users/bj273/Desktop/Gorilla_Data/
emofile= fopen('data_exp_2817-v3_task-xqmz.csv');
Emo=textscan(emofile,'%s %s %q %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %q %s','delimiter', ',')
%Emo=textscan(emofile,'%s %s %q %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %q %s','HeaderLines',1,'delimiter', ',')

fclose(emofile);
%transpose structure because matlab is weird
Emo=Emo';

%%%%Important cells
%%13 Participant name 's02', 's03', 's04', 's05', 's06', 's08', 's09', 's11',
%%'s12', 's13'
%%07 Timestamp
%%30 Trial Number 'BEGIN TASK' 1... 'END TASK'
%%34 Zone type 'response_markdown'
%%35 Reaction Time
%%36 Response
%%38 Correct =1
%%49 answer (correct answer 'Happy' 'Sad')
%%51 condition ('Con' 'Incon-n' 'Incon'e')

trials=20;
subjects={'s02', 's03', 's04', 's05', 's06', 's08', 's09', 's11','s12', 's13'};

RT_H_C=[];

for s=1:10
    
    sub=subjects(s);
    %find all lines of current subject
    idx_s = find(ismember(Emo{13,1},sub));
    idx_zone = find(ismember(Emo{34,1},'response_markdown'));
    idx_time=find(ismember(Emo{30,1},'20'));
    idx_happy=find(ismember(Emo{49,1},'Happy'));
    idx_sad=find(ismember(Emo{49,1},'Sad'));
    idx_con=find(ismember(Emo{51,1},'Con'));
    idx_incon_n=find(ismember(Emo{51,1},'Incon-n'));
    idx_incon_e=find(ismember(Emo{51,1},'Incon-e'));
    
    t=1;
    round=1;
    blockstart=1;
    for i=1:size(Emo{1,1},1)
        if ismember(i,idx_s) && ismember (i,idx_zone)
            RT(t,round)=str2num(Emo{35,1}{i});
            
            %create a Matrix for happy or Sad correct response condition
            HorS{t,round}=(Emo{49,1}{i});
            
            %create a Matrix for Congruent etc
            Contype{t,round}=(Emo{51,1}{i});
            %for each experiment day select the different types
            t=t+1;
            %select_Happy
           
            if ismember (i, idx_happy)
                %select happy congruent
                RT_H_C=[RT_H_C str2num(Emo{35,1}{i})];
            end
            if t>trials % if all the trials for day have been read in, do stats
                Means(round)=mean(RT(:,round));
                M_RT_H_C(round)=mean(RT_H_C);
                Variance(round)=var(RT(:,round));
                round=round+1;
                t=1;
                RT_H_C=[];
            elseif strcmp(Emo{30,1}{i+2},'BEGIN TASK')
                t=1;

            end
        end;
        %Need to only save time and OS if task is completed
        if ismember(i,idx_s) && ismember (i,idx_time) && ismember(i,idx_zone)
            
            Time{blockstart}=Emo{7,1}{i};
            OS{blockstart}=Emo{21,1}{i};
            blockstart=blockstart+1;
        end
        
    end
    Name=strcat(sub,'_emo');
    save(Name{1},'Means','Variance', 'Time','RT','OS','HorS','Contype')
    RT=[];
    Means=[];
    Variance=[];
    clear Time
    clear OS
    clear M_RT_H_C
    clear Contype
    clear HorS
end


