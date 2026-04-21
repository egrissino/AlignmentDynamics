function result = test_rapid_mutation()
%TEST_RAPID_MUTATION  Edge case: noise decays to near-zero quickly -> stable S.

  result.passed   = 0;
  result.failed   = 0;
  result.messages = {};

  % noise_decay_rate = 0.5 means noise drops to ~0.01% by step 10
  params = struct('T', 100, 'N', 64, 'eta', 0.07, 'beta', 0.1, ...
                  'noise_init', 0.2, 'noise_decay_rate', 0.5, ...
                  'k', 0.02, 'gamma', 0.02, 'S0', 0.1, 'seed', 13);
  [U0, S0] = init_conditions(params);
  ic.U = U0;
  ic.S = S0;

  [~, S_hist] = run_simulation(params, ic);

  %% Test 1: No NaN or Inf in S_hist
  if ~any(isnan(S_hist)) && ~any(isinf(S_hist))
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = 'FAIL test 1: NaN or Inf in S_hist with rapid mutation decay';
  end

  %% Test 2: U entropy decreases from early to late period
  % Once mutation noise dies out, pure replicator selection concentrates U
  % on lower-risk strategies, reducing Shannon entropy H[U] over time.
  [U_hist, ~, ~] = run_simulation(params, ic);
  early_H = mean(arrayfun(@(t) entropy_of_row(U_hist(t,:)), 1:50));
  late_H  = mean(arrayfun(@(t) entropy_of_row(U_hist(t,:)), 51:100));
  if late_H <= early_H
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf( ...
      'FAIL test 2: U entropy did not decrease after noise decay (early H=%.4f, late H=%.4f)', ...
      early_H, late_H);
  end

  %% Test 3: Mean F in late period <= mean F in early period
  % Both selection-driven U concentration and rising S suppress F over time.
  [~, ~, F_hist] = run_simulation(params, ic);
  if mean(F_hist(51:end)) <= mean(F_hist(1:50))
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf( ...
      'FAIL test 3: mean F did not decrease (early=%.4f, late=%.4f)', ...
      mean(F_hist(1:50)), mean(F_hist(51:end)));
  end

end

function H = entropy_of_row(U)
  H = -sum(U .* log(U + 1e-12));
end
