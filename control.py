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
        self.thrust_duration = 10

        if self.subject != self.target:
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

            self.distances = np.array([phy.distance(i, self.target.pos) for i in self.trayectory])
            self.velocities = np.array(self.velocities)
            self.speeds = np.array([phy.mag(i) for i in self.velocities])

            # orbit establishment
            self.min_distance = self.distances.min()
            self.thrust_time = np.where(self.distances == self.min_distance)[0][0]
            self.thrust_pos = self.trayectory[self.thrust_time]
            self.thrust_speed = self.speeds.max()
            self.speed_orbit = phy.vc(self.target.mass, self.min_distance)
            self.dv = self.thrust_speed - self.speed_orbit
            self.thrust_acc = self.dv / self.thrust_duration
            self.thrust_mag = self.thrust_acc * self.subject.mass
            self.orb_velocity = self.speed_orbit * phy.normalize(self.velocities[self.thrust_time])

            # orbit representation
            self.period = int(phy.period(self.min_distance, self.target.mass))
            self.orbit = []
            self.v_orbit = self.orb_velocity
            self.x_orbit = self.thrust_pos

            for i in range(self.period):
                if i == 0:
                    self.fg_orbit = ct.G * self.target.mass * self.subject.mass / (phy.distance(self.target.pos, self.thrust_pos))**2 * phy.normalize(self.target.pos - self.thrust_pos)
                else:
                    self.fg_orbit = ct.G * self.target.mass * self.subject.mass / (phy.distance(self.target.pos, self.x_orbit))**2 * phy.normalize(self.target.pos - self.x_orbit)
                self.ft_orbit = self.fg_orbit
                self.a_orbit = self.ft_orbit / self.subject.mass
                self.v_orbit = self.v_orbit + self.a_orbit
                self.x_orbit = self.x_orbit + self.v_orbit
                self.orbit.append(self.x_orbit)

    def update(self):

        if self.subject != self.target:
            # flight parameters
            self.distance = phy.distance(self.target.pos, self.subject.pos)
            self.ert = self.distance / phy.mag(self.subject.vel)
            self.vc = phy.vc(self.target.mass, self.distance)
            self.ve = phy.ve(self.target.mass, self.distance)

            # thrust
            if (round(self.distance, 2) == round(self.min_distance, 2)):
                self.thrust_on = True

            if self.thrust_on and (self.thrust_duration > 0):

                self.subject.prop = -phy.normalize(self.subject.vel) * self.thrust_mag
                self.thrust_duration -= 1
            else:
                self.subject.prop = np.array([0, 0])
                self.thrust_on = False

            # orbit status
            if phy.mag(self.subject.vel) < self.ve:
                if phy.mag(self.subject.vel) < self.vc:
                    self.status = 'lentito'
                else:
                    self.status = 'rapidito'
            else:
                self.status = 'escapito'
