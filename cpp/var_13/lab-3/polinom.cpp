#include "polinom.h"
#include <cmath>

Polinom::Polinom() {}

Polinom::Polinom(double k[], int degree) : m_currentDegree(degree)
{
    if (degree >= MAX_DEGREE) {
        throw std::invalid_argument("Некорректная степень! Степень должна быть меньше 100!");
    }

    for (int i = 0; i < degree; ++i) {
        m_koefs[i] = k[i];
    }
}

double Polinom::operator()(double x) const
{
    double result = 0.0;
    for (int i = 0; i < MAX_DEGREE; ++i) {
        result += m_koefs[i] * std::pow(x,i);
    }
    return result;
}

Polinom Polinom::operator+(const Polinom &pol) const
{
    Polinom res;
    for (int i = 0; i < MAX_DEGREE; ++i) {
        res.m_koefs[i] = m_koefs[i] + pol.m_koefs[i];
    }
    return res;
}

Polinom Polinom::operator-(const Polinom &pol) const
{
    Polinom res;
    for (int i = 0; i < MAX_DEGREE; ++i) {
        res.m_koefs[i] = this->m_koefs[i] - pol.m_koefs[i];
    }
    return res;
}

Polinom Polinom::operator*(const Polinom &pol) const
{
    if (m_currentDegree + pol.m_currentDegree >= MAX_DEGREE) {
        throw std::invalid_argument("Слишком большая степень полинома после умножения!");
    }
    Polinom res;
    for (int i = 0; i < MAX_DEGREE; ++i) {
        for (int j = 0; j < MAX_DEGREE; ++j) {

            res.m_koefs[i+j] += m_koefs[i] * pol.m_koefs[j];
        }
    }
    return res;
}

std::ostream& operator<<(std::ostream& out, const Polinom& poly) {
    bool isFirst = true;
    for (int i = Polinom::MAX_DEGREE - 1; i >= 0; --i) {
        if (poly.m_koefs[i] != 0) {
            if (!isFirst) {
                if (poly.m_koefs[i] < 0) {
                    out << " - ";
                }
                else {
                    out << " + ";
                }

            }
            out << std::abs(poly.m_koefs[i]) << "x^" << i;
            isFirst = false;
        }
    }
    return out;
}
