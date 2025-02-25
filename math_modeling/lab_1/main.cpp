#include <iostream>
#include <fstream>
#include <vector>

struct Point {
	int t = 0;
	double y = 0.0;
};

std::vector<Point> AilerCalc(double x, double k, double a1, double a2, double b1, double b2, int nIter = 580, double h = 0.05) {
	std::vector<Point> res(nIter);
	double z1 = 0;
	double z2 = 0;
	double z3 = 0;

	double dz1 = 0;
	double dz2 = 0;
	double dz3 = 0;
	Point yRes;

	for (int i = 1; i < nIter; ++i) {
		dz1 = z1 + h * z2;
		dz2 = z2 + h * z3;
		dz3 = z3 + h * ((x - z1 - (2 * b1 + b2) * z2 - (2 * b1 * b2 + b1 * b1) * z3) / (b2 * b1 * b1));

		res[i] = { i, k * z1 - a2 * k * z2 + a1 * k * z2 - a1 * a2 * k * z3 };

		z1 = dz1;
		z2 = dz2;
		z3 = dz3;
	}
	return res;
}

int main()
{
	const int x = 5;
	const int k = 3;
	const int a1 = 5;
	const int a2 = 3;
	const int b1 = 3;
	const int b2 = 2;

	std::ofstream file("outputData.txt");
	if (!file.is_open()) {
		std::cout << "Error open file!";
		return 1;
	}

	std::vector<Point> data = AilerCalc(x, k, a1, a2, b1, b2);


	file << "t" << "\t" << "y" << "\n";
	//for (const auto& p : data) {
	//	file << p.t << "\t" << p.y << "\n";
	//}
	
	for (int i = 0; i < data.size(); ++i) {
		if (i % 2 == 0) {
			file << data[i].t << "\t" << data[i].y << "\n";
		}
	}
	
	return 0;
}
