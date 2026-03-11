public with sharing class TicketRepository {

    public static List<Ticket__c> findAll(){

        return [
            SELECT Id, Name, Description__c, Status__c, CreatedDate
            FROM Ticket__c
        ];

    }

    public static Ticket__c findById(Id ticketId){

        List<Ticket__c> tickets = [
            SELECT Id, Name, Description__c, Status__c, CreatedDate
            FROM Ticket__c
            WHERE Id = :ticketId
            LIMIT 1
        ];

        return tickets.isEmpty() ? null : tickets[0];
    }

    public static void insertTicket(Ticket__c ticket){

        insert ticket;

    }

    public static void updateTicket(Ticket__c ticket){

        update ticket;

    }

    public static void deleteTicket(Ticket__c ticket){

        delete ticket;

    }

}