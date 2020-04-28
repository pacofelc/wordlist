-- Es importante tener las tablas de la aplicación separadas
-- de las tablas de sistema.
create schema wordlist;

alter schema wordlist owner to postgres;


-- Por simplicidad no se han añadido, pero las
-- tablas maestras deberían contener atributos de auditoría
-- como la fecha de alta, modificación y baja.

-- -------------------------------------------
-- Tabla maestra de idiomas
-- -------------------------------------------
create table if not exists wordlist.languages
(
	id serial not null
		constraint language_pk
			primary key,
	name char(3) not null,
	description varchar
);

alter table wordlist.languages owner to postgres;

create unique index if not exists languages_name_uindex
	on wordlist.languages (name);

-- -------------------------------------------
-- Tabla maestra de palabras
-- -------------------------------------------
create table if not exists wordlist.words
(
	id serial not null
		constraint words_pk
			primary key,
	word varchar not null
);

alter table wordlist.words owner to postgres;

create unique index if not exists words_word_uindex
	on wordlist.words (word);

-- Tabla maestra de Listas
create table if not exists wordlist.lists
(
	id serial not null
		constraint lists_pk
			primary key,
	name varchar not null,
	description varchar
);

alter table wordlist.lists owner to postgres;

create unique index if not exists lists_name_uindex
	on wordlist.lists (name);

-- -------------------------------------------
-- Composición de las palabras de cada lista
-- -------------------------------------------
create table if not exists wordlist.word_lists
(
	id serial not null
		constraint word_lists_pk
			primary key,
	list_id integer
		constraint word_lists_lists_language_fk
			references wordlist.lists,
	word_id integer
		constraint word_lists_words_id_fk
			references wordlist.words
);

alter table wordlist.word_lists owner to postgres;

create unique index if not exists word_lists_id_uindex
	on wordlist.word_lists (list_id, word_id);

-- -------------------------------------------
-- Traducción de cada lista a su idioma
-- -------------------------------------------
create table if not exists wordlist.list_languages
(
	id serial not null
		constraint list_language_pk
			primary key,
	language_id integer
		constraint list_languages_languages_id_fk
			references wordlist.languages,
	list_id integer
		constraint list_languages_lists_id_fk
			references wordlist.lists,
	translation varchar not null
);

alter table wordlist.list_languages owner to postgres;

create unique index if not exists list_language_language_id_list_id_uindex
	on wordlist.list_languages (language_id, list_id);

-- -------------------------------------------
-- Traducción de cada palabra a su idioma
-- -------------------------------------------
create table if not exists wordlist.word_languages
(
	id serial not null
		constraint word_lang_pk
			primary key,
	language_id integer not null
		constraint word_languages_languages_id_fk
			references wordlist.languages,
	word_id integer
		constraint word_languages_words_id_fk
			references wordlist.words,
	translation varchar
);

alter table wordlist.word_languages owner to postgres;

create unique index if not exists word_languages_language_id_word_id_uindex
	on wordlist.word_languages (language_id, word_id);

-- Comentarios adicionales
--
-- No he añadido una tabla que relacione las listas con un grupo en el que estén incluidas
-- por ejemplo las listas Números I, Números II, Números III... podría tener una clave ajena group_id
-- que haga referencia a la tabla maestra padre "Group" con un registro único "Números"



-- -------------------------------
-- Carga de datos de ejemplo
-- -------------------------------
insert into wordlist.languages (id,name,description) values
(1, 'ESP','Castellano'),
(2, 'ENG','Inglés');

insert into wordlist.lists (id,name,description) values
(1, 'Números I','Lista de números. Primera parte'),
(2, 'Alimentos Básicos I','Alimentos básicos. Primera parte'),
(3, 'Verbos Regulares I','Verbos Regulares. Primera parte');


