ArrayList<Body> bodies;
Body ship;
Body sun;
Body b1, b2;

void setup() {
  size(800, 600);
  frameRate(60);
  
  ship = new Body("ship", new PVector(-1000.0, -1000.0), new PVector(0.0, 15.0), 100000000.0, 50, color(100, 100, 200));
  sun = new Body("sun", new PVector(500.0, 0.0), new PVector(0.0, 0.0), 1000000000.0, 100, color(200, 200, 100));
  
  bodies = new ArrayList<Body>();
  bodies.add(ship);
  bodies.add(sun);
}

void draw() {
  background(0);
  translate(width/2, height/2);
  scale(0.1);
  
  for(int i = 0 ; i < bodies.size() ; i++){
    bodies.get(i).grav = new PVector(0.0, 0.0);
    for(int j = 0 ; j < bodies.size() ; j++){
      if(j != i){
        bodies.get(i).grav.add(g_force(bodies.get(i),bodies.get(j)));
      }
    }
    bodies.get(i).move();
    bodies.get(i).display();
  }
}
