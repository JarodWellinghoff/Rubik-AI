import peasy.*;

PeasyCam cam;

// Params that can be edited
int dim = 3;
float SIZE = 15.0;
float INTERVAL = 10.0; 
int TOTAL_SCRAMBLE_TURNS = min(dim*50, 500);

// Params that should remain untouched
color GREEN = color(0, 168, 93);
color BLUE = color(25, 59, 255);
color WHITE = color(255, 255, 255);
color YELLOW = color(255, 232, 54);
color ORANGE = color(255, 105, 0);
color RED = color(184, 0, 0);
color BLANK = color(0, 0, 0);
float SPEED = HALF_PI/INTERVAL;
char possible_keys[] = {'f', 'b', 'l', 'r','t', 'd'};
int direction = 0;

int k = 0;
int j = 0;
int i = 0;
int frame = 0;

int intervals[][]; 
boolean toggles[][];
int selected_section = 1;
int turns = 1;
boolean scramble = false;
int scramble_turns = 0;

Rubik rubik;

void setup() {
// SPEED = HALF_PI/SPEED; 
  for (int i = 0; i < dim-2; i++) {
    possible_keys = append(possible_keys, 'x');
    possible_keys = append(possible_keys, 'y');
    possible_keys = append(possible_keys, 'z');
  }
  for (char c : possible_keys) {
    println(c);
  }
  size(800, 800, P3D);
  frameRate(60);
  textMode(SHAPE);
  surface.setTitle("Rubik's Cube");

  rubik = new Rubik();
  cam = new PeasyCam(this, int(round(dim*SIZE*3.3333)));

  cam.setMinimumDistance(int(round(dim*SIZE*3.3333)));
  cam.setMaximumDistance(int(round(dim*SIZE*4.3333)));
  cam.rotateY(-QUARTER_PI);
  cam.rotateX(QUARTER_PI/2);

  // Initialize intervals and toggles for each axis to 0 and false
  int a = max(dim, 6);
  intervals = new int[4][a];
  // toggles = new boolean[dim][dim];
  for (int j = 0; j < 6; j++) {
    intervals[0][j] = 0;
    // toggles[i][j] = false;
  }
  
  for (int i = 1; i < 4; i++) {
    for (int j = 0; j < dim-2; j++) {
      intervals[i][j] = 0;
      // toggles[i][j] = false;
    }
  }

  rubik.print_current_cube();
}

void draw() {
  frame +=1;
  background(200);
  drawAxis();
  rubik.display();
  
  // if (frame % 50 == 0) {
  //   if (i < dim-1) {
  //     i += 1;
  //   } else if (j < dim-1) {
  //     i = 0;
  //     j += 1;
  //   } else if (k < 5) {
  //     i = 0;
  //     j = 0;
  //     k += 1;
  //   } else {
  //     i = 0;
  //     j = 0;
  //     k = 0;
  //   }
  // }
  // rubik.faces[k][j][i].display();
        

  // Check if any intervals are non-zero
  for (int i = 0; i < 6; i++) {
    if (intervals[0][i] != 0) {
      intervals[0][i] += 1;
      rubik.rotate(0, i, SPEED, direction);
      if ((intervals[0][i]-1) == INTERVAL) {
        intervals[0][i] = 0;
        // rubik.rotateMatrix(0, i, direction);
        // rubik.print_current_cube();
        
          rubik.rotate(0, i, -HALF_PI, direction);
        // if (direction == 0) {
        // } else {
        //   rubik.rotate(0, i, HALF_PI);
        // }
      }
    }
  }

  for (int i = 1; i < 4; i++) {
    for (int j = 1; j < dim-1; j++) {
      if (intervals[i][j] != 0) {
          intervals[i][j] += 1;
        rubik.rotate(i, selected_section, SPEED, direction);
        // println(intervals[i][j]+1 % INTERVAL);
        if ((intervals[i][j]-1) == INTERVAL) {
          intervals[i][j] = 0;
          // rubik.rotateMatrix(i, selected_section);
          // rubik.print_current_cube();
          rubik.rotate(0, i, -HALF_PI, direction);
          // if (direction == 0) {
          //   rubik.rotate(0, i, -HALF_PI);
          // } else {
          //   rubik.rotate(0, i, HALF_PI);
          // }
        }
      }
    }
  }

  if (scramble && scramble_turns < TOTAL_SCRAMBLE_TURNS) {
    // Check if any intervals are non-zero
    for (int i = 0; i < 6; i++) {
      if (intervals[0][i] != 0) {
        return;
      }
    }

    for (int i = 1; i < 4; i++) {
      for (int j = 1; j < dim-1; j++) {
        if (intervals[i][j] != 0) {
          return;
        }
      }
    }

    char key = possible_keys[int(random(0, possible_keys.length))];
    if (key == 'x' || key == 'y' || key == 'z') {
      selected_section = int(random(1, dim-1));
    }
    direction = int(random(0, 2));
    simulateKeyPress(key);
    scramble_turns += 1;
    println(scramble_turns);
    if (scramble_turns == TOTAL_SCRAMBLE_TURNS) {
      println("Scramble complete!");
      scramble = false;
      scramble_turns = 0;
    }
  }

}

