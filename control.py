import numpy as np
import physics as phy
import constants as ct
import datetime as dt


class Flight():

    def __init__(self, subject=None, target=None):

        self.subject = subject
        self.target = target

        self.thrust_on = False
        self.thrust_mag = 0
        self.status = ''

        # trajectory and velocity prediction
        self.fg_pred = np.array([0, 0])
        self.ft_pred = np.array([0, 0])
        self.a_pred = np.array([0, 0])
        self.v_pred = self.subject.vel
        self.x_pred = self.subject.pos
        self.trayectory = []
        self.velocities = []

        self.pred_time = 100 * ct.FPS

        for i in range(self.pred_time):
            if i == 0:
                self.fg_pred = phy.g_force(self.target, self.subject)
            else:
                self.fg_pred = ct.G * self.target.mass * self.subject.mass / (phy.distance(self.target.pos, self.x_pred))**2 * phy.normalize(self.target.pos - self.x_pred)
            self.ft_pred = self.fg_pred
            self.a_pred = self.ft_pred / self.subject.mass
            self.v_pred = self.v_pred + self.a_pred
            self.x_pred = self.x_pred + self.v_pred
            self.trayectory.append(self.x_pred)
            self.velocities.append(self.v_pred)

        self.distances = [phy.distance(i, self.target.pos) for i in self.trayectory]
        self.velocities_mag = [phy.mag(i) for i in self.velocities]

        # orbit establishment
        self.thrust_point = min(self.distances)
        self.v_max = max(self.velocities_mag)
        self.v_orb = phy.vc(self.target.mass, self.thrust_point)
        self.thrust_time = 10
        self.dv = self.v_max - self.v_orb
        self.thrust_acc = self.dv / self.thrust_time
        self.thrust_mag = self.thrust_acc * self.subject.mass

    def update(self):

        # flight parameters
        self.distance = phy.distance(self.target.pos, self.subject.pos)
        self.ert = self.distance / phy.mag(self.subject.vel)
        self.vc = phy.vc(self.target.mass, self.distance)
        self.ve = phy.ve(self.target.mass, self.distance)

        # thrust
        if (int(self.distance) == int(self.thrust_point)):
            self.thrust_on = True

        if self.thrust_on and (self.thrust_time > 0):

            self.subject.prop = -phy.normalize(self.subject.vel) * self.thrust_mag
            self.thrust_time -= 1
        else:
            self.subject.prop = np.array([0, 0])
            self.thrust_on = False

        # flight status
        if phy.mag(self.subject.vel) < self.ve:
            if phy.mag(self.subject.vel) < self.vc:
                self.status = 'lentito'
            else:
                self.status = 'rapidito'
        else:
            self.status = 'escapito'
