#include "singleton.h"

Item::Item(QObject* parent)
    : QObject(parent)
{
}

Item::Item(QString title, bool checked, QObject* parent)
    : QObject(parent),
      title(title),
      checked(checked)
{
}

Item* Item::fromVariantMap(const QVariantMap& map)
{
    Item* item    = new Item;
    item->checked = map["checked"].toBool();
    item->title   = map["title"].toString();
    return item;
}

QVariantMap Item::toVariantMap() const
{
    QVariantMap map;
    map["checked"] = checked;
    map["title"]   = title;
    return map;
}

Singleton::Singleton(QObject* parent)
    : QObject{parent}
{
}

void Singleton::remove(int index)
{
    model.remove(index);
    emit modelChanged();
}

void Singleton::add(const QString& title)
{
    Item* item = new Item(title);
    add(item);
}

void Singleton::add(Item* item)
{
    model.append(QVariant::fromValue(qobject_cast<QObject*>(item)));
    emit modelChanged();
}

bool Singleton::loadSettings()
{
    int size = settings.beginReadArray("items");
    for (int i = 0; i < size; ++i)
    {
        settings.setArrayIndex(i);
        Item* item = Item::fromVariantMap(settings.value("item").toMap());
        add(item);
    }
    settings.endArray();
    return true;
}

bool Singleton::saveSettings()
{
    settings.beginWriteArray("items");
    for (int i = 0; i < model.size(); ++i)
    {
        settings.setArrayIndex(i);
        settings.setValue("item", model[i].value<Item*>()->toVariantMap());
    }
    settings.endArray();
    settings.sync();
    return settings.status() == QSettings::NoError;
}
