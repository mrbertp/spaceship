float sf = 0.08;
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

class Body {

  String id;
  PVector pos, vel, acc, force, grav;
  float m;
  int s;
  color c;
  ArrayList<PVector> trail;
  int trail_max;

  Body(String identifier, PVector position, PVector velocity, float mass, int size, color col) {

    id = identifier;
    pos = position;
    vel = velocity;
    m = mass;
    s = size;
    c = col;
    force = new PVector(0.0, 0.0);
    grav = new PVector(0.0, 0.0);

    trail = new ArrayList<PVector>();
    trail_max = 0;
  }

  void move() {
    force = grav;
    acc = force.copy().div(m);
    vel = vel.copy().add(acc);
    pos = pos.copy().add(vel);
    if (trail.size() > trail_max) {
      trail.remove(0);
    }
    if (frameCount % int(500*sf) == 0) {
      trail.add(pos.copy());
    }
    fill(c);
    for (int i = 0; i < trail.size(); i++) {
      ellipse(trail.get(i).x, trail.get(i).y, s/2, s/2);
    }
  }

  void display() {
    fill(c);
    noStroke();
    ellipse(pos.x, pos.y, s, s);
  }
}
