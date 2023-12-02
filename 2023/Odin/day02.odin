package aoc2023d2

import "core:fmt"
import "core:strings"
import "core:strconv"

input :: #load("./day02.txt", string)

MAX_RED :: 12;
MAX_GREEN :: 13;
MAX_BLUE :: 14;

set :: [3]int;
Game :: [dynamic]set;

main :: proc()
{
	games: [dynamic]Game;

	lines := strings.split(input, "\n");

	//fill in the games data
	for line in lines
	{
		line_div := strings.split(line, ":");
		sets := strings.split(line_div[1], ";");

		game: Game;
		for str_set in sets
		{
			colour_input := strings.split(str_set, ",");
			new_set : set;

			for colour_str in colour_input
			{
				colour_data := strings.split(colour_str, " ");
				colour_idx: int;

				switch colour_data[2] 
				{
					case "red":
					{colour_idx = 0}
					case "green":
					{colour_idx = 1}
					case "blue":
					{colour_idx = 2}			
				}

				val, ok := strconv.parse_int(colour_data[1])
				new_set[colour_idx] = val;
			}
			append(&game, new_set);
		}
		append(&games, game);
	}

	condition :set = {MAX_RED, MAX_GREEN, MAX_BLUE};

	possible : [dynamic]bool;

	biggest_sets: [dynamic]set;

	for game in games
	{
		is_possible := true;
		for colour_set in game
		{

			if  colour_set.r > condition.r || 
				colour_set.g > condition.g ||
				colour_set.b > condition.b
			{
				is_possible = false;
				break;
			}
		}
		append(&possible, is_possible);

		big_set: set = {0, 0, 0};
		for colour_set in game
		{
			if colour_set.r > big_set.r do big_set.r = colour_set.r
			if colour_set.g > big_set.g do big_set.g = colour_set.g
			if colour_set.b > big_set.b do big_set.b = colour_set.b
		}

		append(&biggest_sets, big_set);
	}

	sum := 0;
	for possibility, i in possible
	{
		if possibility 
		{
			sum += i + 1
		}
	}

	power_sum := 0
	for big_boi in biggest_sets
	{
		power := big_boi.r * big_boi.g * big_boi.b;
		power_sum += power;
	}

	fmt.println("Sum: ", sum);
	fmt.println("POWER Sum: ", power_sum);
} 
