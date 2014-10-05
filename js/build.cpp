#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

int main(int argc, char const *argv[])	{
	string temp;
	string content;

	ifstream source("include.txt", ios::binary | ios::in);
	ifstream file;
	ifstream::pos_type size;
	char* block;
	ofstream out("source.coffee", ios::binary | ios::out | ios::trunc);

	if(source.is_open() && out.is_open())	{
		// get files that are to be included
		while(!source.eof())	{
			getline(source, temp);

			if(temp.length() == 0 || temp.at(0) == '#') {
				continue;
			}

			temp.append(".coffee");

			// read file that is to be included if source line was NOT empty
			if(temp.length() > 7)	{
				file.open(temp.c_str(), ios::binary | ios::in | ios::ate);
				if(file.is_open())	{
					// read source
					size	= file.tellg();
					block	= new char[size];
					file.seekg(0, ios::beg);
					file.read(block, size);
					file.close();
					// write
					out.write("# from ", 7);
					out.write(temp.c_str(), temp.length());
					out.write("\n", 1);
					out.write(block, size);
					out.write("# end ", 6);
					out.write(temp.c_str(), temp.length());
					out.write("\n\n", 2);
					// rid memory
					delete[] block;
				}
			}
		}
		source.close();
		out.close();
	}
	else
		cout << "ERROR: File 'include.js' couldn't be opened!\n";
	
	return 0;
}