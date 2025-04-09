#ifndef NOTEMANAGER_H
#define NOTEMANAGER_H

#include "note.h"
#include <list>
#include <memory>
//!
//! \brief Менеджер записей
//! Хранит все записи, имеет методы работы с записями
class NoteManager
{
public:
    std::shared_ptr<Note> generateNote();
    void addNote(const Note& note);
    void removeNote(const std::shared_ptr<Note> &note);
    const std::list<std::shared_ptr<Note> > &allNotes() const;
    std::list<Note> notesByHashtag(const std::string& hashtag) const;
    std::set<std::string> allHashtags() const;

private:
    std::list<std::shared_ptr<Note>> m_notes;
};

#endif // NOTEMANAGER_H
