#ifndef POINT_H
#define POINT_H

#include <iostream>

/// Создать файл point.h, содержащий определение структуры Point, представляющей
/// собой точку на плоскости. Координаты должны храниться в полях x и y.
struct Point
{
public:
    explicit Point(double _x = 0.0, double _y = 0.0) : x(_x), y(_y) {};

    friend std::ostream& operator<<(std::ostream& out, const Point& p) {
        out << "{" << p.x << ", " << p.y << "}";
        return out;
    }

public:
    double x;
    double y;
};

#endif //POINT_H
