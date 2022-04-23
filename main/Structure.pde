class Structure {
  String id;
  int buttonx, buttony;
  String[] blueprint, ps, fields;
  StringList pieces;
  int x, y, z;
  float[] xs, ys, zs, ws, hs, ds;
  float cx, cy, cz;
  HashMap<String, ArrayList<PVector>> spine, struc, rs;
  HashMap<String, IntList> joints;
  PVector disp, ref, aux, rot;
  float anglex, angley;
  float[][] rotX, rotY, rotZ;
  float anchorx, anchory;
  Boolean anchored;

  Structure(String id_val) {
    id = id_val;
    size = 30;
    buttonx = 50;
    buttony = 50;
    anglex = 0;
    angley = 0;
    anchored = false;
    anchorx = 0;
    anchory = 0;

    blueprint = loadStrings("blueprint.txt");

    xs = new float[blueprint.length-1];
    ys = new float[blueprint.length-1];
    zs = new float[blueprint.length-1];
    spine = new HashMap<String, ArrayList<PVector>>();
    struc = new HashMap<String, ArrayList<PVector>>();
    joints = new HashMap<String, IntList>();
    rs = new HashMap<String, ArrayList<PVector>>();

    for (int i=1; i<blueprint.length; i++) {
      fields = blueprint[i].split("\t");
      xs[i-1] = float(fields[1]);
      ys[i-1] = float(fields[2]);
      zs[i-1] = float(fields[3]);

      if (!spine.keySet().contains(fields[0])) {
        spine.put(fields[0], new ArrayList<PVector>());
        joints.put(fields[0], new IntList());
        rs.put(fields[0], new ArrayList<PVector>());
      }
      spine.get(fields[0]).add(new PVector(int(fields[1]), int(fields[2]), int(fields[3])));
      if (boolean(int(fields[4]))) {
        joints.get(fields[0]).append(spine.get(fields[0]).size()-1);
        rs.get(fields[0]).add(new PVector(float(fields[5]), float(fields[6]), float(fields[7])));
      }
    }

    for (String m : spine.keySet()) {
      struc.put(m, new ArrayList<PVector>());
      for (int i=0; i<spine.get(m).size(); i++) {
        for (float j=-0.5; j<=0.5; j++) {
          for (float k=-0.5; k<=0.5; k++) {
            for (float l=-0.5; l<=0.5; l++) {
              struc.get(m).add(new PVector(size*(spine.get(m).get(i).x + j), size*(spine.get(m).get(i).y + k), size*(spine.get(m).get(i).z + l)));
            }
          }
        }
      }
    }

    cx = (max(xs) - min(xs))/2 + min(xs);
    cy = (max(ys) - min(ys))/2 + min(ys);
    cz = (max(zs) - min(zs))/2 + min(zs);
    disp = new PVector(-cx, -cy, -cz);

    for (String m : struc.keySet()) {
      for (PVector v : struc.get(m)) {
        v.add(disp.copy().mult(size));
      }
    }
  }

  void display() {
    background(0);
    stroke(200);
    strokeWeight(1);

    fill(100);
    rect(buttonx, buttony, size, size);

    stroke(150);
    strokeWeight(0.5);

    //line(width/2, 0, width/2, height);
    //line(0, height/2, width, height/2);

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
    strokeWeight(2);

    for (String m : spine.keySet()) {
      ref = (spine.get(m).get(joints.get(m).get(0)).copy().add(disp)).copy().mult(size);
      stroke(color(200, 0, 0));
      point(ref.x, ref.y, ref.z);
      rot = rs.get(m).get(0);
      for (int i=0; i<struc.get(m).size(); i++) {
        aux = struc.get(m).get(i).copy().sub(ref);
        aux = rot(rot.x, rot.y, rot.z, aux);
        struc.get(m).set(i, aux.copy().add(ref));
      }
    }

    strokeWeight(1);
    stroke(100);
    for (String m : struc.keySet()) {
      for (PVector v : struc.get(m)) {
        point(v.x, v.y, v.z);
      }
      for (int i=0; i<spine.get(m).size(); i++) {
        /*
        // left face
         stroke(color(200,0,0));
         line(struc.get(m).get(0+8*i).x, struc.get(m).get(0+8*i).y, struc.get(m).get(0+8*i).z, struc.get(m).get(1+8*i).x, struc.get(m).get(1+8*i).y, struc.get(m).get(1+8*i).z);
         line(struc.get(m).get(1+8*i).x, struc.get(m).get(1+8*i).y, struc.get(m).get(1+8*i).z, struc.get(m).get(3+8*i).x, struc.get(m).get(3+8*i).y, struc.get(m).get(3+8*i).z);
         line(struc.get(m).get(3+8*i).x, struc.get(m).get(3+8*i).y, struc.get(m).get(3+8*i).z, struc.get(m).get(2+8*i).x, struc.get(m).get(2+8*i).y, struc.get(m).get(2+8*i).z);
         line(struc.get(m).get(2+8*i).x, struc.get(m).get(2+8*i).y, struc.get(m).get(2+8*i).z, struc.get(m).get(0+8*i).x, struc.get(m).get(0+8*i).y, struc.get(m).get(0+8*i).z);
         // right face
         stroke(color(0,200,0));
         line(struc.get(m).get(5+8*i).x, struc.get(m).get(5+8*i).y, struc.get(m).get(5+8*i).z, struc.get(m).get(4+8*i).x, struc.get(m).get(4+8*i).y, struc.get(m).get(4+8*i).z);
         line(struc.get(m).get(4+8*i).x, struc.get(m).get(4+8*i).y, struc.get(m).get(4+8*i).z, struc.get(m).get(6+8*i).x, struc.get(m).get(6+8*i).y, struc.get(m).get(6+8*i).z);
         line(struc.get(m).get(6+8*i).x, struc.get(m).get(6+8*i).y, struc.get(m).get(6+8*i).z, struc.get(m).get(7+8*i).x, struc.get(m).get(7+8*i).y, struc.get(m).get(7+8*i).z);
         line(struc.get(m).get(7+8*i).x, struc.get(m).get(7+8*i).y, struc.get(m).get(7+8*i).z, struc.get(m).get(5+8*i).x, struc.get(m).get(5+8*i).y, struc.get(m).get(5+8*i).z);
         */
        // back face
        stroke(color(0, 0, 200));
        line(struc.get(m).get(4+8*i).x, struc.get(m).get(4+8*i).y, struc.get(m).get(4+8*i).z, struc.get(m).get(0+8*i).x, struc.get(m).get(0+8*i).y, struc.get(m).get(0+8*i).z);
        line(struc.get(m).get(0+8*i).x, struc.get(m).get(0+8*i).y, struc.get(m).get(0+8*i).z, struc.get(m).get(2+8*i).x, struc.get(m).get(2+8*i).y, struc.get(m).get(2+8*i).z);
        line(struc.get(m).get(2+8*i).x, struc.get(m).get(2+8*i).y, struc.get(m).get(2+8*i).z, struc.get(m).get(6+8*i).x, struc.get(m).get(6+8*i).y, struc.get(m).get(6+8*i).z);
        line(struc.get(m).get(6+8*i).x, struc.get(m).get(6+8*i).y, struc.get(m).get(6+8*i).z, struc.get(m).get(4+8*i).x, struc.get(m).get(4+8*i).y, struc.get(m).get(4+8*i).z);
        // front face
        stroke(color(100, 100, 0));
        line(struc.get(m).get(1+8*i).x, struc.get(m).get(1+8*i).y, struc.get(m).get(1+8*i).z, struc.get(m).get(5+8*i).x, struc.get(m).get(5+8*i).y, struc.get(m).get(5+8*i).z);
        line(struc.get(m).get(5+8*i).x, struc.get(m).get(5+8*i).y, struc.get(m).get(5+8*i).z, struc.get(m).get(7+8*i).x, struc.get(m).get(7+8*i).y, struc.get(m).get(7+8*i).z);
        line(struc.get(m).get(7+8*i).x, struc.get(m).get(7+8*i).y, struc.get(m).get(7+8*i).z, struc.get(m).get(3+8*i).x, struc.get(m).get(3+8*i).y, struc.get(m).get(3+8*i).z);
        line(struc.get(m).get(3+8*i).x, struc.get(m).get(3+8*i).y, struc.get(m).get(3+8*i).z, struc.get(m).get(1+8*i).x, struc.get(m).get(1+8*i).y, struc.get(m).get(1+8*i).z);
        // up face
        stroke(color(0, 100, 100));
        line(struc.get(m).get(5+8*i).x, struc.get(m).get(5+8*i).y, struc.get(m).get(5+8*i).z, struc.get(m).get(1+8*i).x, struc.get(m).get(1+8*i).y, struc.get(m).get(1+8*i).z);
        line(struc.get(m).get(1+8*i).x, struc.get(m).get(1+8*i).y, struc.get(m).get(1+8*i).z, struc.get(m).get(0+8*i).x, struc.get(m).get(0+8*i).y, struc.get(m).get(0+8*i).z);
        line(struc.get(m).get(0+8*i).x, struc.get(m).get(0+8*i).y, struc.get(m).get(0+8*i).z, struc.get(m).get(4+8*i).x, struc.get(m).get(4+8*i).y, struc.get(m).get(4+8*i).z);
        line(struc.get(m).get(4+8*i).x, struc.get(m).get(4+8*i).y, struc.get(m).get(4+8*i).z, struc.get(m).get(5+8*i).x, struc.get(m).get(5+8*i).y, struc.get(m).get(5+8*i).z);
        // down face
        stroke(color(100, 0, 100));
        line(struc.get(m).get(6+8*i).x, struc.get(m).get(6+8*i).y, struc.get(m).get(6+8*i).z, struc.get(m).get(2+8*i).x, struc.get(m).get(2+8*i).y, struc.get(m).get(2+8*i).z);
        line(struc.get(m).get(2+8*i).x, struc.get(m).get(2+8*i).y, struc.get(m).get(2+8*i).z, struc.get(m).get(3+8*i).x, struc.get(m).get(3+8*i).y, struc.get(m).get(3+8*i).z);
        line(struc.get(m).get(3+8*i).x, struc.get(m).get(3+8*i).y, struc.get(m).get(3+8*i).z, struc.get(m).get(7+8*i).x, struc.get(m).get(7+8*i).y, struc.get(m).get(7+8*i).z);
        line(struc.get(m).get(7+8*i).x, struc.get(m).get(7+8*i).y, struc.get(m).get(7+8*i).z, struc.get(m).get(6+8*i).x, struc.get(m).get(6+8*i).y, struc.get(m).get(6+8*i).z);
      }
    }
    popMatrix();
  }
}
