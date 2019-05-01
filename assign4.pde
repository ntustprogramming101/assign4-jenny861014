PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundhogIdle, groundhogLeft, groundhogRight, groundhogDown;
PImage bg, life, cabbage, stone1, stone2, soilEmpty;
PImage soldier;
PImage[][] soils, stones;

final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;
final int SOIL_SIZE = 80;

int[][] soilHealth;
float soilEmptyX[] = new float[8];
float soilEmptyY[] = new float[24];

final int START_BUTTON_WIDTH = 144;
final int START_BUTTON_HEIGHT = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

float soldierX[] = new float[6];
float soldierY[] = new float[6];
float cabbageX[] = new float[6];
float cabbageY[] = new float[6];
float soldierSpeed = 2f;

float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;
int playerHealth = 2;
final int PLAYER_MAX_HEALTH = 5;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;

boolean demoMode = false;

void setup() {
	size(640, 480, P2D);
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	groundhogIdle = loadImage("img/groundhogIdle.png");
	groundhogLeft = loadImage("img/groundhogLeft.png");
	groundhogRight = loadImage("img/groundhogRight.png");
	groundhogDown = loadImage("img/groundhogDown.png");
	life = loadImage("img/life.png");
	soldier = loadImage("img/soldier.png");
	cabbage = loadImage("img/cabbage.png");

	// Load PImage[][] soils
	soils = new PImage[6][5];
	for(int i = 0; i < soils.length; i++){
		for(int j = 0; j < soils[i].length; j++){
			soils[i][j] = loadImage("img/soils/soil" + i + "/soil" + i + "_" + j + ".png");
		}
	}

	// Load PImage[][] stones
  stones = new PImage[2][5];
  for(int i = 0; i < stones.length; i++){
    for(int j = 0; j < stones[i].length; j++){
      stones[i][j] = loadImage("img/stones/stone" + i + "/stone" + i + "_" + j + ".png");
    }
}

	// Initialize player
	playerX = PLAYER_INIT_X;
	playerY = PLAYER_INIT_Y;
	playerCol = (int) (playerX / SOIL_SIZE);
	playerRow = (int) (playerY / SOIL_SIZE);
	playerMoveTimer = 0;
	playerHealth = 2;

	// Initialize soilHealth
  //all
	soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
	for(int i = 0; i < soilHealth.length; i++){
		for (int j = 0; j < soilHealth[i].length; j++) {soilHealth[i][j] = 15;}}
  //1~8
  for(int i=0;i<8;i++){soilHealth[0+i][0+i] = 30;}
  //9~16
  for(int i=0;i<2;i++){soilHealth[1+i][8] = 30;}
  for(int i=0;i<2;i++){soilHealth[1+i][11] = 30;}
  for(int i=0;i<2;i++){soilHealth[1+i][12] = 30;}
  for(int i=0;i<2;i++){soilHealth[1+i][15] = 30;}
  for(int i=0;i<2;i++){soilHealth[5+i][8] = 30;}
  for(int i=0;i<2;i++){soilHealth[5+i][11] = 30;}
  for(int i=0;i<2;i++){soilHealth[5+i][12] = 30;}
  for(int i=0;i<2;i++){soilHealth[5+i][15] = 30;}
  for(int i=0;i<8;i=i+7){soilHealth[0+i][9] = 30;}
  for(int i=0;i<2;i++){soilHealth[3+i][9] = 30;}
  for(int i=0;i<8;i=i+7){soilHealth[0+i][10] = 30;}
  for(int i=0;i<2;i++){soilHealth[3+i][10] = 30;}
  for(int i=0;i<8;i=i+7){soilHealth[0+i][13] = 30;}
  for(int i=0;i<2;i++){soilHealth[3+i][13] = 30;}
  for(int i=0;i<8;i=i+7){soilHealth[0+i][14] = 30;}
  for(int i=0;i<2;i++){soilHealth[3+i][14] = 30;}
  //16~24
  for(int i=0;i<8;i=i+3){soilHealth[1+i][16] = 30;}
  for(int i=0;i<6;i=i+3){soilHealth[2+i][16] = 45;}
  for(int i=0;i<8;i=i+3){soilHealth[0+i][17] = 30;}
  for(int i=0;i<8;i=i+3){soilHealth[1+i][17] = 45;}
  for(int i=0;i<6;i=i+3){soilHealth[2+i][18] = 30;}
  for(int i=0;i<8;i=i+3){soilHealth[0+i][18] = 45;}
  for(int i=0;i<8;i=i+3){soilHealth[1+i][19] = 30;}
  for(int i=0;i<6;i=i+3){soilHealth[2+i][19] = 45;}
  for(int i=0;i<8;i=i+3){soilHealth[0+i][20] = 30;}
  for(int i=0;i<8;i=i+3){soilHealth[1+i][20] = 45;}
  for(int i=0;i<6;i=i+3){soilHealth[2+i][21] = 30;}
  for(int i=0;i<8;i=i+3){soilHealth[0+i][21] = 45;}
  for(int i=0;i<8;i=i+3){soilHealth[1+i][22] = 30;}
  for(int i=0;i<6;i=i+3){soilHealth[2+i][22] = 45;}
  for(int i=0;i<8;i=i+3){soilHealth[0+i][23] = 30;}
  for(int i=0;i<8;i=i+3){soilHealth[1+i][23] = 45;}
  
  //EmptySoil
  soilEmpty = loadImage("img/soils/soilEmpty.png");
  for(int i=1 ; i<24 ; i++){
   int count = floor(random(2))+1;
   for(int j=0 ; j<count ; j++){
     int col= floor(random(8));
     soilHealth[col][i] = 0;
  }}

	// Initialize soidiers and their position
  for(int j=0;j<6;j++){
  soldierX[j]=((int)random(8))*SOIL_SIZE;
  soldierY[j]=((int)random(4)+j*4)*SOIL_SIZE;}
	// Initialize cabbages and their position
  for(int i=0;i<6;i++){
  cabbageX[i]=((int)random(8))*SOIL_SIZE;
  cabbageY[i]=((int)random(4)+i*4)*SOIL_SIZE;}
}

