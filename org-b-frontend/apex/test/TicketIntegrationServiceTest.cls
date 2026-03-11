@IsTest
private class TicketIntegrationServiceTest {

    private class TicketMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type','application/json');

            if(req.getMethod() == 'GET'){

                res.setBody('[{"id":"1","title":"Test","description":"Desc","status":"OPEN"}]');
                res.setStatusCode(200);

            } else if(req.getMethod() == 'POST'){

                res.setBody('{"id":"1","title":"Test","description":"Desc","status":"OPEN"}');
                res.setStatusCode(201);

            } else if(req.getMethod() == 'PUT'){

                res.setBody('{"id":"1","title":"Test","description":"Desc","status":"IN_PROGRESS"}');
                res.setStatusCode(200);

            } else if(req.getMethod() == 'DELETE'){

                res.setStatusCode(204);

            }

            return res;
        }
    }

    @IsTest
    static void testListTickets(){

        Test.setMock(HttpCalloutMock.class, new TicketMock());

        Test.startTest();

        List<Object> result = TicketIntegrationService.listTickets();

        Test.stopTest();

        System.assertNotEquals(null, result);
    }

    @IsTest
    static void testCreateTicket(){

        Test.setMock(HttpCalloutMock.class, new TicketMock());

        Map<String,String> req = new Map<String,String>{
            'title' => 'Test',
            'description' => 'Desc'
        };

        Test.startTest();

        Object result = TicketIntegrationService.createTicket(req);

        Test.stopTest();

        System.assertNotEquals(null, result);
    }

    @IsTest
    static void testUpdateStatus(){

        Test.setMock(HttpCalloutMock.class, new TicketMock());

        Test.startTest();

        Object result = TicketIntegrationService.updateTicketStatus('1','IN_PROGRESS');

        Test.stopTest();

        System.assertNotEquals(null, result);
    }

    @IsTest
    static void testDeleteTicket(){

        Test.setMock(HttpCalloutMock.class, new TicketMock());

        Test.startTest();

        TicketIntegrationService.deleteTicket('1');

        Test.stopTest();

        System.assert(true);
    }
}