create database SBD_TP1;
use SBD_TP1;



create TABLE pessoa(
	Nacionalidade varchar(50) not null,
    ccPessoa decimal(7) not null,
	dataNasc DATE not null,
    nome varchar(50) not null,
    
    constraint pk_pessoa primary key (ccPessoa)
);

create TABLE utilizador(
	NomeUtilizador varchar(20) not null,
	ccPessoa decimal(7) not null,
    Bloquear BIT,

	constraint pk_utilizador primary key (NomeUtilizador)

);

create TABLE administrador(
	idAdmin INT not null,
    ccPessoa decimal(7) not null, 
    
	constraint pk_administrador primary key (idAdmin)
);

create TABLE autor(
	ccPessoa decimal(7) not null, 
	tipoAut varchar(20) not null,
    KEY tipoAut_index (tipoAut), 
    
	constraint pk_autor primary key (ccPessoa,tipoAut)

);

create TABLE aceder(
	NumeroRecurso INT not null, 
	NomeUtilizador varchar(20) not null,
    
	constraint pk_aceder primary key (NumeroRecurso,NomeUtilizador)

);

create TABLE carregar(
	NumeroRecurso INT not null, 
	NomeUtilizador varchar(20) not null,
    
	constraint pk_carregar primary key (NumeroRecurso,NomeUtilizador)

);


create TABLE procurar(
	NumeroRecurso INT not null, 
	NomeUtilizador varchar(20) not null,
    
	constraint pk_procurar primary key (NumeroRecurso,NomeUtilizador)

);

create TABLE comentario(
	NumeroRecurso INT not null, 
	NomeUtilizador varchar(20) not null,
    ConteudoCom varchar(200) not null,
    
	constraint pk_comentario primary key (NumeroRecurso,NomeUtilizador)

);

create TABLE classificacao(
	NumeroRecurso INT not null, 
	NomeUtilizador varchar(20) not null,
    NotaClass INT not null,
    
	constraint pk_classificacao primary key (NumeroRecurso,NomeUtilizador)

);

create TABLE recurso(
	NumeroRecurso INT not null, 
	NomeUtilizador varchar(20) not null,
    idAdmin INT not null,
	Ilustracao MEDIUMBLOB not null,
    Tipo varchar(20) not null,
    Titulo varchar(100) not null,
    Resumo varchar(500) not null,
    DataHoraCarr DATETIME not null,
    Pontos INT not null,
    Bloquear BIT, 
    FaixaEtar INT not null,
    
	constraint pk_recurso primary key (NumeroRecurso)

);

create TABLE filme(
	NumeroRecurso INT not null, 
	ccPessoa decimal(7) not null, 
	tipoAut varchar(20) not null,
	AnoLanc INT not null,
    
	constraint pk_filme primary key (NumeroRecurso,ccPessoa,tipoAut)

);

create TABLE musica(
	NumeroRecurso INT not null, 
	ccPessoa decimal(7) not null, 
	tipoAut varchar(20) not null,
    
	constraint pk_musica primary key (NumeroRecurso,ccPessoa,tipoAut)

);

create TABLE poema(
	NumeroRecurso INT not null, 
	ccPessoa decimal(7) not null, 
	tipoAut varchar(20) not null,
    
	constraint pk_poema primary key (NumeroRecurso)

);

create TABLE fotografia(
	NumeroRecurso INT not null, 
	ccPessoa decimal(7) not null, 
	tipoAut varchar(20) not null,
    
	constraint pk_fotografia primary key (NumeroRecurso)

);


alter table utilizador add constraint fk_ccPessoa foreign key (ccPessoa) references pessoa (ccPessoa);
alter table administrador add constraint fk_adccPessoa foreign key (ccPessoa) references pessoa (ccPessoa);
alter table autor add constraint fk_auccPessoa foreign key (ccPessoa) references pessoa (ccPessoa);

alter table aceder add constraint fk_numeroRecurso foreign key (NumeroRecurso) references recurso (NumeroRecurso);
alter table aceder add constraint fk_nomeUtilizador foreign key (NomeUtilizador) references utilizador (NomeUtilizador);

alter table carregar add constraint fk_carnumeroRecurso foreign key (NumeroRecurso) references recurso (NumeroRecurso);
alter table carregar add constraint fk_carnomeUtilizador foreign key (NomeUtilizador) references utilizador (NomeUtilizador);

alter table procurar add constraint fk_pronumeroRecurso foreign key (NumeroRecurso) references recurso (NumeroRecurso);
alter table procurar add constraint fk_pronomeUtilizador foreign key (NomeUtilizador) references utilizador (NomeUtilizador);

alter table comentario add constraint fk_comnumeroRecurso foreign key (NumeroRecurso) references recurso (NumeroRecurso);
alter table comentario add constraint fk_comnomeUtilizador foreign key (NomeUtilizador) references utilizador (NomeUtilizador);

