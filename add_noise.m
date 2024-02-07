function noisy_signal=add_noise(v_results,noise_rate,k)
    real_signal=transpose(v_results);
    noisy_signal=real_signal+rand(1,numel(real_signal)).*real_signal*noise_rate;
    t=1:k;
    plot(t, noisy_signal, 'r.', 'MarkerSize', 10);
    hold on;
    plot(t, real_signal, 'b-', 'LineWidth', 3);
    grid on;
end
