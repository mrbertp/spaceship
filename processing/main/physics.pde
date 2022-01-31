float sf = 0.005;

PVector g_force(Body body1, Body body2) {
  PVector d = PVector.sub(body2.pos, body1.pos);
  float G = 6.674 * pow(10, -11);
  PVector f = d.normalize().mult((G * body1.m * body2.m)/pow(d.mag(), 2));
  return f;
}
