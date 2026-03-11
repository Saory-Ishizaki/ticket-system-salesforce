# Ticket System – Desafio Full Stack Salesforce

Este projeto implementa um sistema simples de gerenciamento de chamados técnicos utilizando Salesforce.

Embora o desafio original sugerisse a implementação em **Java (Spring Boot)**, foi permitido utilizar **Salesforce como alternativa**. Dessa forma, a solução foi implementada utilizando **Apex REST API no backend** e **Lightning Web Components (LWC) no frontend**, mantendo conceitos arquiteturais esperados em uma aplicação full stack.

A solução está dividida em duas orgs Salesforce:

- **Org A (Backend)** – Contém o modelo de dados e a API REST.
- **Org B (Frontend)** – Contém a interface em Lightning Web Components e a camada de integração que consome a API.

---

# Arquitetura

Org B (Frontend)

LWC Component (ticketApp)
↓
TicketIntegrationService (Apex)
↓
Named Credential + OAuth 2.0
↓
Org A REST API

Org A (Backend)

TicketRestController
↓
TicketService
↓
TicketRepository
↓
Objeto Ticket__c


---

# Modelo de Dados

O backend utiliza um objeto customizado:

**Ticket__c**

Mapeamento de campos:

| Campo | Descrição |
|------|-------------|
| Id | Identificador do ticket |
| Name | Título do ticket |
| Description__c | Descrição do ticket |
| Status__c | Status do ticket |
| CreatedDate | Data de criação |

Valores possíveis para o status:

- OPEN
- IN_PROGRESS
- CLOSED

---

# Endpoints da API

Caminho base:

/services/apexrest/tickets

Endpoints disponíveis:

| Método | Endpoint | Descrição |
|------|------|------|
POST | /tickets | Criar um novo ticket |
GET | /tickets | Listar todos os tickets |
GET | /tickets/{id} | Buscar um ticket específico |
PUT | /tickets/{id} | Atualizar o status do ticket |
DELETE | /tickets/{id} | Excluir um ticket |

---

# Instruções para Executar o Projeto

## Backend (Org A)

1. Criar o objeto customizado **Ticket__c**
2. Criar os seguintes campos:

- `Description__c`
- `Status__c` (Picklist com valores: OPEN, IN_PROGRESS, CLOSED)

3. Fazer deploy das classes Apex localizadas em:

org-a-backend/apex


4. Atribuir o Permission Set:

Ticket_Access


5. Configurar integração OAuth:

- Criar um **External Client App**
- Habilitar **Client Credentials Flow**
- Configurar o **Run As User**

---

## Frontend (Org B)

1. Fazer deploy do serviço de integração Apex localizado em:

org-b-frontend/apex


2. Fazer deploy do componente LWC:

org-b-frontend/lwc/ticketApp


3. Configurar integração com a Org A:

- Criar **External Credential**
- Criar **Named Credential**
- Configurar OAuth 2.0 usando **Client Credentials Flow**

4. Atribuir o Permission Set que concede acesso ao External Credential.

5. Adicionar o componente **ticketApp** em uma Lightning App Page.

---

# Teste da API (cURL)

## 1. Obter Token OAuth

curl -X POST "https://orgfarm-1331c83b3c-dev-ed.develop.my.salesforce.com/services/oauth2/token
"
-H "Content-Type: application/x-www-form-urlencoded"
-d "grant_type=client_credentials"
-d "client_id=CLIENT_ID"
-d "client_secret=CLIENT_SECRET"


Guarde o **access_token** retornado para utilizar nas próximas requisições.

---

## 2. Listar todos os Tickets

curl -X GET "https://orgfarm-1331c83b3c-dev-ed.develop.my.salesforce.com/services/apexrest/tickets
"
-H "Authorization: Bearer TOKEN"
-H "Content-Type: application/json"


---

## 3. Buscar Ticket por ID

curl -X GET "https://orgfarm-1331c83b3c-dev-ed.develop.my.salesforce.com/services/apexrest/tickets/TICKET_ID
"
-H "Authorization: Bearer TOKEN"
-H "Content-Type: application/json"


---

## 4. Criar Ticket

curl -X POST "https://orgfarm-1331c83b3c-dev-ed.develop.my.salesforce.com/services/apexrest/tickets
"
-H "Authorization: Bearer TOKEN"
-H "Content-Type: application/json"
-d '{
"title": "Novo Ticket",
"description": "Descrição do ticket"
}'


---

## 5. Atualizar Status do Ticket

Valores válidos para `status`:

- OPEN
- IN_PROGRESS
- CLOSED


curl -X PUT "https://orgfarm-1331c83b3c-dev-ed.develop.my.salesforce.com/services/apexrest/tickets/TICKET_ID
"
-H "Authorization: Bearer TOKEN"
-H "Content-Type: application/json"
-d '{
"status": "IN_PROGRESS"
}'


---

## 6. Deletar Ticket

curl -X DELETE "https://orgfarm-1331c83b3c-dev-ed.develop.my.salesforce.com/services/apexrest/tickets/TICKET_ID
"
-H "Authorization: Bearer TOKEN"
-H "Content-Type: application/json"


---

# Estrutura do Projeto

As pastas foram organizadas separando **backend e frontend** para facilitar a navegação e a identificação das partes da aplicação por quem estiver avaliando o desafio.

org-a-backend/
apex/
controller/
domain/
dto/
repository/
service/
tests/
objects/
permissionsets/

org-b-frontend/
apex/
lwc/
permissionsets/


---

# Observações

- O backend segue uma arquitetura em camadas semelhante a aplicações Java:
  - Controller
  - Service
  - Repository
  - DTO

- O frontend foi implementado com **Lightning Web Components**, atendendo ao requisito de uso de JavaScript no desafio.

- A integração entre as orgs foi realizada utilizando **OAuth 2.0 e Named Credentials**, seguindo boas práticas de segurança do Salesforce.

⚠️ **Observação de Segurança**

Para fins de demonstração neste desafio técnico, os valores de `client_id` e `client_secret` aparecem nos exemplos de teste da API.

Isso ocorre porque o projeto utiliza uma **org Developer Edition para estudo**.

Em um **ambiente empresarial real**, essas credenciais **não devem ser expostas em código ou repositórios públicos**, devendo ser armazenadas com segurança em gerenciadores de segredos ou variáveis de ambiente.

---

# Author
Saory Massakydo Ishizaki de Sousa
*   GitHub: [://github.com/Saory-Ishizaki](https://github.com/Saory-Ishizaki)
*   LinkedIn: [://[linkedin.com](https://www.linkedin.com/in/saory-massakydo-ishizaki-323952247/)]
*   E-mail: saory.massakydo@gmail.com