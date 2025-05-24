#include "romb.h"
#include <stdexcept>


Romb::Romb(const Point &center, const double &diagV, const double &diagH)
    : m_center(center), m_diagV(diagV), m_diagH(diagH)
{
    if (diagV <= 0 || diagH <= 0) {
        throw std::invalid_argument("Длина диагоналей должна быть положительной!");
    }
}

double Romb::getArea() const
{
    return (m_diagV * m_diagH) / 2.0;
}

void Romb::scale(const double &k)
{
    if (k <= 0) {
            throw std::invalid_argument("Коэффициент должен быть больше нуля!");
        }
        m_diagV *= k;
        m_diagH *= k;
}

Point Romb::getCenter() const
{
    return m_center;
}

std::string Romb::getName() const
{
    return "РОМБ";
}
