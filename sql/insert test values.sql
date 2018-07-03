--���������� ��������� ������� ������� ��� ������ 1

insert into t_cities (name) values 
('������������'),
('�����'),
('���������'),
('������'),
('������'),
('����� ���������'),
('������'),
('���'),
('���������'),
('�����');

insert into t_carbrands (name) values 
('���'),
('Audi'),
('BMV'),
('Chevrolet'),
('Nissan'),
('Toyota');

insert into t_carmodels (brand_id, name) values
((select id from t_carbrands where name = '���'), '2110'),
((select id from t_carbrands where name = '���'), '2112'),
((select id from t_carbrands where name = 'Audi'), 'A4'),
((select id from t_carbrands where name = 'Audi'), 'A6'),
((select id from t_carbrands where name = 'BMV'), 'X1'),
((select id from t_carbrands where name = 'BMV'), 'X6'),
((select id from t_carbrands where name = 'Chevrolet'), 'Cruze'),
((select id from t_carbrands where name = 'Nissan'), 'Teana'),
((select id from t_carbrands where name = 'Nissan'), 'X-Trail'),
((select id from t_carbrands where name = 'Toyota'), 'Corolla');

insert into t_carcolors (name) values
('������'),
('�����'),
('�����'),
('�����'),
('�������'),
('�����-�������'),
('������-�������');

insert into persons (last_name, first_name ,middle_name, city_id) values
('������', '����', '��������', (select id from t_cities order by id limit 1 offset 0)),
('������', '����', '��������', (select id from t_cities order by id limit 1 offset 1)),
('�������', '����', '�������', (select id from t_cities order by id limit 1 offset 2)),
('��������', '������', '���������', (select id from t_cities order by id limit 1 offset 3)),
('������', '�������', '����������', (select id from t_cities order by id limit 1 offset 4)),
('����', '�����', null, (select id from t_cities order by id limit 1 offset 5)),
('��������', '�������', '', (select id from t_cities order by id limit 1 offset 6)),
('������', '���������', '���������', (select id from t_cities order by id limit 1 offset 7)),
('��������', '������', '���������', (select id from t_cities order by id limit 1 offset 8)),
('�������', '��������', '��������', (select id from t_cities order by id limit 1 offset 9));


insert into cars(model_id, color_id, reg_number, owner_id) values
((select id from t_carmodels order by id desc limit 1 offset 0), (select id from t_carcolors order by id limit 1 offset 0), '�111��77', (select id from persons order by id limit 1 offset 0)),
((select id from t_carmodels order by id desc limit 1 offset 1), (select id from t_carcolors order by id limit 1 offset 1), '�222��66', (select id from persons order by id limit 1 offset 1)),
((select id from t_carmodels order by id desc limit 1 offset 2), (select id from t_carcolors order by id limit 1 offset 2), '�333��96', (select id from persons order by id limit 1 offset 2)),
((select id from t_carmodels order by id desc limit 1 offset 3), (select id from t_carcolors order by id limit 1 offset 3), '�444��177', (select id from persons order by id limit 1 offset 3)),
((select id from t_carmodels order by id desc limit 1 offset 4), (select id from t_carcolors order by id limit 1 offset 4), '�555��174', (select id from persons order by id limit 1 offset 4)),
((select id from t_carmodels order by id desc limit 1 offset 5), (select id from t_carcolors order by id limit 1 offset 5), '�666��23', (select id from persons order by id limit 1 offset 5)),
((select id from t_carmodels order by id desc limit 1 offset 6), (select id from t_carcolors order by id limit 1 offset 6), '�777��13', (select id from persons order by id limit 1 offset 6)),
((select id from t_carmodels order by id desc limit 1 offset 7), (select id from t_carcolors order by id limit 1 offset 0), '�888��55', (select id from persons order by id limit 1 offset 7)),
((select id from t_carmodels order by id desc limit 1 offset 8), (select id from t_carcolors order by id limit 1 offset 1), '�999��88', (select id from persons order by id limit 1 offset 8)),
((select id from t_carmodels order by id desc limit 1 offset 9), (select id from t_carcolors order by id limit 1 offset 2), null, (select id from persons order by id limit 1 offset 0));


--==========================
--���������� �������� ������ ��� ������ 2
--==========================

insert into clients(first_name, last_name, middle_name, email) values
('������', '����', '��������', 'ivanov@mail.ru'),
('������', '����', '��������', 'petrov@mail.ru'),
('�������', '����', '�������', 'sidorov@mail.ru'),
('�����', '����', null, 'gf@mail.ru');

insert into webusers (login, pwd, is_operator) values ('user1', '111', true), ('user2', '222', false), ('user3', '333', false);

insert into requests(from_first_name, from_last_name, from_middle_name, from_webuser_id, to_client_id, subject, message, dt) values
('������', '����������', '��������', null, (select id from clients order by id limit 1), '���� ���������', '����� ���������', now()),
('', '', '', (select id from webusers order by id limit 1), (select id from clients order by id limit 1), '������', '������ ���������', now() - interval '2345 minutes');
