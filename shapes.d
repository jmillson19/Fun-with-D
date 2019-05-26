/*@author Jason Millson
 * PROGRAM EDITS:
 * Changed function returning functions into code that utilizes string mixins and out parameters to
 * create a string of code that is executed at runtime that either calculates the area or perimeter
 * of the respective quadrilateral
 * Each of the "calcQuadArea" functions are now just calcQuad ones that call the respective formulas on the current
 * quadrilateral's lengths
 */


import std.stdio;
import std.conv;
import std.variant;
import std.math;
import std.string;

const int CIRCLE = 0;
const int POINT = 1;
const int LINE = 2;
const int TRIANGLE = 3;
const int QUAD = 4;
const int PENT = 5;
const int HEX = 6;
const int SEPT = 7;
const int OCT = 8;
const int NON = 9;
const int DEC = 10;
void main(){
	writeln("Welcome to the shapes program!");
	int choice = 0;
	while(choice != 2){
		writeln("What do you want to do?");
		writeln("1: Build a shape\n2:Quit this program\n");
		try
		{
			choice = to!int(strip(stdin.readln()));
		}
		catch(Exception ConvException){
			choice = 0;
		}
		if(choice == 1){
			int sides = 0;
			writeln("How many sides: ");
			try
			{
				sides = to!int(strip(stdin.readln()));
			}
			catch(Exception ConvException){
				//if invalid input, default to circle
				sides = 0;
			}
			buildShape(sides);
		}
		else if(choice == 2){
			writeln("Bye!");
		}
		else{
			writeln("Please enter a valid choice.");
		}
	}
}
/++
	The base shape interface, will be inherited by other classes
+/
interface Shapes{
	void addSide();
	int getSides();
	void setShapeCategory();
	string getCategory();
	double getArea();
	void setArea(double x);
}
/++
The implementation of the Shapes interface using a mixin template which "copies" code from here to the mixin site
+/
mixin template Shapes_Impl(){
	private int sides;
	private double area;
	private double perimeter;
	private double[] sideLengths;
	private string category;

	this(int sides){
		this.sides = sides;
		setShapeCategory();
	}

	void addSide(){
		sides++;
		setShapeCategory();
	}
	int getSides(){
		return sides;
	}
	void setShapeCategory(){
		switch(this.sides){
			//Use 0 for circle because infinity is big
			case 0:
				this.category = "circle";
				break;
			case 1:
				this.category = "point";
				break;
			case 2:
				this.category = "line";
				break;
			case 3:
				this.category = "triangle";
				break;
			case 4:
				this.category = "quadrilateral";
				break;
			case 5:
				this.category = "pentagon";
				break;
			case 6:
				this.category = "hexagon";
				break;
			case 7:
				this.category = "septagon";
				break;
			case 8:
				this.category = "octagon";
				break;
			case 9:
				this.category = "nonagon";
				break;
			case 10:
				this.category = "decagon";
				break;
			default:
				this.category = to!string(sides) ~ "-agon";
				break;
		}
	}
	string getCategory(){
		return category;
	}
	double getArea(){
		return area;
	}
	void setArea(double toSet){
		this.area = toSet;
	}
}

interface Quadrilateral{
	void setLengths(double, double, double, double);
	double calculateP();
}
mixin template Quadrilateral_Impl(){
	double topEdge;
	double bottomEdge;
	double rightEdge;
	double leftEdge;

	void setLengths(double top, double bottom, double right, double left){
		topEdge = top;
		bottomEdge = bottom;
		rightEdge = right;
		leftEdge = left;
	}
	double calculateP(){
		double sum = topEdge + bottomEdge + rightEdge + leftEdge;
		return sum;
	}
}


/++
Multiply inherits from Shape and Quadrilateral interfaces
The mixins Shapes_Impl and Quadrilateral_Impl "copy" the code from the
respective mixin templates site into this class
+/
class Square : Shapes, Quadrilateral {
	mixin Shapes_Impl!();
	mixin Quadrilateral_Impl!();
	void calcArea(){
		area = topEdge * topEdge;
	}
	//Overrides quadrilateral version to make sure all sides
	//are of same length, preserving square properties
	void setLengths(double x){
		topEdge = x;
		bottomEdge = x;
		rightEdge = x;
		leftEdge = x;
	}
}
/++
Multiply inherits from Shape and Quadrilateral interfaces
The mixins Shapes_Impl and Quadrilateral_Impl "copy" the code from the
respective mixin templates site into this class
+/
class Rectangle : Shapes, Quadrilateral{
	mixin Shapes_Impl!();
	mixin Quadrilateral_Impl!();

