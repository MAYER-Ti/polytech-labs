#include "notemanager.h"
#include <algorithm>

std::shared_ptr<Note> NoteManager::generateNote()
{
    m_notes.push_front(std::make_shared<Note>());
    return m_notes.front();
}

void NoteManager::addNote(const Note &note)
{
    m_notes.push_front(std::make_shared<Note>(note));
}

void NoteManager::removeNote(const std::shared_ptr<Note>& note)
{
    m_notes.remove(note);
}

const std::list<std::shared_ptr<Note>> &NoteManager::allNotes() const
{
    return m_notes;
}

std::list<Note> NoteManager::notesByHashtag(const std::string &hashtag) const
{
    std::list<Note> notesByHashtag;
    for (const auto& note : m_notes) {
        if (note->hashtags.find(hashtag) != note->hashtags.end()) {
            notesByHashtag.push_back(*note);
        }
    }
    return notesByHashtag;
}

std::set<std::string> NoteManager::allHashtags() const
{
    std::set<std::string> hashtags;
    std::for_each(m_notes.begin(), m_notes.end(), [&hashtags](const std::shared_ptr<Note>& a) {
        std::for_each(a->hashtags.begin(), a->hashtags.end(), [&hashtags](const std::string& s) {
            hashtags.insert(s);
        });
    });
    return hashtags;
}
