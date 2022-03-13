class Structure {
  String id;
  int buttonx, buttony;
  String[] blueprint, ps, fields;
  StringList pieces;
  int x, y, z;
  float[] xs, ys, zs, ws, hs, ds;
  float cx, cy, cz;
  HashMap<String, ArrayList<PVector>> spine, struc;
  PVector disp;
  float anglex, angley, a;
  float[][] rotX, rotY, rotZ;
  float anchorx, anchory;
  Boolean anchored;

  Structure(String id_val) {
    id = id_val;
    size = 50;
    buttonx = 50;
    buttony = 50;
    anglex = 0;
    angley = 0;
    a = 1;
    anchored = false;
    anchorx = 0;
    anchory = 0;

    rotX = new float[][]{
      {1, 0, 0},
      {0, cos(radians(a)), -sin(radians(a))},
      {0, sin(radians(a)), cos(radians(a))}
    };

    rotY = new float[][]{
      {cos(radians(a)), 0, sin(radians(a))},
      {0, 1, 0},
      {-sin(radians(a)), 0, cos(radians(a))}
    };

    rotZ = new float[][]{
      {cos(radians(a)), -sin(radians(a)), 0},
      {sin(radians(a)), cos(radians(a)), 0},
      {0, 0, 1}
    };

    blueprint = loadStrings("blueprint.txt");

    xs = new float[blueprint.length-1];
    ys = new float[blueprint.length-1];
    zs = new float[blueprint.length-1];
    spine = new HashMap<String, ArrayList<PVector>>();
    struc = new HashMap<String, ArrayList<PVector>>();

    for (int i=1; i<blueprint.length; i++) {
      fields = blueprint[i].split("\t");

      xs[i-1] = float(fields[1]);
      ys[i-1] = float(fields[2]);
      zs[i-1] = float(fields[3]);

      if (!spine.keySet().contains(fields[0])) {
        spine.put(fields[0], new ArrayList<PVector>());
      }
      spine.get(fields[0]).add(new PVector(int(fields[1]), int(fields[2]), int(fields[3])));
    }

    for (String m : spine.keySet()) {
      struc.put(m, new ArrayList<PVector>());
      for (int i=0; i<spine.get(m).size(); i++) {
        for (float j=-1; j<=1; j+=2) {
          for (float k=-1; k<=1; k+=2) {
            for (float l=-1; l<=1; l+=2) {
              struc.get(m).add(new PVector(size*(spine.get(m).get(i).x + j/2), size*(spine.get(m).get(i).y + k/2), size*(spine.get(m).get(i).z + l/2)));
            }
          }
        }
      }
    }

    cx = (max(xs) - min(xs))/2 + min(xs);
    cy = (max(ys) - min(ys))/2 + min(ys);
    cz = (max(zs) - min(zs))/2 + min(zs);
    disp = new PVector(-cx*size, -cy*size, -cz*size);

    for (String m : struc.keySet()) {
      for (PVector v : struc.get(m)) {
        v.add(disp);
      }
    }
    
    pieces = new StringList();
    pieces.append("jesse");
  }

  void display() {
    background(0);
    stroke(200);
    strokeWeight(0.5);

    fill(100);
    rect(buttonx, buttony, size, size);

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
    
    for (String m : pieces){
      for (int i=0; i<struc.get(m).size(); i++){
        PVector aux = spine.get(m).get(i / 8).copy().add(disp);
        struc.get(m).set(i, rot(rotX, struc.get(m).get(i).sub(aux)).add(aux));
      }
    }

    pushMatrix();
    strokeWeight(4);
    
    stroke(color(200, 0, 0));
    point(disp.x, disp.y, disp.z);
    
    for (String m : struc.keySet()) {
      for (PVector v : struc.get(m)) {
        stroke(200);
        point(v.x, v.y, v.z);
      }
    }
    popMatrix();
  }
}
