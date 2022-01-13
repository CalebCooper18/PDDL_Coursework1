; scans one planet fully which is low radition then scans the ground of another one
; scans nebula of one which is dark (additonal feature)
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
a1 - astorid_belt
nowhere b2  - nebula
jik lop - plasma
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
(nebula_contains b2 lop)
(dark b2)
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
    (full_planet_scan mars centralcomputer)
    (planet_info_ground saturn centralcomputer)
    (plasma_info lop centralcomputer)
    (upload centralcomputer missioncontrol)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)