//flock simulation
//jiang wei
//uvic

//modified from nature of code by shiffman
//add GUI
//add collision avoidance
//new border handling
//new cameras

import controlP5.*;

ControlP5 cp5;

Flock flock;

boolean showvalues = false;
PImage img;
color red = color(255,0,0);
color blue = color(0,0,200);
FFCamera ff = new FFCamera();
int camera_id = 0;
void setup() {
  randomSeed(0);
  size(800,500,P3D);
  colorMode(RGB,255,255,255,100);
  smooth();
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 5; i++) {
    flock.addBoid(new Boid(width/2,height/2, red));
    flock.addBoid(new Boid(width/2,height/2, blue));
  }
  
  // add obstacles
  for(int i=0; i<2; i++)
  {
    flock.addObstacle(new Obstacle(random(0,width),random(0,height), 30));
  }

  //background texture
  img = loadImage("Soccer-Field.png");
  
  //GUI
  cp5 = new ControlP5(this);
  cp5.addSlider("swt")
     .setColorLabel(color(185,185,110))
     .setPosition(100,50)
     .setRange(1,10)
     .setLabel("seperate")
     ;
  cp5.addSlider("awt")
     .setColorLabel(color(185,185,110))
     .setPosition(100,75)
     .setRange(1,10)
     .setLabel("alignment")
     ;
  cp5.addSlider("cwt")
     .setColorLabel(color(185,185,110))
     .setPosition(100,100)
     .setRange(1,10)
     .setLabel("cohesion")
     ;
}

void draw() {
  background(255); 
  hint(ENABLE_DEPTH_TEST);
  
  pushMatrix();  
  //add camera transformation
  switch(camera_id)
  {
    case 0:
      break;
    case 1:
      PVector l_w = ff.lookWhere(flock.boids.get(0).vel);
      camera(flock.boids.get(0).pos.x - flock.boids.get(0).vel.copy().normalize().x*100, flock.boids.get(0).pos.y - flock.boids.get(0).vel.copy().normalize().y*100, 40.0, 
          flock.boids.get(0).pos.x - flock.boids.get(0).vel.copy().normalize().x*100 + l_w.x, flock.boids.get(0).pos.y - flock.boids.get(0).vel.copy().normalize().y*100 +l_w.y, 40.0, 
       0.0, 0.0, -1.0);
      break;
    case 2:
      float x1 = 0;
      float y1 = 0;
      float z1 = 10;
      float x2 = width;
      float y2 = 0;
      float z2 = 500;
      float x3 = width;
      float y3 = height;
      float z3 = 500;
      float x4 = 0;
      float y4 = height;
      float z4 = 10;
      
      float t = float(frameCount) / 1000.0;
      int flip = t%2<1?0:1;
      
      t = t%2;
      t = flip==0?t:1-(t-1);
      print(t);
      float x = bezierPoint(x1, x2, x3, x4, t);
      float y = bezierPoint(y1, y2, y3, y4, t);
      float z = bezierPoint(z1, z2, z3, z4, t);
      
      println(x,y,z);
      
      camera(x,y,z,width/2,height/2,0,0,0,-1);
      
    default:
       break;
  }
  
  lights();

  beginShape();
  texture(img);
  vertex(-100, -100, 0, 0, 0);
  vertex(width+100, -100, 0, 2400, 0);
  vertex(width+100, 100+height, 0, 2400, 1500);
  vertex(-100, 100+height, 0, 0, 1500);
  endShape();

  flock.run();

  popMatrix();
  
  hint(DISABLE_DEPTH_TEST);
  
  //click to add boids
  if (mousePressed) {
    int index = frameCount%2;
    flock.addBoid(new Boid(mouseX,mouseY, (index ==0)?red:blue));
  }
  
  //show framerate and number of boids
  if (showvalues) {
    fill(0);
    textAlign(LEFT);
    text("Total boids: " + flock.boids.size() + "\n" + "Framerate: " + round(frameRate) + "\nPress any key to show/hide sliders and text\nClick mouse to add more boids",5,100);
  }
}

void keyPressed() {
  showvalues = !showvalues;
}
