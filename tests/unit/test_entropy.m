function result = test_entropy()
%TEST_ENTROPY  Unit tests for compute_entropy.

  result.passed   = 0;
  result.failed   = 0;
  result.messages = {};

  N = 64;

  %% Invariant 1: F is monotonically non-increasing as S increases (U fixed)
  U = ones(1, N) / N;  % uniform distribution
  k = 0.02;
  S_vals = linspace(0, 5, 20);
  F_vals = arrayfun(@(s) compute_entropy(U, s, k), S_vals);
  if all(diff(F_vals) <= 1e-12)
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = 'FAIL invariant 1: F not monotonically non-increasing with S';
  end

  %% Invariant 2: F = 0 when U is a point mass
  U_point = zeros(1, N);
  U_point(1) = 1.0;
  F_point = compute_entropy(U_point, 0, k);
  % log(0 + 1e-12) is tiny but not exactly 0; allow small tolerance
  if abs(F_point) < 1e-6
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf('FAIL invariant 2: F for point mass = %.6e, expected ~0', F_point);
  end

  %% Invariant 3: F = log(N) when U is uniform and S = 0
  U_uniform = ones(1, N) / N;
  F_uniform = compute_entropy(U_uniform, 0, k);
  expected = log(N);
  if abs(F_uniform - expected) / expected < 1e-6
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf('FAIL invariant 3: F uniform = %.6f, expected %.6f', F_uniform, expected);
  end

  %% Invariant 4: F >= 0 for any valid U
  rng(1);
  for i = 1:10
    U_rand = rand(1, N);
    U_rand = U_rand / sum(U_rand);
    S_rand = rand() * 3;
    F_rand = compute_entropy(U_rand, S_rand, k);
    if F_rand < -1e-12
      result.failed++;
      result.messages{end+1} = sprintf('FAIL invariant 4 (trial %d): F = %.6e < 0', i, F_rand);
      break;
    end
  end
  if result.failed == 0 || ~any(contains(result.messages, 'invariant 4'))
    result.passed++;
  end

end
