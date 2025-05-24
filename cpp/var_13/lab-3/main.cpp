#include <iostream>
#include "polinom.h"

/// Лютов А.В. 30022, вариант 13
///
/// Задание
/// Разработать класс многочленов (для хранения коэффициентов использовать массив
/// фиксированного размера из 100 элементов). Методы для вычисления значения многочлена
/// для заданного аргумента, для сложения, вычитания и умножения многочленов. Подсказка:
/// коэффициенты многочленов можно хранить в виде обычных массивов, не используйте
/// std::vector и динамическое выделение памяти
///

int main()
{
    double koefs1[] {1.5, 2.9, -0.3};
    double koefs2[] {0, 5.1, -1.4, 3.2};


    try {
        Polinom pol1(koefs1, sizeof(koefs1)/sizeof(double));
        Polinom pol2(koefs2, sizeof(koefs2)/sizeof(double));

        std::cout << "Полином 1:\t" << pol1 << '\n';
        std::cout << "Полином 2:\t" << pol2 << '\n';
        std::cout << "Сумма:\t\t" << pol1 + pol2 << '\n';
        std::cout << "Разница:\t" << pol1 - pol2 << '\n';
        std::cout << "Произведение:\t" << pol1 * pol2 << '\n';

        //Polinom polExeption(koefs2, 100); // исключение!
    }
    catch (std::invalid_argument& e) {
        std::cerr << e.what() << '\n';
        return -1;
    }


    return 0;
}
