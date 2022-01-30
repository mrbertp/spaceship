class Body {

  String id;
  PVector pos, vel, acc, force, grav;
  float m;
  int s;
  color c;

  Body(String identifier, PVector position, PVector velocity, float mass, int size, color col) {

    id = identifier;
    pos = position;
    vel = velocity;
    m = mass;
    s = size;
    c = col;
    force = new PVector(0.0, 0.0);
    grav = new PVector(0.0, 0.0);
  }

  void move() {
    force = grav;
    acc = force.div(m);
    vel = vel.add(acc);
    pos = pos.add(vel);
  }
  
  void display() {
    fill(c);
    rect(pos.x, pos.y, s, s);
  }

  
}
