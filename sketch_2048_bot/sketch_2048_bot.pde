
final int cols = 4;
final int rows = 4;


//Mess with these for window size.
//In the setup function near the bottom, you must change the parameters in size(*, *) to be 4 times these numbers
final int w = 150;
final int h = 150;


import java.util.ArrayList;
import java.util.Collections;


//Use LEFT and RIGHT arrow keys for speed of bot
//Up arrow key to end current game


//Parameters for bot
boolean saveAfter = true;
boolean loadFile = true;
int gamesToPlay = 10;
String saveLocation = "location";
String loadLocation = "weights50000";



//Indices for N-Tuple Network
int[] firstTuple = {0, 4, 8, 12};
int[] secondTuple = {1, 5, 9, 13};
int[] thirdTuple = {1 , 2, 5, 6, 9, 10};
int[] fourthTuple = {2, 3, 6, 7, 10, 11};

int[] firstTuple2 = {0, 1, 2, 3};
int[] secondTuple2 = {4, 5, 6, 7};
int[] thirdTuple2 = {5 , 6, 7, 9, 10, 11};
int[] fourthTuple2 = {9, 10, 11, 13, 14, 15};

int[] firstTuple3 = {3, 7, 11, 15};
int[] secondTuple3 = {2, 6, 10, 14};
int[] thirdTuple3 = {5 , 6, 9, 10, 13, 14};
int[] fourthTuple3 = {4, 5, 8, 9, 12, 13};

int[] firstTuple4 = {12, 13, 14, 15};
int[] secondTuple4 = {8, 9, 10, 11};
int[] thirdTuple4 = {4, 5, 6, 8, 9, 10};
int[] fourthTuple4 = {0, 1, 2, 4, 5, 6};


int[] fourthMirrored1 = {0, 1, 4, 5, 8, 9};
int[] fourthMirrored2 = {1, 2, 3, 5, 6, 7};
int[] fourthMirrored3 = {6, 7, 10, 11, 14, 15};
int[] fourthMirrored4 = {8, 9, 10, 12, 13, 14};

int[][] tuple1Indices = {firstTuple, firstTuple2, firstTuple3, firstTuple4};
int[][] tuple2Indices = {secondTuple, secondTuple2, secondTuple3, secondTuple4};
int[][] tuple3Indices = {thirdTuple, thirdTuple2, thirdTuple3, thirdTuple};
int[][] tuple4Indices = {fourthTuple, fourthTuple2, fourthTuple3, fourthTuple4};

int[][] fourthMirrored = {fourthMirrored1, fourthMirrored2, fourthMirrored3, fourthMirrored4};

int[][][] allIndices = {tuple1Indices, tuple2Indices, tuple3Indices, tuple4Indices, fourthMirrored};


int logBase(int x, int base) {
   return (int) (Math.log(x) / Math.log(base)); 
}

int hashIndices(int[] cells, int[] indices) {
   int toReturn = 0;
   for (int index : indices) {
      toReturn *= 14;
      int val = cells[index];
      if (val != 0) {
         toReturn += logBase(val, 2); 
      }
   }
   return toReturn;
  
}

class State {
  int curScore;
  int[] cells;
  boolean[] increased;
  boolean lost;
  int[] hashes;
  
  State( boolean thisIsNewState, State oldState) {
    
    increased = new boolean[16];
    lost = false;
    hashes = new int[20];
    cells = new int[16];

    if (thisIsNewState) {     
        curScore = 0;
        //Create new board
        int index = (int) random(16);
        int index2 = (int) random(16);
        double rand = random(1);
        double rand2 = random(1);
        if (rand < .9)
          cells[index] = 2;
        else
          cells[index] = 4;
        if (rand2 < .9)
          cells[index2] = 2;
        else
          cells[index2] = 4;
         
       increased = new boolean[16];
       
       
       calcHashes();
    } else {
      //Copy an old board
       for (int i = 0; i < 16; i ++) {
          cells[i] = oldState.cells[i]; 
       }
       curScore = oldState.curScore;
       for (int i = 0; i < 20; i ++) {
          hashes[i]  = oldState.hashes[i]; 
       }
    }
  }
  

  
  void calcHashes() {
    int index = 0;
    for (int j = 0; j < 5; j++) {
        int[][] tuple = allIndices[j];   
        for (int[] tuplePos : tuple) {
           hashes[index] = hashIndices(cells, tuplePos);
           index++;
        }
    }
  }
  
