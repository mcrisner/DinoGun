// Imports
import java.util.*;
import java.io.*;
import ddf.minim.*;

// Settings
float framerate = 240.0;
float particleMultiplier = 1;
float fireworkSize = height / 160.0;

// Global variables
Player player;
Weapon gun;
Button playButton;
Button scoresButton;
Button quitButton;
Button backButton;
Button menuButton;
ArrayList<Obstacle> obstacles;
ArrayList<Particle> particles;
ArrayList<Object> objects;
ArrayList<Projectile> bullets;
ArrayList<Integer> highscores;
PImage sky;
PImage dino_right;
PImage dino_left;
PImage dino_dead;
PImage cloud;
PImage coin;
PImage grass;
PImage bullet;
PImage bird;
PImage spiny;
PImage[] cacti;
PGraphics background;
PGraphics frame;
int score;
int obstacleIndex;
int fr;
float time;
float currentTime;
float previousTime;
float deltaTime;
float obstacleTimer;
float cloudTimer;
float speedMult;
float lastIncreaseTime;
float lastIncreaseTimeFR;
float speedUpAlpha;
boolean mainMenu;
boolean showScores;
boolean gameOver;
boolean facingLeft;
boolean displaySpeedUp;
color menuCol;
PFont font;
Minim minim;
AudioPlayer gameMusic;
AudioPlayer menuMusic;
AudioSample coinSound;
AudioSample deathSound;
AudioSample hitSound;
AudioSample fireSound;

void setup() {
  //fullScreen();
  //size(3440, 1440);
  size(1920, 1080);
  frameRate(framerate);
  strokeWeight(4);
  loadImages();
  loadVariables();
  loadScores();
  loadObjects();
  menuMusic.loop();
}

void draw() {
  // Update time based on time elapsed between frames
  currentTime = millis();
  deltaTime = (currentTime - previousTime) / 1000.0;
  previousTime = currentTime;
  time += deltaTime;

  // Draw screen based on current game state
  if (mainMenu) {
    drawMenu();
  } else if (showScores) {
    drawScores();
  } else if (gameOver) {
    drawGame();
    drawGameOver();
  } else {
    runGame();
  }
  
  displayFramerate();
  
}

void keyPressed() {
  if (!mainMenu) {
    if (key == 'w' || keyCode == UP) {
    player.jump();
  } else if (key == 'a' || keyCode == LEFT) {
    player.moveLeft = true;
    facingLeft = true;
  } else if (key == 'd' || keyCode == RIGHT) {
    player.moveRight = true;
    facingLeft = false;
  } else if (key == ' ') {
      if (gameOver) {
        reset();
      } else if (!showScores) {
        gun.fire();
      }
    }
  }
}

void keyReleased() {
  if (key == 'a' || keyCode == LEFT) {
    player.moveLeft = false;
  } else if (key == 'd' || keyCode == RIGHT) {
    player.moveRight = false;
  }
}

void mousePressed() {
  if (mainMenu && playButton.checkCoords(mouseX, mouseY)) {
    reset();
    mainMenu = false;
    menuMusic.pause();
    menuMusic.rewind();
    gameMusic.loop();
  } else if (mainMenu && scoresButton.checkCoords(mouseX, mouseY)) {
    showScores = true;
    mainMenu = false;
  } else if (mainMenu && quitButton.checkCoords(mouseX, mouseY)) {
    exit();
  } else if (showScores && backButton.checkCoords(mouseX, mouseY)) {
    showScores = false;
    mainMenu = true;
  } else if (gameOver && menuButton.checkCoords(mouseX, mouseY)) {
    mainMenu = true;
    gameOver = false;
    player.jumping = false;
    gameMusic.pause();
    gameMusic.rewind();
    menuMusic.loop();
  }
}

void drawMenu() {
  cursor();
  facingLeft = false;
  imageMode(CORNER);
  image(background, 0, 0, width, height);
  playButton.drawRect();
  scoresButton.drawRect();
  quitButton.drawRect();
  textAlign(CENTER);
  fill(0);
  textFont(createFont("Ink Free", height / 4.0));
  text("DINO GUN", width * 0.49, height * 0.3);
  textFont(font, height / 16.0);
  text("Play", width / 2.0, height * 0.47);
  text("High Scores", width / 2.0, height * 0.59);
  text("Quit", width / 2.0, height * 0.71);
  player.pos = new PVector(width * 0.5, height * 0.34);
  player.draw();
  gun.draw();
  if (playButton.checkCoords(mouseX, mouseY)) {
    playButton.col = #D3D3D3;
  } else if (scoresButton.checkCoords(mouseX, mouseY)) {
    scoresButton.col = #D3D3D3;
  } else if (quitButton.checkCoords(mouseX, mouseY)) {
    quitButton.col = #D3D3D3;
  } else {
    playButton.col = 255;
    scoresButton.col = 255;
    quitButton.col = 255;
  }
}

