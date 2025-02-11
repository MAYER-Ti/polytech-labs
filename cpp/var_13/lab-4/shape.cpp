#include "shape.h"

std::ostream& operator<<(std::ostream& out, const Shape& shape)
{
    out << std::string(shape.getName()) << " - Площадь = " << shape.getArea() << " Центр = " << shape.getCenter();
    return out;
}
