%%%import CSV files produced in gorilla
clear all
%Emostroop
cd C:/Users/bj273/Desktop/Gorilla_Data/
RMfile= fopen('data_exp_2817-v3_task-alqf.csv');
RM=textscan(RMfile,'%s %s %q %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %q %s %s %s %s %s %s %s','delimiter', ',')
fclose(RMfile);
RM=RM';

%correct the mistake that 'Real' is 'Displayed'

%%% important rows
% 13 = subject ID
% 36 = response eg 'Think' 'Speak' 'Displayed' 'Imagined'
% 38 = correct =>1
% 47 = display eg 'Recall_Vocalised' 'Recall_Complete'
% 51 = cond eg 'Imagined' 'Real'
% 52 = task eg 'Speak' 'Think'

% 38 should be 1 if response is 'Displayed' when cond is 'Real'

trials=12;

subjects={'s02', 's03', 's04', 's05', 's06', 's08', 's09', 's11','s12', 's13'};

displayed=find(ismember(RM{36,1},'Displayed'));
RespImagined=find(ismember(RM{36,1},'Imagined'));

%Task categories
real=find(ismember(RM{51,1},'Real'));
imagined=find(ismember(RM{51,1},'Imagined'));
spoken=find(ismember(RM{52,1},'Speak'));
thought=find(ismember(RM{52,1},'Think'));

for s=1:10
    sub=subjects(s);
    %sub='s02'
    
    idx_s = find(ismember(RM{13,1},sub));
    idx_zone = find(ismember(RM{47,1},'Recall_Vocalised'));
    idx_zone_2=find(ismember(RM{47,1},'Recall_Complete'));
    idx_time=find(ismember(RM{47,1},'Score'));
    t=1;
    a=1;
    b=1;
    c=1;
    d=1;
    
    RC=1;
    rounda=1;
    roundb=1;
    blockstart=1;
    Correct=[];
    Recall_Complete_Correct=[];
    
    
    for i=1:size(RM{1,1},1)
        %if the correct answer was 'real' and the person responded
        %'displayed', the response was correct.
        if ismember(i,displayed) && ismember ( i, real)
            RM{38,1}{i}='1';
            %If the correct answer was 'real' and the person responded
            %'imagined' the response was incorrect.
        elseif ismember(i,RespImagined) && ismember ( i, real)
            RM{38,1}{i}='0';
        end
        
        %If the trial is of the subject and the zone is Recall Vocalised,
        %save the correctness of response
        if ismember(i,idx_s) && ismember (i, idx_zone)
            Correct(t,rounda)=str2num(RM{38,1}{i});
            t=t+1;
            %if it's vocalised and the task was to speak count correctness
            if ismember(i,spoken)
                corr_spoken(a,rounda)=str2num(RM{38,1}{i});
                a=a+1;
            %count if task was to think
            elseif ismember(i,thought)
                corr_thought(b,rounda)=str2num(RM{38,1}{i});
                b=b+1;
            end
            
            if t>trials % if all the trials for day have been read in, do stats
                Recall_Vocalised(rounda)=sum(Correct(:,rounda));
                CorrSpoken(rounda)=sum(corr_spoken(:,rounda));
                CorrThought(rounda)=sum(corr_thought(:,rounda));
                rounda=rounda+1;
                t=1;
                a=1;
                b=1;
                
            end
            
            
            
        elseif ismember(i,idx_s) && ismember (i, idx_zone_2)
            Recall_Complete_Correct(RC,roundb)=str2num(RM{38,1}{i});
            RC=RC+1;
            
            %if the word was complete
            if ismember(i,real)
                corr_real(c,roundb)=str2num(RM{38,1}{i});
                c=c+1;
            %if the word was imagined
            elseif ismember(i,imagined)
                corr_imagined(d,roundb)=str2num(RM{38,1}{i});
                d=d+1;
            end
            
            if RC>trials % if all the trials for day have been read in, do stats
                Recall_Complete(roundb)=sum(Recall_Complete_Correct(:,roundb));
                CorrComplete(roundb)=sum(corr_real(:,roundb));
                CorrIncomplete(roundb)=sum(corr_imagined(:,roundb));
                roundb=roundb+1;
                RC=1;
                c=1;
                d=1;
            end
            
        end
        
        if ismember(i,idx_s) && ismember (i,idx_time)
            
            Time{blockstart}=RM{7,1}{i};
            OS{blockstart}=RM{21,1}{i};
            blockstart=blockstart+1;
        end
    end
    
    Name=strcat(sub,'_RM');
    save(Name{1},'CorrIncomplete','CorrComplete','CorrSpoken','CorrThought','Recall_Vocalised','Recall_Complete','Correct','Recall_Complete_Correct', 'Time','OS')
    %save(Name{1},'Recall_Vocalised','Recall_Complete', 'Time','OS')
    
    RT=[];
    Means=[];
    Variance=[];
    clear Time
    clear OS
    clear Correct
    clear CorrSpoken
    clear CorrThought
    clear CorrIncomplete
    clear CorrComplete
    clear Recall_Complete_Correct
    clear Recall_Complete
    clear Recall_Vocalised
end


