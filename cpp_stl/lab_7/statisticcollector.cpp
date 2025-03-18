#include "statisticcollector.h"

StatisticCollector::StatisticCollector() {}

void StatisticCollector::operator()(int value)
{
    // Обновление максимального и минимального значений
    if (value > max_val) max_val = value;
    if (value < min_val) min_val = value;
    // Сумма всех элементов
    sum += value;
    // Подсчет количества положительных и отрицательных чисел
    if (value > 0) ++positive_count;
    if (value < 0) ++negative_count;
    // Сумма четных и нечетных элементов
    if (value % 2 == 0) even_sum += value;
    else odd_sum += value;
    // Установка первого элемента
    if (!first_element_set) {
        first_element = value;
        first_element_set = true;
    }
    // Обновление последнего элемента
    last_element = value;
    // Увеличение счетчика элементов
    ++count;
}

int StatisticCollector::getMax_val() const
{
    return max_val;
}

int StatisticCollector::getMin_val() const
{
    return min_val;
}

int StatisticCollector::getSum() const
{
    return sum;
}

int StatisticCollector::getCount() const
{
    return count;
}

int StatisticCollector::getPositive_count() const
{
    return positive_count;
}

int StatisticCollector::getNegative_count() const
{
    return negative_count;
}

int StatisticCollector::getOdd_sum() const
{
    return odd_sum;
}

int StatisticCollector::getEven_sum() const
{
    return even_sum;
}

bool StatisticCollector::getFirst_element_set() const
{
    return first_element_set;
}

int StatisticCollector::getFirst_element() const
{
    return first_element;
}

int StatisticCollector::getLast_element() const
{
    return last_element;
}
