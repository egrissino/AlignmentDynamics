%% AlignmentDynamics Test Runner
% Run all unit tests and report pass/fail summary.
%
% Usage (from repo root):
%   octave --quiet --path src tests/test_runner.m

addpath(genpath('src'));
addpath(genpath('tests'));

test_fns = {
  @test_entropy,
  @test_replicator,
  @test_security_update,
  @test_mutation,
};

test_names = {
  'test_entropy',
  'test_replicator',
  'test_security_update',
  'test_mutation',
};

total_passed = 0;
total_failed = 0;

fprintf('\n=== AlignmentDynamics Test Suite ===\n\n');

for i = 1:numel(test_fns)
  name = test_names{i};
  try
    result = test_fns{i}();
    total_passed += result.passed;
    total_failed += result.failed;
    if result.failed == 0
      fprintf('  PASS  %s (%d checks)\n', name, result.passed);
    else
      fprintf('  FAIL  %s (%d passed, %d failed)\n', name, result.passed, result.failed);
      for j = 1:numel(result.messages)
        fprintf('          %s\n', result.messages{j});
      end
    end
  catch e
    total_failed++;
    fprintf('  ERROR %s: %s\n', name, e.message);
  end
end

fprintf('\n--- Summary: %d passed, %d failed ---\n\n', total_passed, total_failed);

if total_failed > 0
  exit(1);
end
