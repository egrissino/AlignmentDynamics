%% AlignmentDynamics Test Runner
% Run all tests and report pass/fail summary.
%
% Usage (from repo root):
%   octave --quiet --path src tests/test_runner.m

addpath(genpath('src'));
addpath(genpath('tests'));

% Discover all test_*.m files under tests/
test_files = glob('tests/**/test_*.m');

total_passed = 0;
total_failed = 0;
suite_failed = false;

fprintf('\n=== AlignmentDynamics Test Suite ===\n');

% Group tests by subdirectory for readable output
dirs_seen = {};
for i = 1:numel(test_files)
  d = fileparts(test_files{i});
  if ~any(strcmp(dirs_seen, d))
    dirs_seen{end+1} = d;
  end
end

for di = 1:numel(dirs_seen)
  d = dirs_seen{di};
  label = strrep(d, 'tests/', '');
  if isempty(label); label = 'unit'; end
  fprintf('\n  [%s]\n', label);

  dir_files = glob(fullfile(d, 'test_*.m'));
  for i = 1:numel(dir_files)
    [~, fn] = fileparts(dir_files{i});
    try
      result = feval(fn);
      total_passed += result.passed;
      total_failed += result.failed;
      if result.failed == 0
        fprintf('    PASS  %s (%d checks)\n', fn, result.passed);
      else
        suite_failed = true;
        fprintf('    FAIL  %s (%d passed, %d failed)\n', fn, result.passed, result.failed);
        for j = 1:numel(result.messages)
          fprintf('            %s\n', result.messages{j});
        end
      end
    catch e
      total_failed++;
      suite_failed = true;
      fprintf('    ERROR %s: %s\n', fn, e.message);
    end
  end
end

fprintf('\n--- Summary: %d passed, %d failed ---\n\n', total_passed, total_failed);

if suite_failed
  exit(1);
end
