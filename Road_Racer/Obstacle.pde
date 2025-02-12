import processing.opengl.*;
 
class Obstacle {
  float x, y, z; // position of the car
  PShape obstacleModel; // 3D car model
  float rotationX = 0;
  float rotationY = 0;
  float rotationZ = 0;
  float scale = 10;
  int dir;
  String[] obstacleTextures = null;
  String[] obstacleModels = {
     "Obs/obs1/Car6.obj",
     "Obs/obs2/alpaca.obj",
     "Obs/obs3/capybara.obj",
     "Obs/obs4/Car5_Taxi.obj",
     "Obs/obs5/pine_tree.obj",
     "Obs/obs6/pine_tree_snow.obj"
   };
  

  Obstacle(float x_, float y_, float z_) {
    x = x_;
    y = y_;
    z = z_;
    dir = (random(2) < 1) ? 1 : -1;
    setModel(int(random(0,obstacleModels.length)));
  }


  void updateObstacle() {
    
}

void draw() {
    updateObstacle();
    
    pushMatrix(); // save the current transformation state
    translate(x, y, z); // move the car to its position
    obstacleModel.rotateX(radians(rotationX));
    rotationX = 0;
    obstacleModel.rotateY(radians(dir*random(0.05, 0.1)));
    rotationY = 0;
    obstacleModel.rotateZ(radians(rotationZ));
    rotationZ = 0;
    
    scale(scale);
    
    shape(obstacleModel); // draw the car model
    popMatrix(); // restore the previous transformation state
}

void setTexture(String textureFile){
    PImage texture =  loadImage(textureFile);
    obstacleModel.setTexture(texture);
  }
  
  void setModel(int i){
    beginShape();
    obstacleModel = loadShape(obstacleModels[i]); // load the car model in OBJ format
    //carModel.rotateX(radians(180)); // rotate the car model 180 degrees around the X-axis
    //carModel.rotateY(radians(-30));
    endShape();
      obstacleTextures = getTextureFileNames(sketchPath() + "/" +obstacleModels[i]);
    setTexture(obstacleTextures[int(random(0, obstacleTextures.length))]);
    obstacleModel.rotateX(radians(180));
  }
}
