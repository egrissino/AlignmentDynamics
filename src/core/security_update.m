function S = security_update(S, eta, gamma, risk)
%SECURITY_UPDATE  Update security intensity for one time step.
%
%   S = security_update(S, eta, gamma, risk)
%
%   Security grows in response to estimated risk and decays at rate
%   gamma (institutional forgetting / regulatory relaxation).
%
%   Arguments:
%     S     - current security intensity (scalar)
%     eta   - security evolution rate
%     gamma - institutional forgetting rate
%     risk  - current aggregate risk estimate (scalar)
%
%   Returns:
%     S - updated security intensity

  S = S + eta * risk - gamma * S;

end
