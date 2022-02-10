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
