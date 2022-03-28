class Navigation{
  String id;
  ArrayList<Body> bodies;
  
  Navigation(String id_val, ArrayList<Body> bodies_val){
    id = id_val;
    bodies = bodies_val;
  }
  
  void display(){
    background(0);
    
    fill(100);
    rect(x, y, size, size);
    
    fill(200);
    textSize(20);
    text("vel: " + nf(ship.vel.mag(), 0, 2) + " m/s", 10, height-10);
    text("vc: " + nf(vc(star.m, PVector.sub(star.pos, ship.pos).mag()), 0, 2) + " m/s", 10, height-30);
    text("ve: " + nf(sqrt(2) * vc(star.m, PVector.sub(star.pos, ship.pos).mag()), 0, 2) + " m/s", 10, height-50);
    text(str(over(x, y, size)), 10, height-70);    
       
    translate(width/2, height/2);
    scale(sf);
    
    for (int i = 0; i < bodies.size(); i++) {
      bodies.get(i).display();
    }

  }
  
}
