import processing.video.*; //<>//

// Daniel Shiffman
// Thomas Sanchez Lengeling
// Kinect Point Cloud example

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.processing.*;
import java.nio.FloatBuffer;


// Kinect Library object
Kinect2 kinect2;

// Angle for rotation
float a = 3.1;

PImage img;
Movie movie;

int minDepth = 50;
int maxDepth = 2705;

//change render mode between openGL and CPU
int renderMode = 1;

//for openGL render
PGL pgl;
PShader sh;
int  vertLoc;

float scaleVal = 260;
float increase = 0;


void setup() {

  // Rendering in P3D
  //size(800, 600, P3D);
  //fullScreen(P3D);
  size(1920, 1080, P3D);
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();

  //movie = new Movie(this, "2.mov");

  //load shaders
  sh = loadShader("frag.glsl", "vert.glsl");

  smooth(16);

  frameRate(24);
}


void draw() {
  background(0);
  increase = increase + 5;
  // Translate and rotate
  pushMatrix();
  translate(width/2, height/2, 50 + increase);
  //scale(scaleVal, 0, scaleVal+increase);
  rotateY(a);
  strokeWeight(2);

  // We're just going to calculate and draw every 2nd pixel
  int skip = 1;

  // Get the raw depth as array of integers
  int[] depth = kinect2.getRawDepth();

  stroke(255);
  beginShape(POINTS);

  for (int x = 0; x < kinect2.depthWidth; x+=skip) {
    for (int y = 0; y < kinect2.depthHeight; y+=skip) {
      int offset = x + y * kinect2.depthWidth;

      //calculte the x, y, z camera position based on the depth information
      PVector point = depthToPointCloudPos(x, y, depth[offset]);

      if (depth[offset] >= minDepth && depth[offset] <= maxDepth) {

        // Draw a point
        vertex(point.x*1.7, point.y*1.7-290, point.z);

        //pushMatrix();
        ////color c = movie.pixels[offset];
        //color c = img.pixels[offset];
        //fill(c);
        //translate(point.x, point.y, point.z);
        ////rotateY(frameCount*0.1);
        //strokeWeight(0.1);
        //stroke(255);
        //ellipse(0,0,random(30),random(30));
        //popMatrix();
      }
    }
  }
  endShape();

  popMatrix();

  //saveFrame("content/E4####.png");
  // Rotate
  //a += 0.0015f;
}


//calculte the xyz camera position based on the depth data
PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);// / (1.0f); // Convert from mm to meters
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}