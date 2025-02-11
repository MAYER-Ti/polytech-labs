#ifndef ROMB_H
#define ROMB_H

#include "shape.h"

/// Ромб. Конструктор принимает точку центра и длины двух диагоналей: по вертикальной оси и
/// по горизонтальной оси. Считается, что диагонали ромба параллельны осям координатам.
/// Центром фигуры считается точка пересечения диагоналей

class Romb : public Shape
{
public:
    Romb(const Point& center, const double& diagV, const double& diagH);

    double getArea() const override;
    void scale(const double& k) override;
    Point getCenter() const override;
    std::string getName() const override;


private:
    Point m_center;
    double m_diagV;
    double m_diagH;
};

#endif //ROMB_H
