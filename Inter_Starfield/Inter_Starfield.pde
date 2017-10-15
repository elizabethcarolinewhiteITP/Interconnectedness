PShape particles;
PImage sprite;  

int npartTotal = 2500;
float partSize = 20;

int fcount, lastm;
float frate;
int fint = 3; 

int yDecrease = 1000;
  int one = 1;

void setup() {
  //size(800, 600, P3D);
  //fullScreen(P3D);
  //size(7680, 720, P3D);
  size(11520, 1080, P3D);
  frameRate(24);

  particles = createShape(PShape.GROUP);
  sprite = loadImage("sprite.png");
  

  
  yDecrease = yDecrease - one*5;
  if (yDecrease<500){
  one = 0;
  }

  for (int n = 0; n < npartTotal; n++) {
    float cx = random(-displayWidth-1000, +displayWidth+1000);
    float cy = random(-displayHeight+yDecrease, +displayHeight-yDecrease); 
    float cz = random(-10500, +0);
    
    PShape part = createShape();
    part.beginShape(QUAD);
    part.noStroke();
    part.tint(255);
    part.texture(sprite);
    part.normal(0, 0, 1);
    part.vertex(cx - partSize/2, cy - partSize/2, cz, 0, 0);
    part.vertex(cx + partSize/2, cy - partSize/2, cz, sprite.width, 0);
    part.vertex(cx + partSize/2, cy + partSize/2, cz, sprite.width, sprite.height);
    part.vertex(cx - partSize/2, cy + partSize/2, cz, 0, sprite.height);    
    part.endShape();    
    particles.addChild(part);
  }

  // Writing to the depth buffer is disabled to avoid rendering
  // artifacts due to the fact that the particles are semi-transparent
  // but not z-sorted.
  hint(DISABLE_DEPTH_MASK);
} 

void draw () {
  background(0);

  translate(width/2, height/2, frameCount*4-1000);
  //rotateY(frameCount * 0.01);

  shape(particles);
  
  fcount += 1;
  int m = millis();
  if (m - lastm > 1000 * fint) {
    frate = float(fcount) / fint;
    fcount = 0;
    lastm = m;
    //println("fps: " + frate); 
  }  
  
  saveFrame("content/######.png");
}