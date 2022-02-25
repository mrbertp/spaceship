class Structure {
  String id;
  int buttonx, buttony;
  String[] blueprint;
  int x, y, z;
  float[] xs, ys, zs, ws, hs, ds;
  float cx, cy, cz;
  PVector[] backbone, struc;
  PVector disp;
  color[] colors;
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
    ws = new float[blueprint.length-1];
    hs = new float[blueprint.length-1];
    ds = new float[blueprint.length-1];
    backbone = new PVector[blueprint.length-1];
    struc = new PVector[(blueprint.length-1)*8];

    for (int i=1; i<blueprint.length; i++) {
      xs[i-1] = int(blueprint[i].split("\t")[0]);
      ys[i-1] = int(blueprint[i].split("\t")[1]);
      zs[i-1] = int(blueprint[i].split("\t")[2]);
      ws[i-1] = int(blueprint[i].split("\t")[3]);
      hs[i-1] = int(blueprint[i].split("\t")[4]);
      ds[i-1] = int(blueprint[i].split("\t")[5]);
      backbone[i-1] = new PVector(xs[i-1], ys[i-1], zs[i-1]);
    }

    colors = new color[backbone.length];
    for (int i=0; i<backbone.length; i++) {
      colors[i] = color(random(0, 250), random(0, 250), random(0, 250));
    }

    int h = 0;
    for (int i=0; i<backbone.length; i++) {
      for (float j=-1; j<=1; j+=2) {
        for (float k=-1; k<=1; k+=2) {
          for (float l=-1; l<=1; l+=2) {
            struc[h] = new PVector(j/2*ws[i]+size*backbone[i].x, k/2*hs[i]+size*backbone[i].y, l/2*ds[i]+size*backbone[i].z);
            h += 1;
          }
        }
      }
    }
    cx = (max(xs) - min(xs))/2 + min(xs);
    cy = (max(ys) - min(ys))/2 + min(ys);
    cz = (max(zs) - min(zs))/2 + min(zs);

    disp = new PVector(-cx*size, -cy*size, -cz*size);
    for (int i=0; i<struc.length; i++) {
      struc[i].add(disp);
    }
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

    for (int i=72; i<struc.length; i++) {
      struc[i] = rot(rotX, struc[i]);
    }
    pushMatrix();
    strokeWeight(4);
    /*
    stroke(color(200, 0, 0));
     point(disp.x, disp.y, disp.z);
     */
    for (int i = 0; i < struc.length; i++) {
      stroke(200);
      point(struc[i].x, struc[i].y, struc[i].z);
    }
    popMatrix();
  }
}
