"""
gravity_acc(body, h)

Gravity acceleration the model rocket is experiencing.
"""
function gravity_acc(body::Body, altitude)
body.grav*(body.bedrock)^2/(body.bedrock+altitude)^2 # m/s²
end


"""
gravity_acc(body)

Gravity acceleration the model rocket is experiencing.
Flat Earth approximation.
"""
function gravity_acc(body::Body)
body.grav # m/s²
end
