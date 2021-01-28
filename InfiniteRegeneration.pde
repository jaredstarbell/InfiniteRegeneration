// Infinite Regeneration
//  Based on 
// Spiritual Ring
//   Based on the BlendMode Test of November 2019

//   Jared S Tarbell
//   January 6, 2020
//   Levitated Toy Factory
//   Albuquerque, New Mexico USA

ArrayList<Node> nodes = new ArrayList<Node>();
IntList history = new IntList();

Camera cam;

long[] times;
int averageOverFrames = 5;
long baseTime;

int max = 50000;
long lastMillis = 0;

float startx, finalx, atx;

float nodeScale = 1.0;
//float t = 0;
int offx = 0;
int offy = 0;
float warp = .005;
float cry = 0;

int update = 0;

int cnt = 0;

boolean reflected = true;
boolean displayStatus = true;


void setup() {
  //size(1200,1200,FX2D);
  fullScreen(FX2D);
  background(0);
  
  rectMode(CENTER);
  
  cam = new Camera(0,0,0,1000);
  
  startx = -1000;
  finalx = 1000;
  atx = startx;
  
  baseTime = millis();

}

void draw() {
  // clear the background and set the blend mode or not
  background(0);
  
  //cam.dfl = map(mouseY,0,height,1,10000);
  cam.fly();
  
  // adjust node count if necessary
  for (int k=0;k<15;k++) {
    if (nodes.size()<max) {
      Node neo = new Node(offx,offy,warp);
      nodes.add(neo);
    }
    if (nodes.size()>max) {
      nodes.remove(0);
    }
  }
  
  // draw all the nodes
  for (Node b:nodes) b.render();
  
  // noise drift
  cry-=.005;
  
  // time counter
  cnt++;
  //if ((cnt%1800)==0) shake();
  
  // scalin' nodes
  nodeScale = 1;
  
  if (displayStatus) renderStatus(); 

}

void changeNodeMax(int delta) {
  max+=delta; 
  if (max<0) max = 0;
  if (max>100000) max = 100000;
}

void shake() {
  offx = floor(random(10000));
  offy = floor(random(10000));
  warp = random(.0011,.0055);
  //if (random(100)<33) warp*=.1;
  update = nodes.size();
}

void renderStatus() {
  // report status
  fill(255);
  noStroke();
  textSize(18);
  textAlign(LEFT);
  int ns = nodes.size();
  if (reflected) ns*=2;
  String rpt = ns + " nodes @"+round(frameRate)+"fps";
  if (reflected) rpt+=" reflected";
  rpt+="   dfl:"+cam.dfl;
  text(rpt,20,height-20);
  textAlign(RIGHT);
  String txt = "Infinite Regeneration";
  text(txt,width-20,height-20);
}



void mousePressed() {
  // toggle blendmode
  //cam.dfl = map(mouseY,0,height,1,10000);
  cam.dz +=1000;
}

void keyPressed() {
  if (key==' ') {
    shake();
  }
  if (key=='r' || key=='R') {
    reflected = !reflected;
  }
  if (key=='-' || key=='_') {
    changeNodeMax(-100);
  }
  if (key=='=' || key=='+') {
    changeNodeMax(100);
  }
  if (key=='d' || key=='D') {
    displayStatus=!displayStatus;
  }
  if (key=='c' || key=='C') {
    if (cam.dfl>1000) {
      cam.dfl = 1000;
    } else {
      cam.dfl = 10000;
    }
  }
      
}

  
  

    
