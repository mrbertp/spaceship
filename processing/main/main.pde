ArrayList<Body> bodies;
Body ship;
Body sun;
Body b1, b2;

void setup() {
  size(800, 600);
  frameRate(60);
  rectMode(CENTER);
  
  ship = new Body("ship", new PVector(0, 2000), new PVector(-6, 0), 100.0, int(10/sf), color(100, 100, 200));
  sun = new Body("sun", new PVector(0,0), new PVector(0, 0), 1000000000000000.0, int(50/sf), color(200, 200, 100));
  bodies = new ArrayList<Body>();
  bodies.add(ship);
  bodies.add(sun);

}

void draw() {
  background(0);
  translate(width/2, height/2);
  scale(sf);

  for (int i = 0; i < bodies.size(); i++) {
    bodies.get(i).grav = new PVector(0.0, 0.0);
    for (int j = 0; j < bodies.size(); j++) {
      if (j != i) {
        bodies.get(i).grav.add(g_force(bodies.get(i), bodies.get(j)));
      }
    }

    bodies.get(i).move();
    bodies.get(i).display();
  }
  resetMatrix();
  textSize(20);
  fill(200);
  text("vel: " + nf(ship.vel.mag(), 0, 4) + " m/s", 10, height-10);
  text("vc: " + nf(vc(sun.m, PVector.sub(sun.pos, ship.pos).mag()), 0, 4) + " m/s", 10, height-30);
  text("ve: " + nf(sqrt(2) * vc(sun.m, PVector.sub(sun.pos, ship.pos).mag()), 0, 4) + " m/s", 10, height-50);

}
