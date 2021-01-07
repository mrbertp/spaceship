import numpy as np
import physics as phy
import constants as ct


class Flight():

    def __init__(self, subject=None):

        self.subject = subject
        self.target = np.array([0, 200])

    def update(self):

        self.distance = phy.distance(self.target, self.subject.pos)
        self.ert = self.distance / self.subject.prop_mag
