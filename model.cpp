#include "model.h"

Item::Item(QObject* parent)
    : QObject(parent)
{
}

Item::Item(QString title, QObject* parent)
    : QObject(parent),
      title(title),
      checked(false)
{
}

Item* Item::fromVariantMap(const QVariantMap& map)
{
    Item* item    = new Item;
    item->checked = map["selected"].toBool();
    item->title   = map["title"].toString();
    return item;
}

QVariantMap Item::toVariantMap() const
{
    QVariantMap map;
    map["selected"] = checked;
    map["title"]    = title;
    return map;
}

QString Item::getTitle() const
{
    return title;
}

void Item::setTitle(const QString& text)
{
    if (title == text)
        return;

    title = text;
    emit titleChanged();
}

bool Item::isChecked() const
{
    return checked;
}

void Item::setChecked(bool b)
{
    if (checked == b)
        return;

    checked = b;
    emit checkedChanged();
}

Model::Model(QObject* parent)
    : QAbstractListModel(parent)
{
}

void Model::sortByChecked()
{
    beginResetModel();
    std::sort(items.begin(), items.end(), [](auto const& a, auto const& b) {
        return a->isChecked() > b->isChecked();
    });
    endResetModel();
}

void Model::uncheckAll()
{
    beginResetModel();
    for (int i = 0; i < items.size(); ++i)
        items.at(i)->setChecked(false);
    endResetModel();
}

void Model::add(Item* item)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    items.append(item);
    endInsertRows();
}

void Model::remove(int index)
{
    beginRemoveRows(QModelIndex(), index, index);
    items.remove(index);
    endRemoveRows();
}

int Model::count() const
{
    return rowCount();
}

Item* Model::at(int index) const
{
    return items[index];
}

int Model::rowCount(const QModelIndex& parent) const
{
    return items.size();
}

QVariant Model::data(const QModelIndex& index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (role == Qt::DisplayRole)
        return items[index.row()]->getTitle();

    if (role == Qt::UserRole)
        return items[index.row()]->isChecked();

    return QVariant();
}

bool Model::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if (!index.isValid())
        return false;

    if (role == Qt::DisplayRole)
    {
        items[index.row()]->setTitle(value.toString());
        emit dataChanged(index, index, {role});
        return true;
    }

    if (role == Qt::UserRole)
    {
        items[index.row()]->setChecked(value.toBool());
        emit dataChanged(index, index, {role});
        return true;
    }

    return false;
}

QHash<int, QByteArray> Model::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Qt::DisplayRole] = "title";
    roles[Qt::UserRole]    = "selected";
    return roles;
}
