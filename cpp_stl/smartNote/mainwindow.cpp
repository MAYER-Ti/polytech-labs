#include "mainwindow.h"
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <QInputDialog>
#include <QMessageBox>
#include <QCloseEvent>
#include <QFileInfo>
#include <QDebug>
#include <QDir>
#include <QMenu>
#include <QToolBar>
#include <QTextBlock>
#include <QRect>
#include <QToolTip>


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    qRegisterMetaType<std::shared_ptr<Note>>("std::shared_ptr<Note>");
    qRegisterMetaType<std::shared_ptr<Note>>("std::shared_ptr<Note>&");

    initializeGui();
    loadNotes();

    connect(m_editor.get(), &QPlainTextEdit::textChanged, this, &MainWindow::onTextChanged);
    connect(m_hashtagsTree.get(), &QTreeWidget::itemClicked, this, &MainWindow::onHashtagsClicked);

    m_filesTree->setContextMenuPolicy(Qt::CustomContextMenu);
    connect(m_filesTree.get(), &QTreeWidget::customContextMenuRequested,
            this, &MainWindow::showNotesContextMenu);
    connect(m_filesTree.get(), &QTreeWidget::itemClicked,
            this, &MainWindow::onNoteSelected);
}

MainWindow::~MainWindow() {}

void MainWindow::closeEvent(QCloseEvent *event)
{
    m_noteManager.saveToFile(QDir::home().filePath("notes.json"));
    QMainWindow::closeEvent(event);
}

void MainWindow::initializeGui()
{
    QWidget* centralWidget = new QWidget(this);

    QHBoxLayout* layout = new QHBoxLayout(centralWidget);
    QVBoxLayout* vlayout = new QVBoxLayout();

    m_editor = std::make_unique<QPlainTextEdit>();
    m_hashtagsTree = std::make_unique<QTreeWidget>();
    m_hashtagsTree->setHeaderLabel("Хэштеги");
    m_filesTree = std::make_unique<QTreeWidget>();
    m_filesTree->setHeaderLabel("Заметки");

    m_ActionCreateNote = std::make_unique<QAction>("Новая заметка");
    m_ActionDeleteNote = std::make_unique<QAction>("Удалить");
    m_ActionRenameNote = std::make_unique<QAction>("Переименовать");

    connect(m_ActionCreateNote.get(), &QAction::triggered, this, &MainWindow::createNewNote);
    connect(m_ActionDeleteNote.get(), &QAction::triggered, this, &MainWindow::deleteSelectedNote);
    connect(m_ActionRenameNote.get(), &QAction::triggered, this, &MainWindow::renameSelectedNote);

    // Добавляем поле фильтрации
    m_hashtagFilter = std::make_unique<QLineEdit>();
    m_hashtagFilter->setPlaceholderText("Фильтр по хэштегам...");
    connect(m_hashtagFilter.get(), &QLineEdit::textChanged,
            this, &MainWindow::filterNotesByHashtag);

    vlayout->addWidget(m_hashtagFilter.get());
    vlayout->addWidget(m_filesTree.get(), 2);
    vlayout->addWidget(m_hashtagsTree.get(), 1);
    layout->addLayout(vlayout, 1);
    layout->addWidget(m_editor.get(), 4);

    setCentralWidget(centralWidget);

    // Создаем панель навигации
    m_navigationToolBar = std::make_unique<QToolBar>("Навигация");
    addToolBar(Qt::TopToolBarArea, m_navigationToolBar.get());

    // Создаем действия для навигации
    m_ActionPrevNote = std::make_unique<QAction>("← Предыдущая");
    m_ActionNextNote = std::make_unique<QAction>("Следующая →");

    // Настраиваем иконки (опционально)
    m_ActionPrevNote->setIcon(QIcon::fromTheme("go-previous"));
    m_ActionNextNote->setIcon(QIcon::fromTheme("go-next"));

    // Добавляем действия на панель
    m_navigationToolBar->addAction(m_ActionPrevNote.get());
    m_navigationToolBar->addAction(m_ActionNextNote.get());

    // Подключаем сигналы
    connect(m_ActionPrevNote.get(), &QAction::triggered, this, &MainWindow::showPreviousNote);
    connect(m_ActionNextNote.get(), &QAction::triggered, this, &MainWindow::showNextNote);

    m_ActionPrevNote->setShortcut(QKeySequence("Ctrl+Left"));
    m_ActionNextNote->setShortcut(QKeySequence("Ctrl+Right"));

    // Настройка автодополнения для хэштегов
    m_completerModel = std::make_unique<QStringListModel>();
    m_hashtagCompleter = std::make_unique<QCompleter>(m_editor.get());
    m_hashtagCompleter->setModel(m_completerModel.get());
    m_hashtagCompleter->setCaseSensitivity(Qt::CaseInsensitive);
    m_hashtagCompleter->setCompletionMode(QCompleter::PopupCompletion);

    // Обновляем модель автодополнения
    updateHashtagCompleter();

    // Подключаем к редактору через event filter
    m_editor->installEventFilter(this);

    // Простые подсказки при вводе #
    connect(m_editor.get(), &QPlainTextEdit::textChanged, [this]() {
        QTextCursor cursor = m_editor->textCursor();
        QString textBeforeCursor = cursor.block().text().left(cursor.positionInBlock());

        if (textBeforeCursor.endsWith("#")) {
            QPoint p(0.0,0.0);
            QToolTip::showText(m_editor->mapToGlobal(p),
                               "Доступные хэштеги: " + m_completerModel->stringList().join(", "),
                               m_editor.get());
        }
    });
    connect(m_hashtagCompleter.get(), QOverload<const QString &>::of(&QCompleter::activated),
            [this](const QString& completeText){
                m_currentCompletion = completeText;
    });
}

