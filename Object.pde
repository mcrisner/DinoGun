class Object {
  PVector pos;
  PVector vel;
  PImage img;
  boolean isCloud;
  
  Object(PVector pos, PVector vel, PImage img, boolean isCloud) {
    this.pos = pos;
    this.vel = vel;
    this.img = img;
    this.isCloud = isCloud;
  }
  
  void draw() {
    imageMode(CORNER);
    image(img, pos.x, pos.y);
  }
  
  void update(float deltaTime) {
    // Update position
    pos.add(PVector.mult(PVector.mult(vel, deltaTime), speedMult));
    
    // Respawn if offscreen
    if (isCloud) {
      if (pos.x < 0 - img.width) {
        pos.x = random(width + img.width, width * 1.2);
        pos.y = random(height * 0.1, height * 0.60);
      }
    } else if (pos.x < 0 - img.width) {
      pos.x += 10 * grass.width;
    }
  }
}
