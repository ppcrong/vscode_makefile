#include <iostream>
#include <vector>
#include <string>

using namespace std;

int main(int argc, char *argv[])
{
	std::cout << "Hello world!" << std::endl;
	vector<string> msg{"Hello", "C++", "World", "from", "VS Code", "and the C++ extension!"};
	for (const string &word : msg)
	{
		cout << word << " ";
	}
	cout << endl;
}
