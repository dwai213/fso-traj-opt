function moveCamera(h,coords,interval,i)

figure(h)
if (i - interval) < 0
    view(90,0);
    for ang = 5:-.25:1
        camva(ang)
        pause(.1)
    end
else
    dx = coords.x(i);
    dy = coords.y(i);
    dz = coords.z(i);
    campos([dx dy dz])
    drawnow
    camva(35)
end

end