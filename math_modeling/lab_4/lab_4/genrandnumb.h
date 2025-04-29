#ifndef GENRANDNUMB_H
#define GENRANDNUMB_H

#include <cmath>
#include <random>

class GenRandNumb
{
public:
    explicit GenRandNumb();

    double generate(double mean = 0.0, double sigma = 1.0);

private:
    std::random_device rd;
    std::mt19937 gen;
    std::uniform_real_distribution<> dis;
    bool hasSpare;
    double spare;
};

#endif // GENRANDNUMB_H
