void graph(int posx, int posy, int sizex, int sizey, float val, int j) {
  rectMode(CORNER);
  int comp = 10;
  fill(100);
  rect(posx, posy, sizex, sizey);
  if(frameCount % comp == 0){
    fill(color(250, 0, 0));
    noStroke();
    ellipse(j+posx, 1*(sizey-val+posy), 5, 5);
  }
}

boolean over(float x, float y, float size) {
  boolean inside_x, inside_y;
  
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
  if (over(navi_button.posx, navi_button.posy, navi_button.size)) {
    screen = "navigation";
  }
  if (over(struc_button.posx, struc_button.posy, struc_button.size)) {
    screen = "structure";
  }
  if (over(ener_button.posx, ener_button.posy, ener_button.size)) {
    screen = "energy";
  }
}

void mouseWheel(MouseEvent event) {
  dsf += event.getCount();  
}

class Button{
  String name;
  float posx, posy, size;
  
  Button(String n, float px, float py, float s){
    name = n;
    posx = px;
    posy = py;
    size = s;
  }
  
  void display(){
    rectMode(CENTER);
    fill(100);
    stroke(0);
    strokeWeight(1);
    rect(posx, posy, size, size);
    
    fill(0);
    text(name, posx-size/3.5, posy+size/10);
  }
}
