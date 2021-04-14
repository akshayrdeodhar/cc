#include <iostream>
#include <map>
#include <set>
#include <string>
#include <cctype>
#include <vector>

// Calculates first and follow sets using the fixed point method, as described on wikipedia: 
// https://en.wikipedia.org/wiki/LL_parser#Constructing_an_LL(1)_parsing_table

// Tries to read a rule. Returns 0 on success
// 1 when non-terminal is not uppercase
// 2 when syntax is wrong
int read_rule(std::map<char, std::vector<std::string> > &rules) {
	char t;
	std::string checkarrow;
	std::string expansion;

	const std::string arrow ("->");

	std::cin >> t; // read terminal

	if (!isupper(t)) {
		return 1;
	}

	std::cin >> checkarrow;

	if (checkarrow.compare(arrow)) {
		return 2;
	}

	std::cin >> expansion;

	rules[t].push_back(expansion);

	return 0;

}

int is_invalid(std::map<char, std::vector<std::string> > &rules) {
	std::map<char, std::vector<std::string > >::iterator i;
	for (i = rules.begin(); i != rules.end(); i++) {
		int j;
		for (j = 0; j < (i->second).size(); j++) {
			std::string st = i->second[j];
			int k;
			if (st[0] == '<' && st.length() != 1) {
				return -1;
			}

			for (k = 0; k < st.length(); k++) {
				char token = st[k];
				if (isupper(token) && rules.find(token) == rules.end()) { 
					// nonterminal not defined in grammar
					return (int)token;
				}
			}
		}
	}
	return 0;
}

int calculate_total_size(std::map<char, std::set<char> > &first) {
	int total = 0;
	std::map<char, std::set<char> >::iterator x;
	for (x = first.begin(); x != first.end(); x++) {
		total += (x->second).size();
	}
	return total;
}


void print_sets(std::map<char, std::set<char> > &first, std::string str) {
	std::map<char, std::set<char> >::iterator x;
	std::set<char>::iterator y;
	int i;
	for (x = first.begin(); x != first.end(); x++) {
		std::cout << str << "(" << x->first << ") = {";
		for (i = 0, y = (x->second).begin(); y != (x->second).end(); y++, i++) {
			if (i != 0) {
				std::cout << ", ";
			}
			std::cout << *y;
		}
		std::cout << "}" << std::endl;
	}
}


void calculate_first(std::map<char, std::set<char> > &first, std::map<char, std::vector<std::string> > &rules) {
	int size_before_iteration, size_after_iteration;
	std::map<char, std::vector<std::string > >::iterator i;

	// 1: Initialize every first(T) = {}
	// This is done by default
	
	size_before_iteration = 0;
	
	while (true) {
	// 2: Add Fi(w) for every A -> w 
		for (i = rules.begin(); i != rules.end(); i++) {
			int j;
			char terminal = i->first;
			for (j = 0; j < (i->second).size(); j++) {
				// For every rule
				std::string w = i->second[j];

				// A -> <
				// A -> aw
				if (w[0] == '<' || !isupper(w[0])) {
					first[terminal].insert(w[0]);
				}
				// A -> Aw
				else if (isupper(w[0])) {
					if (first[w[0]].find('<') == first[w[0]].end()) {
						// epsilon not present in Fi(A)
						first[terminal].insert(first[w[0]].begin(), first[w[0]].end());
					}
					else {
						// epsilon present in Fi(A)
						std::set<char> first_w_A = first[w[0]];
						first_w_A.erase('<');
						if (w.length() > 1) {
							// A -> Xw' (w = Xw')
							if (isupper(w[1])) {
								first_w_A.insert(first[w[1]].begin(), first[w[1]].end());
							}
							else {
								first_w_A.insert(w[1]);
							}

						}
						first[terminal].insert(first_w_A.begin(), first_w_A.end());
					}
				}
			}
		}
		size_after_iteration = calculate_total_size(first);

		if (size_before_iteration == size_after_iteration) {
			// no change
			break;
		}
		else {
			// new "size before iteration"
			size_before_iteration = size_after_iteration;
		}

		//std::cout << "---" << std::endl;
		//print_sets(first, "first");
		//std::cout << "---" << std::endl;
		//std::cout << size_after_iteration << std::endl;
	}

	print_sets(first, "first");


}

// string is reductible to empty if it consists completely of nonterminals which have epsilon in their first set
bool is_reductible_to_empty(std::string &str, std::map<char, std::set<char> > &first) {
	int i;
	bool all_epsilon = true;
	for (i = 0; i < str.length(); i++) {
		if (isupper(str[i]) && (first[str[i]].find('<') != first[str[i]].end())) {
			// each token is a terminal, and it contains epsilon in its follow set
			continue;
		}
		else {
			//std::cout << "[LOG] " << str << " is not reductible to epsilon" << std::endl;
			return false;
		}
	}
	return all_epsilon;
}

