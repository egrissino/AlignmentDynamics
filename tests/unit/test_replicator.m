function result = test_replicator()
%TEST_REPLICATOR  Unit tests for replicator_step.

  result.passed   = 0;
  result.failed   = 0;
  result.messages = {};

  N = 32;
  rng(2);

  %% Test 1: U sums to 1.0 after replicator step
  for i = 1:10
    U = rand(1, N);
    U = U / sum(U);
    payoff = rand(1, N) + 0.1;  % positive payoffs
    U_new = replicator_step(U, payoff);
    if abs(sum(U_new) - 1.0) < 1e-10
      result.passed++;
    else
      result.failed++;
      result.messages{end+1} = sprintf('FAIL test 1 (trial %d): sum(U) = %.12f', i, sum(U_new));
    end
  end

  %% Test 2: U entries stay >= 0
  U = rand(1, N);
  U = U / sum(U);
  payoff = rand(1, N) + 0.1;
  U_new = replicator_step(U, payoff);
  if all(U_new >= 0)
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = 'FAIL test 2: some U entries < 0 after replicator step';
  end

  %% Test 3: High-payoff strategies gain mass relative to low-payoff ones
  U = ones(1, N) / N;  % start uniform
  payoff = ones(1, N) * 0.5;
  payoff(1) = 2.0;  % strategy 1 has high payoff
  payoff(2) = 0.1;  % strategy 2 has low payoff
  U_new = replicator_step(U, payoff);
  if U_new(1) > U(1) && U_new(2) < U(2)
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = 'FAIL test 3: high-payoff strategy did not gain mass';
  end

end
