function [U, S] = init_conditions(params)
%INIT_CONDITIONS  Initialize simulation state from params struct.
%
%   [U, S] = init_conditions(params)
%
%   Returns:
%     U  - (1 x N) initial user strategy distribution (probability simplex)
%     S  - scalar initial security intensity

  rng(params.seed);

  S = params.S0;
  U = rand(1, params.N);
  U = U / sum(U);

end
