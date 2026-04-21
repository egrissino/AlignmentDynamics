function risk_profile = compute_risk_profile(t, T, N)
%COMPUTE_RISK_PROFILE  Compute the risk profile vector at time t.
%
%   risk_profile = compute_risk_profile(t, T, N)
%
%   Returns:
%     risk_profile - (1 x N) vector of per-strategy risk weights

  risk_profile = (t / T) * linspace(0.1, 1, N);

end
