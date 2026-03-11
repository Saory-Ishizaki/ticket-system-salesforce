public with sharing class TicketIntegrationService {

    @AuraEnabled(cacheable=true)
    public static List<Object> listTickets() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:OrgA_Tickets_API/services/apexrest/tickets');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        HttpResponse res = sendRequest(req);

        if (res.getStatusCode() == 200) {
            return (List<Object>) JSON.deserializeUntyped(res.getBody());
        }

        throw buildException(res, 'Error retrieving tickets');
    }

    @AuraEnabled
    public static Object createTicket(Map<String, String> request) {
        validateCreateRequest(request);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:OrgA_Tickets_API/services/apexrest/tickets');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(request));

        HttpResponse res = sendRequest(req);

        if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
            return JSON.deserializeUntyped(res.getBody());
        }

        throw buildException(res, 'Error creating ticket');
    }

    @AuraEnabled
    public static Object updateTicketStatus(String id, String status) {
        validateId(id);
        validateStatus(status);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:OrgA_Tickets_API/services/apexrest/tickets/' +
            EncodingUtil.urlEncode(id, 'UTF-8'));
        req.setMethod('PUT');
        req.setHeader('Content-Type', 'application/json');

        Map<String, String> body = new Map<String, String>{
            'status' => status
        };

        req.setBody(JSON.serialize(body));

        HttpResponse res = sendRequest(req);

        if (res.getStatusCode() == 200) {
            return JSON.deserializeUntyped(res.getBody());
        }

        throw buildException(res, 'Error updating ticket status');
    }

    @AuraEnabled
    public static void deleteTicket(String id) {
        validateId(id);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:OrgA_Tickets_API/services/apexrest/tickets/' +
            EncodingUtil.urlEncode(id, 'UTF-8'));
        req.setMethod('DELETE');
        req.setHeader('Content-Type', 'application/json');

        HttpResponse res = sendRequest(req);

        if (res.getStatusCode() == 204 || res.getStatusCode() == 200) {
            return;
        }

        throw buildException(res, 'Error deleting ticket');
    }

    private static HttpResponse sendRequest(HttpRequest req) {
        try {
            Http http = new Http();
            return http.send(req);
        } catch (Exception e) {
            throw new AuraHandledException('Callout failed: ' + e.getMessage());
        }
    }

    private static void validateCreateRequest(Map<String, String> request) {
        if (request == null) {
            throw new AuraHandledException('Request body cannot be null');
        }

        if (String.isBlank(request.get('title'))) {
            throw new AuraHandledException('Title is required');
        }
    }

    private static void validateId(String id) {
        if (String.isBlank(id)) {
            throw new AuraHandledException('Ticket id is required');
        }
    }

    private static void validateStatus(String status) {
        Set<String> allowedStatus = new Set<String>{
            'OPEN',
            'IN_PROGRESS',
            'CLOSED'
        };

        if (String.isBlank(status) || !allowedStatus.contains(status)) {
            throw new AuraHandledException('Invalid ticket status');
        }
    }

    private static AuraHandledException buildException(HttpResponse res, String defaultMessage) {
        String message = defaultMessage;

        try {
            Object raw = JSON.deserializeUntyped(res.getBody());

            if (raw instanceof Map<String, Object>) {
                Map<String, Object> body = (Map<String, Object>) raw;

                if (body.containsKey('message') && body.get('message') != null) {
                    message = String.valueOf(body.get('message'));
                }
            }
        } catch (Exception e) {
            if (!String.isBlank(res.getBody())) {
                message = defaultMessage + ': ' + res.getBody();
            }
        }

        return new AuraHandledException(message);
    }
}