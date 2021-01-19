import numpy as np
import physics as phy
import constants as ct


class Flight():

    def __init__(self, subject=None, target=None):

        self.subject = subject
        self.target = target

        self.thrust = 0
        self.thrust_duration = 175
        self.t = 0

    def update(self):

        self.distance = phy.distance(self.target.pos, self.subject.pos)
        self.ert = self.distance / phy.distance((0, 0), self.subject.vel)
        self.vc = phy.vc(self.target, self.subject)
        self.ve = phy.ve(self.target, self.subject)

        if (self.distance < 2000) and (self.t <= self.thrust_duration):
            self.thrust = 5
            self.t += 1
            self.subject.prop = -phy.normalize(self.subject.vel) * self.thrust
        else:
            self.subject.prop = np.array([0, 0])

        print('t:', self.t, 'prop', self.subject.prop)
