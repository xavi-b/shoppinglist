#ifndef SINGLETON_H
#define SINGLETON_H

#include <QObject>
#include <QVariantList>
#include <QSettings>

class Item : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title MEMBER title NOTIFY titleChanged)
    Q_PROPERTY(bool checked MEMBER checked NOTIFY checkedChanged)

public:
    Item(QObject* parent = nullptr);
    Item(QString title, bool checked = false, QObject* parent = nullptr);

    static Item* fromVariantMap(QVariantMap const& map);
    QVariantMap  toVariantMap() const;

signals:
    void titleChanged();
    void checkedChanged();

private:
    QString title;
    bool    checked = false;
};

class Singleton : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList model MEMBER model NOTIFY modelChanged)

public:
    explicit Singleton(QObject* parent = nullptr);

    Q_INVOKABLE
    void remove(int index);
    Q_INVOKABLE
    void add(QString const& title);
    void add(Item* item);

    bool loadSettings();

    Q_INVOKABLE
    bool saveSettings();

signals:
    void modelChanged();

private:
    QVariantList model;
    QSettings    settings;
};

#endif // SINGLETON_H
