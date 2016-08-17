#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

typedef unsigned int uint;

int main(int argc, char *argv[]){
	if (argc < 3){
		cout << "specify data and target" << endl;
		return -1;
	}

	const char* data_file_path = argv[1];
	const char* target_file_path = argv[2];

	ifstream data;
	data.open(data_file_path);

	vector<float> wl;
	vector<float> par;
	float tmp_wl;
	float tmp_par;

	while (!data.eof()){
		data >> tmp_wl;
		data >> tmp_par;

		if (data.eof())
			break;

		wl.push_back(tmp_wl);
		par.push_back(tmp_par);
		// cout << tmp_wl << "\t" << tmp_par << endl;
	}


	// for (int i = 0; i < wl.size(); i++){
	// 	cout << wl[i] << "\t" << par[i] << endl;
	// }
	// cout << wl.size() << "\t" << par.size() << endl;

	ofstream target;
	target.open(target_file_path);

	const uint colcount = 4;
	const uint rem = wl.size() % colcount;
	uint colsize = wl.size() / colcount;
	uint colspace = 0;

	if (rem != 0){
		colsize += 1;
		colspace = colcount - (wl.size() % colcount);
	}

	for (int i = 0; i < colsize - colspace; i++){
		target << wl[i] << " & " << par[i];
		for (int j = 1; j < colcount; j++){
			const uint idx = j*colsize + i;
			target << " & " << wl[idx] << " & " << par[idx];
		}
		target << "\\\\\n";
	}

	for (int i = colsize - colspace; i < colsize; i++){
		target << wl[i] << " & " << par[i];
		for (int j = 1; j < colcount-1; j++){
			const uint idx = j*colsize + i;
			target << " & " << wl[idx] << " & " << par[idx];
		}
		target << " & & \\\\\n";
	}

	return 0;
}