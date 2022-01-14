use SBD_TP1;

/* --------------------- Dados Tabela Pessoa --------------------- */

INSERT INTO pessoa values ('Portugues', 7304002, '1998-01-08', 'Luís Carlos');
INSERT INTO pessoa values ('Cabo-verdiano', 6938521, '1998-02-10', 'Antonio Silva');
INSERT INTO pessoa values ('Nigeriano', 7896542, '1990-08-29', 'Josue Molumbo');
INSERT INTO pessoa values ('Ingles', 1597530, '1969-01-31', 'Charles Ingram');
INSERT INTO pessoa values ('Portugues', 6541238, '1900-08-12', 'Diogo Galaio');
INSERT INTO pessoa values ('Portugues', 4862795, '1996-04-21', 'Vasco Cruz');
INSERT INTO pessoa values ('Portugues', 1239875, '2000-04-01', 'Joao Almeida');
INSERT INTO pessoa values ('Brasileiro', 5123578, '1996-07-10', 'Jose Triangulo');
INSERT INTO pessoa values ('Americano', 5287416, '1980-04-20', 'Quentin Tarantino');
INSERT INTO pessoa values ('Americano', 4569872, '1954-06-25', 'Brad Pitt');
INSERT INTO pessoa values ('Americano', 6541230, '1969-10-14', 'Michael B jordan');
INSERT INTO pessoa values ('Americano', 9426351, '1964-08-11', 'Angelina Jolie');
INSERT INTO pessoa values ('Americano', 6523987, '1978-08-23', 'James Arthur');
INSERT INTO pessoa values ('Espanhol', 7854125, '1981-09-30', 'J Balvin');
INSERT INTO pessoa values ('Portugues', 8524569, '1982-12-28', 'Sebastiao Salgado');
INSERT INTO pessoa values ('Portugues', 1111111, '1999-05-20', 'Default User');
INSERT INTO pessoa values ('Portugues', 9999999, '1988-02-12', 'Default Admin');


/* --------------------- Dados Tabela Utilizador --------------------- */


INSERT INTO utilizador values ('SilentRequiem', 7304002, 0);
INSERT INTO utilizador values ('NonceGaio', 6541238, 0);
INSERT INTO utilizador values ('GateKepre', 6938521, 0);
INSERT INTO utilizador values ('OhStor', 4862795, 0);
INSERT INTO utilizador values ('Scam4Ever', 1597530, 0);
INSERT INTO utilizador values ('BillionareCheater', 1597530, 0);
INSERT INTO utilizador values ('punhas', 1239875, 0);
INSERT INTO utilizador values ('IMORTALPOWA', 1239875, 0);
INSERT INTO utilizador values ('JamesVEVO', 6523987, 0);
INSERT INTO utilizador values ('convidado', 1111111, 0);
INSERT INTO utilizador values ('admin', 9999999, 0);

/* --------------------- Dados Tabela Administrador --------------------- */

INSERT INTO administrador values (1, 7304002);
INSERT INTO administrador values (2, 7896542);
INSERT INTO administrador values (3, 5123578);

/* --------------------- Dados Tabela Autores --------------------- */

INSERT INTO autor values (6938521, 'realizador');
INSERT INTO autor values (6938521, 'poeta');
INSERT INTO autor values (4569872, 'ator');
INSERT INTO autor values (5287416, 'realizador');
INSERT INTO autor values (6541230, 'ator');
INSERT INTO autor values (9426351, 'ator');
INSERT INTO autor values (1239875, 'poeta');
INSERT INTO autor values (6523987, 'musico');
INSERT INTO autor values (7854125, 'musico');
INSERT INTO autor values (7854125, 'letrista');
INSERT INTO autor values (8524569, 'fotografo');
INSERT INTO autor values (1597530, 'musico');
INSERT INTO autor values (1597530, 'letrista');

/* --------------------- Dados Tabela Recursos --------------------- */