	void calcArea(){
		area = topEdge * rightEdge;
	}
	void setLengths(double x, double y){
		topEdge = x;
		bottomEdge = x;
		rightEdge = y;
		leftEdge = y;
	}
	double getTop(){
		return topEdge;
	}
	double getRight(){
		return rightEdge;
	}
}
/++
Multiply inherits from Shape and Quadrilateral interfaces
The mixins Shapes_Impl and Quadrilateral_Impl "copy" the code from the
respective mixin templates site into this class
+/
class Trapezoid:Shapes, Quadrilateral{
	mixin Shapes_Impl!();
	mixin Quadrilateral_Impl!();
	double height;
	void setLengths(double x, double y, double z){
		topEdge = x;
		bottomEdge = y;
		height = z;
	}
}
/++
Inherits from the Shapes interface
+/
class Circle: Shapes{
	mixin Shapes_Impl!();
	private double radius;

	void setRadius(double rad){
		radius = rad;
	}

	void calcArea(){
		area = PI * (radius*radius);
	}
	void calcPer(){
		perimeter = (radius * 2) * PI;
	}
	double getArea(){
		return area;
	}
	double getPerimeter(){
		return perimeter;
	}
}
/++
Class for the Shapes interface
+/
class BaseShape:Shapes{
	mixin Shapes_Impl!();
}

class BaseQuad:Quadrilateral{
	mixin Quadrilateral_Impl!();
}
/++
Main shape builder method.  Special cases for when shape is a circle or quadrilateral
Params:
	sides = number of sides current shape has
+/
void buildShape(int sides){
	Variant a;
	BaseShape shape = new BaseShape(sides);
	a = shape;
	shape.setShapeCategory();
	writeln("Your shape has ", sides, " sides making it a ", shape.getCategory());
	writeln("The variant is currently of type ", a.type());
	if(sides == CIRCLE){
		writeln("The current shape is a circle.  What is its radius?");
		double radius = 1;
		stdin.flush();
		try
		{
			radius = to!double(strip(stdin.readln()));
		}
		catch(Exception ConvException){
			//if invalid input, default to unit circle
			radius = 1;
		}
		Circle cir = new Circle(CIRCLE);
		a = cir;
		cir.setRadius(abs(radius));
		cir.calcArea();
		cir.calcPer();
		writeln("The circle's area is ", cir.getArea());
		writeln("The circle's perimeter is ", cir.getPerimeter());
	}
	if(sides == QUAD){
		writeln("Your current shape is a quadrilateral.  What type of quadrilateral is it?");
		writeln("1. Trapezoid\n2.Rectangle\n3.Square\n");
		int quadChoice = 3;
		stdin.flush();
		try
		{
			quadChoice = to!int(strip(stdin.readln()));
		}
		catch(Exception ConvException){
			//if invalid input, default to trapezoid
			quadChoice = 3;
		}
		if(quadChoice == 1){
			a = trapMethod();
		}
		else if(quadChoice == 2){
			a = rectMethod();
		}
		else{
			a = squareMethod();
		}
		//Calculate the area or the perimeter for the given quadrilateral type
		//Uses option as out parameter to tell us what operation is being performed
		string option;
		double areaOrPerim = geoCalc(a, option);
		//Split the variant type to only get the class name, not the program name as well
		string variantName = to!string(a.type());
		string[] split = variantName.split(".");
		writeln("The ",option, " of the current ", toLower(split[1]), " is ", areaOrPerim);
	}
	writeln("The variant is now of type ", a.type());
	writeln("Would you like to add a side to the current shape? ");
	writeln("1. Yes\n2. No\n3. New shape please\n");
	int addSide = 0;
	try
	{
		addSide = to!int(strip(stdin.readln()));
	}
	catch(Exception ConvException){
		//if invalid input, default to get me out
		sides = 3;
	}
	if(addSide == 1){
		buildShape(sides + 1);
	}
	else if(addSide ==2){
		writeln("Very well, no extra side added.");
		buildShape(sides);
	}
	else{
		writeln("Shape scrapped.");
	}
	}
/++
	Function that looks at current state of Variant a and returns respective area function
	Params:
		a = Variant of type of one of three Quadrilaterals Trapezoid, Rectangle, or Square
		option = out parameter that will return the option of area or perimeter
	Returns:
		Function that determines area of respective quadrilateral type;
		0if Variant isn't of these three types
