class Navigation {

  float anchorx, anchory;
  Boolean anchored_rot, anchored_disp;
  float anglex, angley;
  float dispx, dispy;
  float randpos, randvel;

  ArrayList<Body> bodies;
  Body body, ship, star;
  String[] map;

  Navigation() {

    anglex = 0;
    angley = 0;
    anchored_rot = false;
    anchored_disp = false;
    anchorx = 0;
    anchory = 0;
    dispx = 0;
    dispy = 0;
    randpos = 3000;
    randvel = 3;

    bodies = new ArrayList<Body>();
    map = loadStrings("map.txt");
    for (int i=1; i < map.length; i++) {
      String[] fields = map[i].split("\t");
      String id = fields[0];
      PVector pos = new PVector(int(fields[1]), int(fields[2]), int(fields[3]));
      PVector vel = new PVector(int(fields[4]), int(fields[5]), int(fields[6]));
      float m = float(fields[7]);
      int s = int(fields[8]);
      color c = color(int(fields[9]), int(fields[10]), int(fields[11]));
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
    for (int i = 0; i < 3; i++) {
      bodies.add(new Body("planet"+str(i+1), new PVector(random(-randpos, randpos), random(-randpos, randpos), random(-randpos, randpos)), new PVector(random(-randvel, randvel), random(-randvel, randvel), random(-randvel, randvel)), 200, 60, color(200, 200, 200)));
    }
  }

  void update() {
    for (int i = 0; i < bodies.size(); i++) {
      bodies.get(i).grav = new PVector(0.0, 0.0);
      for (int j = 0; j < bodies.size(); j++) {
        if (j != i) {
          bodies.get(i).grav.add(g_force(bodies.get(i), bodies.get(j)));
        }
      }
      bodies.get(i).move();
    }
  }

  void display() {
    background(0);
    rectMode(CENTER);
    //lights();
    pushMatrix();
    fill(200);
    textSize(20);
    text("vel: " + nf(ship.vel.mag(), 0, 2) + " m/s", 10, height-10);
    text("vc: " + nf(vc(star.m, PVector.sub(star.pos, ship.pos).mag()), 0, 2) + " m/s", 10, height-30);
    text("ve: " + nf(sqrt(2) * vc(star.m, PVector.sub(star.pos, ship.pos).mag()), 0, 2) + " m/s", 10, height-50);
    text("dis: " + nf(PVector.sub(star.pos, ship.pos).mag(), 0, 2) + " m", 10, height-70);

    if (mouseButton == RIGHT && !over(navi_button.posx, navi_button.posy, navi_button.size)) {
      if (!anchored_rot) {
        anchorx = mouseX;
        anchory = mouseY;
        anchored_rot = true;
      } else {
        anglex = mouseY - anchory;
        angley = mouseX - anchorx;
      }
    } else {
      anchored_rot = false;
    }

    if (mouseButton == LEFT && !over(navi_button.posx, navi_button.posy, navi_button.size)) {
      if (!anchored_disp) {
        anchorx = mouseX;
        anchory = mouseY;
        anchored_disp = true;
      } else {
        dispy = mouseY - anchory;
        dispx = mouseX - anchorx;
      }
    } else {
      anchored_disp = false;
    }

    if (mouseButton == CENTER && !over(navi_button.posx, navi_button.posy, navi_button.size)) {
      dsf = 0;
    }

    translate((width+dispx*2)/2, (height+dispy*2-100)/2);

    rotateX(radians(-anglex));
    rotateZ(radians(-angley));

    stroke(50);
    strokeWeight(0.5);

    for (int i = -(width-400)/2; i <= (width-400)/2; i += (width-400)/2/4) {
      line(i, -(height-400-100)/2, i, (height-400-100)/2);
    }
    for (int i = -(height-400-100)/2; i <= (height-400-100)/2; i += (height-400-100)/2/4) {
      line(-(width-400)/2, i, (width-400)/2, i);
    }

    scale(sf-dsf/500);
    for (int i = 0; i < bodies.size(); i++) {
      bodies.get(i).display();
    }
    popMatrix();
  }
}
