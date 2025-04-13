#ifndef NOTEMANAGER_H
#define NOTEMANAGER_H

#include "note.h"
#include <list>
#include <memory>
#include <QString>

class NoteManager
{
public:
    NoteManager();
    ~NoteManager();

    std::shared_ptr<Note> generateNote();
    void addNote(const Note &note);
    void removeNote(const std::shared_ptr<Note> &note);
    const std::list<std::shared_ptr<Note>> &allNotes() const;
    std::list<Note> notesByHashtag(const std::string &hashtag) const;
    std::set<std::string> allHashtags() const;
    std::shared_ptr<Note> findNoteByTitle(const std::string &title) const;
    bool noteTitleExists(const std::string &title) const;

    void saveToFile(const QString &filename) const;
    void loadFromFile(const QString &filename);

private:
    std::list<std::shared_ptr<Note>> m_notes;
    QString m_storageFile;
};

#endif // NOTEMANAGER_H
