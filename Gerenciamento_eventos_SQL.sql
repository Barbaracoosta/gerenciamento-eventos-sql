CREATE TABLE tipos_usuario (
    id_tipos_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
    tipo VARCHAR(20) NOT NULL UNIQUE
);


CREATE TABLE usuarios (
    id_usuario INTEGER PRIMARY KEY AUTOINCREMENT, 
    nickname VARCHAR(50) NOT NULL UNIQUE, 
    senha VARCHAR(255) NOT NULL, 
    nome_completo VARCHAR(150) NOT NULL, 
    email VARCHAR(100) NOT NULL UNIQUE,
    id_tipos_usuario INTEGER NOT NULL, 
    FOREIGN KEY (id_tipos_usuario) REFERENCES tipos_usuario (id_tipos_usuario) 
);

CREATE TABLE eventos (
    id_eventos INTEGER PRIMARY KEY AUTOINCREMENT, 
    titulo VARCHAR(100) NOT NULL, 
    descricao TEXT, 
    data DATE NOT NULL, 
    hora TIME NOT NULL, 
    local VARCHAR(200) NOT NULL, 
    id_organizador INTEGER NOT NULL, 
    status VARCHAR(20) DEFAULT 'ativo', 
    FOREIGN KEY (id_organizador) REFERENCES usuarios (id_usuario) 
);


CREATE TABLE inscricoes (
    id_inscricoes INTEGER PRIMARY KEY AUTOINCREMENT, 
    id_participante INTEGER NOT NULL, 
    id_eventos INTEGER NOT NULL, 
    data_inscricao DATE NOT NULL, 
    UNIQUE (id_participante, id_eventos), 
    FOREIGN KEY (id_participante) REFERENCES usuarios (id_usuario), 
    FOREIGN KEY (id_eventos) REFERENCES eventos (id_eventos) 
);

CREATE TABLE avaliacoes (
    id_avaliacoes INTEGER PRIMARY KEY AUTOINCREMENT, 
    id_inscricao INTEGER NOT NULL, 
    nota INTEGER NOT NULL CHECK (nota BETWEEN 1 AND 5), 
    comentario TEXT, 
    UNIQUE (id_inscricao),
    FOREIGN KEY (id_inscricao) REFERENCES inscricoes (id_inscricoes)
);

INSERT INTO tipos_usuario (tipo) VALUES ('organizador'), ('participante');

INSERT INTO usuarios (nickname, senha, nome_completo, email, id_tipos_usuario) VALUES
('Barbarasilva', 'senha1', 'Barbara Silva', 'Barbara@eventgo.com', 1), 
('AdrieleA', 'senha2', 'Adriele Alves', 'Adriele@eventgo.com', 1), 
('MonicaV', 'senha3', 'Monica Vieira', 'Monica@eventgo.com', 2),
('PamelaB', 'senha4', 'Pamela Borba', 'Pamela@eventgo.com', 2),
('NylbertL', 'senha5', 'Nylbert Lima', 'Nylbert@eventgo.com', 2); 

INSERT INTO eventos (titulo, descricao, data, hora, local, id_organizador) VALUES
('Seminário de Inteligência Artificial', 'Discussão sobre avanços e aplicações de IA.', '2024-12-22', '09:00', 'Auditório A', 1),
('Curso de Fotografia', 'Aulas praticas de fotografia', '2024-12-15', '10:00', 'Sala 101', 1),
('Hackathon TechFest', 'Uma competição de 24h para criar soluções inovadoras.', '2025-01-20', '08:00', 'Laboratório 1', 2);


INSERT INTO inscricoes (id_participante, id_eventos, data_inscricao) VALUES
(3, 1, '2024-12-01'), 
(3, 2, '2024-12-02'), 
(4, 2, '2024-12-03'), 
(5, 3, '2024-12-04'); 

