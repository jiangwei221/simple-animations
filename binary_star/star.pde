class Star implements Cloneable
{
  float mass;
  float len;
  boolean fixed;
  PVector pos;
  PVector old_pos;
  PVector vel;
  PVector acc;
  PVector gravity;
  Orbit orb;
  boolean started;
  int color_hex;
  
  Star(float mass, float len, int color_hex, boolean fixed, PVector pos, PVector vel)
  {
    this.mass = mass;
    this.len = len;
    this.color_hex = color_hex;
    this.fixed = fixed;
    this.pos = pos.copy();
    this.old_pos = pos.copy();
    this.vel = vel.copy();
    this.acc = new PVector(0,0,0);
    this.gravity = new PVector(0,0,0);
    this.orb = new Orbit();
    this.started = false;
  }
  
  Object clone()
  {
    Star copy = null;
    try
    {
      copy = (Star)super.clone();
    }
    catch  (CloneNotSupportedException e) 
    {
      println("CloneNotSupportedException comes out : "+e.getMessage());
    }
    return copy;
  }
  
  void step(float dt, PVector force)
  {
    boolean use_euler = false;
    boolean use_verlet = true;
   
    
    if(!started)
    {
      pos = pos.add(vel.copy().mult(dt));
      started = true;
    }
      
    if(fixed)
    {
      ;
    }
    else
    {
      //println(pos,vel,acc);
      //println(force.mag());
      acc = force.div(mass);
      
      PVector dv = acc.mult(dt);
      PVector new_vel = vel.add(dv);
      if(use_euler)
      {
        //explicit euler
        PVector offset = (vel.copy().add(new_vel.copy())).mult(0.5 * dt);
        pos = pos.copy().add(offset.copy());
      }
      else if(use_verlet)
      {
        //verlet
        PVector new_pos = new PVector(0,0,0);
        new_pos = ((pos.copy().mult(2.0)).sub( old_pos.copy())).add(acc.copy().mult(dt*dt));
        old_pos = pos.copy();
        pos = new_pos.copy();
      }
      vel = new_vel.copy();
      //println(pos,vel,acc);
      orb.add_point(pos);
    }
  }
  
  void fix(float d_energy)
  {
    if(d_energy>0)
    {
      println("i need to slow down");
      if(d_energy > 0.5*mass*vel.mag()*vel.mag())
      {
        println("there is no enough vel to slow down");
        vel.setMag(0);
      }
      float new_vel_mag = sqrt( ((2 * -d_energy)/mass) + vel.mag()*vel.mag() );
      if(!Float.isNaN(new_vel_mag))
      {
        println("fix:", d_energy);
        vel.setMag(new_vel_mag);
      }
      else
      {
        println("NaN based on:",((2 * -d_energy)/mass + vel.mag()*vel.mag()),(2 * -d_energy)/mass, vel.mag()*vel.mag());
      }
      println("new vel:", new_vel_mag);
    }
    else
    {
      println("i need to accelerate");
      //println("ole vel:", vel.mag());
      float new_vel_mag = sqrt( ((2 * abs(d_energy))/mass) + vel.mag()*vel.mag() );
      if(!Float.isNaN(new_vel_mag))
      {
        println("fix:", d_energy);
        vel.setMag(new_vel_mag);
      }
      else
      {
        println("NaN based on:", ((2 * d_energy)/mass) + vel.mag()*vel.mag());
      }
      println("new vel:", new_vel_mag);
    }
  }
  
  void draw()
  {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    fill(color_hex);
    noStroke();
    sphere(28);
    popMatrix();
    orb.draw();
  }
}
