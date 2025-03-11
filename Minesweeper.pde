import de.bezier.guido.*;
int NUM_ROWS=10; 
int NUM_COLS =10;
int NUM_MINES=25;
private ArrayList <MSButton> mines= new ArrayList<MSButton>();
private ArrayList <MSButton> safezone= new ArrayList<MSButton>();
private MSButton[][] buttons=new MSButton[NUM_ROWS][NUM_COLS];
private boolean mineSet=false;
void setup ()
{
  size(400, 450);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  for (int r=0; r<buttons.length; r++) {
    for (int c=0; c<buttons[r].length; c++) {
      buttons[r][c]=new MSButton(r, c);
    }
  }
  //setMines();
}
public void setMines(int r, int c)
{
  safezone.add(buttons[r][c]);
  for (int R=r-1; R<=r+1; R++) {
    for (int C=c-1; C<=c+1; C++) {
      if (isValid(R, C)) {
        safezone.add(buttons[R][C]);
      }
    }
  }
  while (mines.size()<NUM_MINES) {
    int row= (int)(Math.random()*NUM_ROWS);
    int col=(int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[row][col])&&!safezone.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    }
  }
}
public void draw ()
{
  background( 255 );
  if (isWon() == true)
    displayWinningMessage();
  if (isLost()==true) {
    displayLosingMessage();
  }
}
public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!mines.contains(buttons[r][c]) && !buttons[r][c].clicked) {
        return false;
      }
    }
  }
  return true;
}
public boolean isLost() {

  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (mines.contains(buttons[r][c]) && buttons[r][c].clicked&& !buttons[r][c].isFlagged()) {
        return true;
      }
    }
  }
  return false;
}

public void displayLosingMessage()
{
  pushMatrix();
  fill(0);
  text("You Lost...", 200, 425);
  popMatrix();
  for (int r = 0; r < buttons.length; r++) {
    for (int c = 0; c < buttons[r].length; c++) {
      if (mines.contains(buttons[r][c]) && buttons[r][c].isClicked() == false) {
        buttons[r][c].setLabel("!!");
        buttons[r][c].bomb();
      }
    }
  }
}
public void displayWinningMessage()
{
  pushMatrix();
  fill(0);
  text("You Won!", 200, 425);
  popMatrix();
  System.out.println("You Win!");
}
public boolean isValid(int row, int col) {
  if (row<NUM_ROWS&&col<NUM_COLS&&0<=row&&0<=col) {
    return true;
  }
  return false;
}

public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r=row-1; r<=row+1; r++) {
    for (int c=col-1; c<=col+1; c++) {
      if (isValid(r, c)==true&&mines.contains(buttons[r][c])) {
        numMines++;
      }
    }
  }

  if (mines.contains(buttons[row][col])) {
    numMines--;
  }

  return numMines;
}


public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    if (mouseButton==LEFT&&!mineSet) {
      setMines(myRow, myCol);
      mineSet=true;
    }
    if (mouseButton==RIGHT) {
      if (flagged==false) {
        flagged=true;
      } else {
        flagged=false;
        clicked=false;
      }
    } else if ( mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol)>0) {
      myLabel=""+countMines(myRow, myCol);
    } else
      for (int r = myRow - 1; r <= myRow + 1; r++) {
        for (int c = myCol - 1; c <= myCol + 1; c++) {
          if (isValid(r, c)&&!buttons[r][c].isClicked()) {
            buttons[r][c].mousePressed();
          }
        }
      }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);

    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean isClicked() {
    return clicked;
  }
  public void bomb() {
    clicked=true;
  }
}


