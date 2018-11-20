class Governor
{
  ArrayList<Star> stars_prev;
  ArrayList<Star> stars_next;
  float dt;
  float init_energy;
  float sum_mass;
  
  Governor(ArrayList<Star>[] buffer, float dt)
  {
    assert(buffer.length==2);
    this.stars_prev = buffer[0];
    this.stars_next = buffer[1];
    this.dt = dt;
    this.init_energy = cal_energy();
    this.sum_mass = 0;
    for(int i=0; i<stars_prev.size();i++)
    {
      this.sum_mass += stars_prev.get(i).mass;
    }
    println("init mass:", sum_mass, ", init energy:", init_energy);
    
  }
  
  //void step()
  //{
  //  //standard euler method
  //  for(int i=0; i<stars.size();i++)
  //  {
  //    PVector force = get_gravity_by_id(i);
  //    //PVector force = new PVector(0,0,0);
  //    stars.get(i).step(dt, force);
  //  }
    
  //  //offset the energy
  //  //every star gain kinetic energy based on the mass
  //  println("current energy:", cal_energy());
  //  float sum_d_energy = init_energy - cal_energy();
  //  println(sum_d_energy);
  //  for(int i=0; i<stars.size();i++)
  //  {
  //    float gained_energy = sum_d_energy * (stars.get(i).mass / sum_mass);
  //    stars.get(i).fix(gained_energy);
  //  }
  //}
  
  ArrayList<Star> copy_stars(ArrayList<Star> from)
  {
    ArrayList<Star> to = new ArrayList<Star>();
    for(Star s : from) 
    {
      to.add((Star)s.clone());
    }
    return to;
  }
  
  void step()
  {
    //make to prev and next the same
    stars_next = copy_stars(stars_prev);
    
    //standard euler method
    for(int i=0; i<stars_prev.size();i++)
    {
      PVector force = get_gravity_by_id(i);
      stars_next.get(i).step(dt, force);
    }
    
    //offset the energy
    //every star gain kinetic energy based on the mass
    println("current energy:", cal_energy());
    float sum_d_energy = cal_energy() - init_energy;
    println("d_energy:", sum_d_energy);
    for(int i=0; i<stars_prev.size();i++)
    {
      float gained_energy = sum_d_energy * (stars_prev.get(i).mass / sum_mass);
      stars_next.get(i).fix(gained_energy);
    }
    
    //switch buffer
    ArrayList<Star> temp = stars_prev;
    stars_prev = stars_next;
    stars_next = temp;
  }
  
  float cal_energy()
  {
    float sum_energy = 0;
    
    for(int i=0; i<stars_prev.size(); i++)
    {
      float c_kinetic = stars_prev.get(i).mass * stars_prev.get(i).vel.mag();
      float c_potential = get_potential_energy_by_id(i);
      sum_energy += c_kinetic;
      sum_energy += c_potential;
    }
    
    return sum_energy;
  }
  
  float get_potential_energy_by_id(int id)
  {
    assert(id>=0 && id<stars_prev.size());
    float id_mass = stars_prev.get(id).mass;
    PVector id_pos = stars_prev.get(id).pos.copy();
    float sum_potential = 0;
    for(int i=0; i<stars_prev.size(); i++)
    {
      if(i!=id)
      {
        PVector distance = stars_prev.get(i).pos.copy().sub(id_pos.copy());
        float c_potential = -1 * big_g * ((id_mass * stars_prev.get(i).mass)/distance.mag());
        sum_potential += c_potential;
      }
    }
    
    return sum_potential;
  }
  
  PVector get_gravity_by_id(int id)
  {
    assert(id>=0 && id<stars_prev.size());
    float id_mass = stars_prev.get(id).mass;
    PVector id_pos = stars_prev.get(id).pos.copy();
    PVector gravity = new PVector(0,0,0);
    
    for(int i=0; i<stars_prev.size(); i++)
    {
      if(i!=id)
      {
        PVector distance = stars_prev.get(i).pos.copy().sub(id_pos.copy());
        float distance_mag = distance.mag();
        if(distance_mag < 5)
          distance_mag = 5;
        float g_mag = big_g * ((id_mass * stars_prev.get(i).mass) / ( distance_mag * distance_mag));
        PVector g_dir = distance.normalize();
        gravity.add(g_dir.mult(g_mag));
      }
    }
    return gravity;
  }
  
  void draw()
  {
    for(int i=0; i<stars_prev.size(); i++)
    {
      stars_prev.get(i).draw();
    }
  }
}
