package aoc2023d2

input :: #load("day03.txt", string)

import "core:fmt"
import "core:strings"
import "core:strconv"

Token_Type :: enum
{
	NONE,
	PERIOD,
	NUMBER,
	PART,
	GEAR,
}

Token :: struct
{
	val: string,
	type: Token_Type,
	line_num: int,
	pos_start: int,
	pos_end: int,

	freestanding: bool,

	ratio: int,
	times_multiplied: int,
}

is_number :: proc(char: u8) -> bool
{
	return char > 47 && char < 58
}

main :: proc()
{
	input_lines := strings.split(input, "\n")

	tokens: [dynamic]Token

	for input_line, line_num in input_lines
	{
		for i := 0; i < len(input_line); i += 1
		{
			input_character := input_line[i]

			new_token: Token

			switch input_character 
			{
				case '.':
				{
					new_token.val = input_line[i:i+1]
					new_token.type = .PERIOD
					new_token.line_num = line_num
					new_token.pos_start = i
					new_token.pos_end = i
				}
				case '0': fallthrough
				case '1': fallthrough
				case '2': fallthrough
				case '3': fallthrough
				case '4': fallthrough
				case '5': fallthrough
				case '6': fallthrough
				case '7': fallthrough
				case '8': fallthrough
				case '9':
				{
					end_pos := i
					for end_pos + 1 < len(input_line)
					{
						if !is_number(input_line[end_pos + 1]) do break
						end_pos += 1
					}

					new_token.val = input_line[i:end_pos+1]
					new_token.type = .NUMBER
					new_token.line_num = line_num
					new_token.pos_start = i
					new_token.pos_end = end_pos

					i = end_pos
				}
				case '*':
				{
					new_token.val = input_line[i:i+1]
					new_token.type = .GEAR
					new_token.line_num = line_num
					new_token.pos_start = i
					new_token.pos_end = i
				}
				case:
				{
					new_token.val = input_line[i:i+1]
					new_token.type = .PART
					new_token.line_num = line_num
					new_token.pos_start = i
					new_token.pos_end = i
				}
			}

			token_start := i

			//fmt.printf("%c", input_character)
			append(&tokens, new_token)
		}

		//fmt.print("\n")
	}

	//for token in tokens do fmt.println(token)
	
	for token, i in tokens
	{
		if token.type == .NUMBER 
		{
			line_above := token.line_num - 1
			line_below := token.line_num + 1

			is_freestanding := true
			for tok in tokens
			{
				if tok.line_num < line_above || tok.line_num > line_below do continue
				if tok.pos_start < token.pos_start - 1 || tok.pos_end > token.pos_end + 1 do continue
				if tok == token do continue

				if tok.type == .PART || tok.type == .GEAR
				{
					is_freestanding = false
					break
				}
			}

			tokens[i].freestanding = is_freestanding
		}
		else if token.type == .GEAR
		{
			line_above := token.line_num - 1
			line_below := token.line_num + 1

			tokens[i].ratio = 1
			tokens[i].times_multiplied = 0

			for tok in tokens
			{
				if tok.type != .NUMBER do continue
				if tok.line_num < line_above || tok.line_num > line_below do continue
				if tok.pos_end < token.pos_start - 1 || tok.pos_start > token.pos_end + 1 do continue
				if tok == token do continue

				val, ok := strconv.parse_int(tok.val) 
				tokens[i].ratio *= val
				tokens[i].times_multiplied += 1
			}
		}
	}

	sum := 0
	gear_ratio_sum := 0

	for token, i in tokens
	{
		if token.type == .NUMBER
		{
			if token.freestanding do continue;
			val, ok := strconv.parse_int(token.val) 
			sum += val
		}
		else if token.type == .GEAR
		{
			if token.times_multiplied == 2
			{
				gear_ratio_sum += token.ratio
			}
		}
	}

	fmt.println("Sum: ", sum)
	fmt.println("Gear Ratio Sum: ", gear_ratio_sum)

} 
