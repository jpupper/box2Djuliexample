import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
Box2DProcessing box2d;    


ArrayList<Particle> particles;
ArrayList<Pair>   pairs;


//ParticleSystem PS;

// An object to store information about the uneven surface
Surface surface;

Boundary boundary;

Boundary [] boundarys = new Boundary[15];


void setup() {

  smooth();
  colorMode(HSB);
  rectMode(CENTER);
  fullScreen();
  //size(1200, 600);
  particles = new ArrayList<Particle>();
  pairs = new ArrayList<Pair>();

  box2d = new Box2DProcessing(this);
  //Initializes a Box2D world with default settings
  box2d.createWorld();
  //Define gravity :
  box2d.setGravity(0, -25);
  
  
  //boundary = new Boundary(width/2, height/2, 20);

  for (int x=0; x<boundarys.length; x++) {

    boundarys[x] = new Boundary(random(width), random(height * 7/8), random(10, 20));
  }
  surface = new Surface();

  // PS = new ParticleSystem(new PVector(width/2, height /4));
}

void draw() {
  if (mousePressed) {
    
    // particles.add(new Particle(mouseX, mouseY, random(2, 5)));
    //particles.add(new PolygonParticle(mouseX, mouseY, random(2, 5)));
    //particles.add(new Lollipop(mouseX, mouseY));
  }

  box2d.step();    

  background(30,80,210);

  surface.display();
  //boundary.display();
  for (Particle b : particles) {
    b.display();
  }
  for (int x=0; x<boundarys.length; x++) {
    boundarys[x].display();
  }
  
  for(Pair p: pairs){
   p.display(); 
  }
  
  

  //PS.display();

  // Particles that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    if (p.done()) {
      particles.remove(i);
    }
  }
}

void mousePressed(){
 // particles.add(new Lollipop(mouseX, mouseY));
  //AttachedParticle cs = new AttachedParticle(mouseX,mouseY,random(10, 20));
  //particles.add(cs);
  
   Pair p = new Pair(mouseX,mouseY);
   pairs.add(p);
}