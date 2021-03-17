function [low_rank,sparse] = DMD(frameMatrix,t,dt,background)
    % Compute X and X' where AX = X'
    X = frameMatrix(:,1:end-1);
    Xprime = frameMatrix(:,2:end);
    % Find A by computing its eigenvalues and eigenvectors
    [U,S,V] = svd(X, 'econ');
    % find none zero singular value
    subplot(1,2,1)
    plot(diag(S)/sum(diag(S)), 'ko')
    title('Energy in each singular value')
    xlabel('singular values')
    ylabel('Energy percentage')
    rank = find(cumsum(diag(S)./sum(diag(S))) > 0.9,1);
    rank
    U = U(:,1:rank);
    S = S(1:rank,1:rank);
    V = V(:,1:rank);
    % Computing Eignevalues and vectors
    A = U'*Xprime*V/S;
    [ev, D] = eig(A);
    eigenValues = diag(D);
    phi = Xprime*V/S*ev;
    omega = log(eigenValues)/dt;
    subplot(1,2,2)
    plot(abs(omega),'ko')
    title('Frequency of each eigenvalue')
    xlabel('Corresponding eigenvalue')
    ylabel('Frequency')
%   Compute the background
    idx = find(abs(omega) < background);
    omega_back = omega(idx);
    phi_back = phi(:,idx);
    b_back = phi_back \ (X(:,1));
    low_rank = zeros(numel(omega_back), length(t));
    for tt = 1:length(t)
        low_rank(:, tt) = b_back .* exp(omega_back .* t(tt));
    end
    low_rank = phi_back * low_rank;
    % Compute the foreground
    sparse = frameMatrix - abs(low_rank);
    R = sparse .* (sparse < 0);
    low_rank = R + abs(low_rank) ;
    sparse = sparse - R;
end

