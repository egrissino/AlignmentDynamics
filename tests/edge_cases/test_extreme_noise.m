function result = test_extreme_noise()
%TEST_EXTREME_NOISE  Edge case: very high initial noise stays on simplex.

  result.passed   = 0;
  result.failed   = 0;
  result.messages = {};

  params = struct('T', 200, 'N', 64, 'eta', 0.07, 'beta', 0.1, ...
                  'noise_init', 0.99, 'noise_decay_rate', 0.01, ...
                  'k', 0.02, 'gamma', 0.02, 'S0', 0.1, 'seed', 11);
  [U0, S0] = init_conditions(params);
  ic.U = U0;
  ic.S = S0;

  [U_hist, S_hist, F_hist] = run_simulation(params, ic);

  %% Test 1: U stays on simplex throughout (no NaN, sums to 1, non-negative)
  row_sums  = sum(U_hist, 2);
  min_entry = min(U_hist(:));
  any_nan   = any(isnan(U_hist(:)));

  if ~any_nan && max(abs(row_sums - 1)) < 1e-8 && min_entry >= -1e-12
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf( ...
      'FAIL test 1: simplex violated under extreme noise (nan=%d, max_sum_err=%.2e, min_entry=%.2e)', ...
      any_nan, max(abs(row_sums - 1)), min_entry);
  end

  %% Test 2: No NaN or Inf in S_hist or F_hist
  if ~any(isnan(S_hist)) && ~any(isinf(S_hist)) && ...
     ~any(isnan(F_hist)) && ~any(isinf(F_hist))
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = 'FAIL test 2: NaN or Inf in S_hist or F_hist under extreme noise';
  end

  %% Test 3: S still increases overall (security responds even under high noise)
  if S_hist(end) > S_hist(1)
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf('FAIL test 3: S did not increase under extreme noise (S0=%.4f, S_end=%.4f)', ...
      S_hist(1), S_hist(end));
  end

end
