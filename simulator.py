import numpy as np
import pygame as pg
import pygame.freetype
import constants as ct
import navigation as nav
import physics as phy
import control as ctr
import datetime as dt

# INITIALIZATION

pg.init()
screen = pg.display.set_mode((ct.WIDTH, ct.HEIGHT))
pg.display.set_caption('Simulator')
clock = pg.time.Clock()
myfont = pg.freetype.SysFont('Consolas', 20)

toogle_trail = ct.trail
toogle_distance = ct.distance
toogle_forces = ct.forces
toogle_orbit = ct.orbit
# TODO: isolate trajectory calculation out of game loop
marker = 0

bodies = pg.sprite.Group()
ships = pg.sprite.Group()
trails = pg.sprite.Group()

# MAP READ
with open('map/quadrant-1.txt', 'r') as quadrant:
    for line in quadrant:
        entry = line.strip().split('\t')
        ID = entry[0]
        x, y, mass, size, vx, vy = list(map(float, entry[1:]))
        if ID == 'SHIP':
            ship = nav.Body(ID=ID, x=x, y=y, mass=mass, size=size, vel=np.array([vx, vy]))
            ships.add(ship)
        else:
            body = nav.Body(ID=ID, x=x, y=y, mass=mass, size=size, vel=np.array([vx, vy]))
            bodies.add(body)

flight = ctr.Flight(ship, ship)

# GAME LOOP
running = True
while running:
    # 0. run the loop at the desired frame rate
    clock.tick(ct.FPS)
    # 1. USER INPUT
    for event in pg.event.get():

        if event.type == pg.QUIT:
            running = False
        if event.type == pg.MOUSEBUTTONDOWN:
            x, y = event.pos
            for b in bodies:
                if b.rect.collidepoint(x, y):
                    flight.target = b
        if event.type == pg.KEYDOWN:
            if event.key == pg.K_r:
                flight.target = ship
            if event.key == pg.K_t:
                toogle_trail = not(toogle_trail)
            if flight.mode == 'Auto-Pilot':
                if event.key == pg.K_d:
                    toogle_distance = not(toogle_distance)
            if event.key == pg.K_f:
                toogle_forces = not(toogle_forces)
            if event.key == pg.K_o:
                toogle_orbit = not(toogle_orbit)

    # 2. UPDATE
    # gravity calculation
    ship.g_force = np.array([0, 0])
    for b in bodies:
        ship.g_force = ship.g_force + phy.g_force(b, ship)
        b.g_force = np.array([0, 0])
        b.g_force = b.g_force + phy.g_force(ship, b)
        for v in bodies:
            if v.ID != b.ID:
                b.g_force = b.g_force + phy.g_force(v, b)

    # trail calculation
    if marker > 100:
        marker = 1
    else:
        marker += 1
    if toogle_trail:
        if marker % 50 == 0:
            trail = nav.Body(x=ship.pos[0], y=ship.pos[1], size=1, color=ct.YELLOW)
            trails.add(trail)
            trails.update()

    # update elements
    flight.update()
    bodies.update()
    ships.update()

    # 3. RENDER
    screen.fill((0, 0, 0))

    # draw
    if toogle_distance:
        pg.draw.line(screen, ct.BLUE, phy.trans(ship.pos), phy.trans(flight.target.pos))
    if toogle_forces:
        pg.draw.line(screen, ct.YELLOW, phy.trans(ship.pos), phy.trans(ship.pos) + phy.trans(ship.vel, center=False) * 10 * ct.SCALE)
    if toogle_trail:
        trails.draw(screen)
    else:
        trails.empty()
    if flight.parked and toogle_orbit:
        pg.draw.circle(screen, ct.BLUE, (int(phy.trans(flight.target.pos)[0]), int(phy.trans(flight.target.pos)[1])), int(flight.radius/ct.SCALE), 1)

    bodies.draw(screen)
    ships.draw(screen)

    # text
    # TODO: aisolate text anywhere else?

    text, rect = myfont.render('MODE: ' + flight.mode, (255, 255, 255))
    screen.blit(text, (5, 5))
    text, rect = myfont.render(f'Vel: {round(phy.mag(ship.vel), 2)} m/s', (255, 255, 255))
    screen.blit(text, (5, 45))
    text, rect = myfont.render(f'F total: {round(phy.mag(ship.f_total), 2)} N', (255, 255, 255))
    screen.blit(text, (5, 65))
    text, rect = myfont.render(f'Gravity: {round(phy.mag(ship.g_force), 2)} N', (255, 255, 255))
    screen.blit(text, (5, 85))

    if flight.mode == 'Auto-Pilot':

        text, rect = myfont.render(f'Orbit Status: {flight.orbit_status}', (255, 255, 255))
        screen.blit(text, (5, 25))
        text, rect = myfont.render(f'Distance: {round(phy.mag(flight.distance), 0)} u', (255, 255, 255))
        screen.blit(text, (5, 105))
        text, rect = myfont.render(f'ERT: {round(flight.ert, 0)} s', (255, 255, 255))
        screen.blit(text, (5, 125))
        text, rect = myfont.render(f'Vc: {round(flight.vc, 2)} m/s', (255, 255, 255))
        screen.blit(text, (5, 145))
        text, rect = myfont.render(f'Ve: {round(flight.ve, 2)} m/s', (255, 255, 255))
        screen.blit(text, (5, 165))
        if flight.thrust_on:
            text, rect = myfont.render('Thrust', (0, 255, 255))
            screen.blit(text, (5, 185))

    pg.display.flip()
