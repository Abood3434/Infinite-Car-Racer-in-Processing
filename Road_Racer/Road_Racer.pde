final int SCREEN_MAIN_MENU = 0;
final int GAME_SCREEN = 1;
final int GAME_OVER = 2;
//car position variables
float carX = 200;
float carY = 300;
float carZ = 50;
//variables for controlling models and textures
int textureIndex = 0; 
int currentCarModelIndex = 0;
//starting screen
int currentScreen = SCREEN_MAIN_MENU;
//score tracking variable
int score = 0;

Player player;
ArrayList<Obstacle> obstacles;

float lightY;

void setup() {
  fullScreen(P3D); // set the size of the window
  background(153, 0, 204); // set the background color to white
  startMainMenu();
  
  textureMode(NORMAL);
  roadTexture = loadImage(sketchPath() + "/asphalt.jpg");
  markingTexture = loadImage(sketchPath() + "/marking.jpg");
  textureWrap(REPEAT);
}

PImage roadTexture;
PImage markingTexture;

void draw(){ //calls appropriate draw functions
  if (currentScreen == SCREEN_MAIN_MENU) {
    background(153, 0, 204);
    drawMainMenu();
  } else if (currentScreen == GAME_SCREEN) {
    drawGameScreen();
    checkForCollisions();
  } else if (currentScreen == GAME_OVER) {
    drawGameOver();
  }
}

void setCarAtStartingPosition() { // sets car at road beginning 
  float carStartX = 0;
  float carStartY = 1 +0.01;
  float carStartZ = -roadHeight/2 + 90;
  
  player.x = carStartX;
  player.y = carStartY;
  player.z = carStartZ;
  player.rotationX = 180;
  player.rotationY = 180;
  player.rotationZ = 180;
}

void checkForCollisions(){
  for (Obstacle obstacle : obstacles) {
    if (collidesWith(obstacle)) {
      currentScreen = GAME_OVER;
    }
  }
}

boolean collidesWith(Obstacle obstacle) { 
  float carWidth = 80;
  float carLength = 150;
  // Calculate the collision bounds of the car and obstacle
  float carLeft = player.x - carWidth / 2;
  float carRight = player.x + carWidth / 2;
  float carFront = player.z + carLength / 2;
  float carBack = player.z - carLength / 2;

  float obstacleLeft = obstacle.x - 80 / 2;
  float obstacleRight = obstacle.x + 80 / 2;
  float obstacleFront = obstacle.z + 80 / 2;
  float obstacleBack = obstacle.z - 80 / 2;

  // Check for collision by comparing the bounds
  if (carLeft < obstacleRight && carRight > obstacleLeft &&
      carFront > obstacleBack && carBack < obstacleFront) {
    return true; // Collision detected
  } else {
    return false; // No collision
  }
}

void keyPressed() { //key press handler
  //camera movement handling
  if (key == '8') {
    // Move camera forward
    adjustZ -= 10;
  } else if (key == '2') {
    // Move camera backward
      adjustZ += 10;
  } else if (key == '4') {
    // Move camera left
        adjustX -= 10;
  } else if (key == '6') {
    // Move camera right
        adjustX += 10;
  } else if (key == '7') {
    // Move camera up
        adjustY -= 10;
  } else if (key == '1') {
    // Move camera down
        adjustY += 10;
  } else if (key == '5'){ //reset camera to default position
      adjustY = 0;
      adjustX = 0;  
      adjustZ = 0;

  }
  //Car Models and textures switch handling
   if (keyCode == LEFT && currentScreen == SCREEN_MAIN_MENU) {
    if (currentCarModelIndex > 0)
      {
          // Cycle through textures when '' is pressed
        currentCarModelIndex = (currentCarModelIndex  -1);
        // Set the new texture for the player object
    }
    else
    {
      currentCarModelIndex = player.carModels.length-1;}
      player.setModel(currentCarModelIndex);
      textureIndex = 0;
  }
 if (keyCode == RIGHT && currentScreen == SCREEN_MAIN_MENU){
    // Cycle to the next car model texture
    currentCarModelIndex = (currentCarModelIndex + 1) % player.carModels.length;
    player.setModel(currentCarModelIndex);
    textureIndex = 0;
    //print(currentCarModelIndex);
  }
   if (keyCode == UP && currentScreen == SCREEN_MAIN_MENU) {
    // Cycle through textures when '' is pressed
    textureIndex = (textureIndex + 1) % player.carTextures.length;
    // Set the new texture for the player object
    player.setTexture(player.carTextures[textureIndex]);
  }
  if (keyCode == DOWN && currentScreen == SCREEN_MAIN_MENU) {
    if (textureIndex > 0)
      {
          // Cycle through textures when '' is pressed
        textureIndex = (textureIndex  -1) % player.carTextures.length;
    }else{
      textureIndex = player.carTextures.length - 1;
    }
    player.setTexture(player.carTextures[textureIndex]);
  }
   //Screens key handling 
  if (currentScreen == SCREEN_MAIN_MENU && keyCode == ' ') {
    // Start the game when the SPACE key is pressed on the main menu screen
    startGame();
  } else if (currentScreen == GAME_SCREEN && keyCode == BACKSPACE) {
    // End the game and return to the main menu when the ESC key is pressed on the game screen
    startMainMenu();
  } else if(currentScreen == GAME_OVER && (keyCode == 'r' || keyCode == 'R')){
    startMainMenu();
  }
    //car movement handling
  if ((keyCode == 'W' || keyCode == 'w') && currentScreen == GAME_SCREEN) {
    // Increase forward speed
    player.dx  += 1;
  } else if ((keyCode == 'S' || keyCode == 's') && currentScreen == GAME_SCREEN) {
    // Increase backward speed
    player.dnx += 1;
  } else if ((keyCode == 'A' || keyCode == 'a') && currentScreen == GAME_SCREEN) {
    // Set turning angle to turn left
    if(player.brake)
    player.steeringAngle = 3.5;
    else
    player.steeringAngle = 2;
  } else if ((keyCode == 'D' || keyCode == 'd') && currentScreen == GAME_SCREEN) {
    // Set turning angle to turn right
    if(player.brake)
    player.steeringAngle = -3.5;
    else
    player.steeringAngle = -2;
  }else if(keyCode == ' '  && currentScreen == GAME_SCREEN)
  {
    player.brake = true;
  }else if((keyCode == 'X' || keyCode == 'x') && currentScreen == GAME_SCREEN)
    {      //Increase max speed upper limit for testing purposes.
      player.maxSpeed += 2;
    }
 
} 
  
