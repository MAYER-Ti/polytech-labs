#ifndef NOTE_H
#define NOTE_H

#include <QString>
#include <set>


//!
//! \brief Структура для хранения записи
//! Хранит текст записи и набор хэштегов к ней
struct Note
{
    std::string text;
    std::set<std::string> hashtags;

    // bool operator ==(const Note& b);

    void updateHashtags();
};

#endif // NOTE_H
