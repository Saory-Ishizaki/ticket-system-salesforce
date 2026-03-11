@IsTest
private class TicketRestControllerTest {

    @TestSetup
    static void setupData(){

        insert new Ticket__c(
            Name = 'Controller Ticket',
            Description__c = 'Test',
            Status__c = 'OPEN'
        );
    }

    @IsTest
    static void testCreateTicket(){

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestUri = '/services/apexrest/tickets';
        req.httpMethod = 'POST';

        TicketRequestDTO dto = new TicketRequestDTO();
        dto.title = 'API Ticket';
        dto.description = 'Created via API';

        req.requestBody = Blob.valueOf(JSON.serialize(dto));

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

        TicketResponseDTO response = TicketRestController.createTicket();

        Test.stopTest();

        System.assertEquals('API Ticket', response.title);
    }

    @IsTest
    static void testGetTickets(){

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestUri = '/services/apexrest/tickets';
        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

        List<TicketResponseDTO> tickets = TicketRestController.getTickets();

        Test.stopTest();

        System.assert(tickets.size() > 0);
    }

    @IsTest
    static void testUpdateStatus(){

        Ticket__c ticket = [SELECT Id FROM Ticket__c LIMIT 1];

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestUri = '/services/apexrest/tickets/' + ticket.Id;
        req.httpMethod = 'PUT';

        TicketStatusUpdateDTO dto = new TicketStatusUpdateDTO();
        dto.status = 'IN_PROGRESS';

        req.requestBody = Blob.valueOf(JSON.serialize(dto));

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

        TicketResponseDTO response = TicketRestController.updateStatus();

        Test.stopTest();

        System.assertEquals('IN_PROGRESS', response.status);
    }

    @IsTest
    static void testDeleteTicket(){

        Ticket__c ticket = [SELECT Id FROM Ticket__c LIMIT 1];

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestUri = '/services/apexrest/tickets/' + ticket.Id;
        req.httpMethod = 'DELETE';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();

        TicketRestController.deleteTicket();

        Test.stopTest();

        List<Ticket__c> result = [
            SELECT Id
            FROM Ticket__c
            WHERE Id = :ticket.Id
        ];

        System.assertEquals(0, result.size());
    }
}