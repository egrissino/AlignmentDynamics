function F = compute_entropy(U, S, k)
%COMPUTE_ENTROPY  Compute generative flexibility (system output entropy).
%
%   F = compute_entropy(U, S, k)
%
%   The entropy of the user strategy distribution is suppressed
%   exponentially by security intensity S.
%
%   Arguments:
%     U - (1 x N) user strategy distribution (probability simplex)
%     S - scalar security intensity
%     k - entropy suppression rate
%
%   Returns:
%     F - scalar generative flexibility

  F = -sum(U .* log(U + 1e-12)) * exp(-k * S);

end