void calculate_first_of_string(std::set<char> &newfirst, std::string &str, std::map<char, std::set<char> > &first) {

	int i;
	for (i = 0; i < str.length(); i++) {
		if (isupper(str[i])) {
			// token is a nonterminal
			newfirst.insert(first[str[i]].begin(), first[str[i]].end());

			if (first[str[i]].find('<') != first[str[i]].end()) { 
				// nonterminal contains epsilon in first set
				continue;
			}
			else {
				// token does not contain epsilon in first set
				break;
			}
		}
		else {
			newfirst.insert(str[i]);
		}
	}

	newfirst.erase('<');
}
		
		

void calculate_follow(std::map<char, std::set<char> > &follow, 
		std::map<char, std::set<char> > &first,
		std::map<char, std::vector<std::string> > &rules,
		char S) {

	int size_before_iteration, size_after_iteration;
	std::map<char, std::vector<std::string > >::iterator i;

	follow[S].insert('$');

	size_before_iteration = 0;

	while (true) {
		for (i = rules.begin(); i != rules.end(); i++) {
			int j;
			char nonterminal = i->first;
			for (j = 0; j < (i->second).size(); j++) {
				// For every rule
				std::string wAwdash = i->second[j];
				int k;
				for (k = 0; k < wAwdash.length(); k++) {
					if (isupper(wAwdash[k])) {
						char A = wAwdash[k];
						//std::cout << "{" << std::endl;
						//std::cout << "rule: " << nonterminal << " -> " << wAwdash << std::endl;
						//std::cout << "A = " << A << std::endl;
						std::string wdash = wAwdash.substr(k + 1);
						//std::cout << "wAwdash = " << wAwdash << std::endl;
						//std::cout << "wdash = " << wdash << std::endl;
						if (wdash.length() == 0) {
							// wdash is empty
							//std::cout <<"wdash  is empty, add follow of " << nonterminal  << " to follow of " << A << std::endl;
							follow[A].insert(follow[nonterminal].begin(), follow[nonterminal].end());
						}
						if (!isupper(wdash[0])) {
							// first token in wdash is a terminal
							//std::cout << wdash << " starts with a terminal" << std::endl;
							follow[A].insert(wdash[0]);
						}
						if (isupper(wdash[0])) {
							std::set<char> first_of_wdash;
							calculate_first_of_string(first_of_wdash, wdash, first);
							follow[A].insert(first_of_wdash.begin(), first_of_wdash.end());
							//std::cout << "Adding first(" << wdash << ") = ";
							std::set<char>::iterator l;
							for (l = first_of_wdash.begin(); l != first_of_wdash.end(); l++) {
								//std::cout << *l << ", ";
							}
							//std::cout << " to follow of " << A << std::endl;
						}
						if (is_reductible_to_empty(wdash, first)) {
							// wdash is reductible to <
							//std::cout << wdash << " is reductible to 0, add follow of " << nonterminal << " to follow of " << A << std::endl;
							follow[A].insert(follow[nonterminal].begin(), follow[nonterminal].end());
						}
						//std::cout << "}" << std::endl;

						//std::cout << "---" << std::endl;
						//print_sets(follow, "follow");
						//std::cout << "---" << std::endl;
					}
				}
			}
		}
		size_after_iteration = calculate_total_size(follow);

		if (size_before_iteration == size_after_iteration) {
			// no change
			break;
		}
		else {
			// new "size before iteration"
			size_before_iteration = size_after_iteration;
		}

		//std::cout << "---" << std::endl;
		//print_sets(follow, "follow");
		//std::cout << "---" << std::endl;
		//std::cout << size_after_iteration << std::endl;

	}

	print_sets(follow, "follow");
}

int main() {

	std::map<char, std::vector<std::string> > rules;
	std::map<char, std::set<char> > terminals, first, follow;
	int err = 0;

	char S;
	std::cout << "Enter start symbol: " << std::endl;
	std::cin >> S;

	std::cout << "Enter grammar rules" << std::endl << "< represents the empty string" << std::endl;

	while (!(err = read_rule(rules))) {
		std::cin >> std::ws;
		if (std::cin.eof()) {
			break;
		}
	}
	
	// check whether rules were parsed correctly
	switch (err) {
		case 1:
			std::cerr << "Terminal should be uppercase" << std::endl;
			return 1;
			break;
		case 2:
			std::cerr << "Syntax error" << std::endl;
			return 1;
			break;
		default:
			break;
	}


	int token;
	// Check whether grammar is valid
	if ((token = is_invalid(rules))) {
		if (token == -1) {
			std::cerr << "Invalid rule A -> <XXX" << std::endl;
		}
		else {
			std::cerr << "Undefined nonterminal: " << token << std::endl;
		}
		return 1;
	}


	if (rules.find(S) == rules.end()) {
		// S not a nonterminal
		std::cerr << "Invalid start symbol " << S << std::endl;
		return 1;
	}

	calculate_first(first, rules);

	std::cout << std::endl << "---" << std::endl;

	calculate_follow(follow, first, rules, S);

	/*std::map<char, std::vector<std::string> >::iterator i;
	std::cout << "---" << std::endl;
	for (i = rules.begin(); i != rules.end(); i++) {
		int j;
		for (j = 0; j < (i->second).size(); j++) {
			std::string st = i->second[j];
			std::cout << i->first << " -> " << st << std::endl;
		}
	}
	*/
}


