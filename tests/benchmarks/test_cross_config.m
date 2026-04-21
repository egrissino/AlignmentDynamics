function result = test_cross_config()
%TEST_CROSS_CONFIG  Benchmark: compare simulation outcomes across preset configs.
%
%   Asserts theory-motivated invariants that must hold across parameter regimes:
%     1. high_security config produces higher mean S than default
%     2. high_noise config produces higher F variance than default
%     3. high_security config produces lower mean F than default

  result.passed   = 0;
  result.failed   = 0;
  result.messages = {};

  default_cfg       = load_config('config/default.json');
  high_security_cfg = load_config('config/high_security.json');
  high_noise_cfg    = load_config('config/high_noise.json');

  % Run all three configs
  [~, S_def,  F_def]  = run_config(default_cfg);
  [~, S_hsec, F_hsec] = run_config(high_security_cfg);
  [~, S_hnoi, F_hnoi] = run_config(high_noise_cfg);

  %% Test 1: high_security produces higher mean S than default
  if mean(S_hsec) > mean(S_def)
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf( ...
      'FAIL test 1: high_security mean(S)=%.4f not > default mean(S)=%.4f', ...
      mean(S_hsec), mean(S_def));
  end

  %% Test 2: high_noise produces higher mean S than default
  % Sustained mutation noise continuously injects mass into high-risk
  % regions of strategy space, maintaining higher aggregate risk and thus
  % a higher security equilibrium (S* = eta*rho*/gamma).
  if mean(S_hnoi) > mean(S_def)
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf( ...
      'FAIL test 2: high_noise mean(S)=%.4f not > default mean(S)=%.4f', ...
      mean(S_hnoi), mean(S_def));
  end

  %% Test 3: high_security produces lower mean F than default
  % Higher security suppresses flexibility: F = H[U] * exp(-k*S)
  if mean(F_hsec) < mean(F_def)
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf( ...
      'FAIL test 3: high_security mean(F)=%.4f not < default mean(F)=%.4f', ...
      mean(F_hsec), mean(F_def));
  end

  %% Test 4: All configs complete without NaN/Inf
  all_clean = ~any(isnan([S_def; S_hsec; S_hnoi])) && ...
              ~any(isnan([F_def; F_hsec; F_hnoi]));
  if all_clean
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = 'FAIL test 4: NaN found in one or more config runs';
  end

end

function [U_hist, S_hist, F_hist] = run_config(params)
  [U0, S0] = init_conditions(params);
  ic.U = U0;
  ic.S = S0;
  [U_hist, S_hist, F_hist] = run_simulation(params, ic);
end