insert into wordlist.words (id, word) values 
( 0, 'Cero'),
( 1, 'Uno'),
( 2, 'Dos'),
( 3, 'Tres'),
( 4, 'Cuatro'),
( 5, 'Cinco'),
( 6, 'Seis'),
( 7, 'Siete'),
( 8, 'Ocho'),
( 9, 'Nueve'),
(10, 'Diez'),
(11, 'Alimento'),
(12, 'Comida'),
(13, 'Bebida'),
(14, 'Fruta'),
(15, 'Verdura'),
(16, 'Hortaliza'),
(17, 'Huevo'),
(18, 'Caminar'),
(19, 'Estudiar'),
(20, 'Trabajar'),
(21, 'Comprar'),
(22, 'Entregar'),
(23, 'Cocinar'),
(24, 'Cortar');



insert into wordlist.word_languages (id,language_id,word_id,translation) values 
(  0, 1,  0, 'Cero'),
(  1, 1,  1, 'Uno'),
(  2, 1,  2, 'Dos'),
(  3, 1,  3, 'Tres'),
(  4, 1,  4, 'Cuatro'),
(  5, 1,  5, 'Cinco'),
(  6, 1,  6, 'Seis'),
(  7, 1,  7, 'Siete'),
(  8, 1,  8, 'Ocho'),
(  9, 1,  9, 'Nueve'),
( 10, 1, 10, 'Diez'),
( 11, 1, 11, 'Alimento'),
( 12, 1, 12, 'Comida'),
( 13, 1, 13, 'Bebida'),
( 14, 1, 14, 'Fruta'),
( 15, 1, 15, 'Verdura'),
( 16, 1, 16, 'Hortaliza'),
( 17, 1, 17, 'Huevo'),
( 18, 1, 18, 'Caminar'),
( 19, 1, 19, 'Estudiar'),
( 20, 1, 20, 'Trabajar'),
( 21, 1, 21, 'Comprar'),
( 22, 1, 22, 'Entregar'),
( 23, 1, 23, 'Cocinar'),
( 24, 1, 24, 'Cortar'),
(100, 2,  0, 'Zero'),
(101, 2,  1, 'One'),
(102, 2,  2, 'Two'),
(103, 2,  3, 'Three'),
(104, 2,  4, 'Four'),
(105, 2,  5, 'Five'),
(106, 2,  6, 'Six'),
(107, 2,  7, 'Seve'),
(108, 2,  8, 'Eight'),
(109, 2,  9, 'Nine'),
(110, 2, 10, 'Ten'),
(111, 2, 11, 'Food'),
(112, 2, 12, 'Food'),
(113, 2, 13, 'Drink'),
(114, 2, 14, 'Fruit'),
(115, 2, 15, 'Vegetable'),
(116, 2, 16, 'Vegetable'),
(117, 2, 17, 'Egg'),
(118, 2, 18, 'Walk'),
(119, 2, 19, 'Study'),
(120, 2, 20, 'Work'),
(121, 2, 21, 'Buy'),
(122, 2, 22, 'Deliver'),
(123, 2, 23, 'Cook'),
(124, 2, 24, 'Cut');


insert into wordlist.list_languages (id,language_id,list_id,translation) values
( 1, 1, 1, 'Números I'),
( 2, 1, 2, 'Alimentos Básicos I'),
( 3, 1, 3, 'Verbos Regulares I'),
( 4, 2, 1, 'Numbers I'),
( 5, 2, 2, 'Basic Food I'),
( 6, 2, 3, 'Regular Verbs I');


insert into wordlist.word_lists (id, list_id, word_id ) values 
(  0, 1,  0 ),
(  1, 1,  1 ),
(  2, 1,  2 ),
(  3, 1,  3 ),
(  4, 1,  4 ),
(  5, 1,  5 ),
(  6, 1,  6 ),
(  7, 1,  7 ),
(  8, 1,  8 ),
(  9, 1,  9 ),
( 10, 1, 10 ),
( 11, 2, 11 ),
( 12, 2, 12 ),
( 13, 2, 13 ),
( 14, 2, 14 ),
( 15, 2, 15 ),
( 16, 2, 16 ),
( 17, 2, 17 ),
( 18, 3, 18 ),
( 19, 3, 19 ),
( 20, 3, 20 ),
( 21, 3, 21 ),
( 22, 3, 22 ),
( 23, 3, 23 ),
( 24, 3, 24 );










