class Rubik {
  Face[][][] faces;
  float mX;
  float mY;
  float mZ;

  Rubik() {faces = new Face[6][dim][dim];

    float max_distance = (float(dim)/2.0);
    if (dim % 2 != 0) {
      max_distance -= 0.5;
    }

    max_distance *= SIZE;
    if (dim % 2 == 0) {
      max_distance -= SIZE*0.5;
    }

    // Front face: -y, -x
    mY = -max_distance;
    for (int j = 0; j < dim; j++) {
      mX = -max_distance;
      for (int i = 0; i < dim; i++) {
        faces[0][j][i] = new Face(mX, mY, 0.0, 0);
        mX += SIZE;
      }
      mY += SIZE;
    }
    // Left face: -z, -y
      mY = -max_distance;
    for (int j = 0; j < dim; j++) {
    mZ = -max_distance;
      for (int i = 0; i < dim; i++) {
        faces[1][j][i] = new Face(0.0, mY, mZ, 1);
      mZ += SIZE;
      }
        mY += SIZE;
    }
    // Right face: +z, -y
      mY = -max_distance;
    for (int j = 0; j < dim; j++) {
    mZ = max_distance;
      for (int i = 0; i < dim; i++) {
        faces[2][j][i] = new Face(0.0, mY, mZ, 2);
      mZ -= SIZE;
      }
        mY += SIZE;
    }
    // Back face: x, -y
    mY = -max_distance;
    for (int j = 0; j < dim; j++) {
      mX = max_distance;
      for (int i = 0; i < dim; i++) {
        faces[3][j][i] = new Face(mX, mY, 0.0, 3);
        mX -= SIZE;
      }
      mY += SIZE;
    }
    // Top face: -x, -z
    mZ = -max_distance;
    for (int j = 0; j < dim; j++) {
      mX = -max_distance;
      for (int i = 0; i < dim; i++) {
        faces[4][j][i] = new Face(mX, 0.0, mZ, 4);
        mX += SIZE;
      }
      mZ += SIZE;
    }
    // Bottom face: -x, +z
    mZ = max_distance;
    for (int j = 0; j < dim; j++) {
      mX = -max_distance;
      for (int i = 0; i < dim; i++) {
        faces[5][j][i] = new Face(mX, 0.0, mZ, 5);
        mX += SIZE;
      }
      mZ -= SIZE;
    }

    for (int face = 0; face < 6; face++) {
      int index = 0;
      for (int i = 0; i < dim; i++) {
        for (int j = 0; j < dim; j++) {
          faces[face][i][j].current_label = new String(faces[face][i][j].current_label + base10_to_base64(index++));
          //println("face[" + face + "][" + i + "][" + j + "] = " + faces[face][i][j]);
        }
      }
    }
  }

  void rotateMatrix(int i, int section, int direction) {
    if (i == 0) {
      if (section == 0) {
        rotateFrontMatrix();
      } else if (section == 1) {
        rotateLeftMatrix();
      } else if (section == 2) {
        rotateRightMatrix();
      } else if (section == 3) {
        rotateBackMatrix();
      } else if (section == 4) {
        rotateUpperMatrix();
      } else if (section == 5) {
        rotateDownMatrix();
      }
    } else if (i == 1) {
      rotateAroundXMatrix(section);
    } else if (i == 2) {
      rotateAroundYMatrix(section);
    } else if (i == 3) {
      rotateAroundZMatrix(section);
    }
  }

  void rotate(int i, int section, float speed, int direction) {
    if (i == 0) {
      if (section == 0) {
        rotateFrontVisual(speed, direction);
      } else if (section == 1) {
        rotateLeftVisual(speed, direction);
      } else if (section == 2) {
        rotateRightVisual(speed, direction);
      } else if (section == 3) {
        rotateBackVisual(speed, direction);
      } else if (section == 4) {
        rotateUpperVisual(speed, direction);
      } else if (section == 5) {
        rotateDownVisual(speed, direction);
      }
    } else if (i == 1) {
      rotateAroundX(section, speed, direction);
    } else if (i == 2) {
      rotateAroundY(section, speed, direction);
    } else if (i == 3) {
      rotateAroundZ(section, speed, direction);
    }
  }

