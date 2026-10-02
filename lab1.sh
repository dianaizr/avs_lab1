#!/bin/bash

echo "Лабораторная работа №1. Вариант 11"

# Создание каталогов
mkdir -p claude_monet/owner_office
mkdir -p claude_monet/contracts
mkdir -p claude_monet/advertising
mkdir -p claude_monet/kitchen
mkdir -p claude_monet/chef_office
mkdir -p claude_monet/hall
mkdir -p archive


# Создание файлов и запись содержимого

cat > claude_monet/owner_office/owner_order <<'TEXT'
Дмитрий Нагиев требует подготовить ресторан к съёмке
Виктор Петрович должен представить новое меню
Вика отвечает за порядок в зале
TEXT

cat > claude_monet/owner_office/expense_plan <<'TEXT'
Новая вывеска требует согласования
Реклама ресторана оплачивается владельцем
Расходы на банкет проверить отдельно
TEXT

cat > claude_monet/contracts/supplier_contract <<'TEXT'
Поставщик привозит продукты утром
Шеф лично проверяет качество мяса
Оплата производится после приёмки
TEXT

cat > claude_monet/contracts/concert_contract <<'TEXT'
Музыканты выступают в пятницу вечером
Костя готовит напитки для артистов
Вика согласует время начала программы
TEXT

cat > claude_monet/advertising/promo_plan <<'TEXT'
Реклама показывает кухню и главный зал
Нагиев появляется в финале рекламного ролика
Баринов отказывается повторять текст дважды
TEXT

cat > claude_monet/kitchen/chef_order <<'TEXT'
Приготовить фирменное блюдо к восьми часам
Сеня и Федя отвечают за горячий цех
Лёва проверяет выдачу каждого блюда
TEXT

cat > claude_monet/kitchen/menu_prices <<'TEXT'
Утиная ножка 850
Луковый суп 430
Мильфей 520
Стейк от шефа 1100
TEXT

cat > claude_monet/chef_office/barinov_reply <<'TEXT'
Баринов согласен обновить меню
Баринов не согласен сниматься в рекламе
Все решения по кухне принимает шеф
TEXT

cat > claude_monet/hall/vip_guests <<'TEXT'
За первым столом сидят актёры
Для Нагиева оставить место у сцены
Постоянным гостям подать десерт от Луи
TEXT

cat > nagiev_call <<'TEXT'
Нагиев позвонил Вике утром
Владелец приедет после открытия
Отчёт о расходах должен быть готов
TEXT


# Установка прав доступа

chmod 755 claude_monet
chmod u=rwx,g=rx,o= claude_monet/owner_office
chmod 640 claude_monet/owner_office/owner_order
chmod u=rw,g=r,o= claude_monet/owner_office/expense_plan

chmod 750 claude_monet/contracts
chmod u=rw,g=r,o= claude_monet/contracts/supplier_contract
chmod 640 claude_monet/contracts/concert_contract

chmod u=rwx,g=rx,o= claude_monet/advertising
chmod 644 claude_monet/advertising/promo_plan

chmod u=rwx,g=rx,o= claude_monet/kitchen
chmod 640 claude_monet/kitchen/chef_order
chmod u=rw,g=r,o=r claude_monet/kitchen/menu_prices

chmod 750 claude_monet/chef_office
chmod u=rw,g=r,o= claude_monet/chef_office/barinov_reply

chmod 755 claude_monet/hall
chmod u=rw,g=r,o=r claude_monet/hall/vip_guests

chmod u=rwx,g=rx,o= archive
chmod 640 nagiev_call

# Копирование, перемещение и создание ссылок

# 1. Копирование nagiev_call
cp nagiev_call claude_monet/owner_office/nagiev_call_copy

# 2. Копирование каталога advertising
cp -r claude_monet/advertising claude_monet/owner_office/advertising_backup

# 3. Символическая ссылка на supplier_contract
ln -s claude_monet/contracts/supplier_contract owner_contract

# 4. Относительная символическая ссылка на hall
ln -s ../hall claude_monet/owner_office/hall_access

# 5. Жёсткая ссылка на supplier_contract
ln claude_monet/contracts/supplier_contract claude_monet/contracts/supplier_duplicate

# 6. Объединение двух файлов
cat claude_monet/owner_office/owner_order claude_monet/chef_office/barinov_reply > claude_monet/owner_office/meeting_notes

# 7. Дописывание chef_order в nagiev_call
cat claude_monet/kitchen/chef_order >> nagiev_call

# 8. Перемещение promo_plan в archive
mv claude_monet/advertising/promo_plan archive/promo_final

# Поиск, фильтрация и обработка данных

# 1. Пять самых больших обычных файлов без copy
ls -lR | grep '^-' | grep -v 'copy' | sort -k5,5nr | head -n 5

# 2. Строки с Нагиевым или Бариновым без рекламы
grep -RhiE 'нагиев|баринов' claude_monet archive | grep -vi 'реклам' | sort -r | head -n 5

# 3. Количество файлов, содержащих слово поставщик
grep -rli 'поставщик' claude_monet/contracts claude_monet/owner_office | wc -l

# 4. Первая и последняя строки исходных файлов contracts
(head -q -n 1 claude_monet/contracts/supplier_contract claude_monet/contracts/concert_contract; tail -q -n 1 claude_monet/contracts/supplier_contract claude_monet/contracts/concert_contract) | grep -iE 'поставщик|музыкант|оплат' | sort

# 5. Обработка meeting_notes
grep -vi 'согласен' claude_monet/owner_office/meeting_notes | grep -iE 'меню|кухн' | sort -r | wc -w

# 6. Символические ссылки
ls -lR | grep '^l' | sort -k9,9r

# 7. Строки с рекламой из advertising_backup
grep -hi 'реклам' claude_monet/owner_office/advertising_backup/* | grep -v 'Нагиев' | sort | wc -w

# Удаление файлов, ссылок и каталогов

# 1. Удаление копии nagiev_call
rm claude_monet/owner_office/nagiev_call_copy

# 2. Удаление символической ссылки owner_contract
rm owner_contract

# 3. Удаление символической ссылки hall_access
rm claude_monet/owner_office/hall_access

# 4. Удаление жёсткой ссылки supplier_duplicate
rm claude_monet/contracts/supplier_duplicate

# 5. Удаление vip_guests
rm claude_monet/hall/vip_guests

# 6. Удаление пустого каталога hall
rmdir claude_monet/hall

# 7. Удаление пустого каталога advertising
rmdir claude_monet/advertising

# 8. Удаление advertising_backup со всем содержимым
rm -r claude_monet/owner_office/advertising_backup
