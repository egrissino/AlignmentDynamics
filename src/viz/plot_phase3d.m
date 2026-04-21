function plot_phase3d(S_hist, F_hist, out_dir)
%PLOT_PHASE3D  Plot 3D phase trajectory (Security, Flexibility, Time).

  T = numel(S_hist);
  figure;
  plot3(S_hist, F_hist, (1:T)', 'LineWidth', 2);
  xlabel('Security');
  ylabel('Flexibility');
  zlabel('Time');
  title('3D Phase Trajectory');
  grid on;
  saveas(gcf, fullfile(out_dir, 'Phase3D.png'));
  close(gcf);

end
