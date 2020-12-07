import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

import ListDocuments from '@salesforce/apex/QuoteController.ListDocuments';
import sendQuote from '@salesforce/apex/QuoteSender.sendQuote';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
const FIELDS = [
    'Quote.Name',
    'Quote.AccountId',
    'Quote.QuoteNumber',
    'Quote.Email',
    'Quote.Contact.Name',
    'Quote.Contact.Email'
];
const COLUMNS = [
    { label: 'File Name', fieldName: 'Name' }
];

export default class SendQuote extends LightningElement {
    @api recordId;
    html;
    columns = COLUMNS;
    files = [];
    quote;
    preSelectedRows = [];
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    quoteWite({error, data}) {
        if(data) {
            this.quote = data;
            this.html = '<p><h3>Dear '+this.quote.fields.Contact.value.fields.Name.value+'</h3>Here are the quote you requested, attached are also a pdf version of the quote<br>Please login to our community to see, change or accept the quote!<br/><a href="https://isvsi-14ddd2ecd93-175f570bfe7.force.com/architect2020/s/">Open Community</a> or login directly with <a href="https://isvsi-14ddd2ecd93-175f570bfe7.force.com/architect2020/services/auth/sso/Our_Facebook_Provider">Facebook</a><br/>Best Regards</p>';
        }
    }
    @wire(ListDocuments, { quoteId: '$recordId' })
    document({ error, data }) {
        if (data) {
            console.log(JSON.stringify(data));
            this.files = data;
            this.preSelectedRows = data.map( (e) => {
                return e.ContentVersionDocumentId;
            })
        } else if (error) {
            this.files = undefined;
        }
    };

    get name() {
        return this.quote.fields.Name.value;
    }
    get email() {
        console.log(JSON.stringify(this.quote));
        return this.quote.fields.Contact.value.fields.Email.value;
    }
    get pagetitle() {
        return "Send " + this.quote.fields.Name.value;
    }
    htmlchange(event) {
        console.log(event.target.value);
        this.html = event.target.value;
    }
    send() {
        console.log("Send quote not implemented ;)");
        var selected = this.template.querySelector('lightning-datatable').getSelectedRows();
        console.log(JSON.stringify(selected));

        console.log(this.html);
        sendQuote({
            quoteId: this.recordId,
            documentIds: selected.map( (r) => {
                return r.ContentVersionDocumentId;
            }),
            body: this.html
        })
            .then(() => {
                const event = new ShowToastEvent({
                    title: 'Email sent',
                    message: 'Email has been sent',
                    variant: 'success'
                });
                this.dispatchEvent(event);
                this.dispatchEvent(new CustomEvent('close'));
            })
            .catch((error) => {

                let msg = 'Error received: code' + error.errorCode + ', ' +
                    'message ' + error.body.message;
                const event = new ShowToastEvent({
                    title: 'Email not sent',
                    message: msg,
                    variant: 'error'
                });
                this.dispatchEvent(event);
                
            });
    }
}