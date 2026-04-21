function params = load_config(cfg_path)
%LOAD_CONFIG  Load and validate simulation parameters from a JSON file.
%
%   params = load_config(cfg_path)
%
%   Reads a JSON configuration file and returns a validated params struct.
%   Requires Octave >= 6.1 (jsondecode).
%
%   Required JSON fields:
%     T               - number of time steps (positive integer)
%     N               - strategy space dimension (positive integer, <= 65536)
%     eta             - security evolution rate (0, 1)
%     beta            - payoff evolution rate (0, 1)
%     noise_init      - initial noise magnitude [0, 1]
%     noise_decay_rate- noise exponential decay rate (0, 1)
%     k               - entropy suppression rate (0, 1)
%     gamma           - institutional forgetting rate (0, 1)
%     S0              - initial security intensity (>= 0)
%     seed            - RNG seed (non-negative integer)
%     out_dir         - output directory path (string)

  if ~exist(cfg_path, 'file')
    error('load_config: config file not found: %s', cfg_path);
  end

  fid = fopen(cfg_path, 'r');
  raw = fread(fid, Inf, 'char=>char')';
  fclose(fid);

  try
    cfg = jsondecode(raw);
  catch e
    error('load_config: failed to parse JSON in %s: %s', cfg_path, e.message);
  end

  % --- Required fields ---
  required = {'T', 'N', 'eta', 'beta', 'noise_init', 'noise_decay_rate', ...
              'k', 'gamma', 'S0', 'seed', 'out_dir'};
  for i = 1:numel(required)
    if ~isfield(cfg, required{i})
      error('load_config: missing required field "%s" in %s', required{i}, cfg_path);
    end
  end

  % --- Type and range validation ---
  validate_posint(cfg.T,    'T',    cfg_path);
  validate_posint(cfg.N,    'N',    cfg_path);
  if cfg.N > 65536
    error('load_config: N = %d exceeds maximum of 65536 in %s', cfg.N, cfg_path);
  end

  validate_rate(cfg.eta,             'eta',              cfg_path);
  validate_rate(cfg.beta,            'beta',             cfg_path);
  validate_nonneg_rate(cfg.noise_init,       'noise_init',       cfg_path);
  validate_rate(cfg.noise_decay_rate,'noise_decay_rate', cfg_path);
  validate_rate(cfg.k,               'k',                cfg_path);
  validate_rate(cfg.gamma,           'gamma',            cfg_path);

  if ~isnumeric(cfg.S0) || cfg.S0 < 0
    error('load_config: S0 must be a non-negative number in %s', cfg_path);
  end
  if ~isnumeric(cfg.seed) || cfg.seed < 0 || cfg.seed ~= floor(cfg.seed)
    error('load_config: seed must be a non-negative integer in %s', cfg_path);
  end
  if ~ischar(cfg.out_dir) && ~ischar(cfg.out_dir)
    error('load_config: out_dir must be a string in %s', cfg_path);
  end

  params = cfg;

end

% --- Helpers ---

function validate_posint(val, name, path)
  if ~isnumeric(val) || val <= 0 || val ~= floor(val)
    error('load_config: %s must be a positive integer in %s (got %g)', name, path, val);
  end
end

function validate_rate(val, name, path)
  if ~isnumeric(val) || val <= 0 || val >= 1
    error('load_config: %s must be in (0, 1) in %s (got %g)', name, path, val);
  end
end

function validate_nonneg_rate(val, name, path)
  if ~isnumeric(val) || val < 0 || val > 1
    error('load_config: %s must be in [0, 1] in %s (got %g)', name, path, val);
  end
end
