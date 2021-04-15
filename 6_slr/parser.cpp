#include <iostream>
#include <string>
#include <utility>
#include <stack>

#define pr std::make_pair 

void init_goto(char table[256][256]) {

	/* -1 indicates no rule */
	for (int i = 0; i < 256; i++) {
		for (int j = 0; j < 256; j++) {
			table[i][j] = -1;
		}
	}

	table[0]['S'] = 1;
	table[0]['X'] = 2;

	table[2]['X'] = 5;

	table[3]['X'] = 8;

	table[6]['X'] = 9;
}

void init_action(std::pair<char, int> table[256][256]) {
	/* pairs are 0-initialized, so we can check the "first" to see whether it is a valid rule */

	table[0]['a'] = pr('s', 3);
	table[0]['b'] = pr('s', 4);

	table[1]['$'] = pr('a', 0);

	table[2]['a'] = pr('s', 6);
	table[2]['b'] = pr('s', 7);

	table[3]['a'] = pr('s', 3);
	table[3]['b'] = pr('s', 4);

	table[4]['a'] = pr('r', 3);
	table[4]['b'] = pr('r', 3);

	table[5]['$'] = pr('r', 1);

	table[6]['a'] = pr('s', 6);
	table[6]['b'] = pr('s', 7);

	table[7]['$'] = pr('r', 3);

	table[8]['a'] = pr('r', 2);
	table[8]['b'] = pr('r', 2);

	table[9]['$'] = pr('r', 2);
}


/* Assignment: Implement SLR parser for given grammar
 * No grammar was specified in the syllabus, chose this grammar:
 *
 * S -> XX
 * X -> aX
 * X -> b
 *
 * Reference: https://web.stanford.edu/class/archive/cs/cs143/cs143.1128/handouts/110%20LR%20and%20SLR%20Parsing.pdf
 * */


/* Parses the following grammar: */
int main(void) {
	char go_to[256][256] = {0, };
	std::pair<char, int> action[256][256];
	std::stack<int> states;

	std::pair<char, int> curr_action;

	init_goto(go_to);
	init_action(action);

	char rule_nt[4] = {'A', 'S', 'X', 'X'};
	std::string rule_expansion[4] = {"S", "XX", "aX", "b"};

	std::string str;

	std::cout << "Enter string: ";

	std::cin >> str;

	str.push_back('$'); // add EOF symbol

	int i = 0;
	char a, A;
	int s, t, r;
	std::string beta;
	std::string symbols;

	// Reference: Compilers: Principles, Techniques and Tools Figure 4.36- LR-parsing program

	states.push(0); // state 0 at top of stack
	a = str[i++]; // first character of input string

	while (true) {
		s = states.top();
		curr_action = action[s][a];

		std::cout << symbols << "\t| " << str.substr(i) << "\t| ";

		if (curr_action.first == 's') {
			// shift 
			t = curr_action.second;
			states.push(t);
			symbols.push_back(a);
			std::cout << "Shift " << 's' << curr_action.second << ' ' << a << std::endl;
			a = str[i++];
		}
		else if (curr_action.first == 'r') {
			// reduce
			r = curr_action.second;
			A = rule_nt[r];
			beta = rule_expansion[r];

			for (int k = 0; k < beta.length(); k++) {
				symbols.pop_back();
				states.pop();
			}

			symbols.push_back(A);

			t = states.top();
			states.push(go_to[t][A]);

			std::cout << "Reduce " << 'r' << r << ' ' << A << " -> " << beta << std::endl;
		}
		else if (curr_action.first == 'a') {
			// accept
			std::cout <<  "Accept!" << std::endl;
			break;
		}
		else {
			// error
			std::cout << "ERROR" << std::endl;
			break;
		}
	}

}
