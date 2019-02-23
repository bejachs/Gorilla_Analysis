%%%import CSV files produced in gorilla
clear all

cd 'C:/Users/bj273/Desktop/Going Deeper/Gorilla_Data/'
HBfile= fopen('data_exp_2817-v3_task-2tre_orig.csv');
HB=textscan(HBfile,'%s %s %D %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter', ',')
fclose(HBfile);     

%% Important columns
% column 3 UTC Date
% column 8 Experiment ID
% Column 13 Participant ID
% column 30 Trial Number (eg 'Begin Task' or 'End Task')
% column 33 Zone Name
% column 35 Reaction Time
% column 36 Response
% column 48 question

subjects={'s02', 's03', 's04', 's05', 's06', 's08', 's09', 's11','s12', 's13'};

% create a new structure that only contains the relevant lines and columns

% 1 the subject
% 2 the date column 3
% 3 A column counts trial 1 to 10 (column 30)
% 4 Section is column 47 when column 36 = 'ANSWER'
% 5 the RT lines are in column 35 when column 36 = 'ANSWER'
% 6 The questions are in column 46 eg when column 36 = 'ANSWER'
% 7 the response lines are in column 36 when column 33 'Zone Name' = 'content'

% Go through subject by subject
new_idx=1;
for s=1:length(subjects)
    sub=subjects{s}
    
    for line=1:size(HB{1})
        if (ismember(HB{13}(line),sub))
            easyread{new_idx,1}=sub;
            if (ismember(HB{36}(line),'ANSWER'))
                %date
                easyread{new_idx,2}=HB{3}(line);
                %trial count
                easyread{new_idx,3}=HB{30}(line);
                %Section
                easyread{new_idx,4}=HB{47}(line);
                %RT
                easyread{new_idx,5}=HB{35}(line);
                %Questions
                easyread{new_idx,6}=HB{48}(line);
            end
            if (ismember(HB{33}(line),'content'))
               %Response
                easyread{new_idx,7}=HB{36}(line);
                new_idx=new_idx+1;
            end
        end
    end
end
easytable=cell2table(easyread, 'VariableNames',{'SubID','Date','TrialCount','Section','RT','Questions','Responses'});
writetable(easytable,'HB_easytable.csv');
%save this as a csv file

%  fid = fopen('HB_easyread.csv', 'w') ;
%  fprintf(fid, 'Date\t TrialCount\t Section\t RT\t Questions\t Responses\n') ;
%  fclose(fid) ;
 
% column 49: 
% correct = 1 
% A = sentence makes sense
% B= sentence doesn't make sense but word is related to sentence in some
% way
% C = word is made up
% D = word is related to past answer (response strategy)
% E = object is in viscinity

