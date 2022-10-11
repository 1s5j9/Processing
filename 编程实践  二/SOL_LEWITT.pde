# SOL_LEWITT 结构设计的代码
import com.hamoid.*;

VideoExport videoExport;

float sqXPos;
float sqYPos;
float bgWidth = 1200;
float bgHeight = 1200;
float sqSize = 0;
int sq;
float i0;

color[] colors = {#ffffff, #085f82, #4b8ec5, #6baf1a, #2b643a};

void square() {
  for (int sqXPos =0; sqXPos<bgWidth; sqXPos += sqSize) {
    sqSize = random(100, bgWidth/4);
    for (int sqYPos =0; sqYPos<bgHeight; sqYPos += sqSize) {
      i0 = random(20, 301);
      stroke(0);
      strokeWeight(random(4, 7));
      color sqColor = colors[int(random(colors.length))];
      fill(sqColor);
      square(sqXPos, sqYPos, sqSize);
      if ((i0<50)||(150<i0 && i0<200)||(i0>280) ) {
        for (int i=0; i<sqSize; i+= i0) {
          line(sqXPos, i+sqYPos, sqXPos+sqSize-i, sqYPos+sqSize);
          line(sqXPos+sqSize, sqYPos+sqSize-i, sqXPos+i, sqYPos);
        }
      } else if ((i0>=50 && i0<=100)||(i0>200 && i0<280)) {
        for (int i=0; i<sqSize; i+= i0) {
          line(sqXPos, sqYPos+sqSize-i, sqXPos+sqSize-i, sqYPos);
          line(sqXPos+i, sqYPos+sqSize, sqXPos+sqSize, sqYPos+i);
        }
      } 
      else {
        beginShape();
        noFill();
        strokeWeight(5);
        for (int j=0; j<=2*sqrt(2.0)*sqSize; j+= 30) {
          arc(sqXPos, sqYPos, j, j, 0, HALF_PI);
        }
        endShape();
      }
    }
  }
}

void setup() {
  size(1200, 1200);
  background(100);
  videoExport = new VideoExport(this, "myVideo.mp4");
  videoExport.setFrameRate(30);  
  videoExport.startMovie();
}


void draw() {
  if (keyPressed);
  videoExport.saveFrame();
}

void keyPressed() {
  if (key == 'd') {
    square();
  }
  if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}
