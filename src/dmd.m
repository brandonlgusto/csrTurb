function [psi,lam,amp,frq] = dmd(X,nmodes)

    % get dimensions of input matrix
    [n m] = size(X);

    % compute SVD of reduced data matrix (full SVD for now)
    [U, S, V] = svd(X(:,1:m-1), 'econ');

    % truncate modes
    U = U(:,1:nmodes);
    S = S(1:nmodes,1:nmodes);
    V = V(:,1:nmodes);

    % compute the projection of the full matrix A onto POD modes ('A tilde')
    Aproj = U' * X(:,2:m) * V * inv(S);

    % compute the eigendecomposition of projection of A
    [W, lam] = eig(Aproj);
    lam = diag(lam);

    % compute all DMD modes
    psi = X(:,2:m) * V * inv(S) * W;

    % compute frequencies
    frq = log(lam) / (9.0/m);

    % compute initial amplitudes
    amp = pinv(psi) * X(:,1);

end
