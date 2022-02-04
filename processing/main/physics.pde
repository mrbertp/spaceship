float sf = 0.05;
float G = 6.674 * pow(10, -11);

PVector g_force(Body body1, Body body2) {
  PVector r = body2.pos.copy().sub(body1.pos);
  float d = r.mag();
  PVector f = r.copy().setMag((G * body1.m * body2.m)/pow(d, 2));
  return f;
}

float vc(float m_atractor, float d) {
  float G = 6.674 * pow(10, -11);
  return sqrt(G * m_atractor / d);
}