void keyReleased(){ //Key release handler
    //car movement handling
    if (keyCode == 'W' || keyCode == 'w') {
      // Increase forward speed
      score += player.dx/10;
      player.dx  = 0;
      //print("sxxx");
    } else if (keyCode == 'S' || keyCode == 's') {
      // Increase backward speed
      player.dnx = 0;
    } else if (keyCode == 'a' || keyCode == 'A') {
      // Set turning angle to turn left
      player.steeringAngle = 0;
    } else if (keyCode == 'D' || keyCode == 'd') {
      // Set turning angle to turn right
      player.steeringAngle = 0;
    }
    else if(keyCode == ' ')
    {
      player.brake = false;
    }
}

void displayCar(){ //Sets car to be displayed in Main Menu screen
    camera();
    player.scale = 60;
    player.x = carX;
    player.y = carY;
    player.z = carZ;
    player.carModel.rotateY(-1/700.0);
}

void drawMainMenu() {
  background(153, 0, 204);
  camera();
  
  fill(255, 0, 180);
  textSize(40);

  pushMatrix();
  textMode(MODEL);
  
  String text = "Select Car Model \n <- ↑ ->";
  text(text, player.x + 50, player.y-200,player.z-50);
  popMatrix();
  
  //Set the mood
  lightY = map(mouseY, 0, height, -1, 1);
  ambientLight(170, 170, 128);
  directionalLight(255, 255, 255,
  0, lightY, -1);
  
  // Draw the car model
  displayCar();
  player.draw();
}

float adjustX, adjustY, adjustZ = 0; //free-roam camera movement variables
float rotX, rotY, rotZ = 0;
void drawGameScreen(){
  background(102,0,204);
  player.scale = 35;
  
  ambientLight(150, 200, 150);
 
  float camX = player.x + adjustX;
  float camY = player.y - 200 + adjustY;
  float camZ = player.z - 400 + adjustZ;
  float targetX = player.x;
  float targetY = player.y;
  float targetZ = player.z;
  camera(camX, camY+player.speed*1.7 + player.dx/10 , camZ +player.speed*2.5 +player.dx /7,
   targetX, targetY, targetZ,
   0, 1, 0);
   
  float lightX = camX;
  float lightY = camY-500;
  float lightZ = camZ+1000;
  directionalLight(255, 50, 255,
  -lightX, -lightY, -lightZ);
  
  rotateX(rotX + distY);
  rotateY(rotY + distX);
  
  drawRoad();
  player.draw();
  //drawSpeed();
  drawObstacles();
}

void drawObstacles(){
  for (int i = obstacles.size() - 1; i >= 0; i--) {
    Obstacle obstacle = obstacles.get(i);
    if (player.z-150>obstacle.z){
    obstacles.remove(i);
    score+=10;
  }
    else
    obstacle.draw();
  }
  generateObstacles();
}

void drawSpeed(){
  // Set text properties
  fill(255, 0, 0); // Red color
  textAlign(LEFT, BOTTOM); // Align text to the right-bottom corner
  textSize(30); // Set the desired text size

  pushMatrix();// Enable MODEL mode for text rendering
  textMode(MODEL);
  scale(-1, 1);
  // Draw the speed text
  String speedText = "Speed: " + int(player.speed);
  text(speedText, player.x, player.y-50,player.z+50); // Adjust the position if needed
  popMatrix();
}


float roadWidthPercentage = 0.7;   // Percentage of the screen width for road width
float roadHeightPercentage = 1.0;  // Percentage of the screen height for road height

