;destorys 2 astorids scans full planet (which dark and high rad)
; scans another planet in the air which is dark. scans a planet on grund that isnt dark
; and low in radition. then collects plasma which is in the dark and uploads it to mission control
(define (problem problemspace) (:domain space)
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
mars saturn neptune - planet
space - empty
g6 g7 - astorid_belt
nowhere b2 - nebula
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
(not(dark nowehere))
(nebula_contains nowhere jik)
(nebula_contains b2 lop)
(highrad mars)
(dark mars)
(dark neptune)
(dark b2)
(inspacecraftp probe)
(inspacecraftp lander)
(inspacecraftship repairbot1)
(probe_available probe lb)
(lander_available lander lb)
(antenna_available lander ant1)
(antenna_available lander ant2)
(antenna_available lander ant3)
(repair_ship_available repairbot1 lb)
)

(:goal 
(and
  (destory_astorid g6)
  (destory_astorid g7)
  (plasma_info lop centralcomputer)
  (full_planet_scan mars centralcomputer)
  (planet_info_air neptune centralcomputer)
  (planet_info_ground saturn centralcomputer)
  (upload centralcomputer missioncontrol)

    ;todo: put the goal condition here

))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
