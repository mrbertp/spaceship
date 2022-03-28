ArrayList<Body> bodies;
Body body, ship, star;
String[] map;
float x, y, size;
boolean inside_x, inside_y;
Navigation nav_screen;
Structure struc_screen;
String screen;


void setup() {
  size(800, 800, P3D);
  frameRate(60);
  rectMode(CENTER);

  x = 50;
  y = 50;
  size = 50;

  screen = "navigation";

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
    if (id.equals("ship")) {
      ship = new Body(id, pos, vel, m, s, c);
      bodies.add(ship);
    } else if (id.equals("star")) {
      star = new Body(id, pos, vel, m, s, c);
      bodies.add(star);
    } else {
      body = new Body(id, pos, vel, m, s, c);
      bodies.add(body);
    }
  }

  nav_screen = new Navigation("navi", bodies);
  struc_screen = new Structure("struc");
}

void draw() {

  for (int i = 0; i < bodies.size(); i++) {
    bodies.get(i).grav = new PVector(0.0, 0.0);
    for (int j = 0; j < bodies.size(); j++) {
      if (j != i) {
        bodies.get(i).grav.add(g_force(bodies.get(i), bodies.get(j)));
      }
    }
    bodies.get(i).move();
  }

  if (screen.equals("navigation")) {
    nav_screen.display();
  }
  if (screen.equals("structure")) {
    struc_screen.display();
  }
}


// FUNCTIONS
boolean over(float x, float y, float size) {
  if (mouseX < x+size/2 && mouseX > x-size/2) {
    inside_x = true;
  } else {
    inside_x = false;
  }
  if (mouseY < y+size/2 && mouseY > y-size/2) {
    inside_y = true;
  } else {
    inside_y = false;
  }
  return inside_x && inside_y;
}

void mouseClicked() {
  if (over(x, y, size)) {
    if (screen.equals("navigation")) {
      screen = "structure";
    } else if (screen.equals("structure")) {
      screen = "navigation";
    }
  }
}
