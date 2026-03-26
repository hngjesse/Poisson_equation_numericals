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

%% --- Charge density (example: Gaussian) ---
rho = exp(-((X-0.5).^2 + (Y-0.5).^2)/0.01);

%% --- Initialize potential ---
phi = zeros(Ny, Nx);

%% --- Neumann BC values (derivative in normal direction) ---
g_top    = 0.0;    % dphi/dy at top edge
g_bottom = 0.0;    % dphi/dy at bottom edge
g_left   = 0.03;    % dphi/dx at left edge
g_right  = 0;    % dphi/dx at right edge

%% --- Iteration parameters ---
max_iter = 10000;
tolerance = 1e-6;

%% --- Jacobi iteration with general Neumann BC ---
for iter = 1:max_iter
    phi_old = phi;

    % --- Apply Neumann BC ---
    phi(1,:)    = phi(2,:)    + g_top*dy;     % top
    phi(end,:)  = phi(end-1,:) + g_bottom*dy; % bottom
    phi(:,1)    = phi(:,2)    + g_left*dx;    % left
    phi(:,end)  = phi(:,end-1) + g_right*dx;  % right
    
    % --- Update interior points ---
    for i = 2:Ny-1
        for j = 2:Nx-1
            phi_new_scalar = 0.25 * ( ...
                phi(i+1,j) + phi(i-1,j) + ...
                phi(i,j+1) + phi(i,j-1) + ...
                dx^2 * rho(i,j)/epsilon0 );
            phi(i,j) = (1-omega)*phi(i,j) + omega*phi_new_scalar;
        end
    end

    % Check convergence
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
title('\phi(x,y) solution of Poisson equation (Neumann BC)');
xlabel('x'); ylabel('y')
pbaspect([1 1 1])
box off                      
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', ...
    'XColor', 'k','YColor', 'k','TickDir', 'out')