  void setLost(boolean newLost) {
    lost = newLost; 
  }
  
  int move(int index, int direction) {
    
    int j = 0;
    int score = 0;
    
    if (direction == 0) {
      j = index - 1;
    } else if (direction == 1) {
      j = index + 4;
    } else if (direction == 2) {
      j = index + 1;
    } else {
       j = index - 4;  
    }
    
    int cell = cells[j];
    if (cell == cells[index]) {
       cells[j] = 2 * cell;
       score += 2 * cell;
       cells[index] = 0;
       
       increased[index] = false;
       increased[j] = true;
    }
    if (cell == 0) {
       cells[j] = cells[index];
       cells[index] = 0;
       increased[j] = increased[index];
       increased[index] = false;
    }
    
    if (cellCanMove(j, direction)) {
       return score + move(j, direction); 
      
    }
    return score;
  }
  
  
  int getMax() {
   int curMax = 0;
   
   for (int i : cells) {
      if (i > curMax)
        curMax = i;
   }
   
   return curMax;
  }
  
  
  void addScore(int aScore) {
     curScore += aScore; 
  }
  
  
  boolean cellCanMove(int index, int direction) {
   if (cells[index] == 0) 
     return false;
     
   int cell = 0;
   int y = (int) index / 4;
   int x = index - 4 * y;
   int j = -1;
    if (direction == 0) {
      if (x == 0) 
        return false;
      j = index - 1;
    } else if (direction == 1) {
      if (y == 3) 
         return false;
      j = index + 4;
    } else if (direction == 2) {
      if (x == 3) 
         return false; 
      j = index + 1;
    } else {
      if (y == 0)
        return false;
       j = index - 4;
       
    }
    
    cell = cells[j];
    return cell == 0 || (cell == cells[index] && !(increased[j] || increased[index]));
  

 }
 
  void display() {
    
       for (int i = 0; i < 16; i++) {
         int val = cells[i];
         int y = (int) i / 4;
         int x = i - y * 4;
         
        stroke(255);
       int toUse = logBase(val, 2) * 20;
       //Very arbitrary coloring scheme
       fill(toUse % 40 + toUse % 25, toUse / 3 % 100, toUse % 10 + toUse / 2);
       rect(x*w, y*h, w, h);
       fill(255);
       textAlign(CENTER);
       textSize(w / 10);
       text(val, (x+.5)*w, (y+.5)*h);
         
       }

     }

}

//
//Hyperparameter
//
double alpha = .01;


class Weight {
   
  ArrayList<ArrayList<Double>>  weights;
  State curState;
  boolean playAnother;
  int gamesLeft;
  int maxTile;
  boolean save;
  
  //num -> How many games to play
  //locToLoad -> if load is true, where to load weights from
  //load -> whether or not to load
  //save -> whether or not to save 
  Weight(int num, String locToLoad, boolean load, boolean save) {
     gamesLeft = num;
     maxTile = 0;
     this.save = save;
     weights =new ArrayList<ArrayList<Double>>();
     weights.add(new ArrayList<Double>( Collections.nCopies((int)pow(14,4), (double) 0)));
     weights.add(new ArrayList<Double>(Collections.nCopies((int)pow(14,4), (double) 0)));
     weights.add(new ArrayList<Double>(Collections.nCopies((int)pow(14,6), (double) 0)));
     weights.add(new ArrayList<Double>(Collections.nCopies((int)pow(14,6), (double) 0)));
     //print(weights.get(0).size());
     curState = new State(true, null);

     playAnother = true;
     if (load)
       loadWeights(locToLoad);
     
   }
   
   void setAnother(boolean another) {
    playAnother = another; 
   }
   
   
   
