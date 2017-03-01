// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A circular particle

class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;

  color colorShape;
  color colorStroke;

  float life;
  float lifespeed;
  float Bsize;

  Particle(float x, float y, float r_) {
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x, y, r);

    float bri = random(50, 255);
    float sat =  random(150, 220);
    colorShape =  color(150, bri, sat);
    colorStroke = color(150, bri, sat, life);

    life = 255;
    lifespeed = 0.1;

    Bsize = 3;
  }
  // 
  void display() {

    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation


    life -= lifespeed;

    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    SHSBA();
    ellipse(0, 0, r*2, r*2);
    // Let's add a line so we can see the rotation
    line(0, 0, r, 0);
    popMatrix();
  }


  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2 || life < 0) {
      killBody();
      return true;
    }
    return false;
  }
  // Here's our function that adds the particle to the Box2D world
  private void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.6;

    // Attach fixture to body
    body.createFixture(fd);
    // Give it a random initial velocity (and angular velocity)
    //body.setLinearVelocity(new Vec2(random(-10f,10f),random(5f,10f)));
    //body.setAngularVelocity(random(-10,10));
  }

  void SHSBA() {
    //changehue();
    fill(colorShape, life);
    stroke(colorStroke);
    strokeWeight(Bsize);
  }
}


class PolygonParticle extends Particle {

  float RDMvertex;
  PolygonParticle(float _x, float _y, float _size) {
    super(_x, _y, _size);
    killBody();
    colorShape =  color(210, 255, 255);
    colorStroke = color(210, 255, 0 );
    RDMvertex = 30;
    makeBody(_x, _y, _size);
    lifespeed = 2;
  }
  void display() {
    life -= lifespeed;
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    beginShape();
    SHSBA();
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
  }
  void makeBody(float _x, float _Y, float _size) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(_x, _Y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.world.createBody(bd);
    Vec2[] vertices = new Vec2[6];
    for (int x = 0; x<vertices.length; x++) {
      vertices[x] = box2d.vectorPixelsToWorld(
        new Vec2(
        random(_size-RDMvertex, _size+RDMvertex) * sin(map(x, 0, vertices.length, 0, TWO_PI)), 
        random(_size-RDMvertex, _size+RDMvertex) * cos(map(x, 0, vertices.length, 0, TWO_PI))
        ));
    }
    PolygonShape ps = new PolygonShape();
    ps.set(vertices, vertices.length);
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.6;
    body.createFixture(fd);
  }
}




class Lollipop extends Particle {

  // We need to keep track of a Body and a width and height
  Body body;
  
  
  PolygonShape armR;
  PolygonShape armL;
  PolygonShape legs;
  
  float Wchest;
  float Hchest;
  float r;

  float Warms;
  float Harms;

  float Wlegs;
  float Hlegs;

  float proportion;
  // Constructor
  Lollipop(float x, float y) {

    super(0, 0, 0);
    killBody();

    proportion = random(0.3, 1.5);

    Wchest = random(10,60) * proportion;
    Hchest = random(30,60) * proportion;
    
    r = random(8,30) * proportion;

    Warms = random(30,50) * proportion;
    Harms = random(3,10)  * proportion;

    Wlegs = 5  * proportion;
    Hlegs = 30 * proportion;
    // Add the box to the box2d world
    makeBody(new Vec2(x, y));
    
    colorShape =  color(210, 220, 150);
    colorStroke = color(150, 0, 0);
  }



  boolean done() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if (pos.y > height+Wchest*Hchest || life < 0) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the lollipop
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    
    SHSBA();
    
