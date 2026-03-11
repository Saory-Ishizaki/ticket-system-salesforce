@IsTest
private class TicketServiceTest {

    @TestSetup
    static void setupData(){

        List<Ticket__c> tickets = new List<Ticket__c>{
            new Ticket__c(
                Name = 'Ticket 1',
                Description__c = 'Description 1',
                Status__c = 'OPEN'
            ),
            new Ticket__c(
                Name = 'Ticket 2',
                Description__c = 'Description 2',
                Status__c = 'IN_PROGRESS'
            )
        };

        insert tickets;
    }

    @IsTest
    static void testCreateTicket(){

        TicketRequestDTO request = new TicketRequestDTO();
        request.title = 'New Ticket';
        request.description = 'New Description';

        Test.startTest();

        TicketResponseDTO response = TicketService.create(request);

        Test.stopTest();

        System.assertNotEquals(null, response);
        System.assertNotEquals(null, response.id);
        System.assertEquals('New Ticket', response.title);
        System.assertEquals('New Description', response.description);
        System.assertEquals('OPEN', response.status);

        Ticket__c persisted = [
            SELECT Id, Name, Description__c, Status__c
            FROM Ticket__c
            WHERE Id = :response.id
        ];

        System.assertEquals('New Ticket', persisted.Name);
        System.assertEquals('OPEN', persisted.Status__c);
    }

    @IsTest
    static void testListTickets(){

        Test.startTest();

        List<TicketResponseDTO> tickets = TicketService.listTickets();

        Test.stopTest();

        System.assertNotEquals(null, tickets);
        System.assert(tickets.size() >= 2);

        for(TicketResponseDTO t : tickets){
            System.assertNotEquals(null, t.id);
            System.assertNotEquals(null, t.title);
            System.assertNotEquals(null, t.status);
        }
    }

    @IsTest
    static void testGetTicketById(){

        Ticket__c ticket = [
            SELECT Id
            FROM Ticket__c
            LIMIT 1
        ];

        Test.startTest();

        TicketResponseDTO response = TicketService.getById(ticket.Id);

        Test.stopTest();

        System.assertEquals(ticket.Id, response.id);
    }

    @IsTest
    static void testUpdateStatus(){

        Ticket__c ticket = new Ticket__c(
            Name = 'Update Status Ticket',
            Description__c = 'Testing update',
            Status__c = 'OPEN'
        );

        insert ticket;

        Test.startTest();

        TicketResponseDTO response =
            TicketService.updateStatus(ticket.Id, 'IN_PROGRESS');

        Test.stopTest();

        System.assertEquals('IN_PROGRESS', response.status);

        Ticket__c updated = [
            SELECT Status__c
            FROM Ticket__c
            WHERE Id = :ticket.Id
        ];

        System.assertEquals('IN_PROGRESS', updated.Status__c);
    }

    @IsTest
    static void testDeleteTicket(){

        Ticket__c ticket = new Ticket__c(
            Name = 'Delete Ticket',
            Description__c = 'Delete me',
            Status__c = 'OPEN'
        );

        insert ticket;

        Test.startTest();

        TicketService.deleteTicket(ticket.Id);

        Test.stopTest();

        List<Ticket__c> result = [
            SELECT Id
            FROM Ticket__c
            WHERE Id = :ticket.Id
        ];

        System.assertEquals(0, result.size());
    }

    @IsTest
    static void testTicketNotFound(){

        Id fakeId = Schema.SObjectType.Ticket__c.getKeyPrefix() + '000000000000AAA';

        Boolean exceptionThrown = false;

        try{

            Test.startTest();

            TicketService.getById(fakeId);

            Test.stopTest();

        } catch (Exception e){

            exceptionThrown = true;

        }

        System.assertEquals(true, exceptionThrown);
    }
}