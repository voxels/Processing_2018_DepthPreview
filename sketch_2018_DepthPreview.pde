
// Mostly lifted from Dan Shiffman's examples.  Thanks Dan!!
// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

KinectController deviceController;

int sliceOriginX = 200;
int sliceOriginY = 250;
int sliceWidth = 100;
int sliceHeight = 100;

boolean DEBUG = true;

void setup() {
  size(1280, 480);
  setupKinect();
}

void draw() {
  background(0);
  PVector targetOrigin = currentTargetOrigin();
  PVector targetSize = currentTargetSize();
  
  if( frameCount > 100 ) {    
    deviceController.drawDepth(targetOrigin, targetSize);        
    drawSliceTarget(targetOrigin, targetSize);
  }
}

void drawSliceTarget(PVector origin, PVector size) {
  pushMatrix();
  translate(deviceController.kinect.width + origin.x, origin.y);
  stroke(255,0,0);
  strokeWeight(deviceController.previewStrokeWeight / 2.0);  
  noFill();
  rect( -1 * deviceController.previewStrokeWeight / 2.0, -1 * deviceController.previewStrokeWeight / 2.0, 
  size.x + deviceController.previewStrokeWeight / 2.0, deviceController.previewStrokeWeight / 2.0 + size.y);
  noStroke();
  popMatrix();
}

PVector currentTargetOrigin() {
  return new PVector(sliceOriginX, sliceOriginY);
}

PVector currentTargetSize() {
  return new PVector(sliceWidth, sliceHeight);
}

// Adjust the angle and the depth threshold min and max
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      deviceController.angle++;
    } else if (keyCode == DOWN) {
      deviceController.angle--;
    }
    deviceController.angle = constrain(deviceController.angle, 0, 30);
    deviceController.kinect.setTilt(deviceController.angle);
  } else if (key == 'a') {
    deviceController.minDepth = constrain(deviceController.minDepth+10, 0, deviceController.maxDepth);
  } else if (key == 's') {
    deviceController.minDepth = constrain(deviceController.minDepth-10, 0, deviceController.maxDepth);
  } else if (key == 'z') {
    deviceController.maxDepth = constrain(deviceController.maxDepth+10, deviceController.minDepth, 2047);
  } else if (key =='x') {
    deviceController.maxDepth = constrain(deviceController.maxDepth-10, deviceController.minDepth, 2047);
  }
  
  if( DEBUG ) {
    println("TILT: " + deviceController.angle, 10, 20);
    println("THRESHOLD: [" + deviceController.minDepth + ", " + deviceController.maxDepth + "]", 10, 36);    
  }
}
