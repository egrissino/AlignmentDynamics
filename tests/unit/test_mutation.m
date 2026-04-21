function result = test_mutation()
%TEST_MUTATION  Unit tests for mutation_step.

  result.passed   = 0;
  result.failed   = 0;
  result.messages = {};

  N = 64;
  rng(3);

  %% Test 1: U sums to 1.0 after mutation
  for i = 1:10
    U = rand(1, N);
    U = U / sum(U);
    U_new = mutation_step(U, 10, 0.2, 0.01);
    if abs(sum(U_new) - 1.0) < 1e-10
      result.passed++;
    else
      result.failed++;
      result.messages{end+1} = sprintf('FAIL test 1 (trial %d): sum(U) = %.12f', i, sum(U_new));
    end
  end

  %% Test 2: noise_init = 0 is identity (no change to U)
  U = rand(1, N);
  U = U / sum(U);
  U_new = mutation_step(U, 5, 0.0, 0.01);
  if max(abs(U_new - U)) < 1e-12
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf('FAIL test 2: mutation with noise=0 changed U (max diff=%.2e)', max(abs(U_new - U)));
  end

  %% Test 3: all U entries >= 0 after mutation
  U = rand(1, N);
  U = U / sum(U);
  U_new = mutation_step(U, 1, 0.99, 0.001);
  if all(U_new >= 0)
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = 'FAIL test 3: some U entries < 0 after mutation';
  end

end
