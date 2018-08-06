color black = color(0);


/*
 * Draw a line using processings line function
 */
void line_processing(int x0, int y0, int x1, int y1, int plot_y_offset)
{
  line(x0, 300 - (y0 + plot_y_offset), x1, 300 - (y1 + plot_y_offset));
}

/*
 * Draw a line pixel by pixel using the most naive algorithm
 */
void line_naive(int x0, int y0, int x1, int y1, int plot_y_offset)
{
  float m = float(y1 - y0) / float(x1 - x0);
  float b = y0 - m * x0;

  for (int x=x0; x<=x1; x++) {
    float y = (float(x) * m + b);
    set(x, 300 - (round(y) + plot_y_offset), black);
  }
}

/* 
 * Draw a line pixel by pixel using the DDA technique:
 */
void line_dda(int x0, int y0, int x1, int y1, int plot_y_offset)
{
  float m = float(y1 - y0) / float(x1 - x0);
  float b = y0 - m * x0;
  float curr_y = y0;
  

  for (int x=x0; x<=x1; x++) {
    set(x, 300 - (round(curr_y) + plot_y_offset), black);
    curr_y += m;
  }
}


/*
 * Draw a line pixel by pixel using the Bresenham's midpoint algorithm
 */
void line_midpoint(int x0, int y0, int x1, int y1, int plot_y_offset)
{
  float m = float(y1 - y0) / float(x1 - x0);

  float midpoint_f = (float)y0 + 0.5;
  float curr_y = (float)y0;
  int plot_y = y0;

  set(x0, 300 - (y0 + plot_y_offset), black);
  for (int x = x0+1; x <= x1; x++) {

    if (curr_y > midpoint_f) {
      plot_y ++;
      midpoint_f += 1.0;
    }
    curr_y += m;

    set(x, 300 - (plot_y + plot_y_offset), black);
  }
}


/*
 * Draw a line pixel by pixel using integer only operations in the for loop.
 */
void line_midpoint_integer(int x0, int y0, int x1, int y1, int plot_y_offset)
{
  int dx = x1 - x0;
  int dy = y1 - y0;

  int midpoint = (2*y0 + 1) * dx;// int(((float)y0 + 0.5) * 2.0) * dx;
  int midpoint_inc = 1 * 2 * dx;
  int curr_y = y0 * 2 * dx;
  int curr_y_inc = 2 * dy;  // m * 2 * dx

  int plot_y = y0;

  set(x0, 300 - (y0 + plot_y_offset), black);
  for (int x = x0+1; x <= x1; x++) {

    if (curr_y > midpoint) {
      plot_y ++;
      midpoint += midpoint_inc;
    }
    curr_y += curr_y_inc;

    set(x, 300 - (plot_y + plot_y_offset), black);
  }
}

void setup() {
  size(400, 300);
  frameRate(200);
  frame.setTitle("BRESENHAM");
}

void draw() {

  clear();
  background(255);
  
  // At current time, only slopes 0 < m < 1 are supported.
  int start_x = 50;
  int start_y = 50;

  int end_x = 250;
  int end_y = 70;

  fill(50);
  text("PROCESSING NATIVE", 270, 300-( 60 + 0), black);
  text("NAIVE",             270, 300-( 60 + 50), black);
  text("DDA",               270, 300-( 60 + 100), black);
  text("MIDPOINT",          270, 300-( 60 + 150), black);
  text("INTEGER MIDPOINT",  270, 300-( 60 + 200), black);

  for ( int i = 0; i < 10000; i++) {

    line_processing               (start_x, start_y, end_x, end_y, 0);
    line_naive                    (start_x, start_y, end_x, end_y, 50);
    line_dda                      (start_x, start_y, end_x, end_y, 100);
    line_midpoint                 (start_x, start_y, end_x, end_y, 150);
    line_midpoint_integer         (start_x, start_y, end_x, end_y, 200);
  }
  println(frameRate);
}
