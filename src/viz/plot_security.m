function plot_security(S_hist, out_dir)
%PLOT_SECURITY  Plot security intensity over time.

  figure;
  plot(1:numel(S_hist), S_hist, 'LineWidth', 2);
  xlabel('Time');
  ylabel('Security Intensity S(t)');
  title('Monotonic Growth of Security');
  grid on;
  saveas(gcf, fullfile(out_dir, 'Growth.png'));
  close(gcf);

end