void MainWindow::loadNotes()
{
    updateNotesTree();
    if (!m_noteManager.allNotes().empty()) {
        m_currentNote = m_noteManager.allNotes().front();
        m_editor->setPlainText(QString::fromStdString(m_currentNote->text));
    }
}

void MainWindow::updateNotesTree()
{
    m_filesTree->clear();
    for (const auto& note : m_noteManager.allNotes()) {
        QTreeWidgetItem* item = new QTreeWidgetItem(m_filesTree.get());
        item->setText(0, QString::fromStdString(note->title));
        item->setData(0, Qt::UserRole, QVariant::fromValue(note));
    }
}

void MainWindow::onNoteSelected(QTreeWidgetItem* item, int column)
{
    Q_UNUSED(column);

    if (!item) return;

    auto note = item->data(0, Qt::UserRole).value<std::shared_ptr<Note>>();
    if (!note) return;

    // Отключаем сигнал textChanged временно, чтобы не вызывать обновление хэштегов
    disconnect(m_editor.get(), &QPlainTextEdit::textChanged, this, &MainWindow::onTextChanged);

    m_currentNote = note;
    m_editor->setPlainText(QString::fromStdString(note->text));

    // Подключаем сигнал обратно
    connect(m_editor.get(), &QPlainTextEdit::textChanged, this, &MainWindow::onTextChanged);
}

bool MainWindow::eventFilter(QObject *obj, QEvent *event)
{
    if (obj == m_editor.get() && event->type() == QEvent::KeyPress) {
        QKeyEvent* keyEvent = static_cast<QKeyEvent*>(event);


        if (keyEvent->text() == Qt::Key_Tab || keyEvent->text() == Qt::Key_Enter) {
            if (m_hashtagCompleter->popup()->isVisible()) {
                if (!m_currentCompletion.isEmpty()) {
                    m_editor->insertPlainText(m_currentCompletion);
                    m_currentCompletion.clear();
                }
            }
        }
        // Автодополнение при вводе #
        // if (keyEvent->text() == "#") {
        //     showHashtagCompleter();
        //     return true;
        // }

        // Автодополнение при наборе текста после #
        QTextCursor cursor = m_editor->textCursor();
        cursor.movePosition(QTextCursor::Left, QTextCursor::KeepAnchor, 1);
        if (cursor.selectedText() == "#") {
            showHashtagCompleter();
        }
    }
    return QMainWindow::eventFilter(obj, event);
}

void MainWindow::showPreviousNote()
{
    if (!m_currentNote || m_noteManager.allNotes().size() <= 1) return;

    auto notes = m_noteManager.allNotes();
    auto it = std::find(notes.begin(), notes.end(), m_currentNote);

    if (it == notes.end() || it == notes.begin()) {
        it = notes.end();
    }

    --it;
    selectNoteInTree(*it);
}

