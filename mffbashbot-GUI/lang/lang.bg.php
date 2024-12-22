<?php
// Повечето имена на сгради се извличат от АКТИВНИ ДАННИ и затова не могат да бъдат намерени тук.

//Ферми и области
$farmFriendlyName = 
[
'1' => 'Ферма 1', 
'2' => 'Ферма 2', 
'3' => 'Ферма 3', 
'4' => 'Ферма 4', 
'5' => 'Ферма 5', 
'6' => 'Ферма 6', 
'7' => 'Ферма 7', 
'8' => 'Ферма 8',
'9' => 'Ферма 9',
'10' => 'Ферма 10',
'farmersmarket' => 'Фермерски пазар', 
'farmersmarket2' => 'Фермерски пазар 2', 
'forestry' => 'Лесовъдство', 
'foodworld' => 'Пикник Област', 
'city2' => 'Подингтън'];

//Продукти от Лесовъдство
$forestryBuildingFriendlyName = 
[
'Дъскорезница', 
'Дърводелство', 
'Лесовъдство'];

//Продукти от Пикник област
$foodworldBuildingFriendlyName = 
[
'Щанд за сода', 
'Щанд за бързо хранене', 
'Магазин за сладки', 
'Салон за сладолед' ];
$farmersmarket2BuildingFriendlyName = ['Обор за крави състезатели', 'Рибарска колиба', 'Скаути'];
//Продукти от фермата за понита
$ponyfarmproductlist = 
[
2 => "2-часов хак", 
4 => "4-часов хак", 
8 => "8-часов хак"];

