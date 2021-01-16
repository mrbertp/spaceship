import numpy as np
import physics as phy
import constants as ct


class Flight():

    def __init__(self, subject=None):

        self.subject = subject
        self.target = np.array([0, 0])

    def update(self):

        self.distance = phy.distance(self.target, self.subject.pos)
        self.ert = self.distance / phy.distance((0, 0), self.subject.vel)