void drawScores() {
  cursor();
  background(#69beef);
  backButton.drawRect();
  textFont(font);
  textSize(height / 16.0);
  textAlign(CENTER);
  fill(0);
  text("Back", width / 2.0, height * 0.82);
  textSize(height / 16.0);
  text("High Scores", width / 2.0, height * 0.2);
  
  float topLine = height * 0.26;
  float botLine = height * 0.75;
  int i = 0;
  textFont(createFont("Segoe UI Light", height / 24.0));
  for (Integer s : highscores) {
    text((i + 1) + ". " + nf(s, 10), width / 2.0, topLine + (botLine - topLine) / 10 * i);
    i++;
  }
  if (backButton.checkCoords(mouseX, mouseY)) {
    backButton.col = #D3D3D3;
  } else {
    backButton.col = 255;
  }
  //line(width/2,0,width/2,height);
}

void drawGameOver() {
  cursor();
  if (menuButton.checkCoords(mouseX, mouseY)) {
    menuButton.col = #D3D3D3;
  } else {
    menuButton.col = 255;
  }
  menuButton.drawRect();
  fill(0);
  textAlign(CENTER);
  textSize(height / 8.0);
  text("IT'S FINE.", width * 0.5, height * 0.40);
  textSize(height / 32.0);
  text("Just press Space to try again.", width * 0.5, height * 0.45);
  textFont(createFont("Segoe UI Light", height / 36.0));
  text("No it's not.", width * 0.9, height * 0.9);
}

void checkCollision() {
  for (int i = obstacles.size() - 1; i >= 0; i--) {
    Obstacle obs = obstacles.get(i);
    // Is the player touching any of the obstacles?
    if ( abs(obs.pos.x - player.pos.x) < player.size / 2 + obs.size / 2 && abs(obs.pos.y - player.pos.y) < player.size / 4 + obs.size / 2) {
      if (!player.invincible) {
        hitSound.trigger();
        player.health -= 1;
        player.invincible = true;
        player.invincibleTimer = 0.5;
        generateFirework(player.pos, color(255, 0, 0), color(128, 0, 0));
      }
    }
    // Is the player touching a coin?
    if ( obs.hasCoin && abs(obs.coinPos.x - player.pos.x) < player.size / 2 + obs.size / 4 && abs(obs.coinPos.y - player.pos.y) < player.size / 2 + obs.size / 4 ) {
      coinSound.trigger();
      obs.hasCoin = false;
      score += 10000;
      generateFirework(new PVector(obs.coinPos.x - height * 0.01, obs.coinPos.y), #FFD700, #907900);
    }
    // Is the obstacle touching a bullet?
    if (obs.flying && bullets.size() > 0) {
      for (int j = bullets.size() - 1; j >= 0; j--) {
        Projectile bul = bullets.get(j);
        if ( abs(obs.pos.x - bul.pos.x) < obs.size / 2 + bul.wid / 4 &&  abs(obs.pos.y - bul.pos.y) < obs.size / 2 + bul.hei / 2 ) {
          hitSound.trigger();
          generateFirework(obs.pos, color(255, 0, 0), color(128, 0, 0));
          obstacles.remove(i);
          bullets.remove(j);
          score += 10000;
        }
      }
    }
  }
}

void generateFirework(PVector pos, color fillCol, color strokeCol) {
  int numParticles = int(random(150 * fireworkSize * particleMultiplier, 250 * fireworkSize * particleMultiplier));
  
  // Randomly generate particles around the point of explosion
  for (int i = 0; i < numParticles; i++) {
    float angle = random(TWO_PI);
    float speed = random(0, fireworkSize * 5);
    PVector pVel = new PVector(cos(angle), sin(angle)).mult(speed);
    particles.add(new Particle(pos.copy(), pVel, new PVector(0, 0), fillCol, strokeCol));
  }
}

void drawParticles() {
  // Draw and update particles
  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    if (p.pos.x > -5 && p.pos.x < width + 5 && p.pos.y > -5 && p.pos.y < height + 5) {
      p.draw();
      p.update();
    } else {
      particles.remove(i);
    }
    
    // Remove particle from the list if it is fully transparent
    if (p.alpha == 0) {
      particles.remove(i);
    }
  }
}

void reset() {
  gameOver = false;
  obstacles = new ArrayList<Obstacle>();
  particles = new ArrayList<Particle>();
  time = -3.96;
  obstacleTimer = 0;
  speedMult = 1.0;
  lastIncreaseTime = 0;
  lastIncreaseTimeFR = -3.96;
  score = 0;
  player.health = 3;
  player.jumping = true;
  player.invincible = false;
  player.invincibleTimer = 0.0;
  player.vel = new PVector(0, 0);
  gameMusic.rewind();
  gameMusic.loop();
}

void runGame() {
  noCursor();
  drawGame();
  
  // Spawn obstacles
  if (obstacleTimer < time) { 
    obstacles.add(new Obstacle());
    obstacleTimer = random(time + 1, time + 2);
  }
  
  // Update player, obstacle, cloud, and bullet movement/logic
  player.update(deltaTime);
  
  for (int i = obstacles.size() - 1; i >= 0; i--) {
    Obstacle obs = obstacles.get(i);
    if (obs.pos.x < 0 - obs.size) {
      obstacles.remove(i);
    } else {
      obs.update(deltaTime);
    }
  }
  
  for (Object o : objects) {
    o.update(deltaTime);
  }
  
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Projectile bullet = bullets.get(i);
    bullet.update(deltaTime);
    if (bullet.pos.x > width + 10) {
      bullets.remove(i);
    }
  }
  
  // Speed up every 10 seconds
  if (time > 1 && time - lastIncreaseTime > 15.36) {
    speedMult += 0.1;
    lastIncreaseTime = time;
    displaySpeedUp = true;
  }
  
  checkCollision();
  score = int(score + deltaTime * 1000);
}

