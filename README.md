# 🎉 Sistema de Gerenciamento de Eventos (SQLite)

Este projeto contém a estrutura e as consultas SQL para gerenciar um sistema de eventos. Ele inclui:

- Usuários e tipos de usuário (organizador e participante)
- Eventos e suas informações
- Inscrições em eventos
- Avaliações/feedbacks de eventos (vinculadas diretamente às inscrições)

---

## 🗂️ Estrutura do Banco de Dados

### Tabelas principais

| Tabela        | Descrição                                        |
| -------------- | ------------------------------------------------ |
| `tipos_usuario` | Tipos de usuário (organizador ou participante) |
| `usuarios`     | Usuários do sistema                              |
| `eventos`      | Eventos criados por organizadores                |
| `inscricoes`   | Inscrições dos participantes em eventos          |
| `avaliacoes`   | Avaliações de eventos (referenciando apenas as inscrições) |

---

## 📦 Scripts principais

- **Criação das tabelas**  
  Contém as definições de cada tabela e suas chaves estrangeiras.

- **Inserts iniciais**  
  Popula as tabelas com alguns dados de exemplo.

- **Consultas úteis**  
  Exemplos de consultas:
  - Listar eventos e organizadores
  - Contar participantes por evento
  - Calcular nota média dos eventos
  - Listar eventos mesmo sem inscrições

- **Modificações e manutenção**  
  Exemplos de `UPDATE`, `DELETE`, `DROP` e alteração de tabelas.

---

## ⚙️ Como rodar

1. Abra seu cliente SQLite (`sqlite3` ou qualquer gerenciador como DBeaver, DB Browser for SQLite, etc.).
2. Execute o script SQL completo para criar e popular o banco.
3. Utilize as consultas para explorar e manter o banco de dados.

---

## ✏️ Observações

- Este projeto foi feito apenas com SQL puro, sem frameworks adicionais.
- Ideal para uso em testes ou pequenos protótipos de sistemas de eventos.
- Caso queira integrar com uma aplicação (web, desktop, etc.), basta usar a mesma estrutura de tabelas e adaptá-la no seu backend.



