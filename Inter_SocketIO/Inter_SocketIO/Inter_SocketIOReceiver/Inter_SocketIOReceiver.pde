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

PImage img, img2;

int minDepth = 50;
int maxDepth = 2705;

PImage changeIMG;

// Store incoming pc image
PImage pc, newpc;
ReceiverThread thread;

Movie myMovie;

void setup() {
  size(1048, 824, P2D);
  //size(11520, 1080, P2D);
  pc = createImage(524, 412, RGB);
  newpc = createImage(pc.width*2, pc.height*2, RGB);
  thread = new ReceiverThread(pc.width, pc.height);
  thread.start();
  img = loadImage("5.jpg");
  img2 = loadImage("cowportrait.jpg");
  //myMovie = new Movie(this, "horse.mp4");
  //myMovie.play();
}

void draw() {
  if (thread.available()) {
    pc = thread.getImage();
  }

  //image switching stuff//
  changeIMG = img2;
  if (keyPressed) {
    if (key == '1') {

      changeIMG = img;
    }
    if (key == '2') {
      changeIMG = img2;
    }
  }
  background(0);

  // Draw it as a point cloud
  pc.loadPixels();
  newpc.loadPixels();

  //// Turn image into points
  for (int i = 0; i < pc.pixels.length; i++) {
    int x = i%pc.width;
    int y = i/pc.width;
    int newi = newpc.width*(y*2) + (x*2);
  //  // Map the grayscale value back into a z-value
  //  //int z = int(round(map(brightness(pc.pixels[i]), 0, 255, minDepth, maxDepth)));


  //  color c = pc.pixels[i];
  //  //color c = changeIMG.pixels[i];
  //  //color c = color (255);
    
    
  //  // Assign a random color
  //  if (brightness(pc.pixels[i]) > 0) {
      newpc.pixels[newi] = pc.pixels[i];
  //    //pc.pixels[i] = color(random(255), random(255), random(255));
  //  }

  }


  newpc.updatePixels();
  
  //
  
  // Draw the updated image
  //image(changeIMG, 0, 0);
  image(newpc, 0,0);

  //image(changeIMG, 0, 0, 1920, 1080);

  //image(pc, 0, 0, 1920, 1080);
  //image(pc, 1080,0,2160,720);
}

//void movieEvent(Movie m) {
//  m.read();
//}