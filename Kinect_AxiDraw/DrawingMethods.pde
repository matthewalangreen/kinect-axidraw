// helper functions
// -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

// convert from screen pixel location (in processing) to corresponding position on plotter
int screenXToMotorX(int x) {
 return int(floor(float(x - MousePaperLeft) * MotorStepsPerPixel)); 
}

int screenYToMotorY(int y) {
 return int(floor(float(y - MousePaperTop) * MotorStepsPerPixel)); 
}

// move to this position you've just calculated with helper functions
void moveXYUsingScreenValues(int x, int y) {
  int xPos = screenXToMotorX(x);
  int yPos = screenYToMotorY(y);
  //if (debug) { println("xPos: " + xPos + " yPos: " + yPos); }
  MoveToXY(xPos, yPos);
}

// special case of the above function that makes sure point is within appropriate boundary
void safeMove(int x, int y) {
  if(x >= MousePaperLeft && x <= MousePaperRight && y >= MousePaperTop && y <= MousePaperBottom ) {
    moveXYUsingScreenValues(x,y); 
  }
}

// add commands to ToDoList
void penUp() {
  ToDoList = (PVector[]) append(ToDoList, new PVector(-30, 0)); //Command 30 (raise pen)
}

void penDown() {
  ToDoList = (PVector[]) append(ToDoList, new PVector(-31, 0)); //Command 31 (lower pen)
}

// check to see if the head is parked
boolean isParkedQ() {
  PVector cur = ToDoList[ToDoList.length-1];
  if (cur.x == -35 && cur.y == 0.0 && cur.z == 0.0) {
    if(debug) { println("Parked, yo!"); }
    return true;
  } else {
    if(debug) { println("not paaaaaaarked"); }
    return false;
  }
}




// kinect functions
// -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

PVector getKinectObjectPostion() {
  //get lerped position from global tracker object. methods defined in KinectTracker class
  PVector lerp = tracker.getLerpedPos();
  
  // adjust this position for the global kinectImageOffset pvector that is used shift the image on screen
  return new PVector(lerp.x + kinectImageOffset.x, lerp.y + kinectImageOffset.y);
}


// testing movement functions
// -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
void drawBox(float xStart, float yStart, float width, float height)
{
  penUp();

  // Command Code: Move to first (X,Y) point -- at top left corner of rectangle
  ToDoList = (PVector[]) append(ToDoList, new PVector(xStart, yStart));

  penDown();

  // DRAW BOX. Top Left -> Top Right -> Bottom Right -> Bottom Left
  // Command - Move from top left to top right corner
  ToDoList = (PVector[]) append(ToDoList, new PVector(xStart + width, yStart));
  // Command - Move from top right to bottom right corner
  ToDoList = (PVector[]) append(ToDoList, new PVector(xStart + width, yStart + height));
  // Command - Move from bottom right to bottom left corner
  ToDoList = (PVector[]) append(ToDoList, new PVector(xStart, yStart + height));
  // Command - Move back to top left point
  ToDoList = (PVector[]) append(ToDoList, new PVector(xStart, yStart));

  penUp();
}

void drawPoint(float xStart, float yStart) {
  // check to see if any other points have been drawn
  if(isParkedQ()) {
    penUp();
    ToDoList = (PVector[]) append(ToDoList, new PVector(xStart,yStart)); // Command Code: Move to first (X,Y) point
    penDown();
  } else {
   ToDoList = (PVector[]) append(ToDoList, new PVector(xStart,yStart)); // Command Code: Move to first (X,Y) point
  }
 
  if(debug) {
  println(ToDoList);
  //println(xStart, yStart);
  }
}
