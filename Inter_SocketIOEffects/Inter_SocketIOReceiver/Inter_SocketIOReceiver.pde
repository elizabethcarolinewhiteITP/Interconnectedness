import processing.video.*;

// Daniel Shiffman
// <http://www.shiffman.net>

// A Thread using receiving UDP

// Daniel Shiffman
// <http://www.shiffman.net>

// A Thread using receiving UDP to receive images

import java.awt.image.*; 
import javax.imageio.*;
import java.net.*;
import java.io.*;

PImage img, img2, imgSprite;

int minDepth = 50;
int maxDepth = 2705;

PImage changeIMG;
PGraphics newGraphic;

// Store incoming pc image
PImage pc, newpc;
ReceiverThread thread;

Movie myMovie;
int scl = 4;

void setup() {
  //size(1048, 824, P2D);
  size(11520, 1080, P2D);
  pc = createImage(524, 412, RGB);
  newpc = createImage(pc.width*4, pc.height*4, RGB);
  thread = new ReceiverThread(pc.width, pc.height);
  thread.start();
  //img = loadImage("5.jpg");
  //img2 = loadImage("cowportrait.jpg");
  img = loadImage("imgSprite.png");
  newGraphic = createGraphics(pc.width*scl, pc.height*scl);
  //myMovie = new Movie(this, "horse.mp4");
  //myMovie.play();
}

void draw() {
  if (thread.available()) {
    pc = thread.getImage();
  }

  //image switching stuff//
  //changeIMG = img2;
  //if (keyPressed) {
  //  if (key == '1') {

  //    changeIMG = img;
  //  }
  //  if (key == '2') {
  //    changeIMG = img2;
  //  }
  //}
  background(0);

  // Draw it as a point cloud
  pc.loadPixels();
  //newpc.loadPixels();
  newGraphic.beginDraw();
  newGraphic.noStroke();
  newGraphic.background(0);
  //// Turn image into points
  for (int i = 0; i < pc.pixels.length; i++) {
    int x = i%pc.width;
    int y = i/pc.width;
    int newi = newpc.width*(y*scl) + (x*scl);

    //  // Map the grayscale value back into a z-value
    //  //int z = int(round(map(brightness(pc.pixels[i]), 0, 255, minDepth, maxDepth)));

    //  color c = pc.pixels[i];
    //  //color c = changeIMG.pixels[i];
    //  //color c = color (255);

    //  // Assign a random color
    //  if (brightness(pc.pixels[i]) > 0) {




    //////QUESTIONS//////
    //newpc.pixels[newi] = pc.pixels[i];
    //newGraphic.pixels[newi] = pc.pixels[i];
    //newGraphic.pixels[newi] = pc.pixels[i];
    //newGraphic.image(imgSprite, x*2, y*2, 20, 20);
    newGraphic.fill(pc.pixels[i]);
    //newGraphic.image(img, x*scl, y*scl);
    newGraphic.stroke(pc.pixels[i]);
    //newGraphic.point(x*scl, y*scl);
    newGraphic.rect(x*scl, y*scl, 1, 1);
    //pc.pixels[i] = color(random(255), random(255), random(255));
    //  }
    //////QUESTIONS//////
  }

  //newGraphic.updatePixels();
  //newpc.updatePixels();

  //

  // Draw the updated image
  //image(changeIMG, 0, 0);
  //image(newpc, width/2,0);
  //  image(newpc, 0,0);
  //    image(newpc, width-2000,0);
  newGraphic.endDraw();
  image(newGraphic, 0, 0, width/4, height*2);
  //image(newGraphic, width/4, 0);
  //image(newGraphic, width/2, 0);
  //image(newGraphic, width-width/4, 0);
  //image(changeIMG, 0, 0, 1920, 1080);

  //image(pc, 0, 0, 1920, 1080);
  //image(pc, 1080,0,2160,720);
}

//void movieEvent(Movie m) {
//  m.read();
//}