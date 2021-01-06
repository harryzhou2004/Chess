import processing.net.*;

Client myClient;

color lightbrown = #96B0C1;
color darkbrown  = #507087;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
int row1, col1, row2, col2, rowM, colM, pR, pC;
int r1, c1, r2, c2;
char lastPiece;

boolean itsMyTurn = false;
boolean pPromotion = false;
boolean zkey, rkey, bkey, kkey, qkey;

char grid[][] = {
  {'R', 'B', 'N', 'Q', 'K', 'N', 'B', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'b', 'n', 'q', 'k', 'n', 'b', 'r'}
};

void setup() {
  size(800, 800);

  myClient = new Client(this, "127.0.0.1", 1234);

  firstClick = true;

  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");

  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");
}

void draw() {
  stroke(2);
  strokeWeight(1);
  drawBoard();
  drawPieces();
  highlightSquare();
  recieveMove();
  takeBack();
  promotion();
}

void recieveMove() {

  if (myClient.available() > 0) {
    String incoming = myClient.readString();
    r1 = int(incoming.substring(0, 1));
    c1 = int(incoming.substring(2, 3));
    r2 = int(incoming.substring(4, 5));
    c2 = int(incoming.substring(6, 7));
    //int rM = int(incoming.substring(0, 1));
    //int cM = int(incoming.substring(2, 3));
    //int rT = int(incoming.substring(4, 5));
    //int cT = int(incoming.substring(6, 7));
    int identifier = int(incoming.substring(8, 9));

    if (identifier == 1) {
      grid[r2][c2] = grid[r1][c1];
      grid[r1][c1] = ' ';
      itsMyTurn = true;
    }
    if (identifier == 2) {
      grid[r1][c1] = grid[r2][c2];
      grid[r2][c2] = ' ';
    }
    if (identifier == 3 && r2 == 1) {
      grid[r1][c1] = 'r';
    }
    if (identifier == 3 && r2 == 2) {
      grid[r1][c1] = 'b';
    }
    if (identifier == 3 && r2 == 3) {
      grid[r1][c1] = 'n';
    }
    if (identifier == 3 && r2 == 4) {
      grid[r1][c1] = 'q';
    }
  }
}

void promotion() {
  if (pPromotion) {
    rectMode(CENTER);
    textAlign(CENTER);
    fill(140, 205, 247, 200);
    noStroke();
    rect(width/2, 425, 500, 200);
    fill(0);
    textSize(40);
    image(wrook, 177, 357, 75, 75);
    text("R", 215, 482);
    image(wbishop, 302, 357, 75, 75);
    text("B", 340, 482);
    image(wknight, 427, 357, 75, 75);
    text("K", 465, 482);
    image(wqueen, 552, 357, 75, 75);
    text("Q", 590, 482);
  }
  if (pPromotion) {
    if (rkey) {
      grid[row2][col2] = 'R';
      myClient.write(row2 + "," + col2 + "," + 1 + "," + 0 + "," + "3");
      pPromotion = false;
    }
    if (bkey) {
      grid[row2][col2] = 'B';
      myClient.write(row2 + "," + col2 + "," + 2 + "," + 0 + "," + "3");
      pPromotion = false;
    }
    if (kkey) {
      grid[row2][col2] = 'N';
      myClient.write(row2 + "," + col2 + "," + 3 + "," + 0 + "," + "3");
      pPromotion = false;
    }
    if (qkey) {
      grid[row2][col2] = 'Q';
      myClient.write(row2 + "," + col2 + "," + 4 + "," + 0 + "," + "3");
      pPromotion = false;
    }
  }
}

void highlightSquare() {
  if (itsMyTurn) {
    if (firstClick == false) {
      noFill();
      stroke(#FE4365);
      strokeWeight(10);
      rect(col1*100, row1*100, 100, 100);
    }
  }
}

void drawBoard() {
  rectMode(CORNER);
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) { 
      if ( (r%2) == (c%2) ) { 
        fill(lightbrown);
      } else { 
        fill(darkbrown);
      }
      rect(c*100, r*100, 100, 100);
    }
  }
}

void drawPieces() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'r') image (wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image (brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image (wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image (bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image (wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image (bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image (wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image (bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image (wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image (bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image (wpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image (bpawn, c*100, r*100, 100, 100);
    }
  }
}

void takeBack() {
  if (!(itsMyTurn) && zkey) {
    grid[row2][col2] = grid[rowM][colM];
    grid[rowM][colM] = lastPiece;
    myClient.write(rowM + "," + colM + "," + pR + "," + pC + "," + "2");
    zkey = false;
  }
}

void mouseReleased() {
  if (itsMyTurn) {
    if (firstClick) {
      row1 = rowM = mouseY/100;
      col1 = colM = mouseX/100;
      lastPiece = grid[row1][col1];
      if (grid[row1][col1] == ' ') {
        firstClick = true;
      } else {
        firstClick = false;
      }
    } else {
      row2 = pR = mouseY/100;
      col2 = pC = mouseX/100;
      if (!(row2 == row1 && col2 == col1)) {
        grid[row2][col2] = grid[row1][col1];
        grid[row1][col1] = ' ';
        myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + "1");
        firstClick = true;
        if (row2 == 7 && grid[row2][col2] == 'P') pPromotion = true;
        println(row2);
        itsMyTurn = false;
      }
    }
  }
}

void keyPressed() {
  if (key == 'z' || key == 'Z') {
    zkey = true;
  } 
  if (key == 'r' || key == 'R') {
    rkey = true;
  } 
  if (key == 'b' || key == 'B') {
    bkey = true;
  } 
  if (key == 'k' || key == 'K') {
    kkey = true;
  } 
  if (key == 'q' || key == 'q') {
    qkey = true;
  } 
}

void keyReleased() {
  if (key == 'z' || key == 'Z') {
    zkey = false;
  } 
  if (key == 'r' || key == 'R') {
    rkey = false;
  } 
  if (key == 'b' || key == 'B') {
    bkey = false;
  } 
  if (key == 'k' || key == 'K') {
    kkey = false;
  } 
  if (key == 'q' || key == 'q') {
    qkey = false;
  } 

}
