package aoc2023d2

input :: #load("day04.txt", string)

import "core:fmt"
import "core:strings"
import "core:strconv"

Card :: struct
{
	winning : [10]int,
	owned : [25]int,
	score: int,
	cards_won: int
}

main :: proc()
{
	cards: [dynamic]Card

	input_lines := strings.split(input, "\n")
	for input_line, line_num in input_lines
	{
		new_card : Card
		card_str := strings.split(input_line, ":")
		card_numbers := strings.split(card_str[1], "|")
		trim_win := strings.trim(card_numbers[0], " ")
		winning_numbers := strings.split(trim_win, " ")
		trim_own := strings.trim(card_numbers[1], "  ")
		owned_numbers := strings.split(trim_own, " ")

		win_idx := 0
		for win_num_str, i in winning_numbers
		{
			if win_num_str == "" do continue
			val, ok := strconv.parse_int(win_num_str)
			new_card.winning[win_idx] = val
			win_idx += 1
		}

		//fmt.println("line: ", line_num)
		own_idx := 0
		for own_num_str in owned_numbers
		{
			if own_num_str == "" do continue

			val, ok := strconv.parse_int(own_num_str)
			new_card.owned[own_idx] = val
			own_idx += 1
		}

		new_card.cards_won = -1;
		append(&cards, new_card)
	}

	sum := 0
	for card, i in cards
	{
		cards[i].cards_won = 0
		for winning_number in card.winning
		{
			if winning_number == 0 do continue
			for owned_number in card.owned
			{
				if winning_number == owned_number
				{
					cards[i].cards_won += 1
					if cards[i].score < 1
					{
						cards[i].score += 1
					}
					else
					{
						cards[i].score *= 2
					}
				}
			}	
		}

		sum += cards[i].score
	}

	fmt.println("Score sum:", sum)

	card_counter: [dynamic]int
	for c in cards
	{
		append(&card_counter, 1)
	}

	for card, i in cards
	{
		card_count := card_counter[i]
		for count in 0..<card_count
		{
			for j in 1..=card.cards_won
			{
				ofs := j
				if ofs >= len(card_counter) do ofs = len(card_counter) - 1
				card_counter[i + ofs] += 1
			}
		}
	}

	card_sum := 0
	for count, i in card_counter
	{
		card_sum += count
	}

	fmt.println("Card sum:", card_sum)

}