alter table classificacao add constraint fk_clanumeroRecurso foreign key (NumeroRecurso) references recurso (NumeroRecurso);
alter table classificacao add constraint fk_clanomeUtilizador foreign key (NomeUtilizador) references utilizador (NomeUtilizador);

alter table recurso add constraint fk_renomeUtilizador foreign key (NomeUtilizador) references utilizador (NomeUtilizador);
alter table recurso add constraint fk_reidAdmin foreign key (idAdmin) references administrador (idAdmin);

alter table filme add constraint fk_filnumeroRecurso foreign key (NumeroRecurso) references recurso (NumeroRecurso);
alter table filme add constraint fk_filccPessoa foreign key (ccPessoa) references autor (ccPessoa);
alter table filme add constraint fk_filtipoAut foreign key (tipoAut) references autor (tipoAut);

alter table musica add constraint fk_munumeroRecurso foreign key (NumeroRecurso) references recurso (NumeroRecurso);
alter table musica add constraint fk_muccPessoa foreign key (ccPessoa) references autor (ccPessoa);
alter table musica add constraint fk_mutipoAut foreign key (tipoAut) references autor (tipoAut);

alter table poema add constraint fk_poenumeroRecurso foreign key (NumeroRecurso) references recurso (NumeroRecurso);
alter table poema add constraint fk_poeccPessoa foreign key (ccPessoa) references autor (ccPessoa);
alter table poema add constraint fk_poetipoAut foreign key (tipoAut) references autor (tipoAut);

alter table fotografia add constraint fk_fotnumeroRecurso foreign key (NumeroRecurso) references recurso (NumeroRecurso);
alter table fotografia add constraint fk_fotccPessoa foreign key (ccPessoa) references autor (ccPessoa);
alter table fotografia add constraint fk_fottipoAut foreign key (tipoAut) references autor (tipoAut);


-- alter table utilizador drop foreign key fk_ccPessoa;
-- alter table administrador drop foreign key fk_adccPessoa;
-- alter table autor drop foreign key fk_auccPessoa;

-- alter table aceder drop foreign key fk_numeroRecurso;
-- alter table aceder drop foreign key fk_nomeUtilizador;

-- alter table carregar drop foreign key fk_carnumeroRecurso;
-- alter table carregar drop foreign key fk_carnomeUtilizador;

-- alter table procurar drop foreign key fk_pronumeroRecurso;
-- alter table procurar drop foreign key fk_pronomeUtilizador;

-- alter table comentario drop foreign key fk_comnumeroRecurso;
-- alter table comentario drop foreign key fk_comnomeUtilizador;

-- alter table classificacao drop foreign key fk_clanumeroRecurso;
-- alter table classificacao drop foreign key fk_clanomeUtilizador;

-- alter table recurso drop foreign key fk_renomeUtilizador;
-- alter table recurso drop foreign key fk_reidAdmin;

-- alter table filme drop foreign key fk_filnumeroRecurso;
-- alter table filme drop foreign key fk_filccPessoa;
-- alter table filme drop foreign key fk_filtipoAut;

-- alter table musica drop foreign key fk_munumeroRecurso;
-- alter table musica drop foreign key fk_muccPessoa;
-- alter table musica drop foreign key fk_mutipoAut;

-- alter table poema drop foreign key fk_poenumeroRecurso;
-- alter table poema drop foreign key fk_poeccPessoa;
-- alter table poema drop foreign key fk_poetipoAut;

-- alter table fotografia drop foreign key fk_fotnumeroRecurso;
-- alter table fotografia drop foreign key fk_fotccPessoa;
-- alter table fotografia drop foreign key fk_fottipoAut;

-- drop TABLE pessoa;
-- drop TABLE utilizador;
-- drop TABLE administrador;
-- drop TABLE autor;
-- drop TABLE aceder;
-- drop TABLE procurar;
-- drop TABLE comentario;
-- drop TABLE classificacao;
-- drop TABLE carregar;
-- drop TABLE recurso;
-- drop TABLE filme;
-- drop TABLE musica;
-- drop TABLE poema;
-- drop TABLE fotografia;

create TABLE associacao(
	NumeroRecursoA1 INT not null, 
	NumeroRecursoA2 INT not null,
    
	constraint pk_associacao primary key (NumeroRecursoA1)

);

alter table associacao add constraint fk_associacaoNRA1 foreign key (NumeroRecursoA1) references recurso (NumeroRecurso);
alter table associacao add constraint fk_associacaoNRA2 foreign key (NumeroRecursoA2) references recurso (NumeroRecurso);

-- alter table associacao drop foreign key fk_associacaoNRA1;
-- alter table associacao drop foreign key fk_associacaoNRA2;


