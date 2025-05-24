#include "note.h"
#include <QRegularExpression>
#include <QJsonArray>

void Note::updateHashtags()
{
    hashtags.clear();
    QRegularExpression re("#([\\wа-яА-ЯёЁ]+)");
    QRegularExpressionMatchIterator i = re.globalMatch(QString::fromStdString(text));
    while (i.hasNext()) {
        QRegularExpressionMatch match = i.next();
        hashtags.insert(match.captured(1).toStdString());
    }
}

QJsonObject Note::toJson() const
{
    QJsonObject json;
    json["title"] = QString::fromStdString(title);
    json["text"] = QString::fromStdString(text);

    QJsonArray tagsArray;
    for (const auto &tag : hashtags) {
        tagsArray.append(QString::fromStdString(tag));
    }
    json["hashtags"] = tagsArray;

    return json;
}

Note Note::fromJson(const QJsonObject &json)
{
    Note note;
    note.title = json["title"].toString().toStdString();
    note.text = json["text"].toString().toStdString();

    QJsonArray tagsArray = json["hashtags"].toArray();
    for (const auto &tag : tagsArray) {
        note.hashtags.insert(tag.toString().toStdString());
    }

    return note;
}
