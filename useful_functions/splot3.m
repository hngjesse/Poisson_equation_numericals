function h = splot3(X, Y, Z, S, varargin)

% ================= Input parsing =================
p = inputParser;
p.addParameter('MarkerSize', 40, @(x) isnumeric(x));
p.addParameter('Colormap', turbo(256));
p.addParameter('Colorbar', true, @(x) islogical(x) || isnumeric(x));
p.addParameter('Parent', gca);
p.parse(varargin{:});

ms   = p.Results.MarkerSize;
cmap = p.Results.Colormap;
showCB = logical(p.Results.Colorbar);
ax   = p.Results.Parent;

hold(ax, 'on')
view(ax, 3)
grid(ax, 'on')

% ================= Flatten =================
X = X(:);
Y = Y(:);
Z = Z(:);
S = S(:);

% ================= Color mapping =================
S_min = min(S);
S_max = max(S);

colormap(ax, cmap)
clim(ax, [S_min S_max])

% ================= Plot =================
hs = scatter3(ax, X, Y, Z, ms, S, 'filled');

% ================= Axes =================
axis(ax, 'equal')
axis(ax, 'tight')

if showCB
    h.colorbar = colorbar(ax);
else
    h.colorbar = [];
end

xlabel(ax,'$x$','Interpreter','latex')
ylabel(ax,'$y$','Interpreter','latex')
zlabel(ax,'$z$','Interpreter','latex')

% ================= Outputs =================
h.scatter = hs;
h.axes = ax;

end