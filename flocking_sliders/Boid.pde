//modified from nature of code by shiffman
//add collision avoidance
//new border handling
//new loop structure to reduce complexity

float swt = 5.0;     //sep.mult(25.0f);
float awt = 1.0;      //ali.mult(4.0f);
float cwt = 1.0;      //coh.mult(5.0f);
float maxspeed = 1;
float maxforce = 0.025;

class Boid {

  PVector pos;
  PVector vel;
  PVector acc;
  float r;
  color c;

  Boid(float x, float y, color c) {
    acc = new PVector(0,0);
    vel = new PVector(random(-1,1),random(-1,1));
    pos = new PVector(x,y);
    r = 2.0;
    this.c = c;
  }

  void run(ArrayList<Boid> boids, ArrayList<Obstacle> obs) {
    ArrayList<Boid> nei = findNeighbor(boids, 50);
    flock(nei);
    borders();
    avoid(obs);
    update();
    render();
  }

  ArrayList<Boid> findNeighbor(ArrayList<Boid> boids, float dist)
  {
    ArrayList<Boid> nei = new ArrayList<Boid>();
    for (Boid other : boids) {
      float d = PVector.dist(pos,other.pos);
      if ((d > 0) && (d < dist)) {
        nei.add(other);
      }
    }
    
    return nei;
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acc.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    //PVector avo = avoid(boids);
    // Arbitrarily weight these forces
    sep.mult(swt);
    ali.mult(awt);
    coh.mult(cwt);
    //avo.mult(swt);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    //applyForce(avo);
  }

  // Method to update position
  void update() {
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    pos.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,pos);  // A vector pointing from the position to the target

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,vel);
    steer.limit(maxforce);  // Limit to maximum steering force

    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = vel.heading2D() + radians(90);
    fill(c);
    stroke(0);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(theta);
    box(3*r,9*r,3*r);
    //beginShape(TRIANGLES);
    //vertex(0, -r*2, 0);
    //vertex(-r, r*2,0 );
    //vertex(r, r*2, 0);
    //endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    //if (pos.x < -r) vel.x = -vel.x;
    //if (pos.y < -r) vel.y = -vel.y;
    //if (pos.x > width+r) vel.x = -vel.x;
    //if (pos.y > height+r) vel.y = -vel.y;
    PVector push = new PVector();
    if(pos.x < 50)
    {
      push = (new PVector(10.0/max(pos.x,0), 0, 0));
    }
    if(pos.x > width-50)
    {
      push = (new PVector(-10.0/max(width-pos.x,0), 0, 0));
    }
    if(pos.y < 50)
    {
      push = (new PVector(0, 10.0/max(0, pos.y), 0));
    }
    if(pos.y > height-50)
    {
      push = (new PVector(0, -10.0/max(0, height-pos.y), 0));
    }
    //push.limit(maxforce*2);
    acc.add(push);
    //print(acc);
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0;
    PVector steer = new PVector(0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(pos,other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos,other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50.0;
    PVector steer = new PVector();
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(pos,other.pos);
      if ((d > 0) && (d < neighbordist)) {
        steer.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50.0;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(pos,other.pos);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.pos); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return seek(sum);  // Steer towards the position
    }
    return sum;
  }
  
  void avoid (ArrayList<Obstacle> obs)
  {
    for(Obstacle o : obs)
    {
      PVector c = o.pos.copy();
      PVector diff = c.sub(this.pos).normalize();
      c = o.pos.copy();
      float dis = c.sub(this.pos).mag() - o.rad;
      diff = diff.mult(dis);
      if(diff.mag()<o.rad)
      {
        //PVector push = new PVector();
        PVector push = new PVector(-1.0/diff.x, -1.0/diff.y, 0);
        //push.limit(maxforce);
        acc.add(push);
      }
    }
  }
}
