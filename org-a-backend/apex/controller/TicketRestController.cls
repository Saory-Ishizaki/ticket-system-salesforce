@RestResource(urlMapping='/tickets/*')
global with sharing class TicketRestController {

    @HttpPost
    global static TicketResponseDTO createTicket(){

        RestRequest req = RestContext.request;

        TicketRequestDTO dto =
            (TicketRequestDTO) JSON.deserialize(
                req.requestBody.toString(),
                TicketRequestDTO.class
            );

        return TicketService.create(dto);
    }

    @HttpGet
    global static List<TicketResponseDTO> getTickets(){

        RestRequest req = RestContext.request;

        String id = req.requestURI.substringAfter('/tickets/');

        if(String.isBlank(id)){
            return TicketService.listTickets();
        }

        TicketResponseDTO ticket = TicketService.getById((Id) id);

        return new List<TicketResponseDTO>{ ticket };
    }

    @HttpPut
    global static TicketResponseDTO updateStatus(){

        RestRequest req = RestContext.request;

        String id = req.requestURI.substringAfter('/tickets/');

        TicketStatusUpdateDTO dto =
            (TicketStatusUpdateDTO) JSON.deserialize(
                req.requestBody.toString(),
                TicketStatusUpdateDTO.class
            );

        return TicketService.updateStatus((Id) id, dto.status);
    }

    @HttpDelete
    global static void deleteTicket(){

        RestRequest req = RestContext.request;

        String id = req.requestURI.substringAfter('/tickets/');

        TicketService.deleteTicket((Id) id);
    }
}