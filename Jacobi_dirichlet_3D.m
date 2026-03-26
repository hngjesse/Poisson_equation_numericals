clear; clc; 

%% --- Parameters ---
Nx = 50;          % reduce size (3D is heavy!)
Ny = 50;
Nz = 50;

Lx = 1;
Ly = 1;
Lz = 1;

dx = Lx/(Nx-1);
dy = Ly/(Ny-1);
dz = Lz/(Nz-1);

epsilon0 = 1;

%% --- Grid ---
x = linspace(0, Lx, Nx);
y = linspace(0, Ly, Ny);
z = linspace(0, Lz, Nz);

[X, Y, Z] = meshgrid(x, y, z);

%% --- Charge density (3D Gaussian) ---
rho = exp(-((X-0.5).^2 + (Y-0.5).^2 + (Z-0.5).^2)/0.02);

%% --- Initialize potential ---
phi = zeros(Ny, Nx, Nz);

% --- Dirichlet boundary conditions (6 faces) ---
phi(1,:,:)   = 0.002;   % y = 0
phi(end,:,:) = 0.0;   % y = Ly

phi(:,1,:)   = 0.02;   % x = 0
phi(:,end,:) = 0.01;   % x = Lx

phi(:,:,1)   = 0.0;   % z = 0
phi(:,:,end) = 0.0;   % z = Lz

%% --- Iteration parameters ---
max_iter = 5000;
tolerance = 1e-5;

%% --- Jacobi iteration ---
for iter = 1:max_iter
    phi_old = phi;

    for i = 2:Ny-1
        for j = 2:Nx-1
            for k = 2:Nz-1
                phi(i,j,k) = (1/6)*( ...
                    phi_old(i+1,j,k) + phi_old(i-1,j,k) + ...
                    phi_old(i,j+1,k) + phi_old(i,j-1,k) + ...
                    phi_old(i,j,k+1) + phi_old(i,j,k-1) + ...
                    dx^2 * rho(i,j,k)/epsilon0 );
            end
        end
    end

    % Convergence check
    err = max(abs(phi(:) - phi_old(:)));
    if err < tolerance
        fprintf('Converged in %d iterations\n', iter);
        break;
    end
end

%% --- Visualization (slice plot) ---
figure;
isoplot3(X, Y, Z, phi, ...
    'NumLevels', 10, ...
    'FaceAlpha', 0.2, ...
    'Lighting', false);

% skip = 3;
% splot3(X(1:skip:end,1:skip:end,1:skip:end), ...
%        Y(1:skip:end,1:skip:end,1:skip:end), ...
%        Z(1:skip:end,1:skip:end,1:skip:end), ...
%        phi(1:skip:end,1:skip:end,1:skip:end),'MarkerSize', 10);



pbaspect([1 1 1])
box off
set(gca, 'XMinorTick','on','YMinorTick','on', ...
    'XColor','k','YColor','k','TickDir','out');