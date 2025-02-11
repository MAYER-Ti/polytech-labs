#ifndef POLINOM_H
#define POLINOM_H

#include <iostream>

class GeoCoord
{
public:
    // Hemisphere - полушарие
    enum class Hemisphere  {
        NORTH_WEST, NORTH_EAST, SOUTH_WEST, SOUTH_EAST
    };

public:
    GeoCoord(double latitude, double longitude);

    ///
    /// \brief getHemisphere
    /// \return
    /// Возвращает полушарию в котором находится точка
    Hemisphere getHemisphere() const;
    ///
    /// \brief distanceTo
    /// \param point
    /// \return
    /// Возвращает расстояние до точки в км
    double distanceTo(const GeoCoord& point) const;
    ///
    /// \brief timeOfGrinvich
    /// \return
    /// Возвращает смещение времени по гринвичу
    int timeOfGrinvich() const;

    friend std::ostream& operator<<(std::ostream& out, const GeoCoord& point);
    friend std::ostream& operator<<(std::ostream& out, const Hemisphere& point);

private:
    ///
    /// \brief m_lat
    /// Широта
    double m_lat = 0.0;
    ///
    /// \brief m_lon
    ///Долгота
    double m_lon = 0.0;

};

#endif //POLINOM_H