   State addRandom(State oldState) {
     ArrayList<Integer> zeros = new ArrayList<Integer>();
     
     State newState = new State(false, oldState);
     
     for (int i = 0; i < 16; i++ ) {
        if (newState.cells[i] == 0)
          zeros.add(i);
     }
     
     if (zeros.size() != 0) {
        int index = (int) random(zeros.size());
        double rand = random(1);
        if (rand < .9)
          newState.cells[zeros.get(index)] = 2;
        else
          newState.cells[zeros.get(index)] = 4;
     }
     
     return newState;
     
  }
  
  void printBoard(State curState) {
     for (int i : curState.cells) {
        print(i + " " );
        println();
     }
    
  }
   
   double v(int[] stateHashes) {
     double toReturn = 0;
     //println(stateHashes);
     boolean cont = true;
     int index= 0;
     for (int i = 0; cont; i++) {
       if (i == 4) {
         i = 3;
         cont = false;
       }
        ArrayList<Double> curWeights = weights.get(i);
       for(int j = 0; j < 4; j++) {
         //println(curWeights.size()); 
         //printBoard();
         //println(stateHashes.length);
         //println(j + " " + i);
         toReturn += curWeights.get(stateHashes[index]);
         index++;
       }
       
     }
     
     return toReturn;
     
   }
   
  
   void update(State toUpdate, State nextState, double reward) {
     boolean cont = true;
     int index = 0;
     for (int i = 0; cont; i++) {
       if (i == 4) {
         i = 3;
         cont = false;
       }
       ArrayList<Double> curWeights = weights.get(i);
       for(int j = 0; j < 4; j++) {
         double val = curWeights.get(toUpdate.hashes[index]) + alpha * (reward + v(nextState.hashes) - v(toUpdate.hashes));
         curWeights.set(toUpdate.hashes[index], val);
         index++;
       }
       
     }   
   }
   
   Object[] nextMoveState(int direction, State completeNextState) {
     State newState = new State(false, completeNextState);
     int score = 0;
     boolean moved = false;
     int index;
     for (int i = 0; i < 16; i++) {
       index = i;
        if (direction == 2 || direction == 1) {
           index = 16 - 1 - i; 
        }
        
        if (newState.cellCanMove(index, direction)) {
            score += newState.move(index, direction);
            moved = true;
        }
       
     }
              //print("DSDSDSDS");

     newState.calcHashes();
              //print("DSDSD22222SDS");

     Object[] toReturn = new Object[4];
     toReturn[0] = score;
              //print("DSDSD23425cSDS");

     toReturn[1] = v(newState.hashes);
              //print("DSDSD423424SDS");

     toReturn[2] = moved;
     toReturn[3] = newState;
     
     return toReturn;
     
   }
   
   
   int learnFromAfterState(State afterState, State completeNextState) {
     double bestScore = -999999999;
     double bestV = 0;
     int hasntMoved = 0;
     State nextState = null;
     
     
     for (int i = 0; i < 4; i++) {
         Object[] info = nextMoveState(i, completeNextState);
         int score = (int) info[0];
         double vVal = (double) info[1];
         boolean moved = (boolean) info[2];
         State newState = (State) info[3];
       
       if (!moved) {
          hasntMoved += 1;
          if (hasntMoved == 4) {
             completeNextState.setLost(true); 
          }
       } else if (score + vVal >= bestScore + bestV) {
          bestV = vVal;
          bestScore = score;
          nextState = newState;
       }
     }
     
     if (!completeNextState.lost)
       update(afterState, nextState, bestScore);
     return 1;
     
     
   }
  
   
   void loadWeights(String loc) {
     String[] first = loadStrings("../data/" + loc + "0.ddd");
     String[] second = loadStrings("../data/" + loc + "1.ddd");
     String[] third = loadStrings("../data/" + loc + "2.ddd");
     String[] fourth = loadStrings("../data/" + loc + "3.ddd");
     
     String[][] strings = {first, second, third, fourth};
     
     for (int i = 0; i < 4; i++) {
        String[] curStringWeights = strings[i];
        ArrayList<Double> curWeights = weights.get(i);
        
        for (int j = 0; j < curWeights.size(); j++) {
           curWeights.set(j, (Double) ((double) float(curStringWeights[j])));
          
        }

       
     }
     
   }
   void saveData(String name) {

     
     String[] firstSet = new String[(int) pow(14, 4)];
     String[] secondSet = new String[(int) pow(14, 4)];
     String[] thirdSet = new String[(int) pow(14, 6)];
     String[] fourthSet = new String[(int) pow(14, 6)];
     String[][] strings = {firstSet, secondSet, thirdSet, fourthSet};
    for (int i = 0; i < 4; i++) {
        String[] set = strings[i];
        
        ArrayList<Double> curWeights = weights.get(i);
        
        for (int j = 0; j < curWeights.size(); j++) {
          set[j] = str((float)((double) curWeights.get(j)));
          
        }
      
      saveStrings("../data/" + name + str(i) + ".ddd", set) ; 
    }
    
    
     
     
   }
   
