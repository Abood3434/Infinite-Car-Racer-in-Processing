//import processing.opengl.*;
 
class Player {
  float x, y, z; // position of the car
  PShape carModel; // 3D car model
  float rotationX = 0;
  float rotationY = 0;
  float rotationZ = 0;
  float scale = 10;
  String[] carTextures = null;
  String[] carModels = {
  "Cars/Car 01/Car.obj",
  "Cars/Car 02/Car2.obj",
  "Cars/Car 03/Car3.obj",
  "Cars/Car 04/Car4.obj",
  "Cars/Car 05/Car5.obj",
  "Cars/Car 06/Car6.obj"};
  
  float speed= 0; 
  float maxSpeed = 30;           // Maximum speed of the car
  float friction = 0.03;         // Friction to slow down the car
  float frictionHi = 0.001;         // Friction to slow down the car
  boolean brake = false;
  
  float acceleration = 1.05;
  float steeringAngle = 0;      // Steering angle for car rotation
  float antiRotation = 0;
  int antiRotationSteps = 0; 
  float dx, dnx = 0;
  
  long startTime;
  long endTime;
  long duration;
  
  int modelI;
  int textI;

  Player(float x_, float y_, float z_) {
    x = x_;
    y = y_;
    z = z_;
    modelI = 0;
    setModel(modelI);
  }

 //<>// //<>//
  void updateCar() {
    if(!brake){
      if (speed < maxSpeed && speed >= 0)
      {
        speed += dx*acceleration *0.6;
      }
      if (speed > -maxSpeed/3 && speed <= 0.9)
      {
        z -= dnx*5;
        x -= steeringAngle/5 * 5;
      }
      if (speed > 0 && speed < 20)
        speed -= friction * speed/2;
      if (speed < 0 && speed <20)
        speed += frictionHi * speed;
      if (speed > 0 && speed >= 20)
      speed -= friction * speed/2;
      if (speed < 0 && speed >= 20)
        speed += frictionHi * speed;
  }else{
    if (speed>0)
      if (steeringAngle != 0)
        speed -= speed/60;
      else
        speed -= speed/15;
    x += steeringAngle * speed/8;
  }
      z += speed;
      if (speed < 20)
      x += steeringAngle/3 * speed/2;
      if(speed >=20)
      x += steeringAngle/3 * speed/1.75;
      
      rotationY = steeringAngle/6;
      antiRotation += steeringAngle/6;
      if (steeringAngle !=0){
        startTime = System.nanoTime();
      }
      if (steeringAngle ==0){
      if(antiRotation != 0){
        endTime = System.nanoTime();
        duration = (endTime - startTime)/1000000;
        //print(duration +"/n");
        if (duration>=50){
          rotationY = - antiRotation/10;
          antiRotation = antiRotation - antiRotation/10;
      }
    }
  }
}

void flushRotation(){
  if (true){
    carModel.rotateY(-antiRotation);
    antiRotation = 0;
  }
}
void draw() {
    updateCar();
    
    pushMatrix(); // save the current transformation state
    translate(x, y, z); // move the car to its position
    carModel.rotateX(radians(rotationX));
    rotationX = 0;
    carModel.rotateY(radians(rotationY));
    rotationY = 0;
    carModel.rotateZ(radians(rotationZ));
    rotationZ = 0;
    
    scale(scale);
    
    shape(carModel); // draw the car model
    popMatrix(); // restore the previous transformation state
}

void setTexture(String textureFile){
    PImage texture =  loadImage(textureFile);
    carModel.setTexture(texture);
  }
  
  void setModel(int i){
    beginShape();
    carModel = loadShape(carModels[i]); // load the car model in OBJ format
    //carModel.rotateX(radians(180)); // rotate the car model 180 degrees around the X-axis
    //carModel.rotateY(radians(-30));
    endShape();
      carTextures = getTextureFileNames(sketchPath() + "/" +carModels[i]);
      textI = 0;
    setTexture(carTextures[textI]);
    carModel.rotateX(radians(180));
  }
}


   String[] getTextureFileNames(String carModelFolder) {
  File folder = new File(carModelFolder);
  ArrayList<String> textureFiles = new ArrayList<String>();
  //print(folder.getAbsoluteFile());
  folder = new File(folder.getAbsoluteFile().getParent());
  if(folder.exists() && folder.isDirectory()){
    File[] files = folder.listFiles();
    
    for (File file : files) {
      if (file.isFile() && isTextureFile(file)) {
        textureFiles.add(file.getAbsolutePath());
        //System.out.println("Found texture file: " + file.getAbsolutePath());
      }
    }
  } else {
    //System.out.println("Folder does not exist or is not a directory: " + carModelFolder);
  }
  return textureFiles.toArray(new String[0]);
}
boolean isTextureFile(File file) {
  String extension = getFileExtension(file);
  return (extension.equals("png") || extension.equals("jpg") || extension.equals("jpeg"));
}

String getFileExtension(File file) {
  String name = file.getName();
  int lastIndexOfDot = name.lastIndexOf('.');
  return (lastIndexOfDot == -1) ? "" : name.substring(lastIndexOfDot + 1);
} //<>// //<>//
