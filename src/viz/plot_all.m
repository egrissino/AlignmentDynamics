function plot_all(U_hist, S_hist, F_hist, out_dir)
%PLOT_ALL  Generate all simulation visualizations and save to out_dir.
%
%   plot_all(U_hist, S_hist, F_hist, out_dir)

  if ~exist(out_dir, 'dir')
    mkdir(out_dir);
  end

  plot_security(S_hist, out_dir);
  plot_entropy(F_hist, out_dir);
  plot_trajectory(S_hist, F_hist, out_dir);
  plot_evolution(U_hist, out_dir);
  plot_phase3d(S_hist, F_hist, out_dir);
  plot_vector_field(S_hist, F_hist, out_dir);
  plot_poincare(S_hist, F_hist, out_dir);

end
