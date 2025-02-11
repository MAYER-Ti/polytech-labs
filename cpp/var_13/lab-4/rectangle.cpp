#include "rectangle.h"
#include <stdexcept>

Rectangle::Rectangle(const Point &leftButtom, const Point &rightTop)
    : m_bottomLeft(leftButtom), m_topRight(rightTop)
{
    if ((leftButtom.x >= rightTop.x) || (leftButtom.y >= rightTop.y)) {
        throw std::invalid_argument("Некорректные точки!");
    }
}

double Rectangle::getArea() const
{
    return (m_topRight.x - m_bottomLeft.x) * (m_topRight.y - m_bottomLeft.y);
}

void Rectangle::scale(const double &k)
{
    if (k <= 0) {
        throw std::invalid_argument("Некорректный коеффициент!");
    }
    Point center = getCenter();
    double halfWidth = (m_topRight.x - m_bottomLeft.x) / 2 * k;
    double halfHeight = (m_topRight.y - m_bottomLeft.y) / 2 * k;
    m_bottomLeft = Point(center.x - halfWidth, center.y - halfHeight);
    m_topRight = Point(center.x + halfWidth, center.y + halfHeight);
}

Point Rectangle::getCenter() const
{
    return Point((m_bottomLeft.x + m_topRight.x) / 2, (m_bottomLeft.y + m_topRight.y) / 2);
}

std::string Rectangle::getName() const
{
    return "ПРЯМОУГОЛЬНИК";
}


