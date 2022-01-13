;Header and description

(define (domain space)

;remove requirements that are not needed
(:requirements :strips :typing :negative-preconditions :conditional-effects)

(:types
spacecraft
captain navigator engineer officer - crew
bridge engineering_room launch_bay science_lab cannon - rooms
planet astorid_belt nebula empty - spacelocation
repair_ships
probe lander - data_gathering_ships
plasma energy - subtances
computer - ship_database
antenna
spaceport landingbay mission_control - earthlocations
)

(:predicates 
(in_space ?x - spacecraft)
(in_room ?c - crew ?r - rooms)
(launch ?x - spacecraft ?sp - spaceport)
(land ?x - spacecraft ?land - landingbay)
(at ?x - spacecraft ?l - spacelocation)
(damaged ?x - spacecraft)
(highrad ?pla - planet)
(dark ?l - spacelocation)
(full ?p - probe)
(inside_repair_ship ?c - crew ?s - repair_ships)
(repair_ship_available ?s - repair_ships ?l - launch_bay)
(link ?r1 - rooms ?r2 - rooms)
(probe_available ?p - probe ?l - launch_bay)
(lander_available ?l - lander ?lb - launch_bay)
(inspacecraftp ?p - data_gathering_ships)
(inspacecraftship ?s - repair_ships)
(probeat ?p - probe ?sp - spacelocation)
(plasmainship ?pl - plasma ?r - rooms)
(gatherplasma ?p - probe ?pl - plasma)
(plasma_info ?pl - plasma ?comp - computer)
(scan_planet ?p - probe ?pla - planet)
(planet_info_air ?pla - planet ?comp - computer)
(planet_info_ground ?pla - planet ?comp - computer)
(full_planet_scan ?pla - planet ?comp - computer)
(lander_on_planet  ?l - lander ?pla - planet)
(deploy_antenna ?ant - antenna ?pla - planet)
(antenna_available ?l - lander ?ant - antenna)
(upload ?comp - computer ?mis - mission_control)
(nebula_contains ?n - nebula ?pl - plasma)
(destory_astorid ?a - astorid_belt)
;(cannonmode ?c - cannon)
;(ultralightmode ?c - cannon)
(energy_available ?y - energy)
)

; moves the crew by links done in problem file
; cause the person to not be in orignal room but new one instead
(:action crew_move
    :parameters (?c - crew ?r1 - rooms ?r2 - rooms ?x - spacecraft)
    :precondition 
    (and
        (in_room ?c ?r1)
        (link ?r1 ?r2)
     )
    :effect 
    (and 
        (not (in_room ?c ?r1)) 
        (in_room ?c ?r2)
    )
)

; checks to see if there is energy available
; checks to see if all ships and probes are inside
; checks to see if captain and navigator are in the bridge 
; checks to see if the ship isnt damaged
; if it lands travels to a astorid belt the ship becomes damage
; consumes energy and makes it so ship is no longer in orginal position but its new one
(:action space_travel
    :parameters (?cp - captain ?n - navigator ?b - bridge ?x - spacecraft ?l1 - spacelocation ?l2 - spacelocation ?l - launch_bay ?y - energy)
    :precondition 
    (and
        (energy_available ?y)
        (in_space ?x)
        (forall (?p - probe)
        (inspacecraftp ?p)
        )
        (forall (?s - repair_ships)
        (inspacecraftship ?s) 
        )
        (at ?x ?l1)
        (in_room ?cp ?b)
        (in_room ?n ?b)
        (not(damaged ?x))
     )
    
    :effect (and
    (forall (?a - astorid_belt)
        (when (at ?x ?a)
        (damaged ?x)
        ) 
    )
    (not(energy_available ?y))
    (not (at ?x ?l1))
    (at ?x ?l2)
     
    )
)
; repairs the ship if its damaged and there is one engineer in the repairship and another
; in the engeering room
(:action repair_ship
    :parameters (?e - engineering_room ?e1 - engineer ?e2 - engineer ?s - repair_ships ?x - spacecraft)
    :precondition 
    (and 
    (damaged ?x)
    (in_room ?e2 ?e)
    (inside_repair_ship ?e1 ?s)


    )
    :effect 
    (and
    (not(damaged ?x))
     )
)
;lauches a repairbot if the ship is in space and not a nebula
;makes sure the repairbot  is available and 1 engineer is in the lanuchbay and another is in engineering
;cause the engineer to be in the ship (from lanuchbay) and for it to be not available
(:action launch_repairbot
    :parameters (?l - launch_bay ?e - engineering_room ?e1 - engineer ?e2 - engineer ?x - spacecraft ?s - repair_ships ?n - nebula)
    :precondition     
    (and
        (in_space ?x)
        (not(at ?x ?n))
        (in_room ?e2 ?e)
        (repair_ship_available ?s ?l)
        (in_room ?e1 ?l)
    )
    :effect 
    (and
        (not(in_room ?e1 ?l))
        (not(repair_ship_available ?s ?l))
        (not(inspacecraftship ?s))
        (inside_repair_ship ?e1 ?s) 
    
    
)
)
; reutrns repair ship if a engineer is in the ship and one is in the launchbay
; smakes the repair ship available again and in the spacecraft
(:action return_repairbot
    :parameters (?e1 - engineer ?e2 - engineer ?l - launch_bay ?s - repair_ships)
    :precondition 
    (and
        (inside_repair_ship ?e1 ?s)
        (in_room ?e2 ?l)
        (not(inspacecraftship ?s))
     )
    :effect (and
    (inspacecraftship ?s)
    (not(inside_repair_ship ?e1 ?s))
    (in_room ?e1 ?l)
    (repair_ship_available ?s ?l)
     )
)

;launches probe if the ship isnt damaged 
; also checks to see if its available and there is a engineer in the launch bay
;makes it so the probe is no longer in the space and no longer available
(:action launch_probe
    :parameters (?l - launch_bay ?e3 - engineer ?x - spacecraft  ?p - probe)
    :precondition 
    (and 
        (in_space ?x)
        (not(damaged ?x))
        (inspacecraftp ?p)
        (in_room ?e3 ?l)
        (probe_available ?p ?l)
    
    )
    :effect (and
        (not(inspacecraftp ?p))
        (not(probe_available ?p ?l))
     )
)

;makes sure the probe isnt full and isnt in the ship 
;checks to see if nebula isn't dark 
;makes sure the ship is at the nebula
;nebula contains plasma 
;causes probe to get full and its now in the nebula
(:action collect_nebula
    :parameters (?p - probe ?x - spacecraft ?n - nebula ?pl - plasma)
    :precondition 
    (and
        (nebula_contains ?n ?pl)
        (not(dark ?n))
        (not(full ?p))
        (at ?x ?n)
        (not(inspacecraftp ?p))
    )
    :effect 
    (and
        (full ?p)
        (probeat ?p ?n)
        (gatherplasma ?p ?pl)
     )
)

;gets a probe to return the plasma
;makes plasma permentatly available in the launchbay
;makes probe not full, in the ship and available again
;only returns plasma whilst the ship is still in the nebula
(:action return_plasma
    :parameters (?p - probe ?x - spacecraft ?n - nebula ?pl - plasma ?e1 - engineer ?lb - launch_bay)
    :precondition 
    (and
        (in_room ?e1 ?lb)
        (gatherplasma ?p ?pl)
        (probeat ?p ?n)
        (at ?x ?n)
     )
    :effect 
    (and
        (not(full ?p))
        (not(gatherplasma ?p ?pl))
        (not(probeat ?p ?n))
        (probe_available ?p ?lb)
        (inspacecraftp ?p)
        (plasmainship ?pl ?lb)
     )
)

;moves the plasma from the launch bay to the science lab
;gets a officer to move it
(:action move_plasma
    :parameters (?o - officer ?lb - launch_bay ?sc - science_lab ?pl - plasma )
    :precondition 
    (and
        (in_room ?o ?lb)
        (plasmainship ?pl ?lb)
        
     )
    :effect 
    (and
    (not(plasmainship ?pl ?lb))
    (not (in_room ?o ?lb))
    (in_room ?o ?sc)
    (plasmainship ?pl ?sc)
    
     )
)

;scans plasma to the computer if its in the science lab and theres a officer with it
;loses plasma after it has been scanned however
(:action scan_plasma
    :parameters (?pl - plasma ?o - officer ?sc - science_lab ?comp - computer ?x - spacecraft)
    :precondition 
    (and
        (in_space ?x)
        (plasmainship ?pl ?sc)
        (in_room ?o ?sc)

     )
    :effect 
    (and
        (plasma_info ?pl ?comp)
        ;(not(plasmainship ?pl ?sc))
     )
)
; checks to see if it can scan the planet by making sure its not dark
; gets probe to scan planet 
(:action scan_planet
    :parameters (?p - probe ?x - spacecraft ?pla - planet)
    :precondition 
    (and
        (not(dark ?pla))
        (at ?x ?pla)
        (not(inspacecraftp ?p))
     )
    :effect 
    (and
        (probeat ?p ?pla)
        (scan_planet ?p ?pla)
     )

)

; checks to see if probes at planet then scans it if it is
; then it returns the probe back to the ship and makes it available
; it uploads the scan to the computer in the ship
(:action return_scan
    :parameters (?p - probe ?x - spacecraft ?pla - planet ?e1 - engineer ?lb - launch_bay ?comp - computer )
    :precondition 
    (and
        (in_room ?e1 ?lb)
        (probeat ?p ?pla)
        (at ?x ?pla)
        (scan_planet ?p ?pla)
     )
    :effect 
    (and
    (not(scan_planet ?p ?pla))
    (not(probeat ?p ?pla))
    (planet_info_air ?pla ?comp)
    (probe_available ?p ?lb)
    (inspacecraftp ?p)
    
     )
)

;the ship will send a lander if they have scanned the planet from the air first and isn't damaged
; it will also check to see if there is a engineer in the launch bay and a lander is available
; it will then deploy lander and make it unavailable
(:action send_lander
    :parameters (?l - lander ?pla - planet ?x - spacecraft ?e - engineer ?lb - launch_bay ?comp - computer)
    :precondition 
    (and
        (not(damaged ?x))
        (at ?x ?pla) 
        (in_room ?e ?lb)
        (lander_available ?l ?lb)
        (planet_info_air ?pla ?comp)
    ) 
    :effect 
    (and
        (not(inspacecraftp ?l))
        (not(lander_available ?l ?lb))
        (lander_on_planet  ?l ?pla)
     )
)

; if a planet has low radition the lander deploys a single antenna
; makes sure that the antenna is no longer available either
(:action antenna_scan_planet_low_radition
    :parameters (?l - lander ?pla - planet ?ant - antenna ?comp - computer ?x - spacecraft )
    :precondition 
    (and
        (not(highrad ?pla))
        (in_space ?x)
        (antenna_available ?l ?ant)
        (lander_on_planet  ?l ?pla)

     )
    :effect (and

    (deploy_antenna ?ant ?pla)
    (not(antenna_available ?l ?ant))
    (planet_info_ground ?pla ?comp)
    )
)

; If a planet has high radition the lander deploys two different antenna's
; makes sure that the antennas are no longer available either
(:action antenna_scan_planet_high_radition
    :parameters (?l - lander ?pla - planet ?ant1 - antenna ?ant2 - antenna ?comp - computer ?x - spacecraft)
    :precondition 
    (and
        (in_space ?x)
        (highrad ?pla)
        (lander_on_planet  ?l ?pla)
        (antenna_available ?l ?ant1)
        (antenna_available ?l ?ant2)

    )
    :effect (and
    (deploy_antenna ?ant1 ?pla)
    (deploy_antenna ?ant2 ?pla)
    (not(antenna_available ?l ?ant1))
    (not(antenna_available ?l ?ant2))
    (planet_info_ground ?pla ?comp)
     )
)

; the ship will come back to pick up a rover if it needs it
; does this by having a engineer in the launch bay and the ship being back at the planet
(:action retrive_lander
    :parameters (?l - lander ?pla - planet ?x - spacecraft ?e - engineer ?lb - launch_bay)
    :precondition 
    (and
        (in_room ?e ?lb)
        (lander_on_planet  ?l ?pla)
        (at ?x ?pla)

     )
    :effect
    (and
        (lander_available ?l ?lb)

     )
)

; action only takes place if both a the ground and air(atomsphere) have been scanned
; it then uploads the full scan to the computer deleting the other two scans
(:action full_planet_scan
    :parameters (?pla - planet ?l - lander ?p - probe ?comp - computer)
    :precondition 
    (and
        (planet_info_ground ?pla ?comp)
        (planet_info_air ?pla ?comp)
     )
    :effect (and
        (full_planet_scan ?pla ?comp)
        (not (planet_info_ground ?pla ?comp))
        (not(planet_info_air ?pla ?comp))
 )
)
;Launchs the spacecraft making sure the captain and navigator are on the bridge
;it also causes the spaceship to be in space after the action is complete
(:action lunachspace_craft
    :parameters (?x - spacecraft ?sp - spaceport ?l - spacelocation ?cp - captain ?n - navigator ?br - bridge)
    :precondition 
    (and
    (not(in_space ?x))
    (launch ?x ?sp)
    (in_room ?cp ?br)
    (in_room ?n ?br)
    
     )
    :effect (and
    (at ?x ?l)
    (not(launch ?x ?sp))
    (in_space ?x)
     )
)
; lands the spaceship after everything is completed
; makes a check to see if both the repair ships and probes are back in the ship
; makes so that spaceship is considered no longer in space
(:action land_spacecraft
    :parameters (?x - spacecraft ?l - spacelocation ?land - landingbay ?y - energy)
    :precondition 
    (and
        (forall (?s - repair_ships)
        (inspacecraftship ?s) 
        )
        (forall (?p - probe)
        (inspacecraftp ?p)
        )
        (energy_available ?y)
        (not(damaged ?x))
        (at ?x ?l)
        (in_space ?X)
     )
    :effect 
    (and
    (not(in_space ?x))
    (not(at?x ?l))
    (land ?x ?land)
     )
)
; Uploads all the data once the ship has landed back on earth to mission control
(:action upload_all_data
    :parameters (?x  - spacecraft ?land - landingbay ?comp - computer ?mis - mission_control)
    :precondition
    (and
        (land ?x ?land)
        (not(in_space ?x))
     )
    :effect 
    (and
        (upload ?comp ?mis)
        
     )
)
;shoots a ultralight beam if there is enegry available
;the capatain is in the cannon and a engineer is available to watch over 
; makes it not dark and uses energy 
(:action shoot_ultralight_beam
    :parameters (?x - spacecraft ?l - spacelocation ?eng - engineering_room  ?cp - captain ?e - engineer ?c - cannon ?y - energy)
    :precondition 
    (and
    (dark ?l)
    (at ?x ?l)
    (in_room ?cp ?c)
    (in_room ?e ?eng)
    ;(ultralightmode)
    (energy_available ?y)
     )
    :effect (and
    (not(energy_available ?y))
    (not(dark ?l))
    
     )
)

;destroys astorids if they are in the way, still damages ship and consumes energy. 
;leaves the spaceship in a empty part of space
(:action destory_astorid
    :parameters (?x - spacecraft ?a - astorid_belt ?emp -empty ?cp - captain ?e - engineer ?eng - engineering_room ?c - cannon ?y - energy)
    :precondition (and
    (at ?x ?a)
    (in_room ?cp ?c)
    (in_room ?e ?eng)
    (energy_available ?y)
    ;(cannonmode ?c)
     )
    :effect (and
    (not(at ?x ?a))
    (at ?x ?emp)
    (not(energy_available ?y))
    (destory_astorid ?a)
    (damaged ?x)
     )
)
; code below works? however it crashes the system out as it can handle too many actions at once
; needs to be uncommented with other parts of commented code as well as cannonmode in the problem 
;file


;(:action ultralight_mode
    ;:parameters (?e - engineer ?c - cannon)
    ;:precondition 
    ;(and
    ;(cannonmode ?c)
    ;(in_room ?e ?c)
    ; )
    ;:effect (and
   ; (not(cannonmode ?c))
  ;  (ultralightmode ?c)
 ;    )
;)

;(:action cannon_mode
  ;  :parameters (?e - engineer ?c - cannon)
   ; :precondition 
   ; (and
    ;    (ultralightmode ?c)
     ;   (in_room ?e ?c)
     ;)
    ;:effect 
   ; (and
    ;    (not(ultralightmode ?c))
       ; (cannonmode ?c)
     ;)
;)


; creates energy for the ship to move, shoot ultralight beam and cannon
(:action make_energy
    :parameters (?sc - science_lab ?o - officer ?pl - plasma ?y - energy)
    :precondition 
    (and
        (plasmainship ?pl ?sc)
        (in_room ?o ?sc)
     )
    :effect (and
        ;(not(plasmainship ?pl ?sc))
        (energy_available ?y)
     )
)
)