  void rotateFrontVisual(float speed, int direction) {
    if (direction == 1) {
      speed = -speed;
    }
    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < dim; j++) {
        faces[FaceType.FRONT][i][j].rotateZ(speed);
      }
      faces[FaceType.LEFT][i][dim-1].rotateZ(speed);
      faces[FaceType.RIGHT][i][0].rotateZ(speed);
      faces[FaceType.TOP][dim-1][i].rotateZ(speed);
      faces[FaceType.BOTTOM][0][i].rotateZ(speed);
    }
  }

  void rotateFrontMatrix() {
    // Rotate the faces[FaceType.FRONT] matrix 90 degrees clockwise
    // Only rotate the c and cs attributes of each face
    rotateFaceMatrixClockwise(FaceType.FRONT);
    // Move the adjacent faces to the correct position
    // Left face: -y, -z
    for (int i = 0; i < dim; i++) {
      int j = dim-1-i;
      int temp = faces[FaceType.LEFT][i][dim-1].c;
      String temp1 = faces[FaceType.LEFT][i][dim-1].current_label;

      faces[FaceType.LEFT][i][dim-1].c = faces[FaceType.BOTTOM][0][i].c;
      faces[FaceType.LEFT][i][dim-1].current_label = faces[FaceType.BOTTOM][0][i].current_label;

      faces[FaceType.BOTTOM][0][i].c = faces[FaceType.RIGHT][j][0].c;
      faces[FaceType.BOTTOM][0][i].current_label = faces[FaceType.RIGHT][j][0].current_label;

      faces[FaceType.RIGHT][j][0].c = faces[FaceType.TOP][dim-1][j].c;
      faces[FaceType.RIGHT][j][0].current_label = faces[FaceType.TOP][dim-1][j].current_label;

      faces[FaceType.TOP][dim-1][j].c = temp;
      faces[FaceType.TOP][dim-1][j].current_label = temp1;
    }
  }

  void rotateBackVisual(float speed, int direction) {
    if (direction == 1) {
      speed = -speed;
    }
    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < dim; j++) {
        faces[FaceType.BACK][i][j].rotateZ(-speed);
      }
      faces[FaceType.LEFT][i][0].rotateZ(-speed);
      faces[FaceType.RIGHT][i][dim-1].rotateZ(-speed);
      faces[FaceType.TOP][0][i].rotateZ(-speed);
      faces[FaceType.BOTTOM][dim-1][i].rotateZ(-speed);
    }
  }

  void rotateBackMatrix() {
    // Rotate the faces[FaceType.BACK] matrix 90 degrees clockwise
    // Only rotate the c and cs attributes of each face
    rotateFaceMatrixClockwise(FaceType.BACK);
    // Move the adjacent faces to the correct position
    // Left face: +y, +z
    for (int i = 0; i < dim; i++) {
      int j = dim-1-i;
      int temp = faces[FaceType.LEFT][i][0].c;
      String temp1 = faces[FaceType.LEFT][i][0].current_label;

      faces[FaceType.LEFT][i][0].c = faces[FaceType.TOP][0][j].c;
      faces[FaceType.LEFT][i][0].current_label = faces[FaceType.TOP][0][j].current_label;

      faces[FaceType.TOP][0][j].c = faces[FaceType.RIGHT][j][dim-1].c;
      faces[FaceType.TOP][0][j].current_label = faces[FaceType.RIGHT][j][dim-1].current_label;

      faces[FaceType.RIGHT][j][dim-1].c = faces[FaceType.BOTTOM][dim-1][i].c;
      faces[FaceType.RIGHT][j][dim-1].current_label = faces[FaceType.BOTTOM][dim-1][i].current_label;

      faces[FaceType.BOTTOM][dim-1][i].c = temp;
      faces[FaceType.BOTTOM][dim-1][i].current_label = temp1;
    }
  }

  void rotateLeftVisual(float speed, int direction) {
    if (direction == 1) {
      speed = -speed;
    }
    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < dim; j++) {
        faces[FaceType.LEFT][i][j].rotateX(-speed);
      }
      faces[FaceType.FRONT][i][0].rotateX(-speed);
      faces[FaceType.BACK][i][dim-1].rotateX(-speed);
      faces[FaceType.TOP][i][0].rotateX(-speed);
      faces[FaceType.BOTTOM][i][0].rotateX(-speed);
    }
  }

  void rotateLeftMatrix() {
    // Rotate the faces[FaceType.LEFT] matrix 90 degrees clockwise
    // Only rotate the c and cs attributes of each face
    rotateFaceMatrixClockwise(FaceType.LEFT);
    // Move the adjacent faces to the correct position
    // Front face: -y, +x
    for (int i = 0; i < dim; i++) {
      int j = dim-1-i;
      int temp = faces[FaceType.FRONT][i][0].c;
      String temp1 = faces[FaceType.FRONT][i][0].current_label;

      faces[FaceType.FRONT][i][0].c = faces[FaceType.TOP][i][0].c;
      faces[FaceType.FRONT][i][0].current_label = faces[FaceType.TOP][i][0].current_label;

      faces[FaceType.TOP][i][0].c = faces[FaceType.BACK][j][dim-1].c;
      faces[FaceType.TOP][i][0].current_label = faces[FaceType.BACK][j][dim-1].current_label;

      faces[FaceType.BACK][j][dim-1].c = faces[FaceType.BOTTOM][i][0].c;
      faces[FaceType.BACK][j][dim-1].current_label = faces[FaceType.BOTTOM][i][0].current_label;

      faces[FaceType.BOTTOM][i][0].c = temp;
      faces[FaceType.BOTTOM][i][0].current_label = temp1;
    }
  }

  void rotateRightVisual(float speed, int direction) {
    if (direction == 1) {
      speed = -speed;
    }
    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < dim; j++) {
        faces[FaceType.RIGHT][i][j].rotateX(speed);
      }
      faces[FaceType.FRONT][i][dim-1].rotateX(speed);
      faces[FaceType.BACK][i][0].rotateX(speed);
      faces[FaceType.TOP][i][dim-1].rotateX(speed);
      faces[FaceType.BOTTOM][i][dim-1].rotateX(speed);
    }
  }

  void rotateRightMatrix() {
    // Rotate the faces[FaceType.RIGHT] matrix 90 degrees clockwise
    // Only rotate the c and cs attributes of each face
    rotateFaceMatrixClockwise(FaceType.RIGHT);
    // Move the adjacent faces to the correct position
    // Front face: +y, -x
    for (int i = 0; i < dim; i++) {
      int j = dim-1-i;
      int temp = faces[FaceType.FRONT][i][dim-1].c;
      String temp1 = faces[FaceType.FRONT][i][dim-1].current_label;

      faces[FaceType.FRONT][i][dim-1].c = faces[FaceType.BOTTOM][i][dim-1].c;
      faces[FaceType.FRONT][i][dim-1].current_label = faces[FaceType.BOTTOM][i][dim-1].current_label;

      faces[FaceType.BOTTOM][i][dim-1].c = faces[FaceType.BACK][j][0].c;
      faces[FaceType.BOTTOM][i][dim-1].current_label = faces[FaceType.BACK][j][0].current_label;

      faces[FaceType.BACK][j][0].c = faces[FaceType.TOP][i][dim-1].c;
      faces[FaceType.BACK][j][0].current_label = faces[FaceType.TOP][i][dim-1].current_label;

      faces[FaceType.TOP][i][dim-1].c = temp;
      faces[FaceType.TOP][i][dim-1].current_label = temp1;
    }
  }

  void rotateUpperVisual(float speed, int direction) {
    if (direction == 1) {
      speed = -speed;
    }
    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < dim; j++) {
        faces[FaceType.TOP][i][j].rotateY(-speed);
      }
      faces[FaceType.FRONT][0][i].rotateY(-speed);
      faces[FaceType.BACK][0][i].rotateY(-speed);
      faces[FaceType.LEFT][0][i].rotateY(-speed);
      faces[FaceType.RIGHT][0][i].rotateY(-speed);
    }
  }

  void rotateUpperMatrix() {
    // Rotate the faces[FaceType.TOP] matrix 90 degrees clockwise
    // Only rotate the c and cs attributes of each face
    rotateFaceMatrixClockwise(FaceType.TOP);
    // Move the adjacent faces to the correct position
    // Front face: -x, -y
    for (int i = 0; i < dim; i++) {
      int j = dim-1-i;
      int temp = faces[FaceType.FRONT][0][i].c;
      String temp1 = faces[FaceType.FRONT][0][i].current_label;

      faces[FaceType.FRONT][0][i].c = faces[FaceType.RIGHT][0][i].c;
      faces[FaceType.FRONT][0][i].current_label = faces[FaceType.RIGHT][0][i].current_label;

      faces[FaceType.RIGHT][0][i].c = faces[FaceType.BACK][0][i].c;
      faces[FaceType.RIGHT][0][i].current_label = faces[FaceType.BACK][0][i].current_label;

      faces[FaceType.BACK][0][i].c = faces[FaceType.LEFT][0][i].c;
      faces[FaceType.BACK][0][i].current_label = faces[FaceType.LEFT][0][i].current_label;

      faces[FaceType.LEFT][0][i].c = temp;
      faces[FaceType.LEFT][0][i].current_label = temp1;
    }
  }

  void rotateDownVisual(float speed, int direction) {
    if (direction == 1) {
      speed = -speed;
    }
    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < dim; j++) {
        faces[FaceType.BOTTOM][i][j].rotateY(speed);
      }
      faces[FaceType.FRONT][dim-1][i].rotateY(speed);
      faces[FaceType.BACK][dim-1][i].rotateY(speed);
      faces[FaceType.LEFT][dim-1][i].rotateY(speed);
      faces[FaceType.RIGHT][dim-1][i].rotateY(speed);
    }
  }

  void rotateDownMatrix() {
    // Rotate the faces[FaceType.BOTTOM] matrix 90 degrees clockwise
    // Only rotate the c and cs attributes of each face
    rotateFaceMatrixClockwise(FaceType.BOTTOM);
    // Move the adjacent faces to the correct position
    // Front face: +x, +y
    for (int i = 0; i < dim; i++) {
      int j = dim-1-i;
      int temp = faces[FaceType.FRONT][dim-1][i].c;
      String temp1 = faces[FaceType.FRONT][dim-1][i].current_label;

      faces[FaceType.FRONT][dim-1][i].c = faces[FaceType.LEFT][dim-1][i].c;
      faces[FaceType.FRONT][dim-1][i].current_label = faces[FaceType.LEFT][dim-1][i].current_label;

      faces[FaceType.LEFT][dim-1][i].c = faces[FaceType.BACK][dim-1][i].c;
      faces[FaceType.LEFT][dim-1][i].current_label = faces[FaceType.BACK][dim-1][i].current_label;

      faces[FaceType.BACK][dim-1][i].c = faces[FaceType.RIGHT][dim-1][i].c;
      faces[FaceType.BACK][dim-1][i].current_label = faces[FaceType.RIGHT][dim-1][i].current_label;

      faces[FaceType.RIGHT][dim-1][i].c = temp;
      faces[FaceType.RIGHT][dim-1][i].current_label = temp1;
    }
  }

  void rotateAroundZ(int section, float speed, int direction) {
    if (direction == 1) {
      speed = -speed;
    }
      for (int i = 0; i < dim; i++) {
        faces[FaceType.LEFT][i][dim-1-section].rotateZ(speed);
        faces[FaceType.RIGHT][i][section].rotateZ(speed);
        faces[FaceType.TOP][dim-1-section][i].rotateZ(speed);
        faces[FaceType.BOTTOM][section][i].rotateZ(speed);
      }
    
  }

  void rotateAroundZMatrix(int section) {
    for (int i = 0; i < dim; i++) {
      int j = dim-1-i;
      int temp = faces[FaceType.LEFT][i][dim-1-section].c;
      String temp1 = faces[FaceType.LEFT][i][dim-1-section].current_label;

      faces[FaceType.LEFT][i][dim-1-section].c = faces[FaceType.BOTTOM][section][i].c;
      faces[FaceType.LEFT][i][dim-1-section].current_label = faces[FaceType.BOTTOM][section][i].current_label;

      faces[FaceType.BOTTOM][section][i].c = faces[FaceType.RIGHT][j][section].c;
      faces[FaceType.BOTTOM][section][i].current_label = faces[FaceType.RIGHT][j][section].current_label;

      faces[FaceType.RIGHT][j][section].c = faces[FaceType.TOP][dim-1-section][j].c;
      faces[FaceType.RIGHT][j][section].current_label = faces[FaceType.TOP][dim-1-section][j].current_label;

      faces[FaceType.TOP][dim-1-section][j].c = temp;
      faces[FaceType.TOP][dim-1-section][j].current_label = temp1;
    }
  }

  void rotateAroundY(int section, float speed, int direction) {
    if (direction == 1) {
      speed = -speed;
    }
      for (int i = 0; i < dim; i++) {
        faces[FaceType.FRONT][section][i].rotateY(speed);
        faces[FaceType.BACK][section][i].rotateY(speed);
        faces[FaceType.LEFT][section][i].rotateY(speed);
        faces[FaceType.RIGHT][section][i].rotateY(speed);
      }
    
  }

  void rotateAroundYMatrix(int section) {
    for (int i = 0; i < dim; i++) {
      int j = dim-1-i;
      int temp = faces[FaceType.FRONT][section][i].c;
      String temp1 = faces[FaceType.FRONT][section][i].current_label;

      faces[FaceType.FRONT][section][i].c = faces[FaceType.LEFT][section][i].c;
      faces[FaceType.FRONT][section][i].current_label = faces[FaceType.LEFT][section][i].current_label;

      faces[FaceType.LEFT][section][i].c = faces[FaceType.BACK][section][i].c;
      faces[FaceType.LEFT][section][i].current_label = faces[FaceType.BACK][section][i].current_label;

      faces[FaceType.BACK][section][i].c = faces[FaceType.RIGHT][section][i].c;
      faces[FaceType.BACK][section][i].current_label = faces[FaceType.RIGHT][section][i].current_label;

      faces[FaceType.RIGHT][section][i].c = temp;
      faces[FaceType.RIGHT][section][i].current_label = temp1;
    }
  }

  void rotateAroundX(int section, float speed, int direction) {
    if (direction == 1) {
      speed = -speed;
    }
      for (int i = 0; i < dim; i++) {
        faces[FaceType.FRONT][i][section].rotateX(speed);
        faces[FaceType.BACK][i][dim-1-section].rotateX(speed);
        faces[FaceType.TOP][i][section].rotateX(speed);
        faces[FaceType.BOTTOM][i][section].rotateX(speed);
      }
    
  }

  void rotateAroundXMatrix(int section) {
    for (int i = 0; i < dim; i++) {
      int j = dim-1-i;
      int temp = faces[FaceType.FRONT][i][section].c;
      String temp1 = faces[FaceType.FRONT][i][section].current_label;

      faces[FaceType.FRONT][i][section].c = faces[FaceType.BOTTOM][i][section].c;
      faces[FaceType.FRONT][i][section].current_label = faces[FaceType.BOTTOM][i][section].current_label;

      faces[FaceType.BOTTOM][i][section].c = faces[FaceType.BACK][j][dim-1-section].c;
      faces[FaceType.BOTTOM][i][section].current_label = faces[FaceType.BACK][j][dim-1-section].current_label;

      faces[FaceType.BACK][j][dim-1-section].c = faces[FaceType.TOP][i][section].c;
      faces[FaceType.BACK][j][dim-1-section].current_label = faces[FaceType.TOP][i][section].current_label;

      faces[FaceType.TOP][i][section].c = temp;
      faces[FaceType.TOP][i][section].current_label = temp1;
    }
  }

  void display() {
    for (int k = 0; k < 6; k++) {
      for (int j = 0; j < dim; j++) {
        for (int i = 0; i < dim; i++) {
          faces[k][j][i].display();
        }
      }
    }
  }
  void print_current_cube() {
  // FRONT = 0; GREEN
  // LEFT = 1; ORANGE
  // RIGHT = 2; RED
  // BACK = 3; BLUE
  // TOP = 4; WHITE
  // BOTTOM = 5; YELLOW

    int WY_whitespace = dim*5;
    int dash_length = WY_whitespace*4;

    for (int i = 0; i < WY_whitespace + 1; i++) {
      print(' ');
    }

    for (int i = 0; i < WY_whitespace - 1; i++) {
      print('_');
    }
    println();

    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < WY_whitespace; j++) {
        print(' ');
      }
      print('|');
      for (int k = 0; k < dim; k++) {
        if (faces[4][i][k].current_label.length() < 4) {
          print(" ");
        }
        print(faces[4][i][k].current_label);
        if (faces[4][i][k].current_label.length() < 3) {
          print(" ");
        }
        print("|");
      }
      println();

      if (i < dim-1) {
        for (int j = 0; j < WY_whitespace + 1; j++) {
          print(' ');
        }

        for (int j = 0; j < WY_whitespace - 1; j++) {
          print('-');
        }
        println();
      }
    }
    print(' ');

    for (int i = 0; i < dash_length - 1; i++) {
      print('-');
    }
    println();

    for (int i = 0; i < dim; i++) {
      print('|');
      for (int fa = 0; fa < 4; fa++) {
        int f = 0;
        if (fa == 0) {
          f = 1;
        } else if (fa == 1) {
          f = 0;
        } else {
          f = fa;
        }
        for (int j = 0; j < dim; j++) {
          if (faces[f][i][j].current_label.length() < 4) {
            print(" ");
          }
          print(faces[f][i][j].current_label);
          if (faces[f][i][j].current_label.length() < 3) {
            print(" ");
          }
          print("|");
        }
      }

      println();
      print(' ');

      for (int j = 0; j < dash_length - 1; j++) {
        print('-');
      }
      println();
    }

    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < WY_whitespace; j++) {
        print(' ');
      }
      print('|');
      for (int k = 0; k < dim; k++) {
        if (faces[5][i][k].current_label.length() < 4) {
          print(" ");
        }
        print(faces[5][i][k].current_label);
        if (faces[5][i][k].current_label.length() < 3) {
          print(" ");
        }
        print("|");
      }
      println();

      for (int j = 0; j < WY_whitespace + 1; j++) {
        print(' ');
      }

      for (int j = 0; j < WY_whitespace - 1; j++) {
        print('-');
      }
      println();
    }
    println();
  }

  String base10_to_base64(int num) {
    // Take the number and convert it to base 64 String
    if (num == 0) {
      return "0";
    }
    String base64 = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-";
    String str = "";
    int r = 0;
    while (num > 0) {
      r = num % 64;
      num -= r;
      num /= 64;
      str = base64.charAt(r) + str;
    }
    return str;
  }

  void rotateFaceMatrixClockwise(int face) {
    // Rotate the faces[face] matrix 90 degrees clockwise
    // Only rotate the c and cs attributes of each face
    for (int i = 0; i < dim/2; i++) {
      for (int j = i; j < dim-i-1; j++) {
        int temp = faces[face][i][j].c;
        String temp1 = faces[face][i][j].current_label;

        faces[face][i][j].c = faces[face][dim-1-j][i].c;
        faces[face][i][j].current_label = faces[face][dim-1-j][i].current_label;

        faces[face][dim-1-j][i].c = faces[face][dim-1-i][dim-1-j].c;
        faces[face][dim-1-j][i].current_label = faces[face][dim-1-i][dim-1-j].current_label;

        faces[face][dim-1-i][dim-1-j].c = faces[face][j][dim-1-i].c;
        faces[face][dim-1-i][dim-1-j].current_label = faces[face][j][dim-1-i].current_label;

        faces[face][j][dim-1-i].c = temp;
        faces[face][j][dim-1-i].current_label = temp1;
      }
    }
  }

  void rotateFaceMatrixAntiClockwise(int face) {
    // Rotate the faces[face] matrix 90 degrees anti-clockwise
    // Only rotate the c and cs attributes of each face
    for (int i = 0; i < dim/2; i++) {
      for (int j = i; j < dim-i-1; j++) {
        int temp = faces[face][i][j].c;
        String temp1 = faces[face][i][j].current_label;

        faces[face][i][j].c = faces[face][j][dim-1-i].c;
        faces[face][i][j].current_label = faces[face][j][dim-1-i].current_label;

        faces[face][j][dim-1-i].c = faces[face][dim-1-i][dim-1-j].c;
        faces[face][j][dim-1-i].current_label = faces[face][dim-1-i][dim-1-j].current_label;

        faces[face][dim-1-i][dim-1-j].c = faces[face][dim-1-j][i].c;
        faces[face][dim-1-i][dim-1-j].current_label = faces[face][dim-1-j][i].current_label;

        faces[face][dim-1-j][i].c = temp;
        faces[face][dim-1-j][i].current_label = temp1;
      }
    }
  }
}
