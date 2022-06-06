class Energy{
  
  float eT, eP;
  float Q, I;
  
  Energy(){
  
    eT = 0.08;
    eP = 0.30;
    Q = 4400; // W
    I = 0; // W/m2
  }
  
  void update(){
    
    float dis = PVector.sub(navi.star.pos, navi.ship.pos).mag();
    I = I(dis);
  }

  void display() {
    background(0);
    rectMode(CENTER);
    pushMatrix();
    fill(200);
    textSize(20);
    text("Irradiance: " + I + " W/m2", 10, height-10);
    popMatrix();
  }


}
