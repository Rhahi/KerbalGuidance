import Geophysics: pressure as earthpressure

Earth = Body(
    6371km,
    140km,
    9.80665m/s^2,
    earthpressure, # Pa (plain)
    287.052874J/kg/K, # specific gas constant of air
)