void MainWindow::showNextNote()
{
    if (!m_currentNote || m_noteManager.allNotes().size() <= 1) return;

    auto notes = m_noteManager.allNotes();
    auto it = std::find(notes.begin(), notes.end(), m_currentNote);

    if (it != notes.end()) {
        ++it;
        if (it == notes.end()) {
            it = notes.begin();
        }
        selectNoteInTree(*it);
    }
}

void MainWindow::filterNotesByHashtag()
{
    QString filter = m_hashtagFilter->text().trimmed();
    if (filter.isEmpty()) {
        // Показать все заметки, если фильтр пуст
        updateNotesTree();
        return;
    }

    // Разбиваем введенные хэштеги (могут быть через пробел или запятую)
    QStringList tags = filter.split(QRegularExpression("[\\s,]+"), Qt::SkipEmptyParts);

    m_filesTree->clear();
    for (const auto& note : m_noteManager.allNotes()) {
        bool matchesAll = true;
        for (const QString& tag : tags) {
            std::string stdTag = tag.startsWith('#')
            ? tag.mid(1).toStdString()
            : tag.toStdString();

            if (note->hashtags.find(stdTag) == note->hashtags.end()) {
                matchesAll = false;
                break;
            }
        }

        if (matchesAll) {
            QTreeWidgetItem* item = new QTreeWidgetItem(m_filesTree.get());
            item->setText(0, QString::fromStdString(note->title));
            item->setData(0, Qt::UserRole, QVariant::fromValue(note));
        }
    }
}

void MainWindow::updateHashtagsTree()
{
    m_hashtagsTree->clear();
    auto hashtags = m_noteManager.allHashtags();

    // Группируем хэштеги по популярности
    std::map<std::string, int> tagCounts;
    for (const auto& note : m_noteManager.allNotes()) {
        for (const auto& tag : note->hashtags) {
            tagCounts[tag]++;
        }
    }

    // Сортируем по популярности
    std::vector<std::pair<std::string, int>> sortedTags(tagCounts.begin(), tagCounts.end());
    std::sort(sortedTags.begin(), sortedTags.end(),
              [](const auto& a, const auto& b) { return a.second > b.second; });

    // Добавляем в дерево с отображением количества
    for (const auto& [tag, count] : sortedTags) {
        QTreeWidgetItem* item = new QTreeWidgetItem(m_hashtagsTree.get());
        item->setText(0, QString("#%1 (%2)").arg(QString::fromStdString(tag)).arg(count));
        item->setData(0, Qt::UserRole, QString::fromStdString(tag));
        item->setToolTip(0, QString("Кликните для просмотра всех заметок с хэштегом #%1")
                                .arg(QString::fromStdString(tag)));
    }
    updateHashtagCompleter();
}

void MainWindow::onTextChanged()
{
    if (!m_currentNote) return;

    m_currentNote->text = m_editor->toPlainText().toStdString();
    m_currentNote->updateHashtags();
    updateHashtagsTree();
}

void MainWindow::onHashtagsClicked(QTreeWidgetItem* item, int column)
{
    Q_UNUSED(column);

    QString tag = item->data(0, Qt::UserRole).toString();
    showNotesWithHashtag(tag.toStdString());
}

void MainWindow::showNotesContextMenu(const QPoint& pos)
{
    QTreeWidgetItem* item = m_filesTree->itemAt(pos);

    QMenu menu;
    menu.addAction(m_ActionCreateNote.get());

    if (item) {
        menu.addAction(m_ActionDeleteNote.get());
        menu.addAction(m_ActionRenameNote.get());
    }

    menu.exec(m_filesTree->viewport()->mapToGlobal(pos));
}

void MainWindow::createNewNote()
{
    m_currentNote = m_noteManager.generateNote();
    updateNotesTree();

    // Выделяем новую заметку в дереве
    selectNoteInTree(m_currentNote);

    m_editor->setPlainText("");
    m_editor->setFocus();
}

bool MainWindow::confirmDelete()
{
    QMessageBox::StandardButton reply;
    reply = QMessageBox::question(this, "Подтверждение",
                                  "Вы действительно хотите удалить эту заметку?",
                                  QMessageBox::Yes|QMessageBox::No);
    return reply == QMessageBox::Yes;
}

