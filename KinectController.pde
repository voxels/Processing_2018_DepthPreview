import org.openkinect.freenect.*;
import org.openkinect.processing.*;

int DEBUG_X = 0;
int DEBUG_Y = 0;

void setupKinect() {
  Kinect device = new Kinect(this);
  deviceController = new KinectController(device);  
}

class KinectController {
  Kinect kinect;
  float angle;
  
  PImage depthImg;

  int kMaxBrightness = 255;
  int minBrightness = 0;
  
  int minDepth =  60;
  int maxDepth = 860;

  int currentThresholdMaxDepth = 2047;
  int currentThresholdMinDepth = 0;
  
  // We'll use a lookup table so that we don't have to repeat the math over and over
  float[] depthLookUp = new float[2048];

  public KinectController(Kinect device) {
    kinect = device;
    kinect.initDepth();
    angle = kinect.getTilt();
    depthImg = new PImage(kinect.width, kinect.height);
    buildLookupTable();
  }
  
  void buildLookupTable() {
    // Lookup table for all possible depth values (0 - 2047)
    for (int i = 0; i < depthLookUp.length; i++) {
      depthLookUp[i] = rawDepthToMeters(i);
    }
  }  
  
  int brightnessForDepth(int depth, int thresholdMin, int thresholdMax, int brightnessFloor) {    
    return abs(floor(map(depth, thresholdMin, thresholdMax, brightnessFloor, kMaxBrightness)));
  }
  
  int thresholdMax(int[] rawDepth) {
    return max(rawDepth);
  }
  
  int thresholdMin(int[] rawDepth) {
    return min(rawDepth);
  }
  
  void drawDepth(PVector origin, PVector size) {
    // Draw the raw image
    image(kinect.getDepthImage(), 0, 0);
  
    // Threshold the depth image
    int[] rawDepth = kinect.getRawDepth();
    for (int i=0; i < rawDepth.length; i++) {
      if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
        depthImg.pixels[i] = color(255);
      } else {
        depthImg.pixels[i] = color(0);
      }
    }
  
    // Draw the thresholded image
    depthImg.updatePixels();
    image(depthImg, kinect.width, 0);
  
    fill(0);
    text("TILT: " + angle, 10, 20);
    text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
  }
  
  // These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
  float rawDepthToMeters(int depthValue) {
    if (depthValue < 2047) {
      return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
    }
    return 0.0f;
  }
  
  PVector depthToWorld(int x, int y, int depthValue) {
  
    final double fx_d = 1.0 / 5.9421434211923247e+02;
    final double fy_d = 1.0 / 5.9104053696870778e+02;
    final double cx_d = 3.3930780975300314e+02;
    final double cy_d = 2.4273913761751615e+02;
  
    PVector result = new PVector();
    double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
    result.x = (float)((x - cx_d) * depth * fx_d);
    result.y = (float)((y - cy_d) * depth * fy_d);
    result.z = (float)(depth);
    return result;
  }
}
