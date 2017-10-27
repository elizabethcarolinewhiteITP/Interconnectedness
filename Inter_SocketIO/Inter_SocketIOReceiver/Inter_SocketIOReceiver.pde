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

PImage img;

int minDepth = 50;
int maxDepth = 2705;

// Store incoming pc image
PImage pc;
ReceiverThread thread;

Movie myMovie;

void setup() {
  size(1920, 1080, P2D);
  //size(11520, 1080, P2D);
  pc = createImage(524, 412, RGB);
  thread = new ReceiverThread(pc.width, pc.height);
  thread.start();
  
   img = loadImage("5.jpg");
   //myMovie = new Movie(this, "horse.mp4");
   //myMovie.play();
}

void draw() {
  if (thread.available()) {
    pc = thread.getImage();
  }
  
  background(0);

  // Draw it as a point cloud
  pc.loadPixels();

  // Turn image into points
  for (int i = 0; i < pc.pixels.length; i++) {
    //int x = i%pc.width;
    //int y = i/pc.width;
    // Map the grayscale value back into a z-value
    //int z = int(round(map(brightness(pc.pixels[i]), 0, 255, minDepth, maxDepth)));

    //color c = myMovie.pixels[i];
    color c = img.pixels[i];
    //color c = color (255);
    // Assign a random color
    if (brightness(pc.pixels[i]) > 0) {
      pc.pixels[i] = color(c);
      //pc.pixels[i] = color(random(255), random(255), random(255));
      
    }
  }
  pc.updatePixels();

  // Draw the updated image
  image(img, 0,0, 1920, 1080);

  image(pc, 0, 0, 1920, 1080);
  //image(pc, 1080,0,2160,720);
}

//void movieEvent(Movie m) {
//  m.read();
//}