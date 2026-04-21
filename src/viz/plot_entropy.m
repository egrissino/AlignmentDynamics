function plot_entropy(F_hist, out_dir)
%PLOT_ENTROPY  Plot generative flexibility (output entropy) over time.

  figure;
  plot(1:numel(F_hist), F_hist, 'LineWidth', 2);
  xlabel('Time');
  ylabel('Generative Flexibility F(t)');
  title('Entropy of Output Distribution');
  grid on;
  saveas(gcf, fullfile(out_dir, 'Entropy.png'));
  close(gcf);

end
