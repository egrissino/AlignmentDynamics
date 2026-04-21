function payoff = compute_payoff(S, beta, risk_profile)
%COMPUTE_PAYOFF  Compute per-strategy payoff given security intensity.
%
%   payoff = compute_payoff(S, beta, risk_profile)
%
%   High-risk strategies are penalised exponentially by security.
%
%   Arguments:
%     S            - scalar security intensity
%     beta         - payoff evolution rate (penalty scaling)
%     risk_profile - (1 x N) per-strategy risk weights
%
%   Returns:
%     payoff - (1 x N) per-strategy payoff values

  payoff = exp(-beta * S .* risk_profile);

end
