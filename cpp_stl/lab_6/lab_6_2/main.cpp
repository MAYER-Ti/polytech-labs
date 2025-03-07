// Лютов А.В. 30022

//2.	Написать программу, которая выполняет следующие действия (все операции должны выполняться с помощью стандартных алгоритмов):
// a.   Заполняет вектор геометрическими фигурами. Геометрическая фигура может быть треугольником, квадратом,
// прямоугольником или пяти угольником. Структура описывающая геометрическую фигуру  определена ниже,
// b.   Подсчитывает общее количество вершин всех фигур содержащихся в векторе(
// так треугольник добавляет к общему числу3, квадрат4 и т.д.)
// c.   Подсчитывает количество треугольников, квадратов и прямоугольников в векторе
// d.   Удаляет все пятиугольники
// e.	На основании этого вектора создает vector<Point>, который содержит координаты одной из вершин (любой) каждой
// фигуры, т.е. первый элемент этого вектора содержит координаты одной из вершину первой фигуры, второй элемент этого
// вектора содержит координаты одной из вершину второй фигуры и т.д.
// f.	Изменяет вектор так, чтобы он содержал в начале все треугольники, потом все квадраты, а потом прямоугольники.
// g.   Распечатывает вектор после каждого этапа работы

//
// Геометрическая фигура задается следующей структурой:
//
// typedef struct {
//     int vertex_num; // количество вершин, для треугольника 3, для квадрата и
//     // прямоугольника 4, для пяти угольника 5
//     vector<Point> vertexes; // вектор содержащий координаты вершин фигуры
//     // Для треугольника содержит 3 элемента
//     // Для квадрата и прямоугольника содержит 4
//     // элемента
//     // Для пятиугольника 5 элементов
// } Shape;
//
// typedef struct {
//     int x, y;
// } Point;
//
#include <iostream>
#include <vector>
#include <algorithm>

struct Point {
    int x, y;
};

struct Shape {
    int vertex_num;
    std::vector<Point> vertexes;
};

// Функция для подсчета общего количества вершин
int count_total_vertices(const std::vector<Shape>& shapes) {
    int total = 0;
    for (const auto& shape : shapes) {
        total += shape.vertex_num;
    }
    return total;
}

// Функция для подсчета количества фигур каждого типа
void count_shapes(const std::vector<Shape>& shapes, int& triangles, int& squares, int& pentagons) {
    triangles = squares = pentagons = 0;
    for (const auto& shape : shapes) {
        if (shape.vertex_num == 3) {
            triangles++;
        } else if (shape.vertex_num == 4) {
            squares++;
        } else if (shape.vertex_num == 5) {
            pentagons++;
        }
    }
}

// Функция для удаления пятиугольников
void remove_pentagons(std::vector<Shape>& shapes) {
    shapes.erase(std::remove_if(shapes.begin(), shapes.end(), [](const Shape& shape) {
        return shape.vertex_num == 5;
    }), shapes.end());
}

// Функция для создания вектора точек из вершин фигур
std::vector<Point> create_points_vector(const std::vector<Shape>& shapes) {
    std::vector<Point> points;
    for (const auto& shape : shapes) {
        points.push_back(shape.vertexes[0]); // Берем первую вершину каждой фигуры
    }
    return points;
}

// Функция для сортировки фигур: сначала треугольники, затем квадраты, затем прямоугольники
void sort_shapes(std::vector<Shape>& shapes) {
    std::sort(shapes.begin(), shapes.end(), [](const Shape& a, const Shape& b) {
        if (a.vertex_num == 3) return true;
        if (b.vertex_num == 3) return false;
        if (a.vertex_num == 4 && a.vertexes[0].x == a.vertexes[1].x && a.vertexes[1].y == a.vertexes[2].y) return true;
        if (b.vertex_num == 4 && b.vertexes[0].x == b.vertexes[1].x && b.vertexes[1].y == b.vertexes[2].y) return false;
        return a.vertex_num < b.vertex_num;
    });
}

// Функция для печати вектора фигур
void print_shapes(const std::vector<Shape>& shapes) {
    for (const auto& shape : shapes) {
        std::cout << "Shape with " << shape.vertex_num << " vertices: ";
        for (const auto& vertex : shape.vertexes) {
            std::cout << "(" << vertex.x << "," << vertex.y << ") ";
        }
        std::cout << std::endl;
    }
}

int main() {

    std::vector<Shape> shapes = {

        Shape {4, {{0, 0}, {1, 0}, {1, 1}, {0, 1}}}, // Квадрат
        Shape {4, {{0, 0}, {2, 0}, {2, 1}, {0, 1}}}, // Прямоугольник
        Shape {3, {{0, 0}, {1, 0}, {0, 1}}}, // Треугольник
        Shape {5, {{0, 0}, {1, 0}, {1, 1}, {1, 2}, {0, 1}}} // Пятиугольник
    };
    // Первоначальные данные
    print_shapes(shapes);

    // a. Подсчет общего количества вершин
    int total_vertices = count_total_vertices(shapes);
    std::cout << "Total number of vertices: " << total_vertices << std::endl;

    // b. Подсчет количества треугольников, квадратов и прямоугольников
    int triangles, squares, pentagons;
    count_shapes(shapes, triangles, squares, pentagons);
    std::cout << "Triangles: " << triangles << ", Squares: " << squares << ", Pentagons: " << pentagons << std::endl;

    // c. Удаление пятиугольников
    remove_pentagons(shapes);
    std::cout << "After removing pentagons:" << std::endl;
    print_shapes(shapes);

    // d. Создание вектора точек
    std::vector<Point> points = create_points_vector(shapes);
    std::cout << "Vector of points:" << std::endl;
    for (const auto& point : points) {
        std::cout << "(" << point.x << "," << point.y << ") ";
    }
    std::cout << std::endl;

    // e. Сортировка фигур
    sort_shapes(shapes);
    std::cout << "After sorting:" << std::endl;
    print_shapes(shapes);

    return 0;
}