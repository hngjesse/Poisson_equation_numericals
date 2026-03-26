function h = isoplot3(X, Y, Z, S, varargin)

% ================= Input parsing =================
p = inputParser;
p.addParameter('NumLevels', 5, @(x) isnumeric(x) && x>0);
p.addParameter('Levels', [], @(x) isnumeric(x));
p.addParameter('FaceAlpha', 0.5, @(x) isnumeric(x));
p.addParameter('EdgeColor', 'none');
p.addParameter('Colormap', turbo(256));
p.addParameter('Colorbar', true, @(x) islogical(x) || isnumeric(x));
p.addParameter('Lighting', true, @(x) islogical(x));
p.addParameter('Parent', gca);
p.parse(varargin{:});

nLevels = p.Results.NumLevels;
levels  = p.Results.Levels;
fa      = p.Results.FaceAlpha;
ec      = p.Results.EdgeColor;
cmap    = p.Results.Colormap;
showCB  = logical(p.Results.Colorbar);
useLight= p.Results.Lighting;
ax      = p.Results.Parent;

hold(ax, 'on')
view(ax, 3)
grid(ax, 'on')

% ================= Levels =================
Smin = min(S(:));
Smax = max(S(:));

if isempty(levels)
    levels = linspace(Smin, Smax, nLevels+2);
    levels = levels(2:end-1);   % avoid extremes
end

% ================= Colormap =================
colormap(ax, cmap)
clim(ax, [Smin Smax])

% ================= Plot isosurfaces =================
hp = gobjects(length(levels),1);

for i = 1:length(levels)
    isoVal = levels(i);

    % Normalize value → colormap index
    t = (isoVal - Smin) / (Smax - Smin);
    idx = max(1, min(round(t*(size(cmap,1)-1))+1, size(cmap,1)));
    c = cmap(idx,:);

    % Create surface
    p_iso = patch(isosurface(X, Y, Z, S, isoVal));
    
    set(p_iso, ...
        'FaceColor', c, ...
        'EdgeColor', ec, ...
        'FaceAlpha', fa);

    isonormals(X, Y, Z, S, p_iso);

    hp(i) = p_iso;
end

% ================= Lighting =================
if useLight
    camlight(ax, 'headlight');
    lighting(ax, 'gouraud');
end

% ================= Axes =================
axis(ax, 'equal')
axis(ax, 'tight')

xlabel(ax,'$x$','Interpreter','latex')
ylabel(ax,'$y$','Interpreter','latex')
zlabel(ax,'$z$','Interpreter','latex')

% ================= Colorbar =================
if showCB
    h.colorbar = colorbar(ax);
else
    h.colorbar = [];
end

% ================= Outputs =================
h.patches = hp;
h.levels  = levels;
h.axes    = ax;

end