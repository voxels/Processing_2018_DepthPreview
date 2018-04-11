class Slicer {  
  public RGBD slice(RGBD plane, PVector origin, PVector size) {    
    int[] slicedDepth = slice(plane.rawDepth, plane._width, plane._height, origin, size);
    int[] slicedImage = slice(plane.rawImage, plane._width, plane._height, origin, size);    
    return new RGBD(slicedDepth, slicedImage, size);
  }
  
  int[] slice(int[] data, int sourceWidth, int sourceHeight, PVector origin, PVector size) {
    PImage image = createImage(sourceWidth, sourceHeight, RGB);
    image.pixels = data;
    image.updatePixels();
    PImage cropped = image.get(floor(origin.x),floor(origin.y),floor(size.x),floor(size.y));
    return cropped.pixels;
  }
}
