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
        self.thrust_duration = 10
        self.mode = ''
        self.parked = False

    def update(self):

        print(self.thrust_duration)
        # flight parameters
        self.distance = self.target.pos - self.subject.pos
        self.d = phy.mag(self.distance)
        self.ert = self.d / phy.mag(self.subject.vel)

        if self.target.ID != 'SHIP':

            self.mode = 'Auto-Pilot'

            self.vc = phy.vc(self.target.mass, self.d)
            self.ve = phy.ve(self.target.mass, self.d)
            self.angle = int(phy.angle(self.distance, self.subject.vel))

            # thrust
            if (self.angle == 90) and (not self.thrust_on) and (not self.parked):
                self.thrust_on = True
                self.parked = True
                self.dv = self.vc - phy.mag(self.subject.vel)
                self.thrust_acc = self.dv / self.thrust_duration
                self.thrust_mag = self.thrust_acc * self.subject.mass

            if self.thrust_on and (self.thrust_duration > 0):
                self.subject.prop = self.thrust_mag * phy.normalize(self.subject.vel)
                self.thrust_duration -= 1
            else:
                self.thrust_on = False
                self.subject.prop = np.array([0, 0])
                self.thrust_duration = 10

        else:
            self.mode = 'Free-Flight'
