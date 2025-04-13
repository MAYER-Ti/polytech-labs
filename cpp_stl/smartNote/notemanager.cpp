#include "notemanager.h"
#include <algorithm>
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDir>
#include <QMessageBox>

NoteManager::NoteManager()
{
    m_storageFile = QDir::home().filePath("notes.json");
    loadFromFile(m_storageFile);
}

NoteManager::~NoteManager()
{
    saveToFile(m_storageFile);
}

std::shared_ptr<Note> NoteManager::generateNote()
{
    // Генерируем уникальное имя по умолчанию
    int i = 1;
    while (noteTitleExists("Новая заметка " + std::to_string(i))) {
        i++;
    }

    auto note = std::make_shared<Note>();
    note->title = "Новая заметка " + std::to_string(i);
    m_notes.push_front(note);
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
    for (const auto& note : m_notes) {
        hashtags.insert(note->hashtags.begin(), note->hashtags.end());
    }
    return hashtags;
}

std::shared_ptr<Note> NoteManager::findNoteByTitle(const std::string& title) const
{
    auto it = std::find_if(m_notes.begin(), m_notes.end(),
                           [&title](const std::shared_ptr<Note>& note) {
                               return note->title == title;
                           });
    return it != m_notes.end() ? *it : nullptr;
}

bool NoteManager::noteTitleExists(const std::string& title) const
{
    return findNoteByTitle(title) != nullptr;
}

void NoteManager::saveToFile(const QString& filename) const
{
    QJsonArray notesArray;
    for (const auto& note : m_notes) {
        notesArray.append(note->toJson());
    }

    QJsonDocument doc(notesArray);
    QFile file(filename);
    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson());
    }
}

void NoteManager::loadFromFile(const QString& filename)
{
    QFile file(filename);
    if (!file.exists()) return;

    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        QJsonArray notesArray = doc.array();

        for (const auto& noteJson : notesArray) {
            Note note = Note::fromJson(noteJson.toObject());
            m_notes.push_back(std::make_shared<Note>(note));
        }
    }
}
