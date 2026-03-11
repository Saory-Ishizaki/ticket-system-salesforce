import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import listTickets from '@salesforce/apex/TicketIntegrationService.listTickets';
import createTicket from '@salesforce/apex/TicketIntegrationService.createTicket';
import updateTicketStatus from '@salesforce/apex/TicketIntegrationService.updateTicketStatus';

export default class TicketApp extends LightningElement {
    @track tickets = [];
    @track title = '';
    @track description = '';
    @track loading = false;
    @track errorMessage = '';

    connectedCallback() {
        this.loadTickets();
    }

    get statusOptions() {
        return [
            { label: 'OPEN', value: 'OPEN' },
            { label: 'IN_PROGRESS', value: 'IN_PROGRESS' },
            { label: 'CLOSED', value: 'CLOSED' }
        ];
    }

    get hasTickets() {
        return this.tickets && this.tickets.length > 0;
    }

    handleTitleChange(event) {
        this.title = event.target.value;
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    async loadTickets() {
        this.loading = true;
        this.errorMessage = '';

        try {
            const result = await listTickets();
            this.tickets = Array.isArray(result) ? result : [];
        } catch (error) {
            this.tickets = [];
            this.errorMessage = this.normalizeError(error);
            this.showToast('Error', this.errorMessage, 'error');
        } finally {
            this.loading = false;
        }
    }

    async handleCreate() {
        this.errorMessage = '';

        if (!this.title || !this.title.trim()) {
            this.showToast('Validation Error', 'Title is required.', 'error');
            return;
        }

        this.loading = true;

        try {
            await createTicket({
                request: {
                    title: this.title,
                    description: this.description
                }
            });

            this.title = '';
            this.description = '';

            this.showToast('Success', 'Ticket created successfully.', 'success');
            await this.loadTickets();
        } catch (error) {
            this.errorMessage = this.normalizeError(error);
            this.showToast('Error', this.errorMessage, 'error');
        } finally {
            this.loading = false;
        }
    }

    async handleStatusChange(event) {
        const ticketId = event.target.dataset.id;
        const status = event.detail.value;

        this.loading = true;
        this.errorMessage = '';

        try {
            await updateTicketStatus({
                id: ticketId,
                status: status
            });

            this.showToast('Success', 'Ticket status updated successfully.', 'success');
            await this.loadTickets();
        } catch (error) {
            this.errorMessage = this.normalizeError(error);
            this.showToast('Error', this.errorMessage, 'error');
        } finally {
            this.loading = false;
        }
    }

    normalizeError(error) {
        if (error && error.body) {
            if (typeof error.body.message === 'string') {
                return error.body.message;
            }

            if (typeof error.body === 'string') {
                return error.body;
            }
        }

        if (error && error.message) {
            return error.message;
        }

        return 'Unexpected error.';
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}