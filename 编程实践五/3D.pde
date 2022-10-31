import controlP5.*;
import peasy.*;
import nervoussystem.obj.*;

int sectionSideNum = 5;
int sideDivision = 40;
int cylinderHeightSection = 200;
float cylinderSectionHeight = 10;

float sectionRadiusPhase = TWO_PI;
float twistPhase = PI*2/3;
float twistPhaseStart = TWO_PI;

float[] sectionR = new float[cylinderHeightSection+1];
float[] sectionTwistPhase = new float[cylinderHeightSection+1];

PeasyCam cam;
ControlP5 bar;

boolean displayMesh = false;
boolean record;

void setup() {
  size(1280, 1280, P3D);
  cam = new PeasyCam(this, 2000);
  initiateValues();
  UI();
}

void initiateValues() {
  for (int  i =0; i < cylinderHeightSection+1; i ++) {
    sectionR[i] = 100 + 50 * sin((sectionRadiusPhase/cylinderHeightSection) * i);
    sectionTwistPhase[i] = twistPhase * cos((twistPhaseStart*2/cylinderHeightSection) * i);
  }
}

void draw() {
  background(51);
  noStroke();

  if (displayMesh) {
    stroke(0);
  }

  fill(202);
  noStroke();

  lightSettings(); 

  if (record) {
    beginRecord("nervoussystem.obj.OBJExport", "designWork/curvatureVase-####.obj");
  }

  initiateValues();
  drawCylinder();

  if (record) {
    endRecord();
    record = false;
  }

  UIShow();
}

void drawCylinder() {
  float theta = TWO_PI / sectionSideNum;

  //beginShape(TRIANGLES);
  //for (int j = 0; j < cylinderHeightSection; j ++) {
  //    for (int i = 0; i < sectionSideNum; i ++) {
  //        vertex(sectionR[j] * cos(theta * i + sectionTwistPhase[j]), sectionR[j] * sin(theta * i + sectionTwistPhase[j]), cylinderSectionHeight * j);
  //        vertex(sectionR[j+1] * cos(theta * ((i+1)%sectionSideNum) + sectionTwistPhase[j+1]), sectionR[j+1] * sin(theta * ((i+1)%sectionSideNum) + sectionTwistPhase[j+1]), cylinderSectionHeight * (j+1));
  //        vertex(sectionR[j] * cos(theta * ((i+1)%sectionSideNum) + sectionTwistPhase[j]), sectionR[j] * sin(theta * ((i+1)%sectionSideNum) + sectionTwistPhase[j]), cylinderSectionHeight * j);
  //        vertex(sectionR[j] * cos(theta * i + sectionTwistPhase[j]), sectionR[j] * sin(theta * i + sectionTwistPhase[j]), cylinderSectionHeight * j);
  //        vertex(sectionR[j+1] * cos(theta * i + sectionTwistPhase[j+1]), sectionR[j+1] * sin(theta * i + sectionTwistPhase[j+1]), cylinderSectionHeight * (j+1));
  //        vertex(sectionR[j+1] * cos(theta * ((i+1)%sectionSideNum) + sectionTwistPhase[j+1]), sectionR[j+1] * sin(theta * ((i+1)%sectionSideNum) + sectionTwistPhase[j+1]), cylinderSectionHeight * (j+1));
  //    }
  //}
  //endShape();

  beginShape(TRIANGLES);
  for (int j = 0; j < cylinderHeightSection; j ++) {
    for (int i = 0; i < sectionSideNum; i ++) {
      float x11 = sectionR[j] * cos(theta * i + sectionTwistPhase[j]);
      float y11 = sectionR[j] * sin(theta * i + sectionTwistPhase[j]);
      float x12 = sectionR[j] * cos(theta * ((i+1)%sectionSideNum) + sectionTwistPhase[j]);
      float y12 = sectionR[j] * sin(theta * ((i+1)%sectionSideNum) + sectionTwistPhase[j]);

      float x21 = sectionR[j+1] * cos(theta * i + sectionTwistPhase[j+1]);
      float y21 = sectionR[j+1] * sin(theta * i + sectionTwistPhase[j+1]);
      float x22 = sectionR[j+1] * cos(theta * ((i+1)%sectionSideNum) + sectionTwistPhase[j+1]);
      float y22 = sectionR[j+1] * sin(theta * ((i+1)%sectionSideNum) + sectionTwistPhase[j+1]);


      float deltaX12 = (x12 - x11) / sideDivision;
      float deltay12 = (y12 - y11) / sideDivision;
      float deltaX22 = (x22 - x21) / sideDivision;
      float deltay22 = (y22 - y21) / sideDivision;

      //beginShape(TRIANGLES);
      for (int k = 0; k < sideDivision; k ++) {
        vertex(x11 + deltaX12 * k, y11 + deltay12 * k, cylinderSectionHeight * j);
        vertex(x21 + deltaX22 * (k+1), y21 + deltay22 * (k+1), cylinderSectionHeight * (j+1));
        vertex(x11 + deltaX12 * (k+1), y11 + deltay12 * (k+1), cylinderSectionHeight * j);

        vertex(x11 + deltaX12 * k, y11 + deltay12 * k, cylinderSectionHeight * j);
        vertex(x21 + deltaX22 * k, y21 + deltay22 * k, cylinderSectionHeight * (j+1));
        vertex(x21 + deltaX22 * (k+1), y21 + deltay22 * (k+1), cylinderSectionHeight * (j+1));
      }
      //endShape();
    }
  }
  endShape();
}

