import { LightningElement, api, wire } from 'lwc';

import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import CONTACT_ID from "@salesforce/schema/User.ContactId";
import listQuotes from '@salesforce/apex/QuoteController.listQuotes';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
// this gets you the logged in user
import USER_ID from "@salesforce/user/Id";
const COLUMNS = [
    { label: 'Name', fieldName: 'url', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: { fieldName: 'url' } } },
    { label: 'Total Price', fieldName: 'TotalPrice' },
    { label: 'Created', fieldName: 'CreatedDate', type: 'date',
    typeAttributes:{
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit"
    } }
];

export default class QuoteLister extends LightningElement {
    @api recordId;
    quotes = undefined;
    user = undefined;
    contactId = undefined;
    columns = COLUMNS;
    @wire(getRecord, { recordId: USER_ID, fields: [CONTACT_ID] })
    userWire({ error, data }) {
        if (data) {
            console.log("got user data" + JSON.stringify(data));
            this.user = data;
            this.contactId = data.fields.ContactId.value;
            this.refreshList();
        }
        if (error) {
            console.log("Error" + JSON.stringify(error));
        }
    }

    refreshList() {
        listQuotes({ contactId: this.contactId })
            .then(result => {
                console.log("Got data" + JSON.stringify(result));
                this.quotes = result;
            })
            .catch(error => {
                console.log(JSON.stringify(error));
            });
    }
    

}