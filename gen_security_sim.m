%% Generative System Security Tradeoff Simulation
% An numerical analysis of the evolution of Generative Systems
%
%% Background
%   From the roots of machine learning with simple nueral networks, we have come all the 
% way to multi-billion parameter generative models with apparent emergent conciousness.
% These models are commonly used as multi-modal and text based chat interfaces. This 
% analysis treats these models, the users, and the regulators/architects as a time 
% varying system.
% 
%   The architects and regulators create some model (M) at time t. With that is defined
% a user interface U(t) for the model. Due to nature of most generative interfaces, some
% user inputs and model responses are part of the chat context. This context continuously
% changes throughout the user story. Users in general have some strategies for bypassing
% these security measures and there is some risk profile for the operators and some 
% reward for the users.
% 
%   When the context window is identifyied as having an unsafe or liability risk pattern
% it can be flagged. The security strategies for identifying which contexts should be 
% reviewed or flagged is defined as S(t). This secuity function is driven by multiple
% stakeholders, including the operator, the regulators, and social pressures.
%

%% Setup
%
clear;
clc;
close all;

%% Simulation Parameters
% 
% T - Period of time the evolution is simulated for
% N - Size of input array (context window size in bits)
% eta - secuity evolution rate (how fast security happens be it government or corprate)
% beta - payoff evolition rate?
% noise - amount of noise, this is the hardest to model and can have signifiant impact.
% k - Entropy rate
% gamma - institutional forgetting / regulatory relaxation
%
% These should be tuned to some real world data to lay a realist framework for drawing
% real-world conclusions.
%

% Parameters
T = 1000;
N = 4096;
eta = 0.07;
b = 0.1;
noise = 0.2;
k = 0.02;
gamma = 0.02; 


%% Inital Conditions
% U - Model state
% S - Security intensity
% F - System Entropy
%
% Similar to the simulation parameters, these initial conditions will greatly influence
% the outcomes of the simulation. For realistic simulation you must determine adequete
% initial conditions that reflect some point in time. Even from the start of LLMs the 
% security profile was likely never zero,
%

% Conditions
S = 0.1;
U = rand(1, N);
U = U / sum(U);

% These remain zero
U_hist = zeros(T, N);
S_hist = zeros(T, 1);
F_hist = zeros(T, 1);

% SIMULATION LOOP
for t = 1:T

    % Establish risk at t
    risk_profile =  (t/T) * linspace(0.1, 1, N);
    
    % Store history
    U_hist(t,:) = U;
    S_hist(t) = S;

    % SYSTEM OUTPUT ENTROPY--
    % F = -sum(U.*log(U + 1e-12)) * exp(-k*S);
    noise = 0.2 * exp(-0.01*t);
    F = -sum(U.*log(U + 1e-12)) * exp(-k*S);
    F_hist(t) = F;

    % PAYOFF COMPUTATION-
    payoff = exp(-b * S.*risk_profile);

    % REPLICATOR DYNAMICS
    avg_payoff = sum(U.*payoff);
    U = U.*(payoff./ avg_payoff);

    % MUTATION(novel strategies)
    U = U + noise * rand(1, N);
    U = max(U, 0);
    U = U / sum(U);

    % RISK ESTIMATION
    risk = sum(U.*risk_profile);

    % SECURITY UPDATE
    S = S + eta * risk - gamma * S;

end

% VISUALIZATIONS

figure;
plot(1 : T, S_hist, 'LineWidth', 2);
xlabel('Time');
ylabel('Security Intensity S(t)');
title('Monotonic Growth of Security');
grid on;
saveas (gcf, 'out/Growth.png');

figure;
plot(1 : T, F_hist, 'LineWidth', 2);
xlabel('Time');
ylabel('Generative Flexibility F(t)');
title('Entropy of Output Distribution');
grid on;
saveas (gcf, 'out/Entropy.png');

figure;
plot(S_hist, F_hist, 'LineWidth', 2);
xlabel('Security Intensity');
ylabel('Generative Flexibility');
title('Security–Flexibility Phase Trajectory');
grid on;
saveas (gcf, 'out/Trajectory.png');

figure;
imagesc(U_hist');
colorbar;
xlabel('Time');
ylabel('Strategy Index');
title('Evolution of User Strategy Distribution');
saveas (gcf, 'out/Evolution.png');

figure;
plot3(S_hist, F_hist, (1:T),'LineWidth',2);
xlabel('Security');
ylabel('Flexibility');
zlabel('Time');
title('3D Phase Trajectory');
grid on;
saveas (gcf, 'out/Phase3D.png');

dS = diff(S_hist);
dF = diff(F_hist);

figure;
quiver(S_hist(1:end-1),F_hist(1:end-1),dS,dF);
xlabel('Security');
ylabel('Flexibility');
title('Phase Space Vector Field');
grid on;
saveas (gcf, 'out/Vector.png');


idx = find(abs(S_hist-mean(S_hist))<0.01);
figure;
plot(F_hist(idx),zeros(size(idx)),'o');
title('Poincaré Section');
saveas (gcf, 'out/Poincaré.png');
