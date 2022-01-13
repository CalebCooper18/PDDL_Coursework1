;destorys two astorid belts and returns back to earth
(define (problem problem_name) (:domain space)
(:objects 
london - spaceport
manchester - landingbay
kanye - captain
charles - navigator
drake donald kendrick - engineer
travis post - officer
bg - bridge
sc - science_lab
lb - launch_bay
eng - engineering_room
ca - cannon
yeezyus - spacecraft
mars saturn - planet
space - empty
g6 g7 - astorid_belt
nowhere - nebula
jik - plasma
probe - probe
repairbot1  - repair_ships
lander lander1 - lander
ant1 ant2 ant3 ant4 - antenna
centralcomputer - computer
missioncontrol - mission_control
energy - energy
)

(:init
(launch yeezyus london)
(link sc ca)
(link ca sc)
(link eng sc)
(link sc lb)
(link eng bg)
(link bg eng)
(link sc eng)
(link lb sc)
(link lb bg)
(in_room kanye ca)
(in_room charles sc)
(in_room drake sc)
(in_room donald eng)
(in_room kendrick bg)
(in_room travis bg)
(in_room post sc)
(nebula_contains nowhere jik)
(inspacecraftp probe)
(inspacecraftp lander)
(inspacecraftp lander1)
(inspacecraftship repairbot1)
(probe_available probe lb)
(lander_available lander lb)
(lander_available lander1 lb)
(antenna_available lander ant1)
(antenna_available lander ant2)
(antenna_available lander1 ant3)
(antenna_available lander1 ant4)
(repair_ship_available repairbot1 lb)
)

(:goal (and
    (destory_astorid g6)
    (destory_astorid g7)
    (upload centralcomputer missioncontrol)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
