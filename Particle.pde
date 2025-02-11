class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  float gravity = 0.05;
  float coef_drag = 0.01;
  float coef_fric;
  float disapp_rate;
  float alpha;
  float size;
  color fillCol;
  color strokeCol;
  
  Particle(PVector pos, PVector vel, PVector acc, color fillCol, color strokeCol) {
    this.pos = pos;
    this.vel = vel;
    this.acc = acc;
    this.fillCol = fillCol;
    this.strokeCol = strokeCol;
    this.alpha = 255;
    this.size = random(5, 10);
    disapp_rate = random(2, 4);
  }
  
  void draw() {
    stroke(strokeCol, alpha);
    fill(red(fillCol), green(fillCol), blue(fillCol), alpha);
    square(pos.x, pos.y, size);
    stroke(0);
  }
  
  void update() {
    // Calculate and apply drag force
    PVector drag = vel.copy().mult(-coef_drag * size / 5);
    acc.add(drag);
    
    // Update velocity and position
    vel.add(acc);
    pos.add(vel);
    
    // Reset acceleration
    acc.sub(drag);
    
    // Gradually decrease the transparency
    alpha = constrain(alpha - disapp_rate * deltaTime * 200, 0, 255);
  }
}
