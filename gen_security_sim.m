%% Generative System Security Tradeoff Simulation
% A dynamical systems analysis of the co-evolution of security intensity,
% generative flexibility, and user exploitation strategies in large language
% model deployments. Using replicator dynamics from evolutionary game theory
% and information-theoretic measures of model capacity, this simulation
% demonstrates the fundamental tension between restrictive safety measures
% and expressive model capability, and characterizes the long-run equilibria
% that emerge from this interaction.
%

%% 1. Background and Motivation
%
% *The Alignment Problem as a Dynamical System*
%
% The rapid deployment of large language models (LLMs) as sociotechnical
% infrastructure has created a new class of security challenge. Unlike
% traditional software vulnerabilities, which are discrete and patchable,
% the security surface of a generative model is continuous, high-dimensional,
% and adversarially dynamic. The space of possible inputs -- and therefore
% the space of possible model behaviors -- is for all practical purposes
% inexhaustible.
%
% The precise sense is combinatorial rather than literal. Modern LLM
% tokenizers operate on dicharacteral units: tokens composed of two ASCII
% or Unicode characters, giving each token position approximately
% $256^2 = 65{,}536$ possible values. A context window of $L = 4096$ such
% positions therefore spans an input space of cardinality
%
% $$(256^2)^{4096} = 256^{8192}.$$
%
% This number exceeds the count of atoms in the observable universe by
% hundreds of orders of magnitude. No enumeration-based defense is
% conceivable; no finite training set covers it; adversarial progression
% always has unexplored room to maneuver. This combinatorial vastness is
% the structural basis for the perpetual novelty of user exploitation
% strategies modeled in the simulation.
%
% At the same time, the value of these systems depends directly on their
% expressive capacity. A model constrained tightly enough to produce no
% harmful outputs will, by the same constraints, produce few useful ones.
% This is not a solvable engineering problem in the classical sense; it is
% a fundamental tradeoff inscribed in the nature of generative systems.
%
% Three classes of actor shape this tradeoff at any point in time:
%
% * *Architects and regulators* design the model and its safety measures,
%   responding to observed risk and social/legal pressure. Their decisions
%   accumulate into a security intensity $S(t)$.
%
% * *Users* seek to extract value from the model, including in ways its
%   designers did not intend. They are not a monolith -- at any time, the
%   population of users embodies a distribution over strategies, from
%   routine benign use to targeted adversarial exploitation.
%
% * *The model itself* mediates this interaction, its outputs determined by
%   both its architecture and the context supplied by users.
%
% This simulation treats the interaction of these actors as a coupled
% dynamical system and asks: how does security intensity co-evolve with
% user strategy over time, and what happens to the model's generative
% flexibility as a result?
%
% *Evolutionary Game Theory as a Lens*
%
% The framework draws on evolutionary game theory, specifically the
% replicator dynamics introduced by Taylor and Jonker (1978). In this
% tradition, a population does not optimize -- it adapts. Strategies that
% yield higher payoffs grow in prevalence; strategies that yield lower
% payoffs shrink. The population as a whole moves toward Nash equilibria,
% but the path matters as much as the destination.
%
% Applied to LLM users, this means: strategies for interacting with the
% model that successfully extract value (bypassing security measures) will
% proliferate. As security responds, the payoff landscape shifts, and
% the population adapts again. This is not a one-shot game; it is an
% iterated coevolutionary process -- the computational analogue of what
% biologists call an arms race.
%

