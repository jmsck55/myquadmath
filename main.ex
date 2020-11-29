-- Copyright (c) 2020 James J. Cook

include std/console.e

include myquadmath.e

function get_float128_from_user()
	
	sequence s
	atom f128
	
	s = prompt_string("Enter a number: ")
	if length(s) = 0 then
		puts(1, "Incorrect format for number.\n")
		puts(1, "STATUS: Quit\n")
		getc(0)
		abort(0)
	end if
	
	f128 = my_new_float128( s )
	s = my_float128_to_string( f128 )
	
	printf(1, "You entered: %s\n", {s})
	
	return f128
end function

constant operations = {"q", "quit", "exit", "add", "subtract", "mult", "divide"}

atom num1, num2, num3
sequence op, s

puts(1, "Welcome to MyQuadmath")
puts(1, "\n")
puts(1, "By: James Cook\n")
while 1 do
	puts(1, "\nAvailible Operations are: ")
	printf(1, "%s", {operations[1]})
	for i = 2 to length(operations) do
		printf(1, ", %s", {operations[i]})
	end for
	puts(1, "\n")
	op = {}
	while not find(op, operations) do
		op = prompt_string("Enter an operation, then there will be a prompt for two numbers: ")
	end while
	if find(op, operations[1..3]) then
		puts(1, "STATUS: Good-bye\n")
		getc(0)
		abort(0)
	end if
	num1 = get_float128_from_user()
	num2 = get_float128_from_user()
	puts(1, "\nAnswer, ")
	switch op do
	case "add" then
		num3 = my_addq( num1, num2 )
		s = quadmath_snprintf( num3 )
		printf(1, "Added: %s\n", {s})
		
	case "subtract" then
		num3 = my_subtractq( num1, num2 )
		s = quadmath_snprintf( num3 )
		printf(1, "Subtracted: %s\n", {s})
		
	case "mult" then
		num3 = my_multq( num1, num2 )
		s = quadmath_snprintf( num3 )
		printf(1, "Multiplied: %s\n", {s})
		
	case "divide" then
		num3 = my_divideq( num1, num2 )
		s = quadmath_snprintf( num3 )
		printf(1, "Divided: %s\n", {s})
		
	case else
	end switch
	
	
end while


--end of file.
