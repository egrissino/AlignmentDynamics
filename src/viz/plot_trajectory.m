function plot_trajectory(S_hist, F_hist, out_dir)
%PLOT_TRAJECTORY  Plot Security-Flexibility phase trajectory.

  figure;
  plot(S_hist, F_hist, 'LineWidth', 2);
  xlabel('Security Intensity');
  ylabel('Generative Flexibility');
  title('Security-Flexibility Phase Trajectory');
  grid on;
  saveas(gcf, fullfile(out_dir, 'Trajectory.png'));
  close(gcf);

end
