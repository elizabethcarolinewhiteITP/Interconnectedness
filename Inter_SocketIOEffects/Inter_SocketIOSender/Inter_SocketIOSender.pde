import processing.video.*; //<>//

// Daniel Shiffman
// Thomas Sanchez Lengeling
//// Kinect Point Cloud example

/// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.processing.*;
import javax.imageio.*;
import java.awt.image.*; 
import java.net.*;
import java.io.*;////////////////////////////////

// This is the port we are sending to
int clientPort = 9100; 
// This is our object that sends UDP out
DatagramSocket ds; 

// Kinect Library object
Kinect2 kinect2;

// Angle for rotation
float a = 3.1;

int minDepth = 50;
int maxDepth = 1505;
float turn;

int frames = 45;

int[][] depth_history = new int[frames][];

void setup() {
  size(524, 412, P3D);

  // Initialize Kinect stuff
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();

  // Initialize Datagram stuff
  // Setting up the DatagramSocket, requires try/catch
  try {
    ds = new DatagramSocket();
  } 
  catch (SocketException e) {
    e.printStackTrace();
  }

  //smooth(16);
  frameRate(30);
}


void draw() {
  background(0);

turn = turn+0.005;
  // Translate and rotate
  pushMatrix();
  translate(0, height/2+height/4);
  rotateY(3.1);
  //rotateY(turn);


  // We're just going to calculate and draw every 2nd pixel
  int skip = 5;

  // Get the raw depth as array of integers
  int[] depth = kinect2.getRawDepth();

if(frameCount<=45) {
    depth_history[frameCount-1] = depth;
  }
  
  //strokeWeight(2);
  beginShape(POINTS);

if(frameCount>frames) {
    depth_history = shiftArray(depth_history, depth);

  for (int x = 0; x < kinect2.depthWidth; x+=skip) {
    for (int y = 0; y < kinect2.depthHeight; y+=skip) {
      int offset = x + y * kinect2.depthWidth;

      //calculte the x, y, z camera position based on the depth information
        PVector point = depthToPointCloudPos(x, y, depth_history[0][offset]);
        PVector point1 = depthToPointCloudPos(x, y, depth_history[14][offset]);
        PVector point2 = depthToPointCloudPos(x, y, depth_history[29][offset]);
        PVector point3 = depthToPointCloudPos(x, y, depth_history[44][offset]);

      if (depth_history[0][offset] >= minDepth && depth_history[0][offset] <= maxDepth) {

        // Map the depth to grayscale values of 0-255;
        int str = int(round(map(point.z, minDepth, maxDepth, 1, 255))); 
        stroke(str);
        strokeWeight(3);
        //strokeWeight(str/70);
        // Draw a point
          //stroke(255,255,255,255);
          vertex(point.x, point.y - 100- kinect2.depthHeight, point.z);
          //stroke(255,255,255,255);
           stroke(str);
          vertex(point1.x, point1.y - 100- kinect2.depthHeight, point1.z);
          //stroke(255,255,255,255);
           stroke(str);
          vertex(point2.x, point2.y - 100- kinect2.depthHeight, point2.z);
          //stroke(255,255,255,255);
           stroke(str);
          vertex(point3.x, point3.y - 100- kinect2.depthHeight, point3.z);
            stroke(str);
      }
    }
  }
}
  endShape();

  popMatrix();

  broadcast();
}


//calculte the xyz camera position based on the depth data
  PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);// / (1.0f); // Convert from mm to meters
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}

int[][] shiftArray(int[][] inputArray, int[] depth) {
  int[][] outputArray = inputArray;
  for(int i = 0;i<frames-1;i++) {
    outputArray[i] = inputArray[i+1];
  }
  outputArray[frames-1] = depth;
  return outputArray;
}

// Function to broadcast a PImage over UDP
// Special thanks to: http://ubaa.net/shared/processing/udp/
// (This example doesn't use the library, but you can!)
void broadcast() {

  // Sending a grayscale image
  BufferedImage bimg = new BufferedImage( width, height, BufferedImage.TYPE_BYTE_GRAY );

  // Transfer pixels from localFrame to the BufferedImage
  loadPixels();
  bimg.setRGB( 0, 0, width, height, pixels, 0, width);

  // Need these output streams to get image as bytes for UDP communication
  ByteArrayOutputStream baStream  = new ByteArrayOutputStream();
  BufferedOutputStream bos    = new BufferedOutputStream(baStream);

  // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
  // Requires try/catch
  try {
    ImageIO.write(bimg, "png", bos);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }

  // Get the byte array, which we will send out via UDP!
  byte[] packet = baStream.toByteArray();

  // Send JPEG data as a datagram
  println("Sending datagram with " + packet.length + " bytes");
  try {
    ds.send(new DatagramPacket(packet, packet.length, InetAddress.getByName("localhost"), clientPort));
    //ds.send(new DatagramPacket(packet, packet.length, InetAddress.getByName("128.122.151.60"), clientPort));
    //ds.send(new DatagramPacket(packet, packet.length, InetAddress.getByName("192.168.130.174"), clientPort));
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}