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
  
  boolean ir = false;
  boolean colorDepth = true;
  boolean mirror = false;
  
  Slicer slicer;
  RGBD depthData;
  PImage videoImage;
  PImage depthImage;
  int[] rawDepth;

  int kMaxBrightness = 255;
  int minBrightness = 0;
  
  int minDepth =  60;
  int maxDepth = 860;

  int currentThresholdMaxDepth = 2047;
  int currentThresholdMinDepth = 0;
  
  // We'll use a lookup table so that we don't have to repeat the math over and over
  float[] depthLookUp = new float[2048];

  public KinectController(Kinect device) {
    slicer = new Slicer();
    kinect = device;
    kinect.initDepth();
    kinect.initVideo();
    kinect.enableIR(ir);
    kinect.enableColorDepth(colorDepth);
    angle = kinect.getTilt();
    depthImage = new PImage(kinect.width, kinect.height);
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
  
  RGBD updateFrame() {
    return new RGBD(kinect, kinect.width, kinect.height);
  }
  
  void drawDepth(PVector sliceOrigin, PVector sliceSize) {
    depthData = updateFrame();
    RGBD slicedData = slicer.slice(depthData,sliceOrigin,sliceSize);
    drawBackground();
    drawSlice(slicedData);
  }
  
  void drawBackground() {
    image(depthData.depthImage(), 0, 0);
    image(depthData.videoImage(), kinect.width, 0);    
  }
  
  void drawSlice(RGBD slice) {
    
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
