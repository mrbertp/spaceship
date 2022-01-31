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
    trail_max = 100000000;
  }

  void move() {
    force = grav;
    acc = force.div(m);
    vel = vel.add(acc);
    pos = pos.add(vel);
    if(trail.size() > trail_max){
      trail.remove(0);
    }
    if(frameCount % int(2000*sf) == 0){
      trail.add(pos.copy());
    }
    fill(c);
    for (int i = 0; i < trail.size(); i++) {
      ellipse(trail.get(i).x, trail.get(i).y, s/4, s/4);
    }
  }

  void display() {
    fill(c);
    ellipse(pos.x, pos.y, s, s);
  }
}
