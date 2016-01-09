int spacing;
int low_color = 30;
int high_color = 255;
int Y_AXIS = 1;
int X_AXIS = 2;
float rotx = PI/4;
float roty = PI/4;
PImage bg;
color maze_color;
float stroke_weight;
float stroke_comp;
int counter = 0;

void setup() {
  size(3000, 3000, P3D);
  spacing = width / 30;
  maze_color = random_color();
  stroke_weight = width / 400;
  stroke_comp = stroke_weight / 4;
}

void draw() {
  background(255);
  maze_color = color(110, 246, 118);
  strokeWeight(ceil(width / 700.0));
  setGradient(0, 0, width, height, random_color(), random_color(), Y_AXIS);
  
  tint(255, 255, 255, 255);

  
  for (int i = 0; i < width; i += spacing) {
    for (int j = 0; j < height; j += spacing) {
      float x1 = i - stroke_comp;
      float x2 = i + spacing + stroke_comp;
      float y1;
      float y2;
      strokeWeight(stroke_weight);
      stroke(maze_color);
      int high_or_low = int(random(.5, 1.5));
      if (high_or_low > 0) {
        y1 = j + spacing + stroke_comp;
        y2 = j - stroke_comp;
      } else {
        y1 = j - stroke_comp;
        y2 = j + spacing + stroke_comp;
      }
      line(x1, y1, x2, y2);
      noStroke();
      fill(maze_color);
      rect(x1, y1, width / 800, width / 800);
      rect(x2, y2, width / 800, width / 800);
    }
  }
  
  
  //draw_text();
  
  pushMatrix();
  translate(width/2.0, height/2.0, (50 * height / 700));
  /*rotateX(random(TWO_PI));
  rotateY(random(TWO_PI));*/
  rotateX(PI / 4);
  rotateY(PI / 4);
  scale(50 * height / 700);
  noStroke();
  //strokeWeight(.05);
  fill(random_color());
  draw_cube();
  popMatrix();
  save("covers/" + counter + ".png");
  save("0.png");
  counter++;
  
  endRaw();
  if (counter < 100) {
    loop();
  }
  else {
    noLoop();
  }
}

void draw_cube() {
  textureMode(NORMAL);
  //int picture = int(random(0, 2.5));
  PImage tex = loadImage("0.png");
  beginShape(QUADS);
  texture(tex);
  vertex(-1, -1,  1, 0, 0);
  vertex( 1, -1,  1, 1, 0);
  vertex( 1,  1,  1, 1, 1);
  vertex(-1,  1,  1, 0, 1);

  // -Z "back" face
  vertex( 1, -1, -1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1,  1, -1, 1, 1);
  vertex( 1,  1, -1, 0, 1);

  // +Y "bottom" face
  vertex(-1,  1,  1, 0, 0);
  vertex( 1,  1,  1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  // -Y "top" face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, -1,  1, 1, 1);
  vertex(-1, -1,  1, 0, 1);

  // +X "right" face
  vertex( 1, -1,  1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex( 1,  1,  1, 0, 1);

  // -X "left" face
  vertex(-1, -1, -1, 0, 0);
  vertex(-1, -1,  1, 1, 0);
  vertex(-1,  1,  1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  endShape();
}

color random_color() {
  int r = int(random(low_color, high_color));
  int g = int(random(low_color, high_color));
  int b = int(random(low_color, high_color));
  
  int threshold = 65;
  
  if (r < threshold && g < threshold && b < threshold) {
    int coin_toss = floor(random(0, 3));
    if (coin_toss == 0) {
      r = int(random(200, 255));
    }
    else if (coin_toss == 1) {
      g = int(random(200, 255));
    }
    else if (coin_toss == 2) {
      b = int(random(200, 255));
    }  
  }
  return color(r, g, b);
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

void mousePressed() {
  loop(); 
}
