class Energy{
  
  float eT, eP;
  float Q, I;
  String id;
  
  Energy(String id_val){
  
    id = id_val;
    eT = 0.08;
    eP = 0.30;
    Q = 4400; // W
    I = 0; // W/m2
  }
  
  void update(){
    
    float dis = PVector.sub(star.pos, ship.pos).mag();
    I = I(dis);
  }


}
