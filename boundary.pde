// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// An uneven surface boundary

class Boundary {
  // We'll keep track of all of the surface points
  
  Body body;
  ArrayList<Vec2> surface;

  float r;
  float posx,posy;
  color colorStroke;
  color colorShape;
  float Bsize; 
  
  Boundary(float _posx,float _posy,float _r) { 
     
     posx= _posx;
     posy = _posy;
     r = _r;
     
     Bsize = 0;
     colorStroke = color(random(0,30),255,180);
     colorShape = color(random(0,30),255,180);
     makebody(posx,posy,r);
  }

  // A simple function to just draw the edge chain as a series of vertex points
  void display() {
    
    SHSBA();
    ellipse(posx,posy,r*2,r*2);
  }
  
  void makebody(float _posx,float _posy,float r){
    
    
      // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(_posx,_posy);
    bd.type = BodyType.STATIC;
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.3;
    
    // Attach fixture to body
    body.createFixture(fd);

    // Give it a random initial velocity (and angular velocity)
    //body.setLinearVelocity(new Vec2(random(-10f,10f),random(5f,10f)));
    //body.setAngularVelocity(random(-10,10));
    
  }
   void SHSBA() {
    //changehue();
    fill(colorShape);
    stroke(colorStroke);
    strokeWeight(Bsize);
  }
  
}