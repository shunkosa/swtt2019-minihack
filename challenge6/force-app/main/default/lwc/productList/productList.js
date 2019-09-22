import { LightningElement, api, wire } from 'lwc';
import getProductsByFamily from '@salesforce/apex/ProductController.getProductsByFamily';

export default class ProductList extends LightningElement {
    @api recordId;

    @wire(getProductsByFamily, {
        familyId: '$recordId'
    })
    productList;
}