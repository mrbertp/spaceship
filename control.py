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
        # TODO: flight mode switch
        self.mode = ''
        self.orbit_status = ''
        self.parked = False

    def update(self):

        # flight parameters
        self.distance = self.target.pos - self.subject.pos
        self.ert = phy.mag(self.distance) / phy.mag(self.subject.vel)

        if self.target.ID != 'SHIP':

            self.mode = 'Auto-Pilot'

            self.vc = phy.vc(self.target.mass, phy.mag(self.distance))
            self.ve = phy.ve(self.target.mass, phy.mag(self.distance))
            self.angle = phy.angle(self.distance, self.subject.vel)

            # thrust
            if (np.abs(self.angle - 90) < 1) and (not self.thrust_on) and (not self.parked):
                self.thrust_duration = 10
                self.thrust_on = True
                self.parked = True
                self.radius = phy.mag(self.distance)
                self.dv = self.vc - phy.mag(self.subject.vel)
                self.thrust_acc = self.dv / self.thrust_duration
                self.thrust_mag = self.thrust_acc * self.subject.mass

            if self.thrust_on and (self.thrust_duration > 0):
                self.subject.prop = self.thrust_mag * phy.normalize(self.subject.vel)
                self.thrust_duration -= 1
            else:
                self.thrust_on = False
                self.subject.prop = np.array([0, 0])

            # orbit status
            if phy.mag(self.subject.vel) < self.ve:
                if phy.mag(self.subject.vel) < self.vc:
                    self.orbit_status = 'Sub-circular'
                else:
                    self.orbit_status = 'Super-circular'
            else:
                self.orbit_status = 'Escape'

        else:

            self.mode = 'Free-Flight'
