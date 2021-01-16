import numpy as np
import pygame as pg
import pygame.freetype
import constants as ct
import navigation as nav
import physics as phy
import control as ctr

# INITIALIZATION
pg.init()
screen = pg.display.set_mode((ct.WIDTH, ct.HEIGHT))
pg.display.set_caption('Simulator')
clock = pg.time.Clock()
myfont = pg.freetype.SysFont('Consolas', 20)

toogle_trail = ct.trail
toogle_distance = ct.distance
toogle_forces = ct.forces
t = 0

bodies = pg.sprite.Group()
ships = pg.sprite.Group()
trails = pg.sprite.Group()

# FILE READ
with open('quadrant-1.txt', 'r') as quadrant:
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


flight = ctr.Flight(ship)

# GAME LOOP
running = True
while running:
    # 0. run the loop at the desired frame rate
    clock.tick(ct.FPS)
    # 1. USER INPUT
    for event in pg.event.get():
        if event.type == pg.QUIT:
            running = False
        if event.type == pg.KEYDOWN:
            if event.key == pg.K_t:
                toogle_trail = not(toogle_trail)
            if event.key == pg.K_d:
                toogle_distance = not(toogle_distance)
            if event.key == pg.K_p:
                ship.prop = 0
            if event.key == pg.K_f:
                toogle_forces = not(toogle_forces)

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
    if t > 100:
        t = 1
    else:
        t += 1
    if toogle_trail:
        if t % 50 == 0:
            trail = nav.Body(x=ship.pos[0], y=ship.pos[1], size=1, color=ct.YELLOW)
            trails.add(trail)
            trails.update()
    # update elements
    bodies.update()
    ships.update()
    flight.update()

    # 3. RENDER
    screen.fill((0, 0, 0))

    # draw
    if toogle_distance:
        pg.draw.line(screen, ct.BLUE, phy.trans(ship.pos), phy.trans(flight.target))
    if toogle_forces:
        pg.draw.line(screen, ct.YELLOW, phy.trans(ship.pos), phy.trans(ship.pos) + phy.trans(ship.f_total, center=False) * 20 * ct.SCALE)
    if toogle_trail:
        trails.draw(screen)
    else:
        trails.empty()

    bodies.draw(screen)
    ships.draw(screen)

    # text
    text, rect = myfont.render(f'Vel: {round(phy.distance((0,0),ship.vel), 4)} u/s', (255, 255, 255))
    screen.blit(text, (5, 5))
    text, rect = myfont.render(f'Gravity: {round(phy.distance((0,0),ship.g_force), 4)} N', (255, 255, 255))
    screen.blit(text, (5, 25))
    text, rect = myfont.render(f'Distance: {round(flight.distance, 0)} u', (255, 255, 255))
    screen.blit(text, (5, 45))

    pg.display.flip()
