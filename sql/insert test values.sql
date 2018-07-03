--Заполнение тестовыми данными таблицы для задачи 1

insert into t_cities (name) values 
('Екатеринбург'),
('Пермь'),
('Челябинск'),
('Тюмень'),
('Москва'),
('Санкт Петербург'),
('Самара'),
('Уфа'),
('Ульяновск'),
('Киров');

insert into t_carbrands (name) values 
('ВАЗ'),
('Audi'),
('BMV'),
('Chevrolet'),
('Nissan'),
('Toyota');

insert into t_carmodels (brand_id, name) values
((select id from t_carbrands where name = 'ВАЗ'), '2110'),
((select id from t_carbrands where name = 'ВАЗ'), '2112'),
((select id from t_carbrands where name = 'Audi'), 'A4'),
((select id from t_carbrands where name = 'Audi'), 'A6'),
((select id from t_carbrands where name = 'BMV'), 'X1'),
((select id from t_carbrands where name = 'BMV'), 'X6'),
((select id from t_carbrands where name = 'Chevrolet'), 'Cruze'),
((select id from t_carbrands where name = 'Nissan'), 'Teana'),
((select id from t_carbrands where name = 'Nissan'), 'X-Trail'),
((select id from t_carbrands where name = 'Toyota'), 'Corolla');

insert into t_carcolors (name) values
('Черный'),
('Белый'),
('Синий'),
('Серый'),
('Красный'),
('Темно-зеленый'),
('Светло-зеленый');

insert into persons (last_name, first_name ,middle_name, city_id) values
('Иванов', 'Иван', 'Иванович', (select id from t_cities order by id limit 1 offset 0)),
('Петров', 'Петр', 'Петрович', (select id from t_cities order by id limit 1 offset 1)),
('Сидоров', 'Олег', 'Юрьевич', (select id from t_cities order by id limit 1 offset 2)),
('Максимов', 'Никита', 'Сергеевич', (select id from t_cities order by id limit 1 offset 3)),
('Пупкин', 'Василий', 'Эдуардович', (select id from t_cities order by id limit 1 offset 4)),
('Форд', 'Генри', null, (select id from t_cities order by id limit 1 offset 5)),
('Эйнштейн', 'Альберт', '', (select id from t_cities order by id limit 1 offset 6)),
('Пушкин', 'Александр', 'Сергеевич', (select id from t_cities order by id limit 1 offset 7)),
('Некрасов', 'Максим', 'Андреевич', (select id from t_cities order by id limit 1 offset 8)),
('Столбов', 'Анатолий', 'Иванович', (select id from t_cities order by id limit 1 offset 9));


insert into cars(model_id, color_id, reg_number, owner_id) values
((select id from t_carmodels order by id desc limit 1 offset 0), (select id from t_carcolors order by id limit 1 offset 0), 'А111АА77', (select id from persons order by id limit 1 offset 0)),
((select id from t_carmodels order by id desc limit 1 offset 1), (select id from t_carcolors order by id limit 1 offset 1), 'А222АА66', (select id from persons order by id limit 1 offset 1)),
((select id from t_carmodels order by id desc limit 1 offset 2), (select id from t_carcolors order by id limit 1 offset 2), 'А333АА96', (select id from persons order by id limit 1 offset 2)),
((select id from t_carmodels order by id desc limit 1 offset 3), (select id from t_carcolors order by id limit 1 offset 3), 'А444АА177', (select id from persons order by id limit 1 offset 3)),
((select id from t_carmodels order by id desc limit 1 offset 4), (select id from t_carcolors order by id limit 1 offset 4), 'А555АА174', (select id from persons order by id limit 1 offset 4)),
((select id from t_carmodels order by id desc limit 1 offset 5), (select id from t_carcolors order by id limit 1 offset 5), 'А666АА23', (select id from persons order by id limit 1 offset 5)),
((select id from t_carmodels order by id desc limit 1 offset 6), (select id from t_carcolors order by id limit 1 offset 6), 'А777АА13', (select id from persons order by id limit 1 offset 6)),
((select id from t_carmodels order by id desc limit 1 offset 7), (select id from t_carcolors order by id limit 1 offset 0), 'А888АА55', (select id from persons order by id limit 1 offset 7)),
((select id from t_carmodels order by id desc limit 1 offset 8), (select id from t_carcolors order by id limit 1 offset 1), 'А999АА88', (select id from persons order by id limit 1 offset 8)),
((select id from t_carmodels order by id desc limit 1 offset 9), (select id from t_carcolors order by id limit 1 offset 2), null, (select id from persons order by id limit 1 offset 0));


--==========================
--заполнение тестовых данных для задачи 2
--==========================

insert into clients(first_name, last_name, middle_name, email) values
('Иванов', 'Иван', 'Иванович', 'ivanov@mail.ru'),
('Петров', 'Петр', 'Петрович', 'petrov@mail.ru'),
('Сидоров', 'Олег', 'Юрьевич', 'sidorov@mail.ru'),
('Генри', 'Форд', null, 'gf@mail.ru');

insert into webusers (login, pwd, is_operator) values ('user1', '111', true), ('user2', '222', false), ('user3', '333', false);

insert into requests(from_first_name, from_last_name, from_middle_name, from_webuser_id, to_client_id, subject, message, dt) values
('Максим', 'Максимович', 'Максимов', null, (select id from clients order by id limit 1), 'Тема сообщения', 'Текст сообщения', now()),
('', '', '', (select id from webusers order by id limit 1), (select id from clients order by id limit 1), 'Привет', 'Просто сообщение', now() - interval '2345 minutes');
