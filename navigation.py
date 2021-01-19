import physics as phy
import numpy as np
import pygame as pg
import constants as ct


class Coordinates():

    def __init__(self, kind='cart', ux=np.array([1, 0]), uy=np.array([0, 1])):
        self.kind = kind

        if self.kind == 'cart-pygame':
            ux = np.array([1, 0])
            uy = np.array([0, -1])
            self.base = np.array([ux, uy])


class Position(Coordinates):

    def __init__(self, x=0, y=0, orx=0, ory=1):
        Coordinates.__init__(self, kind='cart-pygame')
        self.pos = np.array([x, y])
        self.orientation = np.array([orx, ory])


class Body(pg.sprite.Sprite, Position):

    def __init__(self, ID='', x=0, y=0, mass=1, size=5, color=ct.WHITE, vel=np.array([0, 0])):
        pg.sprite.Sprite.__init__(self)
        Position.__init__(self, x=x, y=y)

        self.ID = ID

        self.image = pg.Surface([size, size])
        self.image.fill(color)
        self.rect = self.image.get_rect()
        self.rect.centerx = phy.trans(self.pos)[0]
        self.rect.centery = phy.trans(self.pos)[1]

        self.mass = mass
        self.g_force = np.array([0, 0])
        self.vel = vel
        self.prop = np.array([0, 0])
        self.f_total = np.array([0, 0])

    def motion(self):

        self.f_total = self.g_force + self.prop
        self.acc = self.f_total / self.mass
        self.vel = self.vel + self.acc
        self.pos = self.pos + self.vel
        self.rect.centerx = phy.trans(self.pos)[0]
        self.rect.centery = phy.trans(self.pos)[1]

    def update(self):
        self.motion()
