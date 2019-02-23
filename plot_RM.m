subjects={'s02', 's03', 's04', 's05', 's06', 's08', 's09', 's11','s12', 's13'};

for i=1:length(subjects)
    sub=subjects{i}
load ([sub '_RM.mat'])
%calculate the first 5 sessions and last 5 sessions
BegComp(i)=mean(CorrComplete(1:5))
EndComp(i)=mean(CorrComplete(end-5:end))

BegInComp(i)=mean(CorrIncomplete(1:5))
EndInComp(i)=mean(CorrIncomplete(end-5:end))

BegSpoken(i)=mean(CorrSpoken(1:5))
EndSpoken(i)=mean(CorrSpoken(end-5:end))

BegThought(i)=mean(CorrThought(1:5))
EndThought(i)=mean(CorrThought(end-5:end))
end
load ('s13_RM.mat')

%plot number 
Complete_errors=6-CorrComplete
Incomplete_errors=6-CorrIncomplete

Completeness_errors=[Complete_errors; Incomplete_errors]
plot(Completeness_errors')
figure
b=notBoxPlot(Completeness_errors')

ax = gca;

ax.XLabel.String = '';
ax.YLabel.String= '';

ax.XTickLabel ={'Complete errors','Incomplete errors'};
hold off