void drawGame() {
  // Background
  imageMode(CORNER);
  image(background, 0, 0);
  
  // Clouds
  for (Object o : objects) {
    if (o.isCloud) {
      o.draw();
    }
  }
  
  // Obstacles
  for (Obstacle obs : obstacles) {
    obs.draw();
  }
  
  // Grass
  for (Object o : objects) {
    if (!o.isCloud) {
      o.draw();
    }
  }
  stroke(#9F9795);
  strokeWeight(4);
  line(0, height * 0.8, width, height * 0.8);
  
  // Score text
  fill(255);
  stroke(0);
  textSize(20);
  textAlign(LEFT);
  textFont(createFont("Segoe UI Bold", height / 54.0));
  text("Score: " + nf(score, 10), width - (height / 54.0 * 9.4), height / 36.0);
  
  // Speed up text
  if (displaySpeedUp && !gameOver) {
    fill(0, 0, 0, speedUpAlpha);
    textAlign(CENTER);
    textSize(height / 8.0);
    text("FASTER!", width * 0.5, height * 0.40);
    
    speedUpAlpha -= 300 * deltaTime;
    if (speedUpAlpha < 0) {
      speedUpAlpha = 255;
      displaySpeedUp = false;
    }
  }
  
  // Bullets
  for (Projectile bullet : bullets) {
    bullet.draw();
  }
  
  // Player
  player.draw();
  gun.draw();
  
  // Firework particles
  drawParticles();
}

PImage scaleImage(PImage img, int scaleFactor) {
  img.loadPixels();
  
  PImage scaledImg = createImage(img.width * scaleFactor, img.height * scaleFactor, ARGB);
  
  // Apply nearest-neighbor scaling to maintain pixel art clarity
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int c = img.pixels[y * img.width + x];
      for (int dy = 0; dy < scaleFactor; dy++) {
        for (int dx = 0; dx < scaleFactor; dx++) {
          scaledImg.set(x * scaleFactor + dx, y * scaleFactor + dy, c);
        }
      }
    }
  }
  
  scaledImg.updatePixels();
  
  return scaledImg;
}

