function [baseline_trials, nb_trials, baseline_trials_idxs] = target_baseline(tp,sub_ind)
%TARGET TREATMENT select baseline target
%   Y: values 

%tp = num2str(FCK_LOCKED_IC_JYOTIKA{sub_ind,1}.trialinfo);
tp = [str2num(tp(:,1)), str2num(tp(:,2))];

%% Keep baseline trials
baseline_trials_idxs = find(tp(:,2) == 5);
baseline_trials = tp(baseline_trials_idxs, 1);

nb_trials = size(baseline_trials,1);

end

