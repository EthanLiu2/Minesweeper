import de.bezier.guido.*;
int NUM_ROWS=5; 
int NUM_COLS = 5;
int NUM_MINES=5;
private ArrayList <MSButton> mines= new ArrayList<MSButton>();
private MSButton[][] buttons=new MSButton[NUM_ROWS][NUM_COLS];
void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  for (int r=0; r<buttons.length; r++) {
    for (int c=0; c<buttons[r].length; c++) {
      buttons[r][c]=new MSButton(r, c);
    }
  }



  setMines();
}
public void setMines()
{

  while (mines.size()<NUM_MINES) {
    int row= (int)(Math.random()*NUM_ROWS);
    int col=(int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
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
public void displayLosingMessage()
{
    for (int r = 0; r < buttons.length; r++) {
    for (int c = 0; c < buttons[r].length; c++) {
      if (mines.contains(buttons[r][c]) && buttons[r][c].isClicked() == false) {
        buttons[r][c].setLabel("!!");
        buttons[r][c].bomb();
      }
    }
  }
  System.out.println("You Lose!");
}
public void displayWinningMessage()
{
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
    if (mouseButton==RIGHT) {
      if (flagged==false) {
        flagged=true;
      } else {
        flagged=false;
        clicked=false;
      }
    } else if ( mines.contains(buttons[myRow][myCol])) {
      displayLosingMessage();
    } else if (countMines(myRow,myCol)>0) {
   myLabel=""+countMines(myRow,myCol);
    }
else
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
  public boolean isClicked(){
  return clicked;
  }
  public void bomb(){
  clicked=true;
  }
}




