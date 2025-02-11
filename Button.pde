class Button {
  float x1;
  float x2;
  float y1;
  float y2;
  color col;
  
  Button(float x1, float y1, float x2, float y2, color col) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.col = col;
  }
  
  void drawCircle() {
    fill(col);
    circle((x1 + x2) / 2, (y1 + y2) / 2, 100);
  }
  
  void drawRect() {
    stroke(0);
    strokeWeight(4);
    rectMode(CORNERS);
    fill(col);
    rect(x1, y1, x2, y2);
  }
  
  boolean checkCoords(float checkX, float checkY) {
    return (checkX > x1 && checkX < x2 && checkY > y1 && checkY < y2);
  }
}
