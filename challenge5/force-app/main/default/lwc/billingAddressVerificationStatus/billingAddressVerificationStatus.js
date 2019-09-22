import { LightningElement, api, wire, track } from 'lwc';
import { subscribe, onError } from 'lightning/empApi';
import { refreshApex } from '@salesforce/apex';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import getAccount from '@salesforce/apex/AccountSelector.selectById';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import BILLING_ADDRESS_VERIFICATION_STATUS_FIELD from '@salesforce/schema/Account.BillingAddressVerificationStatus__c';

export default class BillingAddressVerificationStatus extends LightningElement {
    @api recordId;
    @track status;
    
    @wire(getObjectInfo, {
        objectApiName: ACCOUNT_OBJECT
    })
    objectInfo

    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: BILLING_ADDRESS_VERIFICATION_STATUS_FIELD
    })
    picklistValues;

    wiredAccountResult;

    @wire(getAccount, { accountId: '$recordId' })
    wiredAccount(result) {
        this.wiredAccountResult = result;
        if(result.data) {
            this.status = result.data.BillingAddressVerificationStatus__c;
        }
    }


    connectedCallback() {
        const messageCallback = (response) => {
            const receivedAccountId = response.data.payload.ChangeEventHeader.recordIds[0];
            if(this.recordId === receivedAccountId) {
                refreshApex(this.wiredAccountResult);
            }

        }

        subscribe('/data/AccountChangeEvent', -1, messageCallback).then(
            (response) => {
                console.log(
                    'Successfully subscribed to : ',
                    JSON.stringify(response.channel)
                );
            }
        );
    }

    registerErrorListener() {
        onError((error) => {
            console.log('Received error from server: ', JSON.stringify(error));
        });
    }

}