import std.stdio;

void main()
{
	
    // A whole new approach to Hello World!
    mixin(`writeln("Hello World");`);
	
	//Sends the operator first between the quotes which is then applied to the template values
	writeln("Works on strings too: ", geoFunc!"~"("This ","is ","a ","sentence!"));
	writeln("Perim: ", geoFunc!"+"(5,5,5,5));
	writeln("Area: ", geoFunc!"*"(5,5,1,1));
}



//So it takes in the values for left, right, top, and bottom (which can be of any type)
//And applies the operation in between each one.
//This is how we determine whether to calculate perimeter (and thus send '+' as the operator)
//or area (and send '*' instead)
//~ concatenates and makes the string, which is then executed as code at runtime
auto geoFunc(string op, T)(T left, T right, T top, T bottom){
	return mixin("left " ~ op ~ " right" ~ op ~ "top" ~op ~ "bottom");
}
