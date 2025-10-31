# Итого задание по модулю 5 - Курс "Системы Хранения Данных"

## 🧩 Описание

Проект демонстрирует реализацию **архитектуры Data Vault 2.0** для аналитической модели на основе открытого набора данных **SampleSuperstore.csv**.  

---

## 📁 Структура проекта

| Каталог / Файл | Назначение |
|----------------|------------|
| `SampleSuperstore.csv` | Исходный CSV-файл с данными о продажах, доставке и товарах |
| `DataVault_diagram.png` | Графическое представление схемы |
| `data_check.png` | Проверка загрзуки данных в DataVualt |
| `sql/DataVault_structure.sql` | DDL-скрипт для создания всех таблиц Data Vault |
| `README.md` | Документация проекта |

---

## 📄 Исходный файл `SampleSuperstore.csv`


**Структура полей:**

| Категория | Поля | Описание |
|------------|------|-----------|
| **Shipment** | Ship Mode | Способ доставки |
| **Customer Class** | Segment | Сегмент клиента |
| **Location** | Country, City, State, Postal Code, Region | Географическая информация |
| **Product** | Category, Sub-Category | Категория и подкатегория товара |
| **Stats** | Sales, Quantity, Discount, Profit | Метрики продаж |

---

## 🧱 Архитектура Data Vault

### 🏗️ Основные сущности

#### **Хабы**
| Хаб | Бизнес-ключ | Назначение |
|-----|--------------|------------|
| `HUB_SHIPMENT` | Ship Mode | Способы доставки |
| `HUB_SEGMENT` | Segment | Сегменты клиентов |
| `HUB_LOCATION` | Country + City + Postal Code | Географическая зона |
| `HUB_PRODUCT` | Category + Sub-Category | Категории товаров |

#### **Линк**
| Линк | Соединяет | Назначение |
|------|------------|------------|
| `LINK_SALE` | Shipment + Segment + Location + Product | Контекст продажи (факт связывания всех хабов) |

#### **Спутники**
| Спутник | Привязан к | Содержит | Комментарий |
|----------|-------------|-----------|-------------|
| `SAT_PRODUCT_ATTR` | HUB_PRODUCT | Category, Sub-Category | Атрибуты товара |
| `SAT_LOCATION_ATTR` | HUB_LOCATION | Country, State, City, Region, Postal Code | Географические атрибуты |
| `SAT_SALE_FACTS` | LINK_SALE | Sales, Quantity, Discount, Profit | Фактические показатели продаж |

![Диаграмма Data Vault](DataVault_diagram.png)

## ⚙️ Технические особенности

- **Хэширование:** `MD5()`  
  - Для бизнес-ключей (Hub Keys, Link Keys)  
  - Для вычисления `hashdiff` в спутниках
- **PK в спутниках:** `(business_hashkey, hashdiff)`  
  - обеспечивает уникальность по ключу и содержимому без зависимости от `loaddate`
- **Атрибуты метаданных:**
  - `loaddate` — дата и время загрузки записи  
  - `recordsource` — источник данных (`'CSV_SUPERSTORE'`)


