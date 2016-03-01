function earth = initEarth()

%Real World Constants
earth.G = 6.6740831e-11;
earth.M = 5.97219e24;
earth.R = 6378e3;

h1 = figure(15); clf
[xS, yS, zS] = sphere;
mesh(earth.R*xS,earth.R*yS,earth.R*zS); hold all
xlabel('X'), ylabel('Y')
set(gca,'XTickLabel',[],'YTickLabel',[]);
axis equal
view(0,90)

h2 = figure(20); clf
[xS, yS, zS] = sphere;
mesh(earth.R*xS,earth.R*yS,earth.R*zS); hold all
xlabel('X'), ylabel('Y')
set(gca,'XTickLabel',[],'YTickLabel',[]);
axis equal
view(90,20)

earth.hh = [h1 h2];


end