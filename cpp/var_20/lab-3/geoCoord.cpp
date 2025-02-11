#include "geoCoord.h"
#include <cmath>

GeoCoord::GeoCoord(double latitude, double longitude) : m_lat(latitude), m_lon(longitude)
{
    if (latitude < -90.0 || latitude > 90.0 || longitude < -180.0 || longitude > 180.0) {
        throw std::invalid_argument("Некорректное значение широты или долготы.");
    }
}

GeoCoord::Hemisphere GeoCoord::getHemisphere() const
{
    Hemisphere result;
    if (m_lat >= 0 && m_lon >= 0) {
        result = Hemisphere::NORTH_EAST;
    }
    else if (m_lat >= 0 && m_lon < 0) {
        result = Hemisphere::NORTH_WEST;
    }
    else if (m_lat < 0 && m_lon >= 0) {
        result = Hemisphere::SOUTH_EAST;
    }
    else if (m_lat < 0 && m_lon < 0) {
        result = Hemisphere::SOUTH_WEST;
    }
    else {
        throw std::invalid_argument("Невозможно определить полушарие");
    }

    return result;
}

double GeoCoord::distanceTo(const GeoCoord &point) const
{
    // широту и долготу в радианы
    double lat1 = m_lat * M_PI / 180.0;
    double lon1 = m_lon * M_PI / 180.0;
    double lat2 = point.m_lat * M_PI / 180.0;
    double lon2 = point.m_lon * M_PI / 180.0;

    // формула для вычисления ортодромии
    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;
    double a = std::sin(dlat / 2) * std::sin(dlat / 2) +
               std::cos(lat1) * std::cos(lat2) *
               std::sin(dlon / 2) * std::sin(dlon / 2);
    double c = 2 * std::atan2(std::sqrt(a), std::sqrt(1 - a));

    constexpr static double EARTH_RADIUS = 6371.0; //км
    return EARTH_RADIUS * c;
}

int GeoCoord::timeOfGrinvich() const
{
    return static_cast<int>(m_lon / 15.0 * 60);
}

std::ostream& operator<<(std::ostream& out, const GeoCoord& point)
{
    return out << '(' << point.m_lat << ", " << point.m_lon << ')';
}

std::ostream& operator<<(std::ostream& out, const GeoCoord::Hemisphere& hemisphere)
{
    switch (hemisphere) {
    case GeoCoord::Hemisphere::SOUTH_EAST:
        out << "Юго Восток";
        break;
    case GeoCoord::Hemisphere::NORTH_EAST:
        out << "Северо Восток";
        break;
    case GeoCoord::Hemisphere::NORTH_WEST:
        out << "Северо Запад";
        break;
    case GeoCoord::Hemisphere::SOUTH_WEST:
        out << "Юго Запад";
        break;
    default:
        out << "ERROR";
        break;
    }
    return out;
}
