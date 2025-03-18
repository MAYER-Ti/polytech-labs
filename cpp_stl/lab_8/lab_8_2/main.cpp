#include <iostream>
#include <list>
#include <algorithm> // Для std::sort, std::for_each
#include <memory>    // Для std::unique_ptr

// Базовый класс Shape
class Shape {
protected:
    double x; // Координата x центра
    double y; // Координата y центра

public:
    Shape(double x, double y) : x(x), y(y) {}

    // Методы для сравнения положения фигур
    bool IsMoreLeft(const Shape* other) const {
        return this->x < other->x;
    }

    bool IsUpper(const Shape* other) const {
        return this->y > other->y;
    }

    // Чисто виртуальная функция Draw
    virtual void Draw() const = 0;

    // Геттеры для координат (используются в компараторах)
    double getX() const { return x; }
    double getY() const { return y; }

    // Виртуальный деструктор для корректного удаления объектов
    virtual ~Shape() = default;
};

// Класс Circle
class Circle : public Shape {
public:
    Circle(double x, double y) : Shape(x, y) {}

    void Draw() const override {
        std::cout << "Circle: center at (" << x << ", " << y << ")\n";
    }
};

// Класс Triangle
class Triangle : public Shape {
public:
    Triangle(double x, double y) : Shape(x, y) {}

    void Draw() const override {
        std::cout << "Triangle: center at (" << x << ", " << y << ")\n";
    }
};

// Класс Square
class Square : public Shape {
public:
    Square(double x, double y) : Shape(x, y) {}

    void Draw() const override {
        std::cout << "Square: center at (" << x << ", " << y << ")\n";
    }
};

// Функция для вывода всех фигур
void drawAll(const std::list<std::unique_ptr<Shape>>& shapes) {
    std::for_each(shapes.begin(), shapes.end(), [](const std::unique_ptr<Shape>& shape) {
        shape->Draw();
    });
    std::cout << "\n";
}

int main() {
    // Создаем список фигур
    std::list<std::unique_ptr<Shape>> shapes;
    shapes.push_back(std::make_unique<Circle>(1.0, 5.0));
    shapes.push_back(std::make_unique<Triangle>(3.0, 2.0));
    shapes.push_back(std::make_unique<Square>(4.0, 7.0));
    shapes.push_back(std::make_unique<Circle>(2.0, 6.0));

    // Выводим все фигуры
    std::cout << "Initial list of shapes:\n";
    drawAll(shapes);

    // Сортировка слева-направо (по возрастанию x)
    shapes.sort([](const std::unique_ptr<Shape>& a, const std::unique_ptr<Shape>& b) {
        return a->getX() < b->getX();
    });
    std::cout << "Shapes sorted left-to-right:\n";
    drawAll(shapes);

    // Сортировка справа-налево (по убыванию x)
    shapes.sort([](const std::unique_ptr<Shape>& a, const std::unique_ptr<Shape>& b) {
        return a->getX() > b->getX();
    });
    std::cout << "Shapes sorted right-to-left:\n";
    drawAll(shapes);

    // Сортировка сверху-вниз (по убыванию y)
    shapes.sort([](const std::unique_ptr<Shape>& a, const std::unique_ptr<Shape>& b) {
        return a->getY() > b->getY();
    });
    std::cout << "Shapes sorted top-to-bottom:\n";
    drawAll(shapes);

    // Сортировка снизу-вверх (по возрастанию y)
    shapes.sort([](const std::unique_ptr<Shape>& a, const std::unique_ptr<Shape>& b) {
        return a->getY() < b->getY();
    });
    std::cout << "Shapes sorted bottom-to-top:\n";
    drawAll(shapes);

    return 0;
}