%% 2. System Model and State Variables
%
% The simulation tracks three primary state variables:
%
% *User Strategy Distribution: $U(t) \in \Delta^{N-1}$*
%
% $U(t)$ is a probability vector over $N = 4096$ discrete strategies,
% residing on the $(N-1)$-dimensional probability simplex $\Delta^{N-1}$:
%
% $$U_i(t) \geq 0, \qquad \sum_{i=1}^{N} U_i(t) = 1.$$
%
% Each index $i$ represents an abstract user interaction strategy -- a coarse
% discretization of a true strategy space with cardinality $256^{8192}$ (see
% Section 1). The simulation uses $N = 4096$ abstract strategy buckets as a
% computationally tractable projection of this space: $N$ equals the context
% window length as a matter of implementation convenience, not because each
% token position maps to one strategy dimension. The key property inherited
% from the true space is its practical inexhaustibility -- the mutation term
% in the governing equations (Section 3) models the continuous emergence of
% novel strategies from this combinatorially vast reservoir. The distribution
% $U(t)$ encodes how the user population is currently allocating its
% attention across these abstracted strategy classes.
%
% *Security Intensity: $S(t) \geq 0$*
%
% $S(t)$ is a scalar measure of the aggregate security pressure applied to
% the system at time $t$. It encompasses content filtering, output
% classifiers, rate limiting, policy restrictions, and all other mechanisms
% by which architects and regulators constrain model behavior. Higher $S$
% implies tighter constraints and, as shown below, lower generative
% flexibility.
%
% *Generative Flexibility: $F(t) \geq 0$*
%
% $F(t)$ measures the expressive capacity of the system -- the entropy of
% the user strategy distribution, modulated by security suppression:
%
% $$F(t) = -\left(\sum_{i=1}^{N} U_i(t) \ln U_i(t)\right) e^{-k S(t)}.$$
%
% The first factor is the Shannon entropy $H[U(t)]$, which is maximized
% when all strategies are equally viable and minimized when the population
% concentrates on a single strategy. The exponential suppression
% $e^{-k S(t)}$ models the direct effect of security measures: as $S$
% increases, even a highly entropic user distribution produces diminishing
% effective flexibility.
%
% *Risk Profile: $r(t) \in \mathbb{R}^N$*
%
% The risk profile $r_i(t)$ assigns to each strategy $i$ its hazard weight
% at time $t$:
%
% $$r_i(t) = \frac{t}{T} \cdot \text{linspace}(0.1,\, 1,\, N)_i.$$
%
% The linear spacing reflects a simplifying assumption that strategies are
% ordered by their inherent risk level. The time-varying prefactor
% $t/T \in (0, 1]$ encodes the observation that risk profiles are not
% static: as the system matures, higher-risk strategies become increasingly
% identifiable and their effective hazard weight increases.
%

%% 3. Governing Equations
%
% The simulation advances in discrete time steps. At each step $t$, the
% following sequence of updates is applied.
%
% *Step 1: Payoff Computation*
%
% The payoff to a user following strategy $i$ is a decreasing function of
% security intensity and the strategy's risk weight:
%
% $$f_i(t) = \exp\!\left(-\beta\, S(t)\, r_i(t)\right).$$
%
% High-risk strategies are penalised exponentially. The parameter $\beta$
% controls the rate at which security investment translates into payoff
% reduction. The population-average payoff is:
%
% $$\bar{f}(t) = \sum_{i=1}^{N} U_i(t)\, f_i(t) = \mathbb{E}_{U(t)}[f(t)].$$
%
% *Step 2: Replicator Dynamics*
%
% The user distribution evolves according to the discrete-time replicator
% equation:
%
% $$U_i(t+1) = U_i(t) \cdot \frac{f_i(t)}{\bar{f}(t)}.$$
%
% Strategies with above-average payoff grow in prevalence; below-average
% strategies contract. This preserves the simplex constraint
% $\sum_i U_i = 1$ exactly. The replicator equation is the canonical
% selection dynamic of evolutionary game theory and corresponds to the
% continuous-time differential equation $\dot{U}_i = U_i(f_i - \bar{f})$.
%
% *Step 3: Mutation*
%
% Selection alone drives the population toward a fixed point. Mutation
% injects novel strategies, representing the continuous emergence of new
% user techniques -- jailbreak attempts, prompt engineering, and other
% adversarial innovations. The noise magnitude decays exponentially:
%
% $$\epsilon(t) = \epsilon_0 \, e^{-\delta t}, \qquad \xi \sim \mathrm{Uniform}(0,1)^N,$$
%
% $$\tilde{U}(t+1) = \mathrm{normalize}\!\left(\max\!\left(U(t+1) + \epsilon(t)\,\xi,\; 0\right)\right).$$
%
% The decaying noise envelope reflects the empirical observation that
% novelty rates in adversarial communities tend to decrease as defenders
% respond and the low-hanging fruit of easy exploits is exhausted.
%
% *Step 4: Risk Estimation and Security Update*
%
% The aggregate risk at time $t$ is the expected risk under the current
% user distribution:
%
% $$\rho(t) = \mathbb{E}_{U(t)}[r(t)] = \sum_{i=1}^{N} U_i(t)\, r_i(t).$$
%
% Security intensity is then updated by a first-order linear recurrence:
%
% $$S(t+1) = S(t) + \eta\, \rho(t) - \gamma\, S(t) = (1 - \gamma)\, S(t) + \eta\, \rho(t).$$
%
% This is the Euler discretization of the continuous-time ODE
% $\dot{S} = \eta\rho - \gamma S$, which has the stable fixed point
% $S^* = \eta\rho^*/\gamma$ when $\gamma > 0$.
%

