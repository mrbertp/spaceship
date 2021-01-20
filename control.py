import numpy as np
import physics as phy
import constants as ct


class Flight():

    def __init__(self, subject=None, target=None):

        self.subject = subject
        self.target = target

        self.thrust = 0
        self.ON = False
        self.stopwatch = 150

        self.fg_pred = np.array([0, 0])
        self.ft_pred = np.array([0, 0])
        self.a_pred = np.array([0, 0])
        self.v_pred = self.subject.vel
        self.x_pred = self.subject.pos
        self.trayectory_pred = []

        self.pred_time = 5000
        for i in range(self.pred_time):
            if i == 0:
                self.fg_pred = phy.g_force(self.target, self.subject)
            else:
                self.fg_pred = ct.G * self.target.mass * self.subject.mass / (phy.distance(self.target.pos, self.x_pred))**2 * phy.normalize(self.target.pos - self.x_pred)
            self.ft_pred = self.fg_pred
            self.a_pred = self.ft_pred / self.subject.mass
            self.v_pred = self.v_pred + self.a_pred
            self.x_pred = self.x_pred + self.v_pred
            if i % 100 == 0:
                self.trayectory_pred.append(phy.trans(self.x_pred))

    def update(self):

        self.distance = phy.distance(self.target.pos, self.subject.pos)
        self.ert = self.distance / phy.mag(self.subject.vel)
        self.vc = phy.vc(self.target, self.subject)
        self.ve = phy.ve(self.target, self.subject)

        if (self.distance < 1380):
            self.ON = True

        if self.ON and (self.stopwatch > 0):
            self.thrust = 5
            self.subject.prop = -phy.normalize(self.subject.vel) * self.thrust
            self.stopwatch -= 1
        else:
            self.subject.prop = np.array([0, 0])
            self.ON = False
