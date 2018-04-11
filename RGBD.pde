class RGBD {
  private int _width;
  private int _height;
  private PImage _depthImage;
  
  int[] rawDepth;
  int[] rawImage;
  
  public RGBD(Kinect kinect, int w, int h) {
    _width = w;
    _height = h;
    rawDepth = kinect.getRawDepth();    
    rawImage = kinect.getVideoImage().pixels;
    _depthImage = kinect.getDepthImage();
  }
  
  public PImage videoImage() {
    PImage image = createImage(_width, _height, RGB);
    image.pixels = rawImage;
    image.updatePixels();
    return image;
  };
  
  public PImage depthImage() {
    return _depthImage;
  }
}
