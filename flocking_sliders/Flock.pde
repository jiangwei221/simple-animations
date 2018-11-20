//modified from nature of code by shiffman
//add obstacles

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  ArrayList<Obstacle> obs;
  int num_max_boids = 200;
  int num_max_obs = 10;
  
  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    obs = new ArrayList<Obstacle>();
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids, obs);  // Passing the entire list of boids to each boid individually
    }
    for(Obstacle o : obs)
    {
      o.render();
    }
  }

  void addBoid(Boid b) {
    if(boids.size() < num_max_boids)
      boids.add(b);
  }
  
  void addObstacle(Obstacle o) {
    if(obs.size() < num_max_obs)
      obs.add(o);
  }

}
