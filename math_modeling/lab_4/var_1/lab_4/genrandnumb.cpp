#include "genrandnumb.h"

GenRandNumb::GenRandNumb() : gen(rd()), dis(0.0, 1.0), hasSpare(false) {}

double GenRandNumb::generate(double mean, double sigma)
{
    if (hasSpare) {
        hasSpare = false;
        return spare * sigma + mean;
    }

    double u, v, s;
    do {
        u = dis(gen) * 2.0 - 1.0;
        v = dis(gen) * 2.0 - 1.0;
        s = u * u + v * v;
    } while (s >= 1.0 || s == 0.0);

    s = std::sqrt(-2.0 * std::log(s) / s);
    spare = v * s;
    hasSpare = true;

    return u * s * sigma + mean;
}