    beginShape();
    for (int i = 0; i < armR.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(armR.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    
    beginShape();
    for (int i = 0; i < armL.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(armL.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    
    
    rect(0, 0, Wchest, Hchest);
    ellipse(0, -Hchest/2, r*2, r*2);
    
  

   
    
    beginShape();
    for (int i = 0; i < legs.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(legs.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    
   
    
    
    
    
    //rect(Wchest/2+Warms/2, -Hchest/4, Warms, Harms);
    //rect(-Wchest/2-Warms/2, -Hchest/4, Warms, Harms);

   /* rect(Wchest/2+Wlegs/2, Hchest/2+Hlegs/2, Wlegs, Hlegs);
    rect(-Wchest/2-Wlegs/2, Hchest/2+Hlegs/2, Wlegs, Hlegs);*/

    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center) {

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);


    //chest
    PolygonShape chest = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(Wchest/2);
    float box2dH = box2d.scalarPixelsToWorld(Hchest/2);
    chest.setAsBox(box2dW, box2dH);

    //head
    CircleShape head = new CircleShape();
    head.m_radius = box2d.scalarPixelsToWorld(r);
    Vec2 offset = new Vec2(0, -Hchest/2);
    offset = box2d.vectorPixelsToWorld(offset);
    head.m_p.set(offset.x, offset.y);



    //arms
    Vec2 offsetArmleft  = new Vec2(-Wchest/2 -Warms/2, -Hchest/4);
    Vec2 offsetArmright = new Vec2(Wchest/2  +Warms/2, -Hchest/4);

    
    
    Vec2[] armvertexR = new Vec2[4];
    armvertexR[0] = new Vec2(box2d.vectorPixelsToWorld(Wchest/2  ,  - Hchest /4 + Harms/2));
    armvertexR[1] = new Vec2(box2d.vectorPixelsToWorld(Wchest/2 + Warms ,  - Hchest /4 + Harms/2 ));
    armvertexR[2] = new Vec2(box2d.vectorPixelsToWorld(Wchest/2 + Warms , - Hchest /4 - Harms/2 ));
    armvertexR[3] = new Vec2(box2d.vectorPixelsToWorld(Wchest/2  ,  - Hchest /4 - Harms/2 ));   
    
    armR = new PolygonShape();
    armR.set(armvertexR, armvertexR.length);
    
    Vec2[] armvertexL = new Vec2[4];
    armvertexL[0] = new Vec2(box2d.vectorPixelsToWorld(-Wchest/2  ,  - Hchest /4 - Harms/2));
    armvertexL[1] = new Vec2(box2d.vectorPixelsToWorld(-Wchest/2 - Warms ,  - Hchest /4 - Harms/2 ));
    armvertexL[2] = new Vec2(box2d.vectorPixelsToWorld(-Wchest/2 - Warms ,  - Hchest /4 + Harms/2 ));
    armvertexL[3] = new Vec2(box2d.vectorPixelsToWorld(-Wchest/2  ,  - Hchest /4 + Harms/2 ));   
    armL = new PolygonShape();
    armL.set(armvertexL, armvertexL.length);
    
     
     
    Wlegs = 5;
    Hlegs = 30;
    
    Vec2[] legvertex = new Vec2[4];
    legvertex[0] = new Vec2(box2d.vectorPixelsToWorld(-Wchest/2  ,  Hchest/2 ));
    legvertex[1] = new Vec2(box2d.vectorPixelsToWorld(-Wchest/2 ,  Hchest/2 + Hlegs));
    legvertex[2] = new Vec2(box2d.vectorPixelsToWorld(Wchest/2  , Hchest/2 + Hlegs ));
    legvertex[3] = new Vec2(box2d.vectorPixelsToWorld(Wchest/2 ,Hchest/2));   
    legs = new PolygonShape();
    legs.set(legvertex, legvertex.length);


    body.createFixture(chest, 1.0);
    body.createFixture(armR, 1.0);
    body.createFixture(armL, 1.0);
    body.createFixture(head, 1.0);
   
    body.createFixture(legs,1.0);
    
    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
  
  
  
  PolygonShape Rarm(){
    
    
    
    
    return armR;
  }
}

//EJEMPLO DE DISTANCE JOINT
class Pair {
 
  Particle p1;
  Particle p2;
  float len;
  
  Pair(float x, float y){
   
    len = 60; // LO QUE MIDA EL JOINT
    
    p1 = new Particle(x,y,10);
    p2 = new Particle(x+random(-1,1),y+random(-1,1),10);

    DistanceJointDef djd = new DistanceJointDef();
    // Connection between previous particle and this one
    djd.bodyA = p1.body;
    djd.bodyB = p2.body;
    // Equilibrium length
    djd.length = box2d.scalarPixelsToWorld(len);
    
    // These properties affect how springy the joint is 
    djd.frequencyHz = 1.5;  // Try a value less than 5 (0 for no elasticity)
    djd.dampingRatio =0; // Ranges between 0 and 1 (1 for no springiness)

    // Make the joint.  Note we aren't storing a reference to the joint ourselves anywhere!
    // We might need to someday, but for now it's ok
    DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);
  }
  
  void display() {
    Vec2 pos1 = box2d.getBodyPixelCoord(p1.body);
    Vec2 pos2 = box2d.getBodyPixelCoord(p2.body);
    stroke(0);
    strokeWeight(2);
    line(pos1.x,pos1.y,pos2.x,pos2.y);

    p1.display();
    p2.display();
  }
}