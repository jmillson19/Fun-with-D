import std.stdio;
import std.file;
import std.array;
import std.string;
import std.random;
import std.algorithm;
import std.utf : byChar;
import std.string : cmp;
import std.conv : to;
import std.ascii;


 void main(string[] args){
  write("Enter file path of dictionary: ");
  string path;
  stdin.flush();
  path = strip(stdin.readln());
  int choice = 0;
  while(choice != 3){
    writeln("What do you want to do?");
    writeln("1: Play a round of hangman\n2:Add a word to the dictionary\n3: Quit");
    try
    {
      choice = to!int(strip(stdin.readln()));
    }
    catch(Exception ConvException){
      choice = 0;
    }
    if(choice == 1){
      playGame(path);
    }
    else if(choice == 2){
      addWord(path);
       }
    else if(choice == 3){
      writeln("Bye!");
    }
    else{
      writeln("Please enter a valid choice.");
    }
  }

}
/++
 Function that controls most of the function calls for playing an actual game of hangman
 Ensures guesses are only single letters and not already guessed yet.
 Function ends when game is either won (if the word is solved) or lost (after 6 incorrect guesses)
 Params:
	path = dictionary filepath
 +/
void playGame(string path){
  string guessWord = getRandomString(path);
  writeln(guessWord);
  int wordLength = guessWord.length - 1; //subtract one for terminating symbol
  string displayWord = keepGrammar(guessWord);
  bool winner = false;
  int count;
  string correctGuesses;
  string incorrectGuesses;
  writeln(displayWord);
  while(!winner && count != 7){
  bool invalidGuess = true;
  writeln(count);
  drawMan(count);
  string guess;
  while(invalidGuess){
    write("Guess a letter> ");
    stdin.flush();
    guess = strip(toLower(stdin.readln()));

    if(guess.length == 1){
        if(notContained(guess, incorrectGuesses, correctGuesses)){
          if(!isAlpha(to!char(guess))){
            writeln("Please guess only letters.");
          }
          else
            invalidGuess = false;
      }
      else{
      writeln("Sorry already guessed");
    }
    }
    else
      writeln("Sorry that guess was too long!");

  }
if(checkGuess(guessWord, guess)){
    correctGuesses ~= guess[0];
    displayWord = modifyDisplayWord(guess, guessWord, displayWord);
   }
else{
  incorrectGuesses ~= (guess[0] ~ " ");
  count++;
  if(count == 6){
    drawMan(count);
    break;
  }
  }

  write("incorrectGuesses: ");
  writeln(sort(incorrectGuesses.to!(dchar[])));
  writeln(displayWord);
  winner = checkWinner(displayWord);

  }
  if(winner){
    writeln("__   __         __      __        _ _ ");
    writeln("\\ \\ / /__ _  _  \\ \\    / /__ _ _ | | |");
    writeln(" \\ V / _ \\ || |  \\ \\/\\/ / _ \\ ' \\|_|_|");
    writeln("  |_|\\___/\\_,_|   \\_/\\_/\\___/_||_(_|_)  ");
    writeln();
  }
}

/++
 Function that returns a random string from given filepath
 Params:
	path = the filepath to grab random string from
 Returns:
	Randomly chosen word (set to lowercase for case insensitivity)
+/
string getRandomString(string path){
  string wordList = readText(path);
  string[] list = wordList.split("\n");
  auto wordCount = list.length;
  //Generate a random seed range to get a random number
  auto rng = new Random(unpredictableSeed);
  //Use this range to create and select a random word given the size of the dictionary
  auto rn = uniform(0, wordCount, rng);
  return toLower(list[rn]);
}

/++
 Function that checks whether the guess letter is included in the word
 Params:
	word = the current word for the hangman game
	guess = the player's current guess
 Returns:
	boolean value of whether the guess is contained or not
+/
bool checkGuess(string word, string guess){ //if the letter is in the word, return true
	for(int x = 0; x < word.length; x++){
		if(word[x] == guess[0])
			return true;
	}
	return false;
}

/++
 Function that draws the current state of the man depeending on number of incorrect guesses
 Params: 
	count = number of incorrect guesses.
 +/
