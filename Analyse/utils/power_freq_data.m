function [data,nb_pts_trial] = power_freq_data(FCK_LOCKED_IC_JYOTIKA, high_beta, low_beta, sub_ind, window, idxs)
%FREQ BAND IDXS get idx of the frequence band center

high_closes_idx = [];
low_closes_idx = [];
for i=1:4
    freq = FCK_LOCKED_IC_JYOTIKA{sub_ind,i}.freq;
    high_freq_band_center = high_beta(sub_ind,i);
    low_freq_band_center = low_beta(sub_ind, i);
    [minValue_high,closestIndex_high] = min(abs(freq - high_freq_band_center));
    [minValue_low,closestIndex_low] = min(abs(freq - low_freq_band_center));
    high_closes_idx = [high_closes_idx closestIndex_high];
    low_closes_idx = [low_closes_idx closestIndex_low];
end

high_freq_band_IC1 = high_closes_idx(1) - window : high_closes_idx(1) + window;
high_freq_band_IC2 = high_closes_idx(2) - window : high_closes_idx(2) + window;
high_freq_band_IC3 = high_closes_idx(3) - window : high_closes_idx(3) + window;
high_freq_band_IC4 = high_closes_idx(4) - window : high_closes_idx(4) + window;

low_freq_band_IC1 = low_closes_idx(1) - window : low_closes_idx(1) + window;
low_freq_band_IC2 = low_closes_idx(2) - window : low_closes_idx(2) + window;
low_freq_band_IC3 = low_closes_idx(3) - window : low_closes_idx(3) + window;
low_freq_band_IC4 = low_closes_idx(4) - window : low_closes_idx(4) + window;


pow_all_freq_IC1 = FCK_LOCKED_IC_JYOTIKA{sub_ind,1}.ALL_FREQ_power_20Hz;
pow_all_freq_IC2 = FCK_LOCKED_IC_JYOTIKA{sub_ind,2}.ALL_FREQ_power_20Hz;
pow_all_freq_IC3 = FCK_LOCKED_IC_JYOTIKA{sub_ind,3}.ALL_FREQ_power_20Hz;
pow_all_freq_IC4 = FCK_LOCKED_IC_JYOTIKA{sub_ind,4}.ALL_FREQ_power_20Hz;

ind_nan_1 = find(isnan(pow_all_freq_IC1));
ind_nan_2 = find(isnan(pow_all_freq_IC2));
ind_nan_3 = find(isnan(pow_all_freq_IC3));
ind_nan_4 = find(isnan(pow_all_freq_IC4));

pow_all_freq_IC1(ind_nan_1) = 0;
pow_all_freq_IC2(ind_nan_2) = 0;
pow_all_freq_IC3(ind_nan_3) = 0;
pow_all_freq_IC4(ind_nan_4) = 0;

data = [];
for t = 1: length(idxs)

    pow_all_freq_t_IC1 = squeeze(pow_all_freq_IC1(t,:,:));
    pow_all_freq_t_IC2 = squeeze(pow_all_freq_IC2(t,:,:));
    pow_all_freq_t_IC3 = squeeze(pow_all_freq_IC3(t,:,:));
    pow_all_freq_t_IC4 = squeeze(pow_all_freq_IC4(t,:,:));


    high_mean_IC1 = mean(pow_all_freq_t_IC1(high_freq_band_IC1,:));
    high_mean_IC2 = mean(pow_all_freq_t_IC1(high_freq_band_IC2,:));
    high_mean_IC3 = mean(pow_all_freq_t_IC1(high_freq_band_IC3,:));
    high_mean_IC4 = mean(pow_all_freq_t_IC1(high_freq_band_IC4,:));

    low_mean_IC1 = mean(pow_all_freq_t_IC1(low_freq_band_IC1,:));
    low_mean_IC2 = mean(pow_all_freq_t_IC1(low_freq_band_IC2,:));
    low_mean_IC3 = mean(pow_all_freq_t_IC1(low_freq_band_IC3,:));
    low_mean_IC4 = mean(pow_all_freq_t_IC1(low_freq_band_IC4,:));

    data = [data; [transpose(high_mean_IC1), transpose(low_mean_IC1), transpose(high_mean_IC2), transpose(low_mean_IC2), transpose(high_mean_IC3), transpose(low_mean_IC3), transpose(high_mean_IC4), transpose(low_mean_IC4)]];
end



[f,nb_pts_trial] = size(pow_all_freq_t_IC1);



end

