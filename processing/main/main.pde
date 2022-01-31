ArrayList<Body> bodies;
Body ship;
Body sun;
Body b1, b2;

void setup() {
  size(800, 600);
  frameRate(120);
  rectMode(CENTER);
  
  ship = new Body("ship", new PVector(-10000.0, 10000.0), new PVector(20.0, 20.0), 100, int(10/sf), color(100, 100, 200));
  sun = new Body("sun", new PVector(0.0, 0.0), new PVector(0.0, 0.0), 5000000000.0, int(50/sf), color(200, 200, 100));

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

}
