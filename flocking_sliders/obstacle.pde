
class Obstacle
{
  PVector pos;
  float rad;
  
  Obstacle(float x, float y, float rad) {
    pos = new PVector(x,y);
    this.rad = rad;
  }
  
  void render() {
    fill(175);
    noStroke();
    pushMatrix();
    translate(pos.x,pos.y);
    sphere(30);
    popMatrix();
  }
}