//float roadMarkingSpacing = 0.08;     // Spacing between the road markings as a fraction of road width
//float roadMarkingLength = 0.2; 

float roadOffset = 0.0;  // Offset for scrolling effect

float roadWidth = width * roadWidthPercentage + 1500;
float roadHeight = height * roadHeightPercentage +10000;
//float spacing;

float startZ = 0;
int roadblocks = 1; //number of times road was looped
void drawRoad() {
  float roadOffset = player.z;
  
    //loop road if player nears end 
    if(roadOffset+2500 > startZ + roadHeight/2){
      
      for (int i = obstacles.size() - 1; i >= 0; i--) {
        Obstacle obstacle = obstacles.get(i);
        if (player.z-50>obstacle.z){
            obstacles.remove(i);
            score+=10;
        }else{
          float dist = obstacle.z - roadOffset;
          obstacle.z = -roadHeight / 2 +300 + dist;
      }
    }
    generateObstacles();
    roadblocks++;
    player.maxSpeed++;
    player.z = -roadHeight / 2 +300;
    }
  //draw road block
  drawRoadSection();
}

void drawRoadSection(){
  float startingZ = -roadHeight/2;
  noStroke();
  //draw road in pieces of blockCount instead of one big piece 
  float blockCount = 60; // Number of road blocks
  float blockHeight = roadHeight*1.5 / blockCount; // Height of each road block

  pushMatrix();

  for (int i = 0; i < blockCount; i++) {
    float currentZ = startingZ + (i * blockHeight);
    float nextZ = startingZ + ((i + 1) * blockHeight);
  
    beginShape(QUADS);
    texture(roadTexture);
    vertex(-roadWidth / 2, 2, currentZ, 0, 0); // Upper Left Corner of road
    vertex(roadWidth / 2, 2, currentZ, 0, 1); // Upper right corner of road
    vertex(-roadWidth / 2, 2, nextZ, 1, 0); // Lower left corner of road
    vertex(roadWidth / 2, 2, nextZ, 1, 1); // Lower right corner of road

    vertex(roadWidth / 2, 1, currentZ, 0, 0); // Upper Left Corner of road
    vertex(-roadWidth / 2, 1, currentZ, 0, 1); // Upper right corner of road
    vertex(roadWidth / 2, 1, nextZ, 1, 0); // Lower left corner of road
    vertex(-roadWidth / 2, 1, nextZ, 1, 1); // Lower right corner of road

    endShape(CLOSE);
  }

  noTexture();
  popMatrix();
}

void startMainMenu(){
    player = new Player(-250, -250, 0);
    
    currentCarModelIndex = int(random(0, player.carModels.length));
    player.setModel(currentCarModelIndex);
    textureIndex = int(random(0, player.carTextures.length));
    player.setTexture(player.carTextures[textureIndex]);
    
    obstacles = new ArrayList<Obstacle>();
    generateObstacles();
    currentScreen = SCREEN_MAIN_MENU;
    score = 0;
}

void startGame(){
  player.setModel(currentCarModelIndex);  
  player.setTexture(player.carTextures[textureIndex]);
  setCarAtStartingPosition();
  roadblocks = 0 + roadblocks/2;
  currentScreen = GAME_SCREEN;
}

void generateObstacles() { // generates obstacles
  if (obstacles.size() < roadblocks+10) {
    int numObstacles = (int)random(6, roadblocks+10); // Generate 1-3 obstacles

    float obstacleSpacing = roadWidth / (numObstacles + 1); // Spacing between obstacles
    float minZPos = player.z + 700; // Minimum z position
    float maxZPos = minZPos + roadHeight - 2000; // Maximum z position
    
    for (int i = obstacles.size(); i < numObstacles; i++) {
      float xPos = random(-roadWidth/2 + obstacleSpacing, roadWidth/2 - obstacleSpacing); // Random x position within road boundaries
      float yPos = 0;
      float zPos = map(i, 0, numObstacles - 1, minZPos, maxZPos); // Distribute obstacles evenly along the z-axis

      Obstacle obstacle = new Obstacle(xPos, yPos, zPos);
      obstacle.scale = random(40+roadblocks, 60+roadblocks);
      obstacles.add(obstacle);
    }
  }
}

void drawGameOver() {
  background(0);
  camera();
  textSize(200);
  textAlign(CENTER, CENTER);
  textMode(MODEL);
  fill(180);
  text("Game Over", width/2, height/2 -150);
  textSize(100);
  text("Press 'R' to restart", width/2, height/2+50);
  textSize(80);
  text("Score: " + score, width/2, height/2+140);
}

float lastX, lastY;
float distX, distY;
void mousePressed() {
  // Check if the mouse was clicked inside the main menu screen
  if (mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height && currentScreen == SCREEN_MAIN_MENU) {
    // If so, switch to the game screen
    startGame();
  }
  lastX = mouseX;
  lastY = mouseY;
}
void mouseDragged()
{
  distX = radians(mouseX - lastX)/10;
  distY = radians(lastY - mouseY)/10;
}

void mouseReleased()
{
  rotX += distY/10;
  rotY += distX/10;
  distX = distY = 0;
}
