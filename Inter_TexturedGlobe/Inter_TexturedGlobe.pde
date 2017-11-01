import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.geom.mesh.*;
import toxi.processing.*;



float EARTH_RADIUS=300;
Vec2D HOME=new Vec2D(0,51);

TriangleMesh globe;
PImage earthTex;
float texUOffset=180;

ToxiclibsSupport gfx;

PImage sprite;  

int npartTotal = 50000;
float partSize = 20;

PVector positions[];

int fcount, lastm;
float frate;
int fint = 3;

void setup() {
  //size(displayWidth, displayHeight, P3D);
  size(11520, 1080, P3D);
    noCursor();
    
    sprite = loadImage("sprite.png");
  gfx = new ToxiclibsSupport(this);
  earthTex = loadImage("earth1.jpg");
  globe = (TriangleMesh)new SurfaceMeshBuilder(new SphereFunction()).createMesh(null, 36, EARTH_RADIUS);
  globe.computeVertexNormals();
  smooth(20);
  
    

  initPositions();

  // Writing to the depth buffer is disabled to avoid rendering
  // artifacts due to the fact that the particles are semi-transparent
  // but not z-sorted.
  //hint(DISABLE_DEPTH_MASK);
}

void draw() {
  background(0);

  //lights();
  
  pushMatrix();
float mapped = map(mouseX, 0, displayWidth, -10000,1000);
float mapped2 = 500-frameCount;
  translate(width/2, height/2, 500-frameCount);
  if(mapped2 > 50 && mapped2 < 500){
  
  scale(2,2,2);
}
  rotateX(frameCount*0.001);
  rotateY(frameCount*0.001);
  //fill(255);
  //gfx.origin(400);
  noStroke();
  textureMode(NORMAL);
  gfx.texturedMesh(globe, earthTex, true);
  //fill(255, 0, 255);
  //gfx.box(new AABB(toCartesianWithOffset(HOME), 4));
  popMatrix();
  
  pushMatrix();
  translate(width/2, height/2, 2300-frameCount);
  //rotateY(frameCount * 0.01);

  for (int n = 0; n < npartTotal; n+=50) {
    drawParticle(positions[n]);
  }

  fcount += 1;
  int m = millis();
  if (m - lastm > 1000 * fint) {
    frate = float(fcount) / fint;
    fcount = 0;
    lastm = m;
    //println("fps: " + frate);
  }
  popMatrix();
}

Vec3D toCartesianWithOffset(Vec2D v) {
  return new Vec3D(EARTH_RADIUS, radians(v.x+texUOffset), radians(v.y)).toCartesian();
}


void drawParticle(PVector center) {
 pushMatrix();
   textureMode(IMAGE);
  beginShape(QUAD);
  noStroke();
  tint(255);
  texture(sprite);
  normal(0, 0, 1);
  vertex(center.x - partSize/2, center.y - partSize/2, center.z, 0, 0);
  vertex(center.x + partSize/2, center.y - partSize/2, center.z, sprite.width, 0);
  vertex(center.x + partSize/2, center.y + partSize/2, center.z, sprite.width, sprite.height);
  vertex(center.x - partSize/2, center.y + partSize/2, center.z, 0, sprite.height);                
  endShape();
  popMatrix();
}

void initPositions() {
  pushMatrix();
  positions = new PVector[npartTotal];
  for (int n = 0; n < positions.length; n++) {
    positions[n] = new PVector(random(-1000, +1000), random(-500, +500), random(-1000, +1000));
  }
  popMatrix();
}