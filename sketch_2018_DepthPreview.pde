
// Mostly lifted from Dan Shiffman's examples.  Thanks Dan!!
// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

KinectController deviceController;

void setup() {
  size(1280, 480);
  setupKinect();
}

void draw() {
  if( frameCount > 100 ) {
    deviceController.drawDepth(new PVector(), new PVector());        
  }
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
}
