public with sharing class TicketService {

    public static TicketResponseDTO create(TicketRequestDTO request){

        Ticket__c ticket = new Ticket__c(
            Name = request.title,
            Description__c = request.description,
            Status__c = 'OPEN'
        );

        TicketRepository.insertTicket(ticket);

        return mapToResponse(ticket);
    }

    public static List<TicketResponseDTO> listTickets(){

        List<Ticket__c> tickets = TicketRepository.findAll();
        List<TicketResponseDTO> response = new List<TicketResponseDTO>();

        for(Ticket__c t : tickets){
            response.add(mapToResponse(t));
        }

        return response;
    }

    public static TicketResponseDTO getById(Id id){

        Ticket__c ticket = TicketRepository.findById(id);

        if(ticket == null){
            throw new AuraHandledException('Ticket not found');
        }

        return mapToResponse(ticket);
    }

    public static TicketResponseDTO updateStatus(Id id, String status){

        Ticket__c ticket = TicketRepository.findById(id);

        if(ticket == null){
            throw new AuraHandledException('Ticket not found');
        }

        ticket.Status__c = status;

        TicketRepository.updateTicket(ticket);

        return mapToResponse(ticket);
    }

    public static void deleteTicket (Id id){

        Ticket__c ticket = TicketRepository.findById(id);

        if(ticket == null){
            throw new AuraHandledException('Ticket not found');
        }

        TicketRepository.deleteTicket(ticket);
    }

    private static TicketResponseDTO mapToResponse(Ticket__c ticket){

        TicketResponseDTO dto = new TicketResponseDTO();

        dto.id = ticket.Id;
        dto.title = ticket.Name;
        dto.description = ticket.Description__c;
        dto.status = ticket.Status__c;
        dto.createdAt = ticket.CreatedDate;

        return dto;
    }

}