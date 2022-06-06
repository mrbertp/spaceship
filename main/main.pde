Button navi_button, struc_button, ener_button;
Navigation navi;
Structure struc;
Energy ener;
String screen;
float dsf;


void setup() {
  size(800, 900, P3D);
  frameRate(60);
  
  dsf = 0;
  screen = "navigation";
  
  navi_button = new Button("NAV", 40,40,60);
  struc_button = new Button("STR", 110,40,60);
  ener_button = new Button("ENE", 180,40,60);

  navi = new Navigation();
  struc = new Structure();
  ener = new Energy();
}

void draw() {
  navi.update();
  struc.update();
  ener.update();

  if (screen.equals("navigation")) {
    navi.display();
  }
  if (screen.equals("structure")) {
    struc.display();
  }
  if (screen.equals("energy")) {
    ener.display();
  }
  
  navi_button.display();
  struc_button.display();
  ener_button.display();
  
}