void drawAxis() {
  //float cam_pos[] = cam.getPosition();
  //printArray(cam_pos);
  stroke(BLANK);
  line(-SIZE*dim, 0, 0, 0, 0, 0);
  textSize(10);
  fill(0);
  text("-x", -SIZE*dim, 0, 0);

  fill(RED);
  strokeWeight(5);
  stroke(RED);
  line(0, 0, 0, SIZE*dim, 0, 0);
  text("+x", SIZE*dim, 0, 0);

  stroke(BLANK);
  line(0, -SIZE*dim, 0, 0, 0, 0);
  fill(0);
  text("-y", 0, -SIZE*dim, 0);

  fill(GREEN);
  stroke(GREEN);
  line(0, 0, 0, 0, SIZE*dim, 0);
  text("+y", 0, SIZE*dim, 0);

  stroke(BLANK);
  line(0, 0, -SIZE*dim, 0, 0, 0);
  fill(0);
  text("-z", 0, 0, -SIZE*dim);

  fill(BLUE);
  stroke(BLUE);
  line(0, 0, 0, 0, 0, SIZE*dim);
  text("+z", 0, 0, SIZE*dim);
}

void keyPressed() {
  // println(key);

  // Exit program if escape is pressed
  if (key == ESC) {
    exit();
  }
  // Print current cube if 'p' is pressed
  if (key == 'p') {
    rubik.print_current_cube();
  }
  // Scramble cube if 's' is pressed
  if (key == 's') {
    scramble = true;
  }
  // Increase selected_section if '+' is pressed
  // Decrease selected_section if '-' is pressed
  // Limit selected_section to between 1 and dim-2
  // Make sure all intervals are 0 before changing selected_section
  for (int i = 0; i < 6; i++) {
    if (intervals[0][i] != 0) {
      return;
    }
  }

  for (int i = 1; i < 4; i++) {
    for (int j = 1; j < dim-2; j++) {
      if (intervals[i][j] != 0) {
        return;
      }
    }
  }

  if (key == '+') {
    selected_section = min(selected_section+1, dim-2);
    println("selected section = " + selected_section);
  } else if (key == '-') {
    selected_section = max(selected_section-1, 1);
    println("selected section = " + selected_section);
  }

  if (key == '1') {
    turns = 1;
  } else if (key == '2') {
    turns = 2;
  }
  // Rotate Front face if 'f' is pressed
  // Rotate Back face if 'b' is pressed
  // Rotate Left face if 'l' is pressed
  // Rotate Right face if 'r' is pressed
  // Rotate Top face if 't' is pressed
  // Rotate Bottom face if 'b' is pressed
  if (key == 'f') {
    intervals[0][FaceType.FRONT] += 1;
  } else if (key == 'b') {
    intervals[0][FaceType.BACK] = 1;
  } else if (key == 'l') {
    intervals[0][FaceType.LEFT] = 1;
  } else if (key == 'r') {
    intervals[0][FaceType.RIGHT] = 1;
  } else if (key == 't') {
    intervals[0][FaceType.TOP] = 1;
  } else if (key == 'd') {
    intervals[0][FaceType.BOTTOM] = 1;
  } else if (key == 'x') {
    intervals[1][selected_section] = 1;
  } else if (key == 'y') {
    intervals[2][selected_section] = 1;
  } else if (key == 'z') {
    intervals[3][selected_section] = 1;
  }
}

void simulateKeyPress(char simKey) {
  key = simKey;
  // keyCode = 65;
  keyPressed();
  key = 0;
  keyCode = 0;
}

