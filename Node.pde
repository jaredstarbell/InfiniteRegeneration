class Node {
  float x, y, z;
  float vx, vy, vz;
  float w;
  color myc;
  
  float dw;       // destination width
  
  float theta;    // direction of movement
  float speed;    // velocity of movement
  
  float flux;
  float ox;
  float oy;
  float warp;
  
  Node(float _ox, float _oy, float _warp) {
    ox = _ox;
    oy = _oy;
    warp = _warp;
    
    init();
  }
  
  void init() {
    // materialize around ring
    theta = random(TWO_PI);
    
    //float rad = height*.3;
    //x = rad*cos(theta);
    //y = rad*sin(theta);
    //z = 500 + .2*random(-rad,rad);
    
    // material in a line
    theta = -HALF_PI;
    x = atx;
    y = 0;
    z = 500 + 100*noise(atx*.01);
    
    atx++;
    if (atx>finalx) atx = startx;
    
    float vmax = 0;
    vx = random(-vmax,vmax);
    vy = random(-vmax,vmax);
    vz = 0;
    
    // natural log scale variation
    w = 0;
    dw = 3 + abs(5*log(random(1.0)));
    
    speed = 0;
    theta+=PI;
    
    myc = color(255);
    
    initFlux();
  }
  
  void initFlux() {
    int groups = 30;
    float groupFuzz = 10.0;
    flux = 100*floor(random(groups)) + random(groupFuzz);
  }
  
  void setNoise(float _ox, float _oy, float _warp) {
    ox = _ox;
    oy = _oy;
    warp = _warp;
  }
  
  void render() {
    // update direction speed and position
    theta -= .004*(noise(flux+ox+x*warp,oy+y*warp+cry)-.3);
    speed += .001*(noise(ox+x*warp,oy+y*warp+cry)-.5);
    vx = speed*cos(theta);
    vy = speed*sin(theta);
    
    x+=vx;
    y+=vy;
    z+=vz;

    // slowly increase in size to destination width
    w+=(dw-w)*.01;
    
    
    // compute actual visible size relative to camera  
    float zActual = cam.fl - cam.z + z;
    if (zActual>20000) {
      // object is too far from camera
      init();
      z=cam.dz-500;
      return;
    }
    if (zActual>0) {
      // object is in front of camera
      float scale = cam.fl/zActual;
      float dx = width*.5 + (x - cam.x)*scale;
      float dy = height*.5 + (y - cam.y)*scale;

      // bound check
      //if (dx<-w)  { init(); return; }
      //if (dx>w+width)  { init(); return; }
      //if (dy<-w)  { init(); return; }
      //if (dy>w+height)  { init(); return; }    

      fill(myc,128);
      noStroke();
      ellipse(dx,dy,w*nodeScale,w*nodeScale);
      //stroke(myc);
      //point(x,y-w*.4*nodeScale);
      if (reflected) {
        float wn6 = w*nodeScale*.618;
        //fill(myc,192);
        fill(0,192);
        noStroke();
        ellipse(width-dx,dy,wn6,wn6);
        //stroke(myc);
        //point(width-x,y+.4*wn6);
      }
    } else {
      // object is behind camera
      if (zActual<-600) {
        // object is very far behind camera        
        init();
        z+=cam.z;
      }
    }
     
    

  }
  
  
}
