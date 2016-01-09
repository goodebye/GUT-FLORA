boolean playing = true;
int Y_AXIS = 1;
int X_AXIS = 2;
int filename = 0;
int low_color = 30;
int high_color = 255;
PFont small_font, big_font;


int book_counter = 0;

void setup() {
  size(800, 800);
  big_font = createFont("Arimo Bold", width / 12);
  small_font = createFont("Arimo Bold", width / 20);
}

void draw() {
  
  for (int numCounter=0; numCounter < 3; numCounter++) {
    background(255);
    color c1 = random_color();
    color c2 = random_color();
    setGradient(0, 0, width, height, c1, c2, floor(random(1.5, 2.5))); 
    
    for (int i = 0; i < 13; i++) {
      int[] p = new int[8];
      for (int j = 0; j < p.length; j++) {
        if (j % 2 == 0) {
          p[j] = int(random(width / 50, width - width / 50)); 
        } else {
          p[j] = int(random(height / 50, height - height / 50));
        }
      }
      
      int thickness = int(random(12 * width / 580, 40 * width / 580));
      color c = random_color();
      
      stroke(c);
      makeShape(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], thickness);
    }
    
    if (numCounter == 0) {
      stroke(255);
      fill(255);
      textFont(big_font);
      textAlign(CENTER);
      text("G U T  F L O R A", 0, height * 4 / 9, width, height);
      textFont(small_font);
      text("GOODE BYE", 0, height * 5 / 9, width, height);
      
//      PImage qrcode = loadImage("../qr_codes/images/" + book_counter + ".png");
//      image(qrcode, width / 2, height * 2 / 3, width / 4, height / 4); 
    }
    save("squiggle_" + filename + "_" + numCounter + ".png");
  }
  
  if (filename == 100) {
    noLoop();
  }

  filename++;

}

void mousePressed() {
  if (playing) {
    noLoop();
    playing = false;
  } else {
    playing = true;
    loop();
  }
}

void makeShape(int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4, int thickness) {
  strokeWeight(thickness);
  bezier(x1, y1, x2, y2, x3, y3, x4, y4);
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

color random_color() {
  int r = int(random(low_color, high_color));
  int g = int(random(low_color, high_color));
  int b = int(random(low_color, high_color));
  
  int threshold = 200;
  
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

