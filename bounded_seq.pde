/* AD 315
 * Programming Assignment 3
 *
 * Determining whether sequences are
 * bounded in a discrete complex space
 *
 * The sequence is recursively defined as
 * z_{n+1} = (z_n)^2 + c.
 * Here c is a complex number and z_0 = c
 */

// variables for the real and complex part of 
// a complex number
double a, b;

// variables to determine the real and
// imaginary range of the viewing window
double xmin, xmax, ymin, ymax, dx, dy;

// variable to determine how many iterations
// of the sequence we will look at.
int iterations;

// variable to determine number of iterations
int iterationCount;

// color variable to represent number of iterations
color c;

// since we are in a discrete space, we will choose a finite 
// number to represent infinity5
int infinity;

float r = random(255);

void setup() {
  // be sure to fill in the size method
  size(28800, 16200);
  // HSB stands for hue, saturation, and brightness
  colorMode(HSB);
  // we are only writing to the display window once
  noLoop();
  // initialize the background.
  background(255);

  // set the number of iterations
  iterations = 100000;

  // here we decide what our discrete
  // infinity will be
  infinity = 12;

  // initialize the viewing window
  xmin = -3.2;
  xmax = 1.6;
  ymin = -1.35;
  ymax = 1.35;
}

void draw() {
  // dx and dy should be defined using the 
  // height and width keywords.
  dx = Math.abs(xmax - xmin) / width;
  dy = Math.abs(ymax - ymin) / height;
  // to use the pixels[] array you need to first 
  // call the loadpixels() method
  loadPixels();

  iterationCount = 0;
  double x = xmin;
  for (int i = 0; i < width; i++) {
    double y = ymin;
    for (int j = 0; j < height; j++) {
      // a and b represent the current value of c
      // which depends on i and j. Here c = a + bi
      a = x;
      b = y;

      // determine whether the sequence is bounded
      // at the current value of c
      iterationCount = checkBounded(a, b);

      // write a color to the pixels[] array based
      // on iterationCount
      c = color(iterationCount * 2);
      pixels[i+j*width] = c;
      y+= dy;
    }
    x+=dx;
    int xProg = (int) (((x+3.2)/4.8) * 100);
    System.out.println("Progress: " + xProg + "%.");
    //System.out.println("Current x: " + x);
    //textSize(32);
    //text(xProg, 10, 30); 
    //fill(0, 102, 153);
  }

  // you need to call updatePixels() to display
  // the colors stored in the pixels[] array.
  updatePixels();
  save("mandelbrot.tif");
}

/**
 * Mouse Click Action
 */
void mousePressed() {
  loadPixels();
  // LEFT CLICK
  // Change the color of the set by a random value between 0-255
  if (mousePressed && (mouseButton == LEFT)) {
    r = random(255);
    for (int i = 0; i < width*height; i++) {
      if (pixels[i] != color(0)) {
        pixels[i] = pixels[i] + (int) r;
      }
    }
    updatePixels();
  }

  // RIGHT CLICK
  // redraw the set with double the number of iterations
  if (mousePressed && (mouseButton == RIGHT)) {
    iterations = iterations * 2; 
    draw();
  }
}

// method to check if the sequence is bounded. x 
// is the real part of c, and y is the imaginary part.
int checkBounded(double x, double y) {
  // result is used to determine if a sequence
  // is bounded for a given value of c
  int result;

  // temporary variables used for computation
  double x1 = x;
  double x2;
  double y1 = y;
  double y2;

  // this loop will check if the sequence
  // is bounded for the particular value hof c
  for (int i = 0; i < iterations; i++) {
    x2 = x1 * x1;
    y2 = y1 * y1;
    y1 = 2.0 * x1 * y1 + y;
    x1 = x2 - y2 + x;
    result = (int) (x2 + y2);

    // if result is larger than our discrete infinity
    // return the number of iterations it took to get
    // to the discrete infinity
    if (result > infinity) {
      return i;
    }
  }

  // once we've ran through the specified
  // number of iterations we decide the
  // sequence is bounded for the particular
  // value of c and return 0 as a result.
  return 0;
}

// Handle keyboard input
void keyPressed() {
  // Precalculate 2% change for zooming and moving
  double xDelta = (xmax - xmin) * 0.02;
  double yDelta = (ymax - ymin) * 0.02;

  if (keyCode == RIGHT) {
    //Move view to the right
    xmax += xDelta;
    xmin += xDelta;
  } else if (keyCode == LEFT) {
    //Move view to the left
    xmax -= xDelta;
    xmin -= xDelta;
  } else if (keyCode == UP) {
    //Move view up
    ymax -= yDelta;
    ymin -= yDelta;
  } else if (keyCode == DOWN) {
    //Move view down
    ymax += yDelta;
    ymin += yDelta;
  } else if (key == '=') {
    // Zoom-in view
    ymax -= yDelta; //<>//
    ymin += yDelta;
    xmax -= xDelta;
    xmin += xDelta;
  } else if (key == '-') {
    // Zoom-out view
    ymax += yDelta;
    ymin -= yDelta;
    xmax += xDelta;
    xmin -= xDelta;
  }
}
