class RGBD {
  int width;
  int height;
  int[] rawDepth;
  int[] rawImage;
  
  public PImage videoImage() {
    PImage image = createImage(width, height, RGB);
    image.pixels = rawImage;
    image.updatePixels();
    return image;
  };
  
  public PImage depthImage() {
    return videoImage();
  }
}