INSERT INTO avaliacoes (id_inscricao, nota, comentario) VALUES
(1, 5, 'Ótimo seminário, Amei!'),
(2, 4, 'Bom curso, mas poderia ser mais detalhado.'),
(3, 5, 'Excelente didática.'),
(4, 5, 'Adorei o Hackathon TechFest.');

--modificar o nome de uma tabela
ALTER TABLE avaliacoes RENAME TO feedback;

-- alterar titulo evento
UPDATE eventos
SET titulo = 'Workshop de IA'
WHERE id_eventos = 1;

-- alterar senha
UPDATE usuarios
SET nome_completo = 'Monica Viana', senha = 'nova_senha'
WHERE id_usuario = 3;

-- deletar inscrições
DELETE FROM inscricoes
WHERE id_inscricoes IN (1, 2, 3);

-- deletar tabela
DELETE FROM feedback
WHERE nota < 3;

DROP TABLE IF EXISTS feedback;

--Recuperar dados de usuários e seus eventos.

-- Eventos organizados
SELECT 
    u.nome_completo AS usuario,
    'Organizador' AS papel,
    e.titulo AS evento,
    e.data AS data_evento,
    e.local AS local_evento
FROM 
    usuarios u
JOIN 
    eventos e 
ON 
    u.id_usuario = e.id_organizador

UNION

-- Eventos participados
SELECT 
    u.nome_completo AS usuario,
    'Participante' AS papel,
    e.titulo AS evento,
    e.data AS data_evento,
    e.local AS local_evento
FROM 
    usuarios u
JOIN 
    inscricoes i 
ON 
    u.id_usuario = i.id_participante
JOIN 
    eventos e 
ON 
    i.id_eventos = e.id_eventos;

--•	Listar todos os eventos e seus organizadores.
SELECT 
    e.titulo AS evento,
    e.data AS data_evento,
    e.hora AS hora_evento,
    e.local AS local_evento,
    e.status AS status_evento,
    u.nome_completo AS organizador,
    u.email AS email_organizador
FROM 
    eventos e
JOIN 
    usuarios u 
ON 
    e.id_organizador = u.id_usuario;

-- Mostrar todos os eventos, mesmo aqueles sem inscrições

SELECT 
    e.id_eventos,
    e.titulo AS evento,
    e.data AS data_evento,
    e.hora AS hora_evento,
    e.local AS local_evento,
    e.status AS status_evento,
    i.id_inscricoes AS inscricao_id
FROM 
    eventos e
LEFT JOIN 
    inscricoes i 
ON 
    e.id_eventos = i.id_eventos
ORDER BY 
    e.data, e.hora;

--Usar COUNT para contar o número de participantes em cada evento.

SELECT 
    e.id_eventos,
    e.titulo AS evento,
    COUNT(i.id_participante) AS numero_participantes
FROM 
    eventos e
LEFT JOIN 
    inscricoes i 
ON 
    e.id_eventos = i.id_eventos
GROUP BY 
    e.id_eventos, e.titulo
ORDER BY 
    numero_participantes DESC;

-- Calcular a nota média de feedbacks de um evento.

SELECT 
    e.id_eventos,
    e.titulo AS evento,
    AVG(a.nota) AS nota_media
FROM 
    eventos e
LEFT JOIN 
    feedback a 
ON 
    e.id_eventos = a.id_evento
GROUP BY 
    e.id_eventos, e.titulo
ORDER BY 
    nota_media DESC;

-- Agrupar resultados por evento ou organizador
SELECT 
    e.id_eventos,
    e.titulo AS evento,
    COUNT(i.id_participante) AS numero_participantes,
    AVG(a.nota) AS nota_media
FROM 
    eventos e
LEFT JOIN 
    inscricoes i 
ON 
    e.id_eventos = i.id_eventos
LEFT JOIN 
    avaliacoes a 
ON 
    e.id_eventos = a.id_evento
GROUP BY 
    e.id_eventos, e.titulo
ORDER BY 
    e.titulo;
