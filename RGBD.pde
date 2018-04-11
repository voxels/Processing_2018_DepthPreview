class RGBD {
  int _width;
  int _height;
  private PImage _depthImage;
  
  int[] rawDepth;
  int[] rawImage;
  
  public RGBD(int[] depth, int[] image, PVector size) {
    rawDepth = depth;
    rawImage = image;
    _width = floor(size.x);
    _height = floor(size.y);
    _depthImage = null;
  }
  
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
    if( _depthImage != null ) {
      return _depthImage;      
    } else {
      return new PImage(); 
    }
  }
}
