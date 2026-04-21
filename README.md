# LLM Alignment Dynamics

A dynamical systems simulation of the co-evolution of security intensity, generative flexibility, and user exploitation strategies in large language model deployments.

The simulation applies replicator dynamics from evolutionary game theory to model how a population of users adapts its strategy distribution in response to shifting security measures — and how security in turn responds to observed risk. The published documentation (`html/gen_security_sim.html`) provides a full mathematical treatment of the framework.

## Requirements

- **GNU Octave >= 6.1** (required for `jsondecode`)
- No additional toolboxes are needed

Install on Ubuntu/Debian:
```bash
sudo apt-get install octave
```

## Running the Simulation

### Interactive (default config)
```bash
octave gen_security_sim.m
```

### Command-line with a specific config
```bash
octave gen_security_sim.m config/high_security.json
octave gen_security_sim.m config/high_noise.json
```

Output plots are saved to the directory specified by `out_dir` in the config (e.g. `out/default/`).

## Configuration

All parameters are defined in JSON files under `config/`. Three presets are provided:

| File | Description |
|------|-------------|
| `config/default.json` | Baseline regime |
| `config/high_security.json` | High institutional responsiveness, low forgetting |
| `config/high_noise.json` | Sustained novel strategy emergence |

### Parameter Reference

| Parameter | Type | Range | Description |
|-----------|------|--------|-------------|
| `T` | int | > 0 | Number of simulation time steps |
| `N` | int | (0, 65536] | Strategy space discretization dimension |
| `eta` | float | (0, 1) | Security evolution rate |
| `beta` | float | (0, 1) | Payoff sensitivity to security |
| `noise_init` | float | [0, 1] | Initial novel strategy emergence rate |
| `noise_decay_rate` | float | (0, 1) | Exponential decay rate of noise |
| `k` | float | (0, 1) | Entropy suppression rate |
| `gamma` | float | (0, 1) | Institutional forgetting rate |
| `S0` | float | >= 0 | Initial security intensity |
| `seed` | int | >= 0 | RNG seed for reproducibility |
| `out_dir` | string | — | Output directory for plots |

## Output

Each run saves seven plots to `out_dir/`:

| File | Description |
|------|-------------|
| `Growth.png` | Security intensity S(t) over time |
| `Entropy.png` | Generative flexibility F(t) over time |
| `Trajectory.png` | Phase portrait: S vs F |
| `Evolution.png` | Heatmap of user strategy distribution U(t) |
| `Phase3D.png` | 3D trajectory (S, F, time) |
| `Vector.png` | Phase space vector field |
| `Poincare.png` | Poincaré section at mean S |

## Project Structure

```
gen_security_sim.m      Entry point (publish-ready with full mathematical commentary)
config/                 JSON parameter presets
src/
  core/                 Simulation logic (run_simulation, replicator_step, ...)
  viz/                  Visualization functions (plot_all, plot_security, ...)
  config/               load_config.m — JSON loading and validation
tests/
  test_runner.m         Runs all unit tests
  unit/                 Unit tests for each core function
html/                   Published HTML/LaTeX documentation
out/                    Simulation output (gitignored)
```

## Tests

```bash
octave --quiet --path src tests/test_runner.m
```

## Publishing Documentation

To regenerate the HTML treatise from the annotated source:

```bash
octave ./gen_security_sim.m
```

The script will save the plots to the out directory
