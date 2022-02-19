class Structure {
  String id;
  int buttonx, buttony;
  String[] blueprint;
  int x, y, z;
  float[] xs, ys, zs, ws, hs, ds;
  float cx, cy, cz;
  ArrayList<PVector> backbone;
  color[] colors;
  float anglex, angley;
  float anchorx, anchory;
  Boolean anchored;

  Structure(String id_val) {
    id = id_val;
    size = 50;
    buttonx = 50;
    buttony = 50;
    backbone = new ArrayList<PVector>();
    anglex = 0;
    angley = 0;
    anchored = false;
    anchorx = 0;
    anchory = 0;

    blueprint = loadStrings("blueprint.txt");
    xs = new float[blueprint.length-1];
    ys = new float[blueprint.length-1];
    zs = new float[blueprint.length-1];
    ws = new float[blueprint.length-1];
    hs = new float[blueprint.length-1];
    ds = new float[blueprint.length-1];
    
    for (int i=1; i<blueprint.length; i++) {
      xs[i-1] = int(blueprint[i].split("\t")[0]);
      ys[i-1] = int(blueprint[i].split("\t")[1]);
      zs[i-1] = int(blueprint[i].split("\t")[2]);
      ws[i-1] = int(blueprint[i].split("\t")[3]);
      hs[i-1] = int(blueprint[i].split("\t")[4]);
      ds[i-1] = int(blueprint[i].split("\t")[5]);
      backbone.add(new PVector(xs[i-1], ys[i-1], zs[i-1]));
    }
    
    colors = new color[backbone.size()];
    for(int i=0; i<backbone.size(); i++){
      colors[i] = color(random(0,250), random(0,250), random(0,250));
    }
    
    cx = (max(xs) - min(xs))/2 + min(xs);
    cy = (max(ys) - min(ys))/2 + min(ys);
    cz = (max(zs) - min(zs))/2 + min(zs);
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

    pushMatrix();
    translate(-cx*size, -cy*size, -cz*size);
    strokeWeight(3);
    for (int i=0; i<backbone.size(); i++) {
      for (float j=-1; j<=1; j+=2) {
        for (float k=-1; k<=1; k+=2) {
          for (float l=-1; l<=1; l+=2) {
            stroke(colors[i]);
            point(j/2*ws[i]+size*backbone.get(i).x, k/2*hs[i]+size*backbone.get(i).y, l/2*ds[i]+size*backbone.get(i).z);
          }
        }
      }
    }
    popMatrix();
  }
}
