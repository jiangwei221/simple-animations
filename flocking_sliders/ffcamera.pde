//first person camera

class FFCamera
{
  PVector cur_vel;
  
  PVector cur_lookat;
  float prev_fr;
  boolean is_new;
  
  FFCamera()
  {
    cur_vel = new PVector();
    cur_lookat = new PVector();
    is_new =true;
  }
  
  PVector lookWhere(PVector c_vel)
  {
    if(is_new)
    {
      is_new = false;
      cur_vel = c_vel.copy().normalize();
      cur_lookat = cur_vel.copy();
      prev_fr = frameCount;
    }
    else
    {
      cur_vel = c_vel.copy().normalize();
      //PVector diff = cur_vel.copy().sub(prev_vel);
      float a = PVector.angleBetween(cur_lookat, cur_vel);
      a = a/0.1;
      float t = frameCount - prev_fr;
      prev_fr = frameCount;
      float dt = constrain((t/a),0.0,1.0);
      
      println(a, t, dt);
      cur_lookat = slerp(cur_lookat, cur_vel, dt);
    }
    cur_lookat.normalize();
    return cur_lookat;
  }
  
  PVector slerp(PVector start, PVector end, float t)
  {
    float dot = start.dot(end);
    dot = constrain(dot, -1.0f, 1.0f);
    float theta = acos(dot)*t;
    PVector relative = end.copy().sub(start.copy().mult(dot));
    relative = relative.normalize();
    return start.copy().mult(cos(theta)).add(relative.copy().mult(sin(theta)));
  }
  
}
