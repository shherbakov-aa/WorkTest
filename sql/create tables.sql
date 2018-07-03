-- Создание таблиц для задачи 1

create table t_cities (
  id serial NOT NULL,
  name character varying(15) NOT NULL,
  PRIMARY KEY (id)
);
COMMENT ON TABLE t_cities IS 'Справочник городов';

create table t_carbrands (
  id serial NOT NULL,
  name character varying(20) NOT NULL,
  PRIMARY KEY (id)
);
COMMENT ON TABLE t_carbrands IS 'Справочник марок машин';

create table t_carmodels (
  id serial NOT NULL,
  brand_id integer NOT NULL,
  name character varying(20) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (brand_id)
      REFERENCES t_carbrands (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
);
COMMENT ON TABLE t_carmodels IS 'Справочник моделей машин';

create table t_carcolors (
  id serial NOT NULL,
  name character varying(15) NOT NULL,
  PRIMARY KEY (id)
);
COMMENT ON TABLE t_carcolors IS 'Справочник цветов машин';

create table persons (
  id serial NOT NULL,
  first_name character varying(20) NOT NULL,
  last_name character varying(20) NOT NULL,
  middle_name character varying(20),
  city_id integer NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (city_id)
      REFERENCES t_cities (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
);
COMMENT ON TABLE persons IS 'Таблица людей';

create table cars(
  id serial NOT NULL,
  model_id integer NOT NULL,
  color_id integer NOT NULL,
  reg_number character varying(10),
  owner_id integer,
  PRIMARY KEY (id),
  FOREIGN KEY (model_id)
      REFERENCES t_carmodels (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  FOREIGN KEY (color_id)
      REFERENCES t_carcolors (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  FOREIGN KEY (owner_id)
      REFERENCES persons (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
);
COMMENT ON TABLE cars IS 'Таблица машин';

--=============================
-- Создание таблиц для задачи 2
create table clients (
  id serial NOT NULL,
  first_name character varying(20) NOT NULL,
  last_name character varying(20) NOT NULL,
  middle_name character varying(20),
  email character varying(128) NOT NULL,
  PRIMARY KEY (id)
);
COMMENT ON TABLE clients IS 'Таблица получателей для формы обратной связи';

create table webusers(
  id serial NOT NULL,
  login character varying(32) NOT NULL,
  pwd character varying(32) NOT NULL,
  is_operator boolean NOT NULL DEFAULT false,
  active boolean NOT NULL DEFAULT true,
  jsessionid character varying(32),
  last_login_dt timestamp(0),
  PRIMARY KEY (id),
  UNIQUE (login)
);
COMMENT ON TABLE webusers IS 'Таблица пользователей web-приложения';

create table requests(
  id serial NOT NULL,
  from_first_name character varying(20),
  from_last_name character varying(20),
  from_middle_name character varying(20),
  from_webuser_id integer,
  to_client_id integer NOT NULL,
  subject character varying(30),
  message character varying(100),
  dt timestamp(0) DEFAULT now(),
  PRIMARY KEY (id),
  FOREIGN KEY (from_webuser_id)
      REFERENCES webusers (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  FOREIGN KEY (to_client_id)
      REFERENCES clients (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
);
COMMENT ON TABLE requests IS 'Таблица запросов с формы обратной связи';
