class Orbit
{
  ArrayList<PVector> path;
  
  Orbit()
  {
    this.path = new ArrayList<PVector>();
  }
  
  void add_point(PVector pnt)
  {
    path.add(pnt.copy());
  }
  
  void draw()
  {
    if(path.size() >= 2)
    {
      for(int i=0; i<path.size()-1; i++)
      {
        PVector start = path.get(i);
        PVector end = path.get(i+1);
        stroke(255,255,255,100);
        line(start.x, start.y, start.z, end.x, end.y , end.z);
      }
    }
  }
}
