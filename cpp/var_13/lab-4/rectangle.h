#ifndef RECTANGLE_H
#define RECTANGLE_H

#include "shape.h"

/// Прямоугольник. Конструктор принимает две точки: левый нижний и правый верхний углы.
/// Считается, что стороны прямоугольника параллельны осям координат. Центром фигуры считается
/// точка пересечения диагоналей.

class Rectangle : public Shape
{
public:
    Rectangle(const Point& leftButtom, const Point& rightTop);

    double getArea() const override;
    void scale(const double& k) override;
    Point getCenter() const override;
    std::string getName() const override;

    friend std::ostream& operator<<(std::ostream& out, const Shape& shape);

private:
    Point m_bottomLeft;
    Point m_topRight;
};

#endif //RECTANGLE_H
