float sf = 0.07;
float G = 6.674e-11;
float Is = 5.961e7;
float Rs = 6.96e8;

PVector g_force(Body body1, Body body2) {
  PVector r = body2.pos.copy().sub(body1.pos);
  float d = r.mag();
  PVector f = r.copy().setMag((G * body1.m * body2.m)/pow(d, 2));
  return f;
}

float vc(float m_atractor, float d) {
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
    trail_max = 20;
  }

  void move() {
    force = grav;
    acc = force.copy().div(m);
    vel = vel.copy().add(acc);
    pos = pos.copy().add(vel);
    if (trail.size() > trail_max) {
      trail.remove(0);
    }
    if (frameCount % int(300*sf) == 0) {
      trail.add(pos.copy());
    }
  }

  void display() {
    fill(c);
    noStroke();
    // reallocated trail display to display function
    
    for (int i = 0; i < trail.size(); i++) {
      pushMatrix();
      translate(trail.get(i).x, trail.get(i).y, trail.get(i).z);
      sphere(s/6);
      popMatrix();
    }
        
    stroke(c);
    strokeWeight(1);
    
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    sphere(s);
    popMatrix();
  }
}

float I(float d){
  return Is * pow(Rs/d, 2);
}
