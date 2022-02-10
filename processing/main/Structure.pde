class Structure{
  String id;
  ArrayList<Body> bodies;
  
  Structure(String id_val){
    id = id_val;
  }
  
  void display(){
    background(0);
    stroke(100);
    noFill();
    rect(100, 100, 50, 50);
    rect(200, 200, 50, 50);
    
    fill(100);
    rect(x, y, size, size);
  }
  
}