%% 4. Equilibrium Analysis
%
% The long-run behavior of the coupled system $(U, S)$ admits a
% characterization in terms of fixed points.
%
% *Security Equilibrium*
%
% For a fixed risk level $\rho^*$, the security update converges to:
%
% $$S^* = \frac{\eta\, \rho^*}{\gamma}.$$
%
% The ratio $\eta/\gamma$ is the fundamental sensitivity of the security
% equilibrium: systems with high institutional responsiveness $\eta$ and
% low forgetting rate $\gamma$ will sustain high equilibrium security
% intensity. Conversely, high institutional forgetting (large $\gamma$)
% acts as a structural ceiling on security, regardless of how high risk
% climbs.
%
% *Strategy Equilibrium*
%
% In the absence of mutation, the replicator dynamics converge to a pure
% Nash equilibrium: the entire population concentrates on the strategy
% $i^* = \arg\min_i r_i(t)$ (the lowest-risk strategy given current
% security). Mutation prevents this degenerate outcome, maintaining
% strategic diversity and keeping $\rho^*$ bounded above zero.
%
% *The Security-Flexibility Tradeoff*
%
% At equilibrium, the generative flexibility is:
%
% $$F^* = H[U^*]\, e^{-k S^*} = H[U^*]\, \exp\!\!\left(-\frac{k\eta\rho^*}{\gamma}\right).$$
%
% This reveals the fundamental tradeoff: any increase in equilibrium
% security $S^*$ (whether from increased risk $\rho^*$, faster institutional
% response $\eta$, or slower forgetting $\gamma$) suppresses flexibility
% exponentially. The tradeoff cannot be engineered away -- it is a
% structural property of systems where security measures act on the same
% generative capacity that creates value for users.
%

%% 5. Environment Setup
%
% The simulation is structured as a thin entry point that delegates to
% modular functions in |src/core/| (simulation logic) and |src/viz/|
% (visualization). This separation enables independent testing of each
% component and facilitates extension without modifying the core dynamics.
%
% Parameters are loaded from a JSON configuration file. A path to the
% config file may be supplied as the first command-line argument when
% running non-interactively:
%
%   octave gen_security_sim.m config/high_noise.json
%
% If no argument is supplied, |config/default.json| is used.
%
clear;
clc;
close all;
addpath(genpath('src'));

args = argv();
if numel(args) >= 1
  cfg_path = args{1};
else
  cfg_path = 'config/default.json';
end

%% 6. Simulation Parameters
%
% The parameters below define the dynamical regime of the simulation.
% They are not yet empirically calibrated -- a key direction for future
% work -- but have been chosen to produce qualitatively representative
% behavior consistent with the theoretical predictions of Section 4.
%
% * |T = 1000|: The number of discrete time steps. One step corresponds
%   roughly to a week of deployment time; 1000 steps thus spans
%   approximately 20 years of model evolution. This is long enough to
%   observe convergence behavior while remaining computationally tractable.
%
% * |N = 4096|: The number of abstract strategy buckets used to discretize
%   the true input space (cardinality $256^{8192}$). Set equal to the
%   context window length as a computational convenience; there is no
%   claim of one-to-one correspondence between strategy indices and token
%   positions. Increasing $N$ refines the discretization but increases
%   memory proportionally (|U_hist| is $T \times N$).
%
% * |eta = 0.07|: The security evolution rate. This is the primary coupling
%   constant between observed risk and security response. A value of 0.07
%   reflects moderate institutional responsiveness; large enterprises and
%   well-resourced model providers may exhibit higher values, while
%   regulatory bodies typically exhibit lower ones.
%
% * |beta = 0.1|: The payoff sensitivity to security. Controls how steeply
%   the payoff $f_i$ falls as $S$ rises for a given risk weight $r_i$.
%   Lower values make high-risk strategies more viable under high security;
%   higher values make them sharply non-viable.
%
% * |noise_init = 0.2|: The initial rate of novel strategy emergence.
%   This is the hardest parameter to calibrate empirically. A value of 0.2
%   produces noticeable strategy diversity throughout the simulation while
%   not overwhelming the selection dynamics.
%
% * |noise_decay_rate = 0.01|: The exponential rate at which novel strategy
%   emergence decays. Combined with |noise_init|, the effective noise at
%   time $t$ is $0.2 \cdot e^{-0.01 t}$, reaching approximately 4% of its
%   initial value at $t = 300$ and becoming negligible by $t = 500$.
%
% * |k = 0.02|: The entropy suppression rate. Governs how rapidly
%   generative flexibility $F(t)$ decays as security $S(t)$ rises.
%   This is an information-theoretic coupling constant: $k$ roughly sets
%   the scale of $S$ at which the model's effective output entropy is
%   halved ($S_{1/2} = \ln 2 / k \approx 34.7$).
%
% * |gamma = 0.02|: The institutional forgetting rate. Regulatory and
%   corporate security postures are not permanent; they relax over time
%   in the absence of fresh incidents. $\gamma = 0.02$ implies a
%   characteristic forgetting time of $1/\gamma = 50$ steps (~1 year).
%   The equilibrium security level is $S^* = \eta\rho^*/\gamma = 3.5\rho^*$
%   at these parameter values.
%
% * |S0 = 0.1|: Initial security intensity. LLMs have never been deployed
%   without some security measures; a value of 0.1 reflects the modest but
%   nonzero baseline of pre-deployment safety testing.
%
% * |seed = 42|: Random seed for reproducibility. All stochastic elements
%   (initial $U(0)$ and mutation noise $\xi(t)$) are drawn from this seed.
%
% Default values for all parameters are defined in |config/default.json|.
% Preset configurations for common scenarios are provided in
% |config/high_security.json| and |config/high_noise.json|.
%
params = load_config(cfg_path);

