function plot_vector_field(S_hist, F_hist, out_dir)
%PLOT_VECTOR_FIELD  Plot phase space vector field from trajectory increments.

  dS = diff(S_hist);
  dF = diff(F_hist);

  figure;
  quiver(S_hist(1:end-1), F_hist(1:end-1), dS, dF);
  xlabel('Security');
  ylabel('Flexibility');
  title('Phase Space Vector Field');
  grid on;
  saveas(gcf, fullfile(out_dir, 'Vector.png'));
  close(gcf);

end
