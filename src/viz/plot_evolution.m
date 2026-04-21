function plot_evolution(U_hist, out_dir)
%PLOT_EVOLUTION  Plot heatmap of user strategy distribution over time.

  figure;
  imagesc(U_hist');
  colorbar;
  xlabel('Time');
  ylabel('Strategy Index');
  title('Evolution of User Strategy Distribution');
  saveas(gcf, fullfile(out_dir, 'Evolution.png'));
  close(gcf);

end
