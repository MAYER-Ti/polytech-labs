#ifndef POLINOM_H
#define POLINOM_H

#include <iostream>

class Polinom
{
public:
    Polinom();
    Polinom(double k[], int degree);
    ///
    /// \brief operator ()
    /// \param x
    /// \return
    /// Возвращает значение полинома при заданном значении
    double operator()(double x) const;
    Polinom operator+(const Polinom& pol) const;
    Polinom operator-(const Polinom& pol) const;
    Polinom operator*(const Polinom& pol) const;
    friend std::ostream& operator<<(std::ostream& out, const Polinom& pol);
private:
    int m_currentDegree = 0;
    ///
    /// \brief MAX_DEGREE
    /// Максимальная степень
    static const int MAX_DEGREE = 100;
    ///
    /// Коэффициенты полинома, где индекс массива это степень члена полинома
    double m_koefs[MAX_DEGREE] {0};
};

#endif //POLINOM_H