void draw() {

	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}

		break;

		case GAME_RUN: // In-Game
		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

	    // CAREFUL!
	    // Because of how this translate value is calculated, the Y value of the ground level is actually 0
		pushMatrix();
		translate(0, max(SOIL_SIZE * -18, SOIL_SIZE * 1 - playerY));

		// Ground

		fill(124, 204, 25);
		noStroke();
		rect(0, -GRASS_HEIGHT, width, GRASS_HEIGHT);

		// Soil
		for(int i = 0; i < soilHealth.length; i++){
			for (int j = 0; j < soilHealth[i].length; j++) {
				// Change this part to show soil and stone images based on soilHealth value
				// NOTE: To avoid errors on webpage, you can either use floor(j / 4) or (int)(j / 4) to make sure it's an integer.
				int areaIndex = floor(j / 4);
				image(soils[areaIndex][4], i * SOIL_SIZE, j * SOIL_SIZE);
        if(soilHealth[i][j]== 0) image(soilEmpty,i * SOIL_SIZE,j * SOIL_SIZE);

        if(soilHealth[i][j]>0 && soilHealth[i][j]<=3 ){
          image(soils[areaIndex][0],i * SOIL_SIZE,j * SOIL_SIZE);}
        if(soilHealth[i][j]>=4 && soilHealth[i][j]<=6){
          image(soils[areaIndex][1],i * SOIL_SIZE,j * SOIL_SIZE);}
        if(soilHealth[i][j]>=7 && soilHealth[i][j]<=9){
          image(soils[areaIndex][2],i * SOIL_SIZE,j * SOIL_SIZE);}
        if(soilHealth[i][j]>=10 && soilHealth[i][j]<=12 ){
          image(soils[areaIndex][3],i * SOIL_SIZE,j * SOIL_SIZE);}
          
        //stone
        
        if(soilHealth[i][j]>=16 && soilHealth[i][j]<=18 ){
          image(stones[0][0],i * SOIL_SIZE,j * SOIL_SIZE);}
        if(soilHealth[i][j]>=19 && soilHealth[i][j]<=21 ){
          image(stones[0][1],i * SOIL_SIZE,j * SOIL_SIZE);}
        if(soilHealth[i][j]>=22 && soilHealth[i][j]<=24 ){
          image(stones[0][2],i * SOIL_SIZE,j * SOIL_SIZE);}
        if(soilHealth[i][j]>=25 && soilHealth[i][j]<=27 ){
          image(stones[0][3],i * SOIL_SIZE,j * SOIL_SIZE);}
        if(soilHealth[i][j]>=28 && soilHealth[i][j]<=45 ){
          image(stones[0][4],i * SOIL_SIZE,j * SOIL_SIZE);}
          
        if(soilHealth[i][j]>=31 && soilHealth[i][j]<=33 ){
          image(stones[1][0],i * SOIL_SIZE,j * SOIL_SIZE);}
        if(soilHealth[i][j]>=34 && soilHealth[i][j]<=36 ){
          image(stones[1][1],i * SOIL_SIZE,j * SOIL_SIZE);}
        if(soilHealth[i][j]>=37 && soilHealth[i][j]<=39 ){
          image(stones[1][2],i * SOIL_SIZE,j * SOIL_SIZE);}
        if(soilHealth[i][j]>=40 && soilHealth[i][j]<=42 ){
          image(stones[1][3],i * SOIL_SIZE,j * SOIL_SIZE);}
        if(soilHealth[i][j]>=43 && soilHealth[i][j]<=45 ){
          image(stones[1][4],i * SOIL_SIZE,j * SOIL_SIZE);}
          
		    
}
    }
		// Cabbages
    for(int i=0;i<6;i++){
    image(cabbage,cabbageX[i],cabbageY[i]);
    if(cabbageX[i] < playerX+80 && cabbageX[i]+80 > playerX &&
      cabbageY[i] < playerY+80 && cabbageY[i]+80 > playerY && playerHealth<5){
          cabbageX[i]= 800;
          playerHealth++;}
    if(cabbageX[i] < playerX+80 && cabbageX[i]+80 > playerX &&
      cabbageY[i] < playerY+80 && cabbageY[i]+80 > playerY && playerHealth>=5){
          playerHealth=5;}}

		// Groundhog
		PImage groundhogDisplay = groundhogIdle;

		// If player is not moving, we have to decide what player has to do next
		if(playerMoveTimer == 0){
      if(playerRow>=0 && playerRow<23 && soilHealth[playerCol][playerRow+1] == 0){
            playerMoveDirection = DOWN;
            playerMoveTimer = playerMoveDuration;
          }else{
          
			if(leftState){

				groundhogDisplay = groundhogLeft;
				// Check left boundary
				if(playerCol > 0){
          if(playerRow >=0 && soilHealth[playerCol-1][playerRow] > 0){
            playerMoveDirection = LEFT;
            playerMoveTimer = 0;
            soilHealth[playerCol-1][playerRow]--;
          }else{
					// HINT:
					// Check if "player is NOT above the ground AND there's soil on the left"
					// > If so, dig it and decrease its health
					// > Else then start moving (set playerMoveDirection and playerMoveTimer)

					playerMoveDirection = LEFT;
					playerMoveTimer = playerMoveDuration;
          }
				}

			}else if(rightState){

				groundhogDisplay = groundhogRight;

				// Check right boundary
				if(playerCol < SOIL_COL_COUNT - 1){
            if(playerRow >=0 && soilHealth[playerCol+1][playerRow] > 0){
            playerMoveDirection = RIGHT;
            playerMoveTimer = 0;
            soilHealth[playerCol+1][playerRow]--;}else{

					// HINT:
					// Check if "player is NOT above the ground AND there's soil on the right"
					// > If so, dig it and decrease its health
					// > Else then start moving (set playerMoveDirection and playerMoveTimer)

					playerMoveDirection = RIGHT;
					playerMoveTimer = playerMoveDuration;
          }
				}

			}else if(downState){

				groundhogDisplay = groundhogDown;

				// Check bottom boundary

				// HINT:
				// We have already checked "player is NOT at the bottom AND the soil under the player is empty",
				// and since we can only get here when the above statement is false,
				// we only have to check again if "player is NOT at the bottom" to make sure there won't be out-of-bound exception
				if(playerRow < SOIL_ROW_COUNT - 1){

					if(playerRow >=-1 && soilHealth[playerCol][playerRow+1] > 0){
            playerMoveDirection = DOWN;
            playerMoveTimer = 0;
            soilHealth[playerCol][playerRow+1]--;
          }else{
            
          playerMoveDirection = DOWN;
					playerMoveTimer = playerMoveDuration;}

          }
				}
			
       }
		}

		// If player is now moving?
		// (Separated if-else so player can actually move as soon as an action starts)
		// (I don't think you have to change any of these)

		if(playerMoveTimer > 0){

			playerMoveTimer --;
			switch(playerMoveDirection){

				case LEFT:
				groundhogDisplay = groundhogLeft;
				if(playerMoveTimer == 0){
					playerCol--;
					playerX = SOIL_SIZE * playerCol;
				}else{
					playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * SOIL_SIZE;
				}
				break;

				case RIGHT:
				groundhogDisplay = groundhogRight;
				if(playerMoveTimer == 0){
					playerCol++;
					playerX = SOIL_SIZE * playerCol;
				}else{
					playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * SOIL_SIZE;
				}
				break;

				case DOWN:
				groundhogDisplay = groundhogDown;
				if(playerMoveTimer == 0){
					playerRow++;
					playerY = SOIL_SIZE * playerRow;
				}else{
					playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
				}
				break;
			}

		}


		image(groundhogDisplay, playerX, playerY);

		// Soldiers 
    for(int i=0;i<6;i++){
    image(soldier,soldierX[i],soldierY[i]);
    soldierX[i]+=soldierSpeed;
      if(soldierX[i] >= 8*80)soldierX[i] = -80;
      if(soldierX[i] < playerX+80 && soldierX[i]+80 > playerX &&
         soldierY[i] < playerY+80 && soldierY[i]+80 > playerY ){
          playerX = 320;
          playerY = -80;
          playerMoveTimer = 0;
          playerCol = (int) (playerX / SOIL_SIZE);
          playerRow = (int) (playerY / SOIL_SIZE);
          playerHealth--;
          soilHealth[4][0]=15;
        }
      }

		// Demo mode: Show the value of soilHealth on each soil
		// (DO NOT CHANGE THE CODE HERE!)

		if(demoMode){	

			fill(255);
			textSize(26);
			textAlign(LEFT, TOP);

			for(int i = 0; i < soilHealth.length; i++){
				for(int j = 0; j < soilHealth[i].length; j++){
					text(soilHealth[i][j], i * SOIL_SIZE, j * SOIL_SIZE);
				}
			}

		}

		popMatrix();

		// Health UI
    for (int i = 0; i < playerHealth; i ++){
    pushMatrix();
    translate(10, 10);
    image(life,70*i,0);
    popMatrix();
    }
    
    if(playerHealth==0){
      gameState=GAME_OVER;}

		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;

				// Initialize player
				playerX = PLAYER_INIT_X;
				playerY = PLAYER_INIT_Y;
				playerCol = (int) (playerX / SOIL_SIZE);
				playerRow = (int) (playerY / SOIL_SIZE);
				playerMoveTimer = 0;
				playerHealth = 2;

        // Initialize soilHealth
        //all
        soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
        for(int i = 0; i < soilHealth.length; i++){
          for (int j = 0; j < soilHealth[i].length; j++) {soilHealth[i][j] = 15;}}
        //1~8
        for(int i=0;i<8;i++){soilHealth[0+i][0+i] = 30;}
        //9~16
        for(int i=0;i<2;i++){soilHealth[1+i][8] = 30;}
        for(int i=0;i<2;i++){soilHealth[1+i][11] = 30;}
        for(int i=0;i<2;i++){soilHealth[1+i][12] = 30;}
        for(int i=0;i<2;i++){soilHealth[1+i][15] = 30;}
        for(int i=0;i<2;i++){soilHealth[5+i][8] = 30;}
        for(int i=0;i<2;i++){soilHealth[5+i][11] = 30;}
        for(int i=0;i<2;i++){soilHealth[5+i][12] = 30;}
        for(int i=0;i<2;i++){soilHealth[5+i][15] = 30;}
        for(int i=0;i<8;i=i+7){soilHealth[0+i][9] = 30;}
        for(int i=0;i<2;i++){soilHealth[3+i][9] = 30;}
        for(int i=0;i<8;i=i+7){soilHealth[0+i][10] = 30;}
        for(int i=0;i<2;i++){soilHealth[3+i][10] = 30;}
        for(int i=0;i<8;i=i+7){soilHealth[0+i][13] = 30;}
        for(int i=0;i<2;i++){soilHealth[3+i][13] = 30;}
        for(int i=0;i<8;i=i+7){soilHealth[0+i][14] = 30;}
        for(int i=0;i<2;i++){soilHealth[3+i][14] = 30;}
        //16~24
        for(int i=0;i<8;i=i+3){soilHealth[1+i][16] = 30;}
        for(int i=0;i<6;i=i+3){soilHealth[2+i][16] = 45;}
        for(int i=0;i<8;i=i+3){soilHealth[0+i][17] = 30;}
        for(int i=0;i<8;i=i+3){soilHealth[1+i][17] = 45;}
        for(int i=0;i<6;i=i+3){soilHealth[2+i][18] = 30;}
        for(int i=0;i<8;i=i+3){soilHealth[0+i][18] = 45;}
        for(int i=0;i<8;i=i+3){soilHealth[1+i][19] = 30;}
        for(int i=0;i<6;i=i+3){soilHealth[2+i][19] = 45;}
        for(int i=0;i<8;i=i+3){soilHealth[0+i][20] = 30;}
        for(int i=0;i<8;i=i+3){soilHealth[1+i][20] = 45;}
        for(int i=0;i<6;i=i+3){soilHealth[2+i][21] = 30;}
        for(int i=0;i<8;i=i+3){soilHealth[0+i][21] = 45;}
        for(int i=0;i<8;i=i+3){soilHealth[1+i][22] = 30;}
        for(int i=0;i<6;i=i+3){soilHealth[2+i][22] = 45;}
        for(int i=0;i<8;i=i+3){soilHealth[0+i][23] = 30;}
        for(int i=0;i<8;i=i+3){soilHealth[1+i][23] = 45;}
        
        //EmptySoil
        soilEmpty = loadImage("img/soils/soilEmpty.png");
        for(int i=1 ; i<24 ; i++){
         int count = floor(random(2))+1;
         for(int j=0 ; j<count ; j++){
           int col= floor(random(8));
           soilHealth[col][i] = 0;
        }}
      
        // Initialize soidiers and their position
        for(int j=0;j<6;j++){
        soldierX[j]=((int)random(8))*SOIL_SIZE;
        soldierY[j]=((int)random(4)+j*4)*SOIL_SIZE;}
        // Initialize cabbages and their position
        for(int i=0;i<6;i++){
        cabbageX[i]=((int)random(8))*SOIL_SIZE;
        cabbageY[i]=((int)random(4)+i*4)*SOIL_SIZE;}
			}

		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}
}

void keyPressed(){
	if(key==CODED){
		switch(keyCode){
			case LEFT:
			leftState = true;
			break;
			case RIGHT:
			rightState = true;
			break;
			case DOWN:
			downState = true;
			break;
		}
	}else{
		if(key=='b'){
			// Press B to toggle demo mode
			demoMode = !demoMode;
		}
	}
}

void keyReleased(){
	if(key==CODED){
		switch(keyCode){
			case LEFT:
			leftState = false;
			break;
			case RIGHT:
			rightState = false;
			break;
			case DOWN:
			downState = false;
			break;
		}
	}
}