void keyPressed() {
  if (key == 's') {
    record = true;
  }
}

int canvasLeftCornerX = 30;
int canvasLeftCornerY = 60;

void UI() {
  bar = new ControlP5(this, createFont("微软雅黑", 14));

  int barSize = 200;
  int barHeight = 20;
  int barInterval = barHeight + 10;

  bar.addSlider("sectionSideNum", 3, 16, 5, canvasLeftCornerX, canvasLeftCornerY, barSize, barHeight).setLabel("断面边数");
  bar.addSlider("sideDivision", 1, 100, 40, canvasLeftCornerX, canvasLeftCornerY+barInterval, barSize, barHeight).setLabel("断面边细分段数");
  //bar.addSlider("cylinderHeightSection", 3, 500, 200, canvasLeftCornerX, canvasLeftCornerY+barInterval*2, barSize, barHeight).setLabel("柱体高度分段数");
  bar.addSlider("cylinderSectionHeight", 0, 100, 10, canvasLeftCornerX, canvasLeftCornerY+barInterval*3, barSize, barHeight).setLabel("柱体分段高度");
  bar.addSlider("sectionRadiusPhase", 0, PI*8, TWO_PI, canvasLeftCornerX, canvasLeftCornerY+barInterval*4, barSize, barHeight).setLabel("柱体半径相变");
  bar.addSlider("twistPhase", -TWO_PI, TWO_PI, PI*2/3, canvasLeftCornerX, canvasLeftCornerY+barInterval*5, barSize, barHeight).setLabel("柱体扭曲相变");
  bar.addSlider("twistPhaseStart", -TWO_PI, TWO_PI, TWO_PI, canvasLeftCornerX, canvasLeftCornerY+barInterval*6, barSize, barHeight).setLabel("柱体扭曲相变起始值");

  bar.setAutoDraw(false);
}

void lightSettings() {
  lightSpecular(255, 255, 255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  specular(200, 200, 200);
  shininess(15);
}

void UIShow() {
  cam.beginHUD();  
  lights();
  bar.draw();
  cam.endHUD();

  if (mouseX<400 && mouseY< height) {
    cam.setActive(false);
  } else {
    cam.setActive(true);
  }
}
