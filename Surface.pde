// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// An uneven surface boundary

class Surface {
  // We'll keep track of all of the surface points
  ArrayList<Vec2> surface;


  Surface() {
    
    surface = new ArrayList<Vec2>();
    // Here we keep track of the screen coordinates of the chain
    
    
   
    
    int cant = 20;
    float altura = height * 7/8 ;
    
    surface.add(new Vec2(0, altura));
    for (int j=0; j< cant; j++){
      
      float posX = map(j,0,cant,0,width);
        float posY = altura + random (-10,10) +30 * sin(map(j,0,cant,0,PI * 5));
      
      surface.add(new Vec2(posX, posY));
    }
   // surface.add(new Vec2(width/2, height/2+100));
    surface.add(new Vec2(width, altura ));

    // This is what box2d uses to put the surface in its world
    ChainShape chain = new ChainShape();

    // We can add 3 vertices by making an array of 3 Vec2 objects
    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = box2d.coordPixelsToWorld(surface.get(i));
    }

    chain.createChain(vertices, vertices.length);

    // The edge chain is now a body!
    BodyDef bd = new BodyDef();
    Body body = box2d.world.createBody(bd);
    // Shortcut, we could define a fixture if we
    // want to specify frictions, restitution, etc.
    body.createFixture(chain, 1);
  }

  // A simple function to just draw the edge chain as a series of vertex points
  void display() {
    strokeWeight(1);
    stroke(0);
    fill(20,225,100);
    beginShape();
    for (Vec2 v: surface) {
      vertex(v.x, v.y);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}