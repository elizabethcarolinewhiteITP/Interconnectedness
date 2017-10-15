import processing.video.*;

/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress host;
int x, y, z;

//Movie myMovie;
PImage img;
PGraphics IAC;
ArrayList<PVector> pos = new ArrayList<PVector>();

void setup() {
  //size(11520,1080);
  //fullScreen(P3D, SPAN);
  //size(1920, 1080, P3D);
  size(1920,1080, P3D);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12001 */
  OscProperties op = new OscProperties();
  op.setListeningPort(12001);
  op.setDatagramSize(64000);
  oscP5 = new OscP5(this, op);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  host = new NetAddress("localhost", 12000);

  IAC = createGraphics(960, 720, P3D);
  
  //myMovie = new Movie(this, "LightMetaphors.mp4");
  //myMovie.loop();
  
  img = loadImage("cowportrait.jpg");
}


void draw() {

  IAC.beginDraw();
  IAC.pushMatrix();
  IAC.translate(width/2, height/2, 50);
  IAC.rotateY(3.1);
  IAC.background(0);
  IAC.stroke(255);
  IAC.strokeWeight(2);
  IAC.beginShape(POINTS);
  for (int i = 0; i < pos.size(); i++) {
    try {
      PVector p = pos.get(i);
      //IAC.vertex(p.x, p.y, p.z);
      
      IAC.pushMatrix();
      //color c = movie.pixels[offset];
      //IAC.color c = img.pixels[p];
      IAC.fill(255, 0, 0);
      IAC.translate(p.x, p.y, p.z);
      //rotateY(frameCount*0.1);
      IAC.strokeWeight(2);
      IAC.stroke(255);
      IAC.rect(0,0,5,5);
      IAC.popMatrix();
    }
    catch(Exception e) {
     e.printStackTrace(); 
    }
  }
  IAC.endShape();
  IAC.popMatrix();
  IAC.endDraw();
  
  image(IAC, 0,0,480, 360);
  image(IAC, 480, 0, 960, 360);
  image(IAC, 0, 360, 480, 720);
  image(IAC, 480, 360, 960, 720);
  //IAC.image(myMovie, 0,0);
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+ theOscMessage.addrPattern());
  //print(" typetag: "+ theOscMessage.typetag());
  //println(" value: "+ theOscMessage.get(0).intValue());
  int len = theOscMessage.get(0).intValue();
  pos.clear();
  println(len);

  for (int i = 1; i < (len*3)+1; i+=3) {
    int x = theOscMessage.get(i).intValue();
    int y = theOscMessage.get(i+1).intValue();
    int z = theOscMessage.get(i+2).intValue();
    //println(x + "\t" + y + "\t" + z);
    //PVector p = depthToPointCloudPos(x, y, z);
    pos.add(new PVector(x, y, z));
    if (random(1) < 0.25) {
      println(int(x) + "\t" + int(y) + "\t" + int(z));
      //println(int(p.x) + "\t" + int(p.y) + "\t" + int(p.z));
    }
  }
}

PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);// / (1.0f); // Convert from mm to meters
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}