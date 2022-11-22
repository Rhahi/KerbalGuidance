using SpaceLib
using KerbalGuidance

sp = connect_to_spacecraft()
ref = Navigation.ReferenceFrame.BCBF(sp)
r = Navigation.coordinate(sp, ref)
up, east, north = Navigation.directionsₗ(r)
Navigation.Drawing.add_direction(sp, up, ref; color=:grey)
Navigation.Drawing.add_direction(sp, east, ref; color=:grey)
Navigation.Drawing.add_direction(sp, north, ref; color=:grey)

rotated1 = KerbalGuidance.planar_rotate(east, up, 45)
line1 = Navigation.Drawing.add_direction(sp, rotated1, ref; color=:white)
rotated2 = KerbalGuidance.axial_rotateₗ(east, up, 45)
line2 = Navigation.Drawing.add_direction(sp, rotated2, ref; color=:yellow)
rotated3 = KerbalGuidance.angle_directionₗ(r, 45, 45)
line3 = Navigation.Drawing.add_direction(sp, rotated3, ref; color=:blue)

a = [1,0,0]
b = [0,1,0]
n = [0,0,1]
@show KerbalGuidance.planar_rotate(a, b, 45)
@show KerbalGuidance.axial_rotate(a, n, 45)

function show_direction(r, θ, ϕ, ref)
    dir = KerbalGuidance.angle_direction(r, θ, ϕ)
    line = Navigation.Drawing.add_direction(sp, dir, ref; length=40, color=:cyan)
    @async begin
        sleep(5)
        Navigation.Drawing.remove!(line)
    end
end
function show_directionₗ(r, θ, ϕ, ref)
    dir = KerbalGuidance.angle_directionₗ(r, θ, ϕ)
    line = Navigation.Drawing.add_direction(sp, dir, ref; length=40, color=:cyan)
    @async begin
        sleep(5)
        Navigation.Drawing.remove!(line)
    end
end
