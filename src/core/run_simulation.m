function [U_hist, S_hist, F_hist, risk_hist] = run_simulation(params, ic)
%RUN_SIMULATION  Run the generative system security tradeoff simulation.
%
%   [U_hist, S_hist, F_hist, risk_hist] = run_simulation(params, ic)
%
%   Arguments:
%     params - struct with fields:
%                T               - number of time steps
%                N               - strategy space dimension
%                eta             - security evolution rate
%                beta            - payoff evolution rate
%                noise_init      - initial noise magnitude
%                noise_decay_rate- exponential decay rate for noise
%                k               - entropy suppression rate
%                gamma           - institutional forgetting rate
%                seed            - RNG seed for reproducibility
%     ic     - struct with fields:
%                U - (1 x N) initial user strategy distribution
%                S - initial security intensity (scalar)
%
%   Returns:
%     U_hist    - (T x N) history of user strategy distributions
%     S_hist    - (T x 1) history of security intensity
%     F_hist    - (T x 1) history of generative flexibility
%     risk_hist - (T x N) history of risk profiles

  T    = params.T;
  N    = params.N;
  eta  = params.eta;
  beta = params.beta;
  k    = params.k;
  gamma         = params.gamma;
  noise_init    = params.noise_init;
  noise_decay_rate = params.noise_decay_rate;

  U = ic.U;
  S = ic.S;

  U_hist    = zeros(T, N);
  S_hist    = zeros(T, 1);
  F_hist    = zeros(T, 1);
  risk_hist = zeros(T, N);

  for t = 1:T

    % Compute risk profile for this time step
    risk_profile = compute_risk_profile(t, T, N);

    % Store history
    U_hist(t, :)    = U;
    S_hist(t)       = S;
    risk_hist(t, :) = risk_profile;

    % Generative flexibility (system output entropy)
    F = compute_entropy(U, S, k);
    F_hist(t) = F;

    % Payoff and replicator dynamics
    payoff = compute_payoff(S, beta, risk_profile);
    U = replicator_step(U, payoff);

    % Mutation: novel strategy emergence
    U = mutation_step(U, t, noise_init, noise_decay_rate);

    % Aggregate risk and security update
    risk = sum(U .* risk_profile);
    S = security_update(S, eta, gamma, risk);

  end

end