void loadImages() {
  sky = loadImage("sky.png");
  dino_right = loadImage("dino_right.png");
  dino_left = loadImage("dino_left.png");
  dino_dead = loadImage("dino_dead.png");
  cloud = loadImage("cloud.png");
  coin = loadImage("coin.png");
  grass = loadImage("grass.png");
  bullet = loadImage("bullet.png");
  bird = loadImage("bird.png");
  spiny = loadImage("spiny.png");
  cacti = new PImage[3];
  cacti[0] = loadImage("cactus0.png");
  cacti[1] = loadImage("cactus1.png");
  cacti[2] = loadImage("cactus2.png");
  dino_right = scaleImage(dino_right, height / 180);
  dino_left = scaleImage(dino_left, height / 180);
  dino_dead = scaleImage(dino_dead, height / 180);
  cloud = scaleImage(cloud, constrain(height / 240, 1, 1000));
  coin = scaleImage(coin, constrain(height / 240, 2, 1000));
  grass = scaleImage(grass, height / 90);
  bullet = scaleImage(bullet, constrain(height / 360, 1, 100));
  bird = scaleImage(bird, height / 150);
  cacti[0] = scaleImage(cacti[0], height / 200);
  cacti[1] = scaleImage(cacti[1], height / 200);
  cacti[2] = scaleImage(cacti[2], height / 200);
  background = createGraphics(width, height);
  background.beginDraw();
  background.image(sky, 0, 0, width, height);
  background.endDraw();
  frame = createGraphics(width, height);
}

void loadVariables() {
  font = createFont("Corbel Light", 20);
  menuCol = color(255, 255, 255);
  player = new Player();
  gun = new Weapon();
  obstacles = new ArrayList<Obstacle>();
  particles = new ArrayList<Particle>();
  bullets = new ArrayList<Projectile>();
  obstacleIndex = 0;
  score = 0;
  time = 0.0;
  speedMult = 1.0;
  lastIncreaseTime = 0.0;
  lastIncreaseTimeFR = 0.0;
  speedUpAlpha = 255;
  obstacleTimer = random(1, 2);
  obstacleTimer = random(2, 3);
  mainMenu = true;
  showScores = false;
  gameOver = false;
  displaySpeedUp = false;
  playButton = new Button(width * 0.4, height * 0.4, width * 0.6, height * 0.5, menuCol);
  scoresButton = new Button(width * 0.4, height * 0.52, width * 0.6, height * 0.62, menuCol);
  quitButton = new Button(width * 0.4, height * 0.64, width * 0.6, height * 0.74, menuCol);
  backButton = new Button(width * 0.44, height * 0.75, width * 0.56, height * 0.85, menuCol);
  menuButton = new Button(width * 0.84, height * 0.87, width * 0.96, height * 0.91, menuCol);
  minim = new Minim(this);
  gameMusic = minim.loadFile("digitallove.mp3");
  menuMusic = minim.loadFile("kingvamp.mp3");
  coinSound = minim.loadSample("pickupCoin.wav");
  deathSound = minim.loadSample("death.wav");
  hitSound = minim.loadSample("hit.wav");
  fireSound = minim.loadSample("gunshot.wav");
  menuMusic.loop();
}

void loadScores() {
  highscores = new ArrayList<Integer>();
  ArrayList<String> scores = new ArrayList<>(Arrays.asList(loadStrings("highscores.txt")));
  for (String s : scores) {
    highscores.add(Integer.parseInt(s));
  }
  Collections.sort(highscores, Collections.reverseOrder());
}

void saveScores(int finalscore) {
  highscores.add(finalscore);
  Collections.sort(highscores, Collections.reverseOrder());
  highscores.remove(10);
  
  try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataPath("highscores.txt")))) {
    for (Integer s : highscores) {
        writer.write(s.toString());
        writer.newLine();
    }
  } catch (IOException e) {
      e.printStackTrace();
  }
}

void loadObjects() {
  objects = new ArrayList<Object>();
  
  // Generate clouds
  for (float i = 0; i < 1.8; i = i + 0.3) {
    PVector pos = new PVector(random(width * i, width * (i + 0.3)), random(height * 0.1, height * 0.60));
    PVector vel = new PVector(width / -8.0, 0);
    objects.add(new Object(pos, vel, cloud, true));
  }
  
  // Generate grass
  for (int i = 0; i < 10; i++) {
    PVector pos = new PVector(grass.width * i, height * 0.8);
    PVector vel = new PVector(width / -2.0, 0);
    objects.add(new Object(pos, vel, grass, false));
  }
}

void displayFramerate() {
  // Display framerate
  fill(255);
  stroke(0);
  textSize(20);
  textAlign(LEFT);
  textFont(createFont("Segoe UI Bold", height / 54.0));
  text(fr + " FPS", height / 54.0, height / 36.0);
  
  if (time - lastIncreaseTimeFR > 0.5) {
    lastIncreaseTimeFR = time;
    fr = int(frameRate);
  }
}
