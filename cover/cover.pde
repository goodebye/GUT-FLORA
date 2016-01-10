int spacing;
int Y_AXIS = 1;
int X_AXIS = 2;
float rotx = PI/4;
float roty = PI/4;
PImage bg;
color maze_color;
float stroke_weight;
float stroke_comp;
int counter = 0;

PGraphics frontCover;
PGraphics backCover;

boolean firstCover = true;

PImage monolith_puncture;
PImage cube_texture;

void setup() {
  size(6000, 3000, P3D);
  spacing = width / 30;
  maze_color = random_color();
  stroke_weight = width / 400;
  stroke_comp = stroke_weight / 4;
  
  monolith_puncture = loadImage("monolith_puncture.png");
  
  frontCover = createGraphics(height, height, P3D);
  backCover = createGraphics(height, height, P3D);
}

void draw() {
  background(255);
  draw_cover(frontCover);
  firstCover = false;
  draw_cover(backCover);
  image(frontCover, 0, 0);
  image(backCover, width / 2, 0);
  frontCover.save("for_ebook/" + (frameCount - 1) + "_front.png");
  backCover.save("for_ebook/" + (frameCount - 1) + "_back.png");

  save("for_print/" + (frameCount - 1) + ".png");
}

void draw_cover(PGraphics canvas) {
  canvas.beginDraw();
    maze_color = random_color();
    canvas.strokeWeight(ceil(canvas.width / 700.0));
    setGradient(canvas, 0, 0, canvas.width, canvas.height, random_color(), random_color(), Y_AXIS);
    
    canvas.tint(255, 255, 255, 255);
  
    
    for (int i = 0; i < canvas.width; i += spacing) {
      for (int j = 0; j < canvas.height; j += spacing) {
        float x1 = i - stroke_comp;
        float x2 = i + spacing + stroke_comp;
        float y1;
        float y2;
        canvas.strokeWeight(stroke_weight);
        canvas.stroke(maze_color);
        int coinFlip = int(random(.5, 1.5));
        if (coinFlip == 1) {
          y1 = j + spacing + stroke_comp;
          y2 = j - stroke_comp;
        } else {
          y1 = j - stroke_comp;
          y2 = j + spacing + stroke_comp;
        }
        canvas.line(x1, y1, x2, y2);
        canvas.noStroke();
        canvas.fill(maze_color);
        canvas.rect(x1, y1, canvas.width / 800, canvas.width / 800);
        canvas.rect(x2, y2, canvas.width / 800, canvas.width / 800);
      }
    }
    
    
    
    canvas.pushMatrix();
    canvas.translate(canvas.width/2.0, canvas.height/2.0, (50 * canvas.height / 700));
  
    canvas.rotateX(PI / 4);
    canvas.rotateY(PI / 4);
    canvas.scale(50 * canvas.height / 700);
    canvas.noStroke();
    canvas.fill(random_color());
    if (firstCover) {
      cube_texture = monolith_puncture; 
    }
    else {
      cube_texture = loadImage("texture_for_cube.png"); 
    }
    draw_cube(canvas);
    canvas.popMatrix();
    canvas.save("texture_for_cube.png");
    counter++;
   canvas.endDraw();

}

void draw_cube(PGraphics canvas) {
  canvas.textureMode(NORMAL);
  canvas.beginShape(QUADS);
  canvas.texture(cube_texture);
  canvas.vertex(-1, -1,  1, 0, 0);
  canvas.vertex( 1, -1,  1, 1, 0);
  canvas.vertex( 1,  1,  1, 1, 1);
  canvas.vertex(-1,  1,  1, 0, 1);

  // -Z "back" face
  canvas.vertex( 1, -1, -1, 0, 0);
  canvas.vertex(-1, -1, -1, 1, 0);
  canvas.vertex(-1,  1, -1, 1, 1);
  canvas.vertex( 1,  1, -1, 0, 1);

  // +Y "bottom" face
  canvas.vertex(-1,  1,  1, 0, 0);
  canvas.vertex( 1,  1,  1, 1, 0);
  canvas.vertex( 1,  1, -1, 1, 1);
  canvas.vertex(-1,  1, -1, 0, 1);

  // -Y "top" face
  canvas.vertex(-1, -1, -1, 0, 0);
  canvas.vertex( 1, -1, -1, 1, 0);
  canvas.vertex( 1, -1,  1, 1, 1);
  canvas.vertex(-1, -1,  1, 0, 1);

  // +X "right" face
  canvas.vertex( 1, -1,  1, 0, 0);
  canvas.vertex( 1, -1, -1, 1, 0);
  canvas.vertex( 1,  1, -1, 1, 1);
  canvas.vertex( 1,  1,  1, 0, 1);

  // -X "left" face
  canvas.vertex(-1, -1, -1, 0, 0);
  canvas.vertex(-1, -1,  1, 1, 0);
  canvas.vertex(-1,  1,  1, 1, 1);
  canvas.vertex(-1,  1, -1, 0, 1);

  canvas.endShape();
}

color random_color() {
    
  int low_color = 30;
  int high_color = 255;
  
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

void setGradient(PGraphics canvas, int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      canvas.stroke(c);
      canvas.line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      canvas.stroke(c);
      canvas.line(i, y, i, y+h);
    }
  }
}

void mousePressed() {
  loop(); 
}
