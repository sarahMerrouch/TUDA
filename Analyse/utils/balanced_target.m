function [balanced_idxs, nb_trials] = balanced_target(baseline_trials)
%BALANCED TARGET find minority class
% randomly keep as many elements of the majority class as there are in the minority class 

%% Balance target data
success = find(baseline_trials(:,1) == 1);
failure = find(baseline_trials(:,1) == 2);

min_elements = min(length(failure),length(success));

%% keep some idxs from success element
if length(failure) < length(success)
    disp('I have more success than failure : keep some success only');
    count = 0;
    elements_to_keep = [];
    while count < min_elements
        idx = randsample(success, 1);
        if any(elements_to_keep(:) == idx) == 0
            count = count + 1;
            elements_to_keep = [elements_to_keep, idx];
        end
    end 
    balanced_idxs = cat(1, failure, transpose(elements_to_keep));
    
%% keep some idxs from failure element    
else
    disp('I have more failure than sucess : keep some failure only');
    count = 0;
    elements_to_keep = [];
    while count < min_elements
        idx = randsample(failure, 1);
        if any(elements_to_keep(:) == idx) == 0
            count = count + 1;
            elements_to_keep = [elements_to_keep idx];

        end
    end
    balanced_idxs = cat(1, success ,transpose(elements_to_keep));
end   

nb_trials = size(balanced_idxs,1);

end