+/
double geoCalc(Variant a, out string option){
	writeln("Area or Perimeter?");
	writeln("1. Area\n2. Perimeter\n");
	auto choice = 0;
	try
	{
		choice = to!int(strip(stdin.readln()));
	}
	catch(Exception ConvException){
		//if invalid input, default to area
		choice = 1;
	}
	if(choice == 1){
		option = "area";
	}
	else{
		option = "perimeter";
	}
	//Peek method sets b to point to variant a given that it is of type shapes.Square
	auto b = a.peek!(shapes.Square);
	//We then call respective functions along with choice to compute area or perimeter of the given object
	if(b != null){
		return calcSquare(b.topEdge, choice);
	}
	else{
		auto c = a.peek!(shapes.Rectangle);
		if(c != null){
			return calcRect(c.getTop(), c.getRight(), choice);
		}
		else{
			auto d = a.peek!(shapes.Trapezoid);
			if(d != null){
				return calcTrapezoid(d.topEdge, d.bottomEdge, d.height, choice);
			}
		}
	}
	return 0;
}
//Function takes in the values for left, right, top, and bottom (which can be of any type)
//And applies the operation in between each one.
//This is how we determine whether to calculate perimeter (and thus send '+' as the operator)
//or area (and send '*' instead)
//~ concatenates and makes the string, which is then executed as code at runtime
auto geoFunc(string op, T)(T left, T right, T top, T bottom){
	return mixin("left " ~ op ~ " right" ~ op ~ "top" ~op ~ "bottom");
}

/++
	Calculates geometric functions of rectangle
+/
pure double calcRect(double x, double y, int op){
	if(op == 1){
		return geoFunc!"*"(x,y,1,1);
	}
	else{
		return geoFunc!"+"(x,x,y,y);
	}
	return 0;
}
/++
	Calculates  geometric functions of square
+/
pure double calcSquare(double x, int op){
	if(op == 1){
		return geoFunc!"*"(x,x,1,1);
	}
	else{
		return geoFunc!"+"(x,x,x,x);
	}
	return 0;
}
/++
	Calculates  geometric functions of isoscles trapezoid
+/
pure double calcTrapezoid(double base1, double base2, double height, int op){

	if(op == 1){
		return geoFunc!"*"((.5*(base1+base2)),height,1,1);
	}
	else{
		auto triBase = abs(base1-base2);
		auto hypot = hypot(triBase, height);
		return geoFunc!"+"(base1,base2,hypot,hypot);
	}
	return 0;
}
/++
	Generates a trapezoid with user specified edge lengths
	Returns:
		Trapezoid object with given dimensions
+/
Trapezoid trapMethod(){
	writeln("Assumes isoscles trapezoid.");
	Trapezoid trap = new Trapezoid(QUAD);
	writeln("How long is the top base: ");
	auto x = to!double(strip(stdin.readln()));
	writeln("How long is the bottom base: ");
	auto y = to!double(strip(stdin.readln()));
	writeln("How long is the height: ");
	auto z = to!double(strip(stdin.readln()));
	trap.setLengths(x, y, z);
	return trap;
}
/++
	Generates a rectangle with user specified edge lengths
	Returns:
		Rectangle object with given dimensions
+/
Rectangle rectMethod(){
	Rectangle rect = new Rectangle(QUAD);
	writeln("How long are the top and bottom edges: ");
	auto x = to!double(strip(stdin.readln()));
	writeln("How long are the right and left edges: ");
	auto y = to!double(strip(stdin.readln()));
	rect.setLengths(x, y);
	return rect;
}
/++
	Generates a square with user specified edge lengths
	Returns:
		Square object with given dimensions
+/
Square squareMethod(){
	Square sq = new Square(QUAD);
	writeln("How long are the edges: ");
	auto x = to!double(strip(stdin.readln()));
	sq.setLengths(x);
	return sq;
}
//Todo: fix up this, currently it causes a compilation error
//"variable i cannot be read at compile time"
//Draws a crude representation of the shape (rounds to integers
/*
void drawShape(double w, double x, double y, double z){
	string[][] drawing;
	for(int i = 0; i < x; i++){
		for(int j = 0; j < y; j++){
			string[i][j] = " ";
		}
	}
	for(int i = 0; i < w; i++){
	string[i][0] = "-";
	}
	for(int i = 0; i < x; i++){
		string[i][y] = "-";
	}
	for(int i = 0; i < y; i++){
		string[0][i] = "-";
	}
	for(int i = 0; i < z; i++){
		string[w][i] = "-";
	}
	for(int i = 0; i < x; i++){
		for(int j = 0; j < y; j++){
			write(string[i][j]);
		}
		writeln();
	}
}*/
