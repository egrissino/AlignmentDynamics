function result = test_security_update()
%TEST_SECURITY_UPDATE  Unit tests for security_update.

  result.passed   = 0;
  result.failed   = 0;
  result.messages = {};

  eta   = 0.07;
  gamma = 0.02;

  %% Test 1: S increases when risk is high
  S0   = 0.5;
  risk = 1.0;  % high risk
  S1   = security_update(S0, eta, gamma, risk);
  if S1 > S0
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf('FAIL test 1: S did not increase (S0=%.3f, S1=%.3f)', S0, S1);
  end

  %% Test 2: S decreases when risk is near zero
  S0   = 0.5;
  risk = 0.0;
  S1   = security_update(S0, eta, gamma, risk);
  if S1 < S0
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf('FAIL test 2: S did not decrease (S0=%.3f, S1=%.3f)', S0, S1);
  end

  %% Test 3: S stays non-negative when starting at 0 with zero risk
  S0   = 0.0;
  risk = 0.0;
  S1   = security_update(S0, eta, gamma, risk);
  if S1 >= 0
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf('FAIL test 3: S went negative (S1=%.6f)', S1);
  end

  %% Test 4: equilibrium point satisfies eta*risk == gamma*S
  % At equilibrium: S* = eta * risk / gamma
  risk = 0.3;
  S_eq = eta * risk / gamma;
  S1   = security_update(S_eq, eta, gamma, risk);
  if abs(S1 - S_eq) < 1e-10
    result.passed++;
  else
    result.failed++;
    result.messages{end+1} = sprintf('FAIL test 4: equilibrium not stable (S_eq=%.6f, S1=%.6f)', S_eq, S1);
  end

end
