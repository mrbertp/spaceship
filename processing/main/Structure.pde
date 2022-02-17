class Structure {
  String id;
  String[] blueprint;
  float[] xs, ys;
  float cx, cy;
  ArrayList<PVector> backbone;
  float ax, ay, anglex, angley;
  float anchorx, anchory;
  Boolean anchored;

  Structure(String id_val) {
    id = id_val;
    size = 50;
    backbone = new ArrayList<PVector>();
    anglex = 0;
    angley = 0;
    anchored = false;
    anchorx = 0;
    anchory = 0;

    blueprint = loadStrings("blueprint.txt");
    for (int i=1; i<blueprint.length; i++) {
      int x = int(blueprint[i].split("\t")[0]);
      int y = int(blueprint[i].split("\t")[1]);
      backbone.add(new PVector(x, y));
    }
    xs = new float[backbone.size()];
    ys = new float[backbone.size()];

    for (int i=0; i<backbone.size(); i++) {
      xs[i] = backbone.get(i).x;
      ys[i] = backbone.get(i).y;
    }
    cx = (max(xs) - min(xs))/2 + min(xs);
    cy = (max(ys) - min(ys))/2 + min(ys);
  }

  void display() {
    background(0);
    stroke(200);
    strokeWeight(0.5);

    fill(100);
    rect(x, y, size, size);

    stroke(150);
    strokeWeight(0.5);

    line(width/2, 0, width/2, height);
    line(0, height/2, width, height/2);

    translate(width/2, height/2);

    if (mouseButton == RIGHT && !over(x, y, size)) {
      if (!anchored) {
        anchorx = mouseX;
        anchory = mouseY;
        anchored = true;
      } else {
        anglex = mouseY - anchory;
        angley = mouseX - anchorx;
      }
    } else {
      anchored = false;
    }

    rotateX(radians(-anglex));
    rotateY(radians(angley));

    pushMatrix();
    translate(-cx*size, -cy*size);
    for (int i=0; i<backbone.size(); i++) {
      pushMatrix();
      translate(size*backbone.get(i).x, size*backbone.get(i).y);
      fill(100);
      stroke(200);
      strokeWeight(1);
      box(size);
      popMatrix();
    }
    popMatrix();
  }
}