void MainWindow::selectNoteInTree(const std::shared_ptr<Note> &note)
{
    for (int i = 0; i < m_filesTree->topLevelItemCount(); ++i) {
        QTreeWidgetItem* item = m_filesTree->topLevelItem(i);
        auto itemNote = item->data(0, Qt::UserRole).value<std::shared_ptr<Note>>();

        if (itemNote == note) {
            m_filesTree->setCurrentItem(item);
            onNoteSelected(item, 0);
            break;
        }
    }
}

void MainWindow::showNotesWithHashtag(const std::string &hashtag)
{
    // Создаем временное окно для отображения заметок с этим хэштегом
    QDialog* dialog = new QDialog(this);
    dialog->setWindowTitle(QString("Заметки с хэштегом #%1").arg(QString::fromStdString(hashtag)));

    QVBoxLayout* layout = new QVBoxLayout(dialog);
    QListWidget* notesList = new QListWidget();

    auto notes = m_noteManager.notesByHashtag(hashtag);
    for (const auto& note : notes) {
        QListWidgetItem* item = new QListWidgetItem(
            QString::fromStdString(note.title + " (" + std::to_string(note.hashtags.size()) + " тегов)"));
        item->setData(Qt::UserRole, QString::fromStdString(note.title));
        notesList->addItem(item);
    }

    connect(notesList, &QListWidget::itemClicked, [this, dialog](QListWidgetItem* item) {
        QString title = item->data(Qt::UserRole).toString();
        auto note = m_noteManager.findNoteByTitle(title.toStdString());
        if (note) {
            selectNoteInTree(note);
            dialog->accept();
        }
    });

    layout->addWidget(notesList);
    dialog->setLayout(layout);
    dialog->exec();
}

void MainWindow::updateHashtagCompleter()
{
    QStringList tags;
    for (const auto& tag : m_noteManager.allHashtags()) {
        tags << "#" + QString::fromStdString(tag);
    }
    m_completerModel->setStringList(tags);
}

void MainWindow::showHashtagCompleter()
{
    QTextCursor cursor = m_editor->textCursor();
    QRect cursorRect = m_editor->cursorRect(cursor);

    // // Позиционируем completer под курсором
    m_hashtagCompleter->setCompletionPrefix(getCurrentHashtagPrefix());
    //m_hashtagCompleter->complete();
    m_hashtagCompleter->setWidget(m_editor.get());
    m_hashtagCompleter->complete();
}

QString MainWindow::getCurrentHashtagPrefix() const
{
    QTextCursor cursor = m_editor->textCursor();
    QString textBeforeCursor = cursor.block().text().left(cursor.positionInBlock());

    // Находим последний # в тексте
    int hashPos = textBeforeCursor.lastIndexOf('#');
    if (hashPos >= 0) {
        return textBeforeCursor.mid(hashPos);
    }
    return QString();
}

void MainWindow::deleteSelectedNote()
{
    QTreeWidgetItem* item = m_filesTree->currentItem();
    if (!item || !confirmDelete()) return;

    auto note = item->data(0, Qt::UserRole).value<std::shared_ptr<Note>>();
    m_noteManager.removeNote(note);

    if (note == m_currentNote) {
        m_currentNote.reset();
        m_editor->clear();
    }

    updateNotesTree();
}

void MainWindow::renameSelectedNote()
{
    QTreeWidgetItem* item = m_filesTree->currentItem();
    if (!item) return;

    auto note = item->data(0, Qt::UserRole).value<std::shared_ptr<Note>>();
    QString currentName = QString::fromStdString(note->title);

    bool ok;
    QString newName = QInputDialog::getText(this, "Переименовать",
                                            "Новое название:",
                                            QLineEdit::Normal,
                                            currentName,
                                            &ok);
    if (ok && !newName.isEmpty()) {
        std::string newNameStd = newName.toStdString();

        if (m_noteManager.noteTitleExists(newNameStd) && newNameStd != note->title) {
            QMessageBox::warning(this, "Ошибка", "Заметка с таким названием уже существует");
            return;
        }

        note->title = newNameStd;
        updateNotesTree();
    }
}
