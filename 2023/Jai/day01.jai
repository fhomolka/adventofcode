#import "Basic";
#import "File";
#import "String";

main :: ()
{
	input := read_entire_file("day01.txt");
	lines := split(input, "\n");
	digits :: "0123456789";

	words :: string.["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];

	sum := 0;

	for line : lines
	{
		left_word_idx := -1;
		left_word_val := 0;

		right_word_idx := -1;
		right_word_val := 0;

		for word, i : words
		{
			t_left_idx := find_index_from_left(line, word);
			if t_left_idx != -1 && (t_left_idx < left_word_idx || left_word_idx == -1)
			{
				left_word_idx = t_left_idx;
				left_word_val = i;
			}

			t_right_idx := find_index_from_right(line, word);
			if t_right_idx > right_word_idx
			{
				right_word_idx = t_right_idx;
				right_word_val = i;
			}
		}

		left_digit_idx := find_index_of_any_from_left(line, digits);
		right_digit_idx := find_index_of_any_from_right(line, digits);

		left_digit := 
		ifx left_digit_idx != -1 && (left_word_idx == -1 || left_digit_idx < left_word_idx) then
			line[left_digit_idx] - #char "0"
		else 
			left_word_val;
		
		right_digit := ifx right_digit_idx > right_word_idx then line[right_digit_idx] - #char "0" else right_word_val;

		number := 10 * left_digit + right_digit;

		sum += number;
	}

	print("Sum: %\n", sum);
}

#run main();