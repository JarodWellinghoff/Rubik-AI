class Face {
  float x, y, z; // Position on 3d graph
  int ft;
  float s = SIZE * 0.5;
  color c;
  PShape f;
  String current_label;

  Face (float xpos, float ypos, float zpos, int face_type) {
    this.x = xpos;
    this.y = ypos;
    this.z = zpos;
    this.ft = face_type;
    this.f = createShape();

    switch (face_type) {
    case FaceType.FRONT:
      this.c = GREEN;
      this.current_label = "G";
      f.beginShape(QUADS);
      f.fill(GREEN);
      f.vertex(-s + xpos, -s + ypos, +s*dim + zpos);
      f.vertex(+s + xpos, -s + ypos, +s*dim + zpos);
      f.vertex(+s + xpos, +s + ypos, +s*dim + zpos);
      f.vertex(-s + xpos, +s + ypos, +s*dim + zpos);
      f.endShape();
      break;
    case FaceType.LEFT:
      this.c = ORANGE;
      this.current_label = "O";
      f.beginShape(QUADS);
      f.fill(ORANGE);
      f.vertex(-s*dim + xpos, -s + ypos, +s + zpos);
      f.vertex(-s*dim + xpos, -s + ypos, -s + zpos);
      f.vertex(-s*dim + xpos, +s + ypos, -s + zpos);
      f.vertex(-s*dim + xpos, +s + ypos, +s + zpos);
      f.endShape();
      break;
    case FaceType.RIGHT:
      this.c = RED;
      this.current_label = "R";
      f.beginShape(QUADS);
      f.fill(RED);
      f.vertex(+s*dim + xpos, -s + ypos, +s + zpos);
      f.vertex(+s*dim + xpos, -s + ypos, -s + zpos);
      f.vertex(+s*dim + xpos, +s + ypos, -s + zpos);
      f.vertex(+s*dim + xpos, +s + ypos, +s + zpos);
      f.endShape();
      break;
    case FaceType.BACK:
      this.c = BLUE;
      this.current_label = "B";
      f.beginShape(QUADS);
      f.fill(BLUE);
      f.vertex(-s + xpos, -s + ypos, -s*dim + zpos);
      f.vertex(+s + xpos, -s + ypos, -s*dim + zpos);
      f.vertex(+s + xpos, +s + ypos, -s*dim + zpos);
      f.vertex(-s + xpos, +s + ypos, -s*dim + zpos);
      f.endShape();
      break;
    case FaceType.TOP:
      this.c = WHITE;
      this.current_label = "W";
      f.beginShape(QUADS);
      f.fill(WHITE);
      f.vertex(-s + xpos, -s*dim + ypos, +s + zpos);
      f.vertex(-s + xpos, -s*dim + ypos, -s + zpos);
      f.vertex(+s + xpos, -s*dim + ypos, -s + zpos);
      f.vertex(+s + xpos, -s*dim + ypos, +s + zpos);
      f.endShape();
      break;
    case FaceType.BOTTOM:
      this.c = YELLOW;
      this.current_label = "Y";
      f.beginShape(QUADS);
      f.fill(YELLOW);
      f.vertex(+s + xpos, +s*dim + ypos, +s + zpos);
      f.vertex(+s + xpos, +s*dim + ypos, -s + zpos);
      f.vertex(-s + xpos, +s*dim + ypos, -s + zpos);
      f.vertex(-s + xpos, +s*dim + ypos, +s + zpos);
      f.endShape();
      break;
    }
  }

  void rotateZ(float angle) {
    f.rotateZ(angle);
  }
  void rotateY(float angle) {
    f.rotateY(angle);
  }
  void rotateX(float angle) {
    f.rotateX(angle);
  }

  void display() {
    f.setFill(this.c);
    shape(this.f);
  }
}
