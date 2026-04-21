function U = mutation_step(U, t, noise_init, noise_decay_rate)
%MUTATION_STEP  Inject decaying random noise to model novel strategies.
%
%   U = mutation_step(U, t, noise_init, noise_decay_rate)
%
%   Noise decays exponentially with time, representing diminishing
%   rates of novel strategy emergence as the system matures.
%
%   Arguments:
%     U                - (1 x N) current user strategy distribution
%     t                - current time step
%     noise_init       - initial noise magnitude
%     noise_decay_rate - exponential decay rate for noise
%
%   Returns:
%     U - (1 x N) updated strategy distribution (still on simplex)

  noise_decay = noise_init * exp(-noise_decay_rate * t);
  U = U + noise_decay * rand(1, numel(U));
  U = max(U, 0);
  U = U / sum(U);

end
