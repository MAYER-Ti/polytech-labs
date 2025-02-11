#include <iostream>

#include "rectangle.h"
#include "romb.h"

#include <algorithm>
#include <vector>
///
/// Реализовать функцию, сортирующую массив указателей на фигуры в порядке неубывания
/// их площадей (алгоритм сортировки выберите на ваше усмотрение).
/// Написать программу, в которой:
/// • Создать массив указателей на фигуры (не менее 5 фигур)
/// • Отсортировать фигуры по неубыванию площадей
/// • Вывести информацию о фигурах на экран (имя, координаты центра, площадь)
/// • Выполнить масштабирование всех фигур на заданный коэффициент
/// • Вывести информацию о фигурах на экран ещё раз
///

int main()
{
    std::vector<Shape*> vShapes;
    try {

        vShapes.push_back(new Rectangle(Point(0.0, 0.0), Point(1.0, 1.0)));
        vShapes.push_back(new Romb(Point(15.0, 0.0), 15.0, 10.0));
        vShapes.push_back(new Rectangle(Point(-10.0, -10.0), Point(10.0, 10.0)));
        vShapes.push_back(new Romb(Point(-3.0, -15.0), 20.0, 7.0));
        vShapes.push_back(new Rectangle(Point(16.0, 32.0), Point(32.0, 115.0)));


        std::cout << "Исходные фигуры:" << '\n';
        for (const Shape* shape : vShapes) {
            std::cout << *shape << '\n';
        }

        std::cout << "\n" << "Фигуры после масштабирования в 2 раза" << "\n";
        for (Shape* shape : vShapes) {
            shape->scale(2.0);
            std::cout << *shape << '\n';
        }

        std::sort(vShapes.begin(), vShapes.end(), [](Shape* sh1, Shape* sh2) {return *sh1 < *sh2;});

        std::cout << "\n" << "Фигуры после сортировки по площади" << "\n";
        for (Shape* shape : vShapes) {
            shape->scale(2.0);
            std::cout << *shape << '\n';
        }

        for (Shape* shape : vShapes) {
            delete shape;
        }
    }
    catch (const std::exception& e) {
        std::cerr << e.what() << "\n";

        for (Shape* shape : vShapes) {
            delete shape;
        }
    }
    return 0;
}
