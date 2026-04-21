function U = replicator_step(U, payoff)
%REPLICATOR_STEP  Apply one step of replicator dynamics.
%
%   U = replicator_step(U, payoff)
%
%   Strategies with above-average payoff grow; below-average shrink.
%   U remains on the probability simplex.
%
%   Arguments:
%     U      - (1 x N) current user strategy distribution
%     payoff - (1 x N) per-strategy payoff values
%
%   Returns:
%     U - (1 x N) updated strategy distribution

  avg_payoff = sum(U .* payoff);
  U = U .* (payoff ./ avg_payoff);

end