void drawMan(int count){
  if(count == 0){
      writeln("   ____________");
      writeln("   |");
      writeln("   |");
      writeln("   |");
      writeln("   |");
      writeln("   |");
      writeln("   |");
      writeln("   | ");
      writeln("___|___");
    }
    else if(count == 1){

    writeln("   ____________");
    writeln("   |          |");
    writeln("   |          O");
    writeln("   |");
    writeln("   |");
    writeln("   |");
    writeln("   |");
    writeln("   | ");
    writeln("___|___");
  }
    else if(count == 2){
    writeln("   ____________");
    writeln("   |          |");
    writeln("   |          O");
    writeln("   |          |");
    writeln("   |          |");
    writeln("   |");
    writeln("   |");
    writeln("   | ");
    writeln("___|___");
  }
    else if(count == 3){
    writeln("   ____________");
    writeln("   |          |");
    writeln("   |        \\ O");
    writeln("   |         \\|");
    writeln("   |          |");
    writeln("   |");
    writeln("   |");
    writeln("   | ");
    writeln("___|___");
  }
    else if(count == 4){
    writeln("   ____________");
    writeln("   |          |");
    writeln("   |        \\ O /");
    writeln("   |         \\|/");
    writeln("   |          |");
    writeln("   |");
    writeln("   |");
    writeln("   | ");
    writeln("___|___");
  }
    else if(count == 5){
    writeln("   ____________");
    writeln("   |          |");
    writeln("   |        \\ O /");
    writeln("   |         \\|/");
    writeln("   |          |");
    writeln("   |         /");
    writeln("   |        /");
    writeln("   | ");
    writeln("___|___");
  }
    else if(count == 6){
    writeln("   ____________");
    writeln("   |          |");
    writeln("   |        \\ O /");
    writeln("   |         \\|/");
    writeln("   |          |");
    writeln("   |         / \\");
    writeln("   |        /   \\");
    writeln("   | ");
    writeln("___|___");
    writeln(" _    ___  ___ ___ ___");
    writeln("| |  / _ \\/ __| __| _ \\");
    writeln("| |_| (_) \\__ \\ _||   /");
    writeln("|____\\___/|___/___|_|_\\");
    writeln();
  }
  else{
    writeln("error!");
  }
}
/++
 Function to determine whether the current guess has been guessed yet
 Params:
	guess = current guess
	incorrectGuesses = list of incorrect guesses
	correctGuesses = list of correct guesses

 Returns:
	boolean value of whether it was already guessed
+/
bool notContained(string guess, string incorrectGuesses, string correctGuesses){
  if(!canFind(incorrectGuesses, guess) && !canFind(correctGuesses, guess)){
    return true;
  }
  return false;
}

/++
 Function that replaces asterisks in display word with guess letter if it is a correct guess
 Params:
	guess = current guess
	word = current games word to guess
	displayword = current state of the display word
 Returns:
	modified version of displayword
+/
string modifyDisplayWord(string guess, string word, string displayWord){
  string temp;
  auto limit = word.length - 1;
  for(auto i = 0; i < limit; i++){
    if(word[i] == guess[0]){
      temp ~= guess[0];
    }
    else{
      temp ~= displayWord[i];
    }
  }
  return temp;
}

/++
 Function that determines whether the game is won
 Params:
	displayword = current state of display word
 Returns:
	boolean value true if no asterisks in displayword false otherwise
+/
bool checkWinner(string displayWord){
  if(canFind(displayWord, "*")){
    return false;
  }
  return true;
}

/++
 Function that searches current dictionary for inputted word and appends it to the file if it is not already in the dictionary
 This function is not case sensitive
 Params:
	path = filepath for given dictionary
+/
void addWord(string path){
  write("Enter the word to add to dictionary: ");
  stdin.flush();
  string wordList = readText(path);
  string newWord = strip(stdin.readln());
  //First check if word is already in dictionary
  if(canFind(wordList, newWord)){
      writeln("Sorry word already in dictionary.");
  }
  else{
    append(path, "\r\n");
    append(path, newWord);
    writeln("Added " ~ newWord ~ " to " ~ path);
  }
}
/++
 Function that creates the display word, making sure to keep grammar included in the words
 Note: game will not work as planned if there is an asterisk contained in the word to guess
 Params:
	word = current games word to guess
 Returns: 
	kept = word to display (letters are replaced by asterisks)
+/
string keepGrammar(string word){
  string kept;
  for(int i = 0; i < word.length; i++){
    if(isAlpha(word[i])){
      kept ~= '*';
    }
    else{
      kept ~= word[i];
    }
  }
  return kept;
}