//Други струни 
$strings['mill'] = 'Мелница';
$strings['pleasewait'] = 'Моля изчакайте...';
$strings['logonfailed'] = 'Входът неуспешен!';
$strings['save'] = 'Запис';
$strings['youareat'] = 'Вие сте тук:';
$strings['lastbotiteration'] = 'Последен вход';
$strings['thebotis'] = 'Ботът в момента е';
$strings['forcebotstart'] = 'Стартиране на бота';
$strings['logon'] = 'Изход';
$strings['options'] = 'Опции';
$strings['moreoptions'] = 'Повече опции';
$strings['ben'] = 'Активиране на Добрият Гофри ежедневно';
$strings['puzzlepartpurchase'] = 'Купи парчета от пъзел за 5000кД ежедневно';
$strings['saynotofarmies'] = 'Отговори с "Не" на всички фермерчета';
$strings['lot'] = 'Лотария';
$strings['instantwin'] = 'Незабавна размяна';
$strings['collectdaily'] = 'събиране ежедневно';
$strings['sheepcart'] = 'Овчарска количка';
$strings['tractor'] = 'Трактор';
$strings['lorry'] = 'Камион';
$strings['sportscar'] = 'Спортна кола';
$strings['truck'] = 'ТИР';
$strings['dogsled'] = 'Кучешки впряг';
$strings['atv'] = 'АТВ';
$strings['snowgroomer'] = 'Снежният гример';
$strings['helicopter'] = 'Хеликоптер';
$strings['hotairballoon'] = 'Балон с горещ въздух';
$strings['coach'] = 'Впряг с коне';
$strings['tuktuk'] = 'Триколка';
$strings['sprinter'] = 'Спринтер';
$strings['drone'] = 'Дрон';
$strings['airplane'] = 'Самолет';
$strings['rowingboat'] = 'Лодка за гребане';
$strings['swampboat'] = 'Блатна лодка';
$strings['barge'] = 'Шлеп';
$strings['waterhelicopter'] = 'Водоносен хеликоптер';
$strings['containership'] = 'Контейнеровоз';
$strings['draisine'] = 'Камион';
$strings['steamtrain'] = 'Локомотив';
$strings['diesellocomotive'] = 'Дизелов Локомотив';
$strings['expresstrain'] = 'Експресен влак';
$strings['freighttrain'] = 'Товарен влак';
$strings['moped'] = 'Мотопед';
$strings['oxcart'] = 'Волска каруца';
$strings['lighttruck'] = 'Светлинен камион';
$strings['suv'] = 'СЮВ';
// lorry is used twice, so it's missing here
$strings['autotransport5'] = 'Транспортиране на стоки от/към Ферма 5';
$strings['autotransport6'] = 'Транспортиране на стоки от/към Ферма 6';
$strings['autotransport7'] = 'Транспортиране на стоки от/към Ферма 7';
$strings['autotransport8'] = 'Транспортиране на стоки от/към Ферма 8';
$strings['autotransport9'] = 'Транспортиране на стоки от/към Ферма 9';
$strings['autotransport10'] = 'Транспортиране на стоки от/към Ферма 10';
$strings['satisfyfoodneed'] = 'Задоволи нуждите от храна';
$strings['satisfytoyneed'] = 'Задоволи нуждите от играчки';
$strings['satisfyplushyneed'] = 'Задоволи нуждите от плюшки';
$strings['botisactive'] = 'АКТИВЕН';
$strings['botisidle'] = 'В ИЗЧАКВАНЕ';
$strings['saynotoforestryfarmies'] = 'Отговори с "Не" на всички фермерчета от Лесовъдство';
$strings['saynotomunchies'] = 'Отговори с "Не" на всички гладници';
$strings['saveNOK'] = 'Грешка при запазването на информацията. Моля, проверете LOG файловете.';
$strings['wrongqueue'] = 'Това не е правилната опашка за този елемент.';
$strings['saveOK'] = 'Запазено';
$strings['notavailable'] = 'Не наличен';
$strings['nonsense'] = 'Този избор няма много смисъл ...';
$strings['missingamount'] = 'Липсва количество!';
$strings['updateavailable'] = 'Наличен ъпдейт: ';
$strings['updateto'] = 'Ъпдейт към';
$strings['confirmupdate'] = 'Това ще започне ъпдейт, който ще отнеме няколко секунди.\nУбедете се че бота е неактивен, преди да натиснете ОК.\n15 секунди след като кликнете ОК ще бъдете изпратени към формата за вход.\n\nИскаш ли да продължа?';
$strings['botisupdating'] = 'Ъпдейтване';
$strings['saynotoflowerfarmies'] = 'Отговори с "Не" на всички цветни фермерчета';
$strings['historyishere'] = '<a href="https://github.com/HackerHarry/mffbashbot/wiki/History" target="_blank">История на версиите</a>';
$strings['correctqueuenumber'] = 'Коригирайте номерата на опашката веднъж';
$strings['useponyenergybar'] = 'Използвайте енергийните барове на Понитата';
$strings['trans25'] = 'Транспортиране към Ферма 5';
$strings['trans26'] = 'Транспортиране към Ферма 6';
$strings['trans27'] = 'Транспортиране към Ферма 7';
$strings['trans28'] = 'Транспортиране към Ферма 8';
$strings['trans29'] = 'Транспортиране към Ферма 9';
$strings['trans210'] = 'Транспортиране към Ферма 10';
$strings['puzzlepartredeem'] = 'Осребрете пакетите с части от пъзела';
$strings['butterflypointbonus'] = 'Съберете бонус точки за пеперуди';
$strings['onehourdelivery'] = 'Събитие за доставка: направете час за доставка';
$strings['powerups'] = 'Ъпгрейди';
$strings['refillolympiaenergy'] = 'Олимпийско / Зимно събитие: Зареждане на енергия';
$strings['dailyseedboxredeem'] = 'Съберете дневните бонуси за семена';
$strings['waltraud'] = 'Активиране на късметлийското магаре Люк ежедневно';
$strings['tools'] = 'Инструменти';
$strings['placebefore'] = 'Вмъкнете обект преди да изберете.';
$strings['deletequeueitem'] = 'Изтриване на избран/ите елементи от опашката.';
$strings['placeatend'] = 'Вмъкване на елемент в края на опашката';
$strings['selectserver'] = 'Моля, изберете сървър';
$strings['enterpw'] = 'Моля, въведете валидна парола.';
$strings['logonsuccess'] = 'Вход УСПЕШЕН. Зареждане на контролният панел';
$strings['error'] = 'Грешка!';
$strings['vetjobeasy'] = 'просто';
$strings['vetjobmedium'] = 'средно';
$strings['vetjobhard'] = 'труден';
$strings['restartvetjob'] = 'ветеринарна практика стартиране';
$strings['startcowrace'] = 'Стартиране на състезание с крави (Обучение)';
$strings['excluderank1cow'] = 'Премахнете първенците от тренировъчното състезание';
$strings['feedsecontestant'] = 'Нахранете състезателя за бързо хранене';
$strings['racecowslots'] = 'Слотове на състезателни крави';
$strings['slot'] = 'Слот';
$strings['collectloginbonus'] = 'Съберете и активирайте входният бонус';
$strings['insert-multiplier'] = 'Въведете множител';
$strings['farmadded'] = 'Фермата е добавена';
$strings['farmadditionfailed'] = 'Неуспешно добавяне на нова ферма';
$strings['startcowracepvp'] = 'Стартиране на състезание с крави (PvP)';
$strings['opencalendardoors'] = 'Календарна събитие: Отворени врати';
$strings['fruitstallslots'] = 'Щанд за плодове';
$strings['stockmgmt'] = 'Управление на стоки';
$strings['buyatmerchant'] = '(отбележете количество) избраните стоки се капуват веднага, щом количеството им спадне на 50% от отбелязаното';
$strings['flowerarrangements'] = 'Цветни аранжименти';
$strings['sendrosieshopping'] = 'Изпращане Рози да пазарува ежедневно';
$strings['butterflies'] = 'Пеперуди';
$strings['speciesbait'] = 'Стръв за видове';
$strings['raritybait'] = 'Стръв за редки видове';
$strings['fishinggear'] = 'Риболовни принадлежности';
$strings['preferredbait'] = 'Предпочитана продукция в/във';
$strings['ben-tt'] = 'Фермерското куче "Добрият Гофри" може да бъде намерен във ферма 1';
$strings['puzzlepartpurchase-tt'] = 'Поръчка на парчета от пъзел';
$strings['puzzlepartredeem-tt'] = 'Осребряване на парчета от пъзел';
$strings['saynotofarmies-tt'] = 'Откажи на всички фермерчета от ферма 1';
$strings['saynotoforestryfarmies-tt'] = 'Откажи на всички фермерчета от Лесовъдство';
$strings['saynotomunchies-tt'] = 'Откажи на всички клиенти от Пикник областта';
$strings['saynotoflowerfarmies-tt'] = 'Откажи на всипки цвеари фермери';
$strings['correctqueuenumber-tt'] = 'Промени номера на опашките във фермите (от 1 до 9)';
$strings['useponyenergybar-tt'] = 'Ако притежавате ферма за понита, може да регулирате използването на "бар за понита" тук';
$strings['butterflypointbonus-tt'] = 'Това означава, че пеперудите ще бъдат освободени';
$strings['onehourdelivery-tt'] = 'Стартиране на печеливша едночасова доставка когато е възможно';
$strings['refillolympiaenergy-tt'] = 'Ако е възможно, това допълва 10% енергия за всяко действие на бота';
$strings['opencalendardoors-tt'] = 'Отваряне на врати от Календарното събитие';
$strings['dailyseedboxredeem-tt'] = 'Събиране на бонусите от Кутията за подаръци';
$strings['waltraud-tt'] = 'Късметлийското магаре Люк се намера във ферма 1';
$strings['startcowrace-tt'] = 'Автоматизиране на състезанията с крави след 42 ниво';
$strings['startcowracepvp-tt'] = 'Стартирай PvP състезания с крави автоматично';
$strings['excluderank1cow-tt'] = 'Пропусни обучението на крави, които са стигнали ниво 1';
$strings['feedsecontestant-tt'] = 'Бързо хранене може да бъде открито на фермерският пазар';
$strings['sendrosieshopping-tt'] = 'Изпрати Рози да пазарува дистанционно (Ниво 49 и нагоре)';
$strings['autotransportO5'] = 'Транспортирай от Ферма 5';
$strings['autotransportO6'] = 'Транспортирай от Ферма 6';
$strings['autotransportO7'] = 'Транспортирай от Ферма 7';
$strings['autotransportO8'] = 'Транспортирай от Ферма 8';
$strings['autotransportO9'] = 'Транспортирай от Ферма 9';
$strings['autotransportO10'] = 'Транспортирай от Ферма 10';
$strings['trimlogstock'] = 'Унищожаване на дънери';
$strings['trimlogstock-tt'] = 'Ако не можете да прибирате дървета, тази опция може да помогне да унищожите част от инвентара';
$strings['removeweed'] = 'Премахни плевели веднъж';
$strings['removeweed-tt'] = 'Премахва плевели, камъни, дънери и хлебарки от полетата';
$strings['careforpeonybush'] = 'Събитие с понита : Приложи поливане и тор';
$strings['careforpeonybush-tt'] = 'Полагане на грижи за храста - полива и тори';
$strings['farmremoved'] = 'Фермата беше премахната';
$strings['farmdeletionfailed'] = 'Провал в изтриването на фермата !';
$strings['passwordmismatch'] = 'Паролата не съвпада';
$strings['checkconfirmbox'] = 'Моля, маркирайте полето';
$strings['harvestvine'] = 'Ожъни лоза ако има свободен бидон';
$strings['harvestvineinautumn'] = 'Ожъни лоза през есента ако времето не е слънчево';
$strings['restartvine'] = 'Посади лоза след жътва';
$strings['removevine'] = 'Замени лоза след 4-та година';
$strings['buyvinetillsunny'] = 'Заменяй докато пролетта не е слънчева';
$strings['harvestvine-tt'] = 'Първият бидон се използва тук';
$strings['harvestvineinautumn-tt'] = 'Не-слънчево време през есента има негативен ефект върху лозата';
$strings['restartvine-tt'] = 'Това работи само, ако лозата е ожъната';
$strings['removevine-tt'] = 'Тази опция купува същият сорт лоза';
$strings['buyvinetillsunny-tt'] = 'Ботът купува лоза докато пролетта не стане слънчева';
$strings['weathermitigation'] = 'Метеорологични контрамерки за всички лози';
$strings['summercut'] = 'Лятно подрязване на лозите';
$strings['wintercut'] = 'Зимно подрязване на лозите';
$strings['middle'] = 'средно';
$strings['short'] = 'късо';
$strings['long'] = 'дълго';
$strings['applytoallvines'] = 'приложено за всички лози';
$strings['leafstripping'] = 'Премахване на листа';
$strings['sproutremoval'] = 'Премахване на издънки';
$strings['grapethinning'] = 'Изтъняване на гроздовете';
$strings['standardfertiliser'] = 'Стандартна тор';
$strings['powerfertiliser'] = 'Силна тор';
$strings['specialfertiliser'] = 'Специална тор';
$strings['waterbucket'] = 'Кофа вода';
$strings['wateringcan'] = 'Градинарска лейка';
$strings['waterhose'] = 'Маркуч за поливане';
$strings['vinefullservice'] = 'Напълни и продай винени бутилки';
$strings['vinefullservice-tt'] = 'Ако няма бъчва, най-узрялото грозе ще бъде бутилирано, бъчви от същият тип може да бъдат презакупени и виното с по-ниско качество ще бъде продадено на изкупвача на вино, ако е наложително';
$strings['sushibar'] = 'Суши бар';
$strings['sushibarsoup'] = 'Сложи супа в купичка ако е възможно';
$strings['sushibarsalad'] = 'Сложи салата на чиния ако е възможно';
$strings['sushibarsushi'] = 'Сложи суши на чиния ако е възможно';
$strings['sushibardessert'] = 'Суши бар десерт';
$strings['lasterror'] = 'Предна грешка';
$strings['scouttaskfood'] = 'Презареди енергия и стартирай задачи';
$strings['doinsecthotel'] = 'Обслужи хотел за насекоми';
$strings['doinsecthotel-tt'] = 'Обслужи хотел за насекоми';
$strings['eventgarden'] = 'Събитие поле';
$strings['doeventgarden'] = 'Обслужи поле за събитие';
$strings['doeventgarden-tt'] = 'Накарайте бота да обслужва опашката за събитиени полета в Пондсвил.';
$strings['dogreenhouse'] = 'Събирайте бонус точки от оранжерията';
$strings['dogreenhouse-tt'] = 'Този бонус може да бъде събиран на всеки 23 часа.';
$strings['spicehouseoven'] = 'Домашна фурна с подправки';
$strings['saynotospicehousefarmies'] = 'n/a';
$strings['saynotospicehousefarmies-tt'] = 'n/a';
// $strings[''] = '';
?>
