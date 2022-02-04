ArrayList<Body> bodies;
Body body, ship, star;
String[] map;

void setup() {
  size(800, 600);
  frameRate(120);
  rectMode(CENTER);

  bodies = new ArrayList<Body>();
  map = loadStrings("map.txt");
  for (int i=1; i < map.length; i++) {
    String[] fields = map[i].split("\t");
    String id = fields[0];
    PVector pos = new PVector(int(fields[1]), int(fields[2]));
    PVector vel = new PVector(int(fields[3]), int(fields[4]));
    float m = float(fields[5]);
    int s = int(fields[6]);
    color c = color(int(fields[7]), int(fields[8]), int(fields[9]));
    body = new Body(id, pos, vel, m, s, c);
    bodies.add(body);
  }
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
  for (int i=0; i < bodies.size(); i++) {
    if (bodies.get(i).id.equals("ship")) {
      ship = bodies.get(i);      
    }
    if (bodies.get(i).id.equals("star")) {
      star = bodies.get(i);
    }
  }
  text("vel: " + nf(ship.vel.mag(), 0, 2) + " m/s", 10, height-10);
  text("vc: " + nf(vc(star.m, PVector.sub(star.pos, ship.pos).mag()), 0, 2) + " m/s", 10, height-30);
  text("ve: " + nf(sqrt(2) * vc(star.m, PVector.sub(star.pos, ship.pos).mag()), 0, 2) + " m/s", 10, height-50);
}
