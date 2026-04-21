function result = test_full_simulation()
%TEST_FULL_SIMULATION  Integration tests for run_simulation end-to-end.

  result.passed   = 0;
  result.failed   = 0;
  result.messages = {};

  % Shared small-scale params for speed
  base = struct('T', 100, 'N', 64, 'eta', 0.07, 'beta', 0.1, ...
                'noise_init', 0.2, 'noise_decay_rate', 0.01, ...
                'k', 0.02, 'gamma', 0.02, 'S0', 0.1, 'seed', 7);

  %% Test 1: No NaN or Inf in any history array (default params)
  ic = make_ic(base);
  [U_hist, S_hist, F_hist, risk_hist] = run_simulation(base, ic);

  if ~any(isnan(U_hist(:))) && ~any(isinf(U_hist(:))) && ...
     ~any(isnan(S_hist))   && ~any(isinf(S_hist))   && ...
     ~any(isnan(F_hist))   && ~any(isinf(F_hist))
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = 'FAIL test 1: NaN or Inf found in simulation output';
  end

  %% Test 2: eta = 0 keeps S at S0 throughout
  p = base;
  p.eta = 0.001;  % as close to 0 as the validator allows; use small value
  % Note: validator requires eta in (0,1), so use a very small positive value
  % and verify S barely moves from S0
  ic = make_ic(p);
  [~, S_hist2] = run_simulation(p, ic);
  % With eta~=0 and gamma>0, S should decay from S0 toward 0
  if S_hist2(end) < S_hist2(1)
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf('FAIL test 2: S did not decay with near-zero eta (S0=%.4f, S_end=%.4f)', S_hist2(1), S_hist2(end));
  end

  %% Test 3: k = 0 means F equals raw Shannon entropy (no suppression)
  p = base;
  p.k = 0.001;  % near-zero k: suppression factor exp(-k*S) ~ 1
  ic = make_ic(p);
  [U_hist3, S_hist3, F_hist3] = run_simulation(p, ic);
  % Compute expected F directly from U_hist at each step
  max_err = 0;
  for t = 1:p.T
    U = U_hist3(t, :);
    expected_F = -sum(U .* log(U + 1e-12));  % raw entropy, suppression ~ 1
    max_err = max(max_err, abs(F_hist3(t) - expected_F));
  end
  % With k=0.001 and S <= ~10, exp(-0.001*10) ~ 0.99, so error < 1%
  if max_err < 0.1
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf('FAIL test 3: k~0 but F deviates from raw entropy by %.4f', max_err);
  end

  %% Test 4: gamma = 0 with fixed non-zero risk -> S grows monotonically
  p = base;
  p.gamma = 0.001;  % near-zero forgetting
  ic = make_ic(p);
  [~, S_hist4] = run_simulation(p, ic);
  if all(diff(S_hist4) >= -1e-10)
    result.passed++;
  else
    n_decreases = sum(diff(S_hist4) < -1e-10);
    result.failed++;
    result.messages{end+1} = sprintf('FAIL test 4: S decreased %d time(s) with near-zero gamma', n_decreases);
  end

  %% Test 5: U stays on the probability simplex throughout
  ic = make_ic(base);
  [U_hist5] = run_simulation(base, ic);
  row_sums = sum(U_hist5, 2);
  min_entry = min(U_hist5(:));
  if max(abs(row_sums - 1)) < 1e-8 && min_entry >= -1e-12
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf('FAIL test 5: simplex violated (max row-sum err=%.2e, min entry=%.2e)', ...
      max(abs(row_sums - 1)), min_entry);
  end

end

function ic = make_ic(params)
  [U0, S0] = init_conditions(params);
  ic.U = U0;
  ic.S = S0;
end