INSERT INTO recurso values (53, 'NonceGaio', 1, load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pandp.mp4'), 'Filme', 'Modelo Presa e Predador', 'Fantastica historia de um homem a seguir a sua presa','2013-06-12 12:00:00', 1, 1,18);
INSERT INTO recurso values (54, 'punhas', 1, load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/gatekeeper.txt'), 'Poema', 'A Beleza dos Gatekeepers', 'Um poema de rir e chorar por mais', '2020-12-11 19:43:00', 4, 0, 12);
INSERT INTO recurso values (55, 'JamesVEVO', 2, load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/impossible.mp3'), 'Musica', 'Impossible', 'A very inspiring song about my life', '2010-07-24 15:35:37', 5, 0, 6);
INSERT INTO recurso values (67, 'JamesVEVO', 1, load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/funkharrypotter.mp3'), 'Musica', 'Funki do Harry Potter', 'Diretamente de Hogwarts - Wingdardium Levi Rola', '2015-04-10 23:01:47', 5, 1, 18);
INSERT INTO recurso values (69, 'SilentRequiem', 3, load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/flormaisbela.txt'), 'Poema', 'Flor Mais Bela', 'Historia de Amor cantada no melhor portugues', '2020-12-10 17:00:00', 3, 0, 12);
INSERT INTO recurso values (70, 'SilentRequiem', 1, load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/marportugues.txt'), 'Poema', 'O Mar Portugues', 'Poema do mar', '2018-10-08 10:25:59', 4, 0, 6);
INSERT INTO recurso values (74, 'OhStor', 1, load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/campo.jpg'), 'Fotografia', 'Fotografia Do Campo', 'Bela Paisagem', '2012-05-14 13:25:00', 2, 1, 6);
INSERT INTO recurso values (75, 'GateKepre', 2, load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/equipa.jpg'), 'Fotografia', 'Equipas', 'Duas equipas que se enfrentam na liga portuguesa', '2015-12-25 19:59:59', 5, 0, 12);
INSERT INTO recurso values (76, 'GateKepre', 3, load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/isel.jpg'), 'Fotografia', 'Faculdade', 'Faculdade de Engenharia de Lisboa', '2018-10-20 21:59:59', 4, 0, 6);
INSERT INTO recurso values (77, 'IMORTALPOWA', 1, load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/baleiaazul.mp4'), 'Filme', 'Baleias', 'A Baleia azul e o perigo de entrar em extinção', '2019-09-09 23:08:00', 5, 0, 16);
INSERT INTO recurso values (80, 'BillionareCheater', 2, load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/millionairecheater.mp3'), 'Musica', 'Quem quer ser milionario', 'Musica de um cheater cheatando', '2007-02-25 17:26:03', 3, 1, 6);

/* --------------------- Dados Tabela Comentarios --------------------- */

INSERT INTO comentario values (53, 'punhas', 'FBI, onde andas????!!!! open the door!!!!');
INSERT INTO comentario values (54, 'IMORTALPOWA', 'sabes quem é o master slave determination?');
INSERT INTO comentario values (76, 'SilentRequiem', 'A comida da cantina é a melhor coisa que ja comi');
INSERT INTO comentario values (55, 'OhStor', 'Voces ouviram o que ele disse? BRIDGE PRIURITI');

/* --------------------- Dados Tabela Classificações --------------------- */

INSERT INTO classificacao values (75, 'GateKepre', 5);
INSERT INTO classificacao values (76, 'SilentRequiem', 1);
INSERT INTO classificacao values (70, 'punhas', 2);
INSERT INTO classificacao values (53, 'Scam4Ever', 4);
INSERT INTO classificacao values (54, 'Scam4Ever', 5);
INSERT INTO classificacao values (55, 'Scam4Ever', 5);
INSERT INTO classificacao values (67, 'IMORTALPOWA', 1);
INSERT INTO classificacao values (69, 'OhStor', 3);
INSERT INTO classificacao values (74, 'BillionareCheater', 4);
INSERT INTO classificacao values (77, 'Scam4Ever', 2);
INSERT INTO classificacao values (80, 'JamesVEVO', 5);

/* --------------------- Dados Tabela Aceder --------------------- */

INSERT INTO aceder values (53, 'punhas');
INSERT INTO aceder values (54, 'IMORTALPOWA');
INSERT INTO aceder values (76, 'SilentRequiem');
INSERT INTO aceder values (55, 'OhStor');
INSERT INTO aceder values (75, 'GateKepre');
INSERT INTO aceder values (70, 'punhas');
INSERT INTO aceder values (53, 'Scam4Ever');

/* --------------------- Dados Tabela Procurar --------------------- */

INSERT INTO procurar values (53, 'punhas');
INSERT INTO procurar values (54, 'IMORTALPOWA');
INSERT INTO procurar values (76, 'SilentRequiem');
INSERT INTO procurar values (55, 'OhStor');
INSERT INTO procurar values (75, 'GateKepre');
INSERT INTO procurar values (70, 'punhas');
INSERT INTO procurar values (53, 'Scam4Ever');
INSERT INTO procurar values (74, 'BillionareCheater');

/* --------------------- Dados Tabela Carregar --------------------- */

INSERT INTO carregar values (53, 'NonceGaio');
INSERT INTO carregar values (54, 'punhas');
INSERT INTO carregar values (55, 'JamesVEVO');
INSERT INTO carregar values (67, 'JamesVEVO');
INSERT INTO carregar values (69, 'SilentRequiem');
INSERT INTO carregar values (70, 'SilentRequiem');
INSERT INTO carregar values (74, 'OhStor');
INSERT INTO carregar values (75, 'GateKepre');
INSERT INTO carregar values (76, 'GateKepre');

/* --------------------- Dados Tabela Filmes --------------------- */

INSERT INTO filme values (53, 6938521, 'realizador', 2013);
INSERT INTO filme values (53, 5287416, 'realizador', 2013);
INSERT INTO filme values (53, 9426351, 'ator', 2013);
INSERT INTO filme values (53, 4569872, 'ator', 2013);
INSERT INTO filme values (77, 6938521, 'realizador', 2019);
INSERT INTO filme values (77, 4569872, 'ator', 2019);

/* --------------------- Dados Tabela Musicas --------------------- */

INSERT INTO musica values (55, 6523987, 'musico');
INSERT INTO musica values (55, 7854125, 'letrista');
INSERT INTO musica values (67, 7854125, 'musico');
INSERT INTO musica values (67, 6523987, 'musico');
INSERT INTO musica values (67, 7854125, 'letrista');
INSERT INTO musica values (80, 1597530, 'musico');
INSERT INTO musica values (80, 1597530, 'letrista');

/* --------------------- Dados Tabela Poemas --------------------- */

INSERT INTO poema values (54, 6938521, 'poeta');
INSERT INTO poema values (69, 1239875, 'poeta');
INSERT INTO poema values (70, 1239875, 'poeta');

/* --------------------- Dados Tabela Fotografias --------------------- */

INSERT INTO fotografia values (74, 8524569, 'fotografo');
INSERT INTO fotografia values (75, 8524569, 'fotografo');
INSERT INTO fotografia values (76, 8524569, 'fotografo');


-- SELECT * from pessoa;
-- SELECT * from utilizador;
-- SELECT * from administrador;
-- SELECT * from autor;
-- SELECT * from recurso;
-- SELECT * from comentario;
-- SELECT * from classificacao;
-- SELECT * from aceder;
-- SELECT * from procurar;
-- SELECT * from carregar;
-- SELECT * from filme;
-- SELECT * from musica;
-- SELECT * from poema;
-- SELECT * from fotografia;
-- SELECT associacao.NumeroRecursoA1, recurso.Tipo as Tipo1, recurso.Titulo as Titulo1 from associacao, recurso where associacao.NumeroRecursoA1 = recurso.NumeroRecurso;
-- SELECT associacao.NumeroRecursoA2, recurso.Tipo as Tipo2, recurso.Titulo as Titulo2 from associacao, recurso where associacao.NumeroRecursoA2 = recurso.NumeroRecurso;