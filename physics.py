import numpy as np
import constants as ct
import navigation as nav

ux = np.array([1, 0])
uy = np.array([0, -1])
base = np.array([ux, uy])


def distance(u, v):
    return ((u[0] - v[0])**2 + (u[1] - v[1])**2)**(1 / 2)


def mag(v):
    return distance((0, 0), v)


def normalize(v):
    mod = distance((0, 0), (v[0], v[1]))
    return (v / mod)


def rotate(v, alpha):
    a = np.radians(alpha)
    kernel = np.array([
        np.array([np.cos(a), np.sin(a)]),
        np.array([np.sin(a), np.cos(a)])
    ])
    return np.dot(v, kernel)


def trans(array, center=True):
    trans = np.dot(array, base) / ct.SCALE
    if center:
        trans = trans + np.array([ct.WIDTH, ct.HEIGHT]) / 2
    return trans


def trans_rev(array, center=True):
    trans_rev = array
    if center:
        trans_rev = trans_rev - np.array([ct.WIDTH, ct.HEIGHT]) / 2
    trans_rev = np.dot(trans_rev, base) * ct.SCALE
    return trans_rev


def g_force(body1, body2):
    r = distance(body1.pos, body2.pos)
    f_mod = ct.G * body1.mass * body2.mass / r**2
    f_u = normalize(body1.pos - body2.pos)
    f = f_mod * f_u
    return f


def vc(M, r):
    return (ct.G*M/r)**(1/2)


def ve(M, r):
    return vc(M, r)*2**(1/2)


def period(r, M):
    return 2 * np.pi * (r**3/(ct.G*M))**(1/2)
