
import peasy.*;

PeasyCam cam;

float big_g = 1000;//6.6742E-11;
float dt = 0.1;
ArrayList<Star>[] buffer = new ArrayList[2];
ArrayList<Star> stars_prev = new ArrayList<Star>();
ArrayList<Star> stars_next = new ArrayList<Star>();
Governor gov;

void setup()
{ 
  size(1000,1000,P3D);
  
  cam = new PeasyCam(this, -10,0,0,100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
  int red = #C80000;
  int blue = #284263;
  int grey = #B1A6C7;
  int case_id = 0;
  if(case_id == 0)
  {
    Star star1 = new Star(200, 5, red, false, new PVector(300.,300.,0), new PVector(0,0,0));
    Star star2 = new Star(20, 5, red, false, new PVector(400.,300.,0), new PVector(2.45,-10,-1.785));
    Star star3 = new Star(3, 1, blue, false, new PVector(400.,100.,10), new PVector(2,1,10));
    stars_prev.add(star1);
    stars_prev.add(star2);
    stars_prev.add(star3);
  }
  else if(case_id == 1)
  {
    Star star1 = new Star(1, 5, red, false, new PVector(300.,300.,0), new PVector(0,0,0));
    Star star2 = new Star(1, 5, red, false, new PVector(400.,300.,0), new PVector(0,0,0));
    
    stars_prev.add(star1);
    stars_prev.add(star2);
  }
  else if(case_id == 2)
  {
    Star star1 = new Star(100, 5, red, true, new PVector(200.,300.,0), new PVector(0,0,0));
    Star star2 = new Star(100, 5, red, true, new PVector(400.,300.,0), new PVector(0,0,0));
    Star star3 = new Star(30, 1, blue, false, new PVector(500.,200.,0), new PVector(-4,10,0));
   
    stars_prev.add(star1);
    stars_prev.add(star2);
    stars_prev.add(star3);
  }
  
  for(Star s : stars_prev) 
  {
    stars_next.add((Star)s.clone());
  }
  
  buffer[0] = stars_prev;
  buffer[1] = stars_next;
  gov = new Governor(buffer, dt);
}

void draw()
{
  background(0);
  lights();
  gov.step();
  gov.draw();
}