%% 7. Initial Conditions
%
% The initial user strategy distribution $U(0)$ is drawn uniformly at
% random from the probability simplex. This corresponds to maximum
% strategic uncertainty at the moment of model deployment: no strategy
% has yet been shown to be more effective than any other. In practice,
% the true initial distribution is shaped by the strategies users bring
% from prior systems -- a meaningful direction for empirical grounding.
%
% The initial security $S(0) = 0.1$ reflects the baseline safety measures
% present at launch. Setting $S(0) = 0$ would assume a completely
% unsecured deployment, which is not realistic for any major LLM release.
%
[U0, S0] = init_conditions(params);
ic.U = U0;
ic.S = S0;

%% 8. Simulation
%
% The core simulation loop is implemented in |src/core/run_simulation.m|.
% At each of the $T = 1000$ time steps, it applies the sequence of updates
% described in Section 3: risk profile computation, entropy measurement,
% payoff and replicator dynamics, mutation, risk estimation, and security
% update. Full histories are returned for all state variables, including
% the risk profile at every step, enabling exact reproduction of any
% trajectory segment.
%
[U_hist, S_hist, F_hist, risk_hist] = run_simulation(params, ic);

%% 9. Results and Interpretation
%
% Seven visualizations are generated, each illuminating a different facet
% of the system's dynamics.
%
% *Security Growth (Growth.png)*
% $S(t)$ increases monotonically toward its equilibrium value
% $S^* \approx \eta\rho^*/\gamma$. The growth is rapid early, when risk
% is high and security has not yet caught up, and decelerates as the
% system approaches equilibrium. This curve should be compared to
% empirical timelines of safety measure adoption in deployed LLMs.
%
% *Generative Flexibility (Entropy.png)*
% $F(t)$ mirrors $S(t)$: as security rises, flexibility falls. The
% exponential coupling $e^{-kS}$ means that early security gains have
% outsized impact on flexibility, while later increments to an already
% high $S$ have diminishing suppressive effect.
%
% *Phase Trajectory (Trajectory.png)*
% The parametric curve $(S(t), F(t))$ in the security-flexibility plane
% traces the path from the initial state $(S_0, F_0)$ toward the
% equilibrium $(S^*, F^*)$. The shape of this curve encodes the system's
% dynamical response: a steep initial descent in $F$ corresponds to a
% period of rapid security tightening before strategy adaptation occurs.
%
% *Strategy Evolution (Evolution.png)*
% The heatmap of $U(t)$ over time reveals how the user population's
% strategy distribution shifts under selection and mutation pressure. Early
% in the simulation, the distribution is broad (high entropy). As high-risk
% strategies become increasingly costly, the population concentrates, and
% the heatmap brightens in the low-risk regions. Mutation prevents complete
% concentration, maintaining a residual background of novel strategies.
%
% *3D Phase Trajectory (Phase3D.png)*
% Adding the time axis to the phase plot reveals the rate at which the
% system traverses its trajectory. A compressed helix indicates rapid
% early dynamics; a stretched trajectory later in time indicates a system
% approaching its equilibrium slowly.
%
% *Phase Space Vector Field (Vector.png)*
% The quiver plot of $(dS/dt, dF/dt)$ evaluated along the trajectory
% visualizes the local flow of the dynamical system. Arrows point in the
% direction of increasing security and decreasing flexibility -- the
% universal direction of the field throughout the parameter regime
% explored here.
%
% *Poincare Section (Poincare.png)*
% The Poincare section is taken at $S(t) \approx \bar{S}$ (the time-average
% of security intensity). For a system with periodic or quasi-periodic
% dynamics, this section would exhibit structure; for the monotone regime
% explored here, it reduces to a small cluster of flexibility values,
% providing a diagnostic for how closely the system tracks its equilibrium
% in the neighborhood of $\bar{S}$.
%
plot_all(U_hist, S_hist, F_hist, params.out_dir);
