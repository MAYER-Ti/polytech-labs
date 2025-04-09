#include "note.h"
#include <QRegularExpression>
#include <QDebug>

// bool Note::operator ==(const Note& b)
// {
//     return (this->text == b.text) && (this->hashtags == b.hashtags);
// }

void Note::updateHashtags()
{
    hashtags.clear();
    QRegularExpression re("#(\\w+)");
    QRegularExpressionMatchIterator i = re.globalMatch(QString(text.data()));
    while (i.hasNext()) {
        QRegularExpressionMatch match = i.next();
        hashtags.insert(match.captured(1).toStdString()); // без решетки
    }
    //qDebug() << "Текущие теги:";
    // std::for_each(hashtags.begin(), hashtags.end(),
    //               [](const std::string& tag) {
    //     qDebug() << tag.data();
    // });

}