   void reset() {
     
     if (curState.getMax() > maxTile)
         maxTile = curState.getMax();
     println("Game Ended with score " + curState.curScore + " and max tile " + curState.getMax() + " -- Games Left: " + (gamesLeft - 1) + " -- All Time Max Tile: " + maxTile);
       
     
     
     if (gamesLeft == 1 && save) {  
       saveData(saveLocation);  
       exit();
     }
     
     gamesLeft -= 1;
     curState = new State(true, null); 
     
 
      
   }
   
   

   int doMove(boolean learn) {
     State state = curState;
     int bestScore = -999999999;
     State nextState = null;
     double bestV = 0;
     for (int i = 0; i < 4; i++) {

       Object[] info = nextMoveState(i, state);

       int points = (int) info[0];
       double vVal = (double) info[1];
       boolean moved = (boolean) info[2];
       State newState = (State) info[3];
       
       if (vVal + points >= bestScore + bestV && moved) {
          bestV = vVal;
          bestScore = points;
          nextState = newState;
       }
      }

         State sNext = addRandom(nextState);
         if (learn)
           learnFromAfterState(nextState, sNext);
         
         state = sNext;
         state.addScore(bestScore);

         curState = state;
         if (curState.lost)
           return 0;
         return 1;
     
     
   }
   
   int playOneGame(boolean learn, int timePerMove) {
     
     State state = curState;
     int start;
     while (!state.lost) {
         start = millis();
         int bestScore = -999999999;
         State nextState = null;
         double bestV = 0;
         for (int i = 0; i < 4; i++) {

           Object[] info = nextMoveState(i, state);

           int points = (int) info[0];
           double vVal = (double) info[1];
           boolean moved = (boolean) info[2];
           State newState = (State) info[3];
           
           if (vVal + points >= bestScore + bestV && moved) {
              bestV = vVal;
              bestScore = points;
              nextState = newState;
           }

         }

         State sNext = addRandom(nextState);
         
         if (learn)
           learnFromAfterState(nextState, sNext);
         
         state = sNext;
         state.addScore(bestScore);

         curState = state;
         delay(timePerMove - (millis() - start));
         
     }  
     
     return curState.curScore;
     
   }
   
   void display() {
      curState.display(); 
   }
   

}  


Weight learner;
int framerate = 10;

void setup() {
  size(600, 600);
  
  frameRate(framerate);
  learner = new Weight(gamesToPlay, loadLocation, loadFile, saveAfter);
  background(0);  
}


void playGame() {
    
  learner.setAnother(false);
  learner.playOneGame(true, 500);
  learner.setAnother(true);
  learner.reset();
 
}


void keyPressed() {
 if (keyCode == UP)  {
   learner.reset();
 } 
  
  if (keyCode == DOWN) {
 
  }
  
  if (keyCode == RIGHT) {
    framerate += 5;
    
    frameRate(framerate);
  }
  
  if (keyCode == LEFT) {
        framerate -= 5;
        if (framerate <= 0)
            framerate = 1;
    frameRate(framerate);
  }
  draw();
}


void draw() {    
    if (learner.curState.lost)
      learner.reset();
    learner.display();
    
    learner.doMove(true);
    
}