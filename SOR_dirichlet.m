clear; clc; 

%% --- Parameters ---
Nx = 100;
Ny = 100;
Lx = 1;
Ly = 1;

dx = Lx/(Nx-1);
dy = Ly/(Ny-1);

epsilon0 = 1;

omega = 1.8;  % try between 1 and 2


%% --- Grid ---
x = linspace(0, Lx, Nx);
y = linspace(0, Ly, Ny);
[X, Y] = meshgrid(x, y);

%% --- Charge density ---
rho = exp(-((X-0.5).^2 + (Y-0.5).^2)/0.01);

%% --- Initialize potential ---
phi = zeros(Ny, Nx);

% Boundary conditions
phi(1,:) = 0.1;
phi(end,:) = 0.3;
phi(:,1) = 0.4;
phi(:,end) = 0;

%% --- Iteration parameters ---
max_iter = 5000;
tolerance = 1e-6;

%% --- Gauss-Seidel iteration ---
for iter = 1:max_iter
    phi_old = phi;   % only for convergence check

    for i = 2:Ny-1
        for j = 2:Nx-1
            phi_new_scalar = 0.25 * ( ...
                phi(i+1,j) + phi(i-1,j) + ...
                phi(i,j+1) + phi(i,j-1) + ...
                dx^2 * rho(i,j)/epsilon0 );
            phi(i,j) = (1-omega)*phi(i,j) + omega*phi_new_scalar;
        end
    end

    % Convergence check
    err = max(max(abs(phi - phi_old)));
    if err < tolerance
        fprintf('Converged in %d iterations\n', iter);
        break;
    end
end

%% --- Plot ---
figure;
contourf(X, Y, phi, 100, 'EdgeColor', 'none');
colorbar;
title('\phi(x,y) solution of Poisson equation (Gauss-Seidel)');
xlabel('x'); ylabel('y');
pbaspect([1 1 1])
box off                      
set(gca, 'XMinorTick','on','YMinorTick','on', ...
    'XColor','k','YColor','k','TickDir','out');