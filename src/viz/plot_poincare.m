function plot_poincare(S_hist, F_hist, out_dir)
%PLOT_POINCARE  Plot Poincare section at crossings near mean S.

  idx = find(abs(S_hist - mean(S_hist)) < 0.01);

  figure;
  plot(F_hist(idx), zeros(size(idx)), 'o');
  xlabel('Generative Flexibility');
  ylabel('');
  title('Poincare Section');
  grid on;
  saveas(gcf, fullfile(out_dir, 'Poincare.png'));
  close(gcf);

end
