#ifndef STATISTICCOLLECTOR_H
#define STATISTICCOLLECTOR_H

#include <cstdint>
#include <cstdlib>
#include <ctime>

class StatisticCollector
{
public:
    explicit StatisticCollector();

    void operator()(int value);

    int getMax_val() const;
    int getMin_val() const;
    int getSum() const;
    int getCount() const;
    int getPositive_count() const;
    int getNegative_count() const;
    int getOdd_sum() const;
    int getEven_sum() const;
    bool getFirst_element_set() const;
    int getFirst_element() const;
    int getLast_element() const;
    inline bool isEqualFirstLast() const { return first_element == last_element;};
    inline double average() const { return static_cast<double>(sum) / static_cast<double>(count); };

private:
    bool first_element_set = false; // Флаг установки первого элемента

    int max_val = INT32_MIN;  // Максимальное значение
    int min_val = INT32_MAX;  // Минимальное значение
    int sum = 0;              // Сумма всех элементов
    int count = 0;            // Количество элементов
    int positive_count = 0;   // Количество положительных чисел
    int negative_count = 0;   // Количество отрицательных чисел
    int odd_sum = 0;          // Сумма нечетных элементов
    int even_sum = 0;         // Сумма четных элементов
    int first_element = 0;    // Первый элемент
    int last_element = 0;     // Последний элемент
};

#endif // STATISTICCOLLECTOR_H
