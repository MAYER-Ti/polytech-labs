#ifndef NOTE_H
#define NOTE_H

#include <string>
#include <set>
#include <QJsonObject>

struct Note
{
    std::string text;
    std::string title;
    std::set<std::string> hashtags;

    void updateHashtags();
    QJsonObject toJson() const;
    static Note fromJson(const QJsonObject &json);
};

Q_DECLARE_METATYPE(std::shared_ptr<Note>)

#endif // NOTE_H
