#ifndef SHAPE_H
#define SHAPE_H

#include "point.h"
#include <string>

/// Создать файл shape.h, содержащий определение абстрактного класса Shape. Этот класс
///должен предоставлять следующие методы:
/// • getArea вычисление площади
/// • scale изотропное масштабирование фигуры относительно её центра с указанным
/// коэффициентом
/// • getCenter получение точки центра фигуры
/// • getName получение названия фигуры (RECTANGLE, CIRCLE и т.д.), метод использовать
/// при выводе
///
/// У каждой фигуры должен быть конструктор, принимающий определённые параметры.
/// • Классы должны контролировать свои данные и не допускать создания объектов с
/// некорректным состоянием (можно выбрасывать исключения с помощью throw).
/// • Объявление класса должно быть в заголовочном файле (.h, не забывайте про header guard), а
/// определения методов в файле реализации (.cpp).
///
class Shape
{
public:
    virtual ~Shape() = default;

    virtual double getArea() const = 0;
    virtual void scale(const double& k) = 0;
    virtual Point getCenter() const = 0;
    virtual std::string getName() const = 0;

    bool operator<(const Shape& other) const {
        return this->getArea() < other.getArea();
    }

    friend std::ostream& operator<<(std::ostream& out, const Shape& shape);
};

#endif //SHAPE_H
