class Player {
  PVector pos;
  PVector vel;
  PVector acl;
  boolean jumping;
  boolean jumpBuffer;
  boolean moveLeft;
  boolean moveRight;
  boolean invincible;
  boolean leftFoot;
  color col;
  float speed;
  float size;
  float invincibleTimer;
  int health;
  int spriteBuf;
  
  Player() {
    size = dino_left.width * 0.63;
    pos = new PVector(width * 0.15, height * 0.74);
    vel = new PVector(0, 0);
    acl = new PVector(0, height * 1.5);
    jumping = false;
    jumpBuffer = false;
    moveLeft = false;
    moveRight = false;
    invincible = false;
    leftFoot = false;
    col = #585858;
    speed = height / 2.0;
    invincibleTimer = 0.0;
    health = 3;
    spriteBuf = 0;
  }
  
  void draw() { 
    pushMatrix();
    translate(pos.x, pos.y);
    if (facingLeft) {
      scale(-1, 1);
    }
    imageMode(CENTER);
    if (gameOver) {
      tint(col);
      image(dino_dead, 0, 0);
      noTint();
    } else if (spriteBuf >= 10) {
      tint(col);
      image(dino_left, 0, 0);
      noTint();
      leftFoot = false;
      spriteBuf += 1;
    } else {
      tint(col);
      image(dino_right, 0, 0);
      noTint();
      leftFoot = true;
      spriteBuf += 1;
    }
    if (!jumping && spriteBuf >= 20) {
      spriteBuf = 0;
    }
    popMatrix();
  }
  
  void jump() {
    if (!jumping) { 
      pos.y -= 1;
      vel.y = height / -1.0;
      jumping = true;
    } else if (pos.y > height * 0.65) {
      // Queue a jump if the player is close to the ground
      jumpBuffer = true;
    }
  }
  
  void update(float deltaTime) {
    // Check if player hits the ground this frame
    if (pos.y >= (height * 0.74)) {
      pos.y = (height * 0.74);
      vel.set(0, 0);
      jumping = false;
      if (jumpBuffer) {
        jump();
        jumpBuffer = false;
      }
    } else {
      pos.add(PVector.mult(vel, deltaTime));
      vel.add(PVector.mult(acl, deltaTime));
    }
    
    // Move player left or right
    if (moveLeft) {
      pos.x -= speed * deltaTime;
    }
    if (moveRight) {
      pos.x += speed * deltaTime;
    }
    
    // Keep player on screen
    if (pos.x < 0 + size / 2) {
      pos.x = size / 2;
    } else if (pos.x > width - size / 2) {
      pos.x = width - size / 2;
    }
    
    // Check if dead
    if (health == 0) {
      gameMusic.pause();
      deathSound.trigger();
      gameOver = true;
      saveScores(score);
    }
    
    // If invincible timer > 0, decrease timer
    if (invincibleTimer > 0) {
      invincibleTimer = constrain(invincibleTimer - deltaTime, 0, 5);
    } else {
      invincible = false;
    }
  }
  
}
