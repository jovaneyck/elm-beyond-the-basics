'use strict';
// Initialize Firebase
// var config = {
//   apiKey: "YOURAPIKEYHERE",
//   authDomain: "YOURAUTHDOMAINHERE",
//   databaseURL: "YOURURLHERE",
//   storageBucket: "",
// };
var config = {
    apiKey: "AIzaSyB0PfbK06KOxiaMz9HzkTEocRlLyUCXuDc",
    authDomain: "elm-beyond-basics-waitlist-app.firebaseapp.com",
    databaseURL: "https://elm-beyond-basics-waitlist-app.firebaseio.com",
    projectId: "elm-beyond-basics-waitlist-app",
    storageBucket: "",
    messagingSenderId: "521580828083"
  };

var app = firebase.initializeApp(config);
var database = app.database();
var CUSTOMERREFPATH = "customers"

function addCustomer(customer){
  var promise = database
    .ref(CUSTOMERREFPATH)
    .push(customer);
  return promise;
}

function updateCustomer(customer){
  var id = customer.id;
  var promise = database
    .ref(CUSTOMERREFPATH + "/" + id)
    .set(customer);
  return promise;
}

function deleteCustomer(customer){
  var id = customer.id;
  var promise = database
    .ref(CUSTOMERREFPATH + "/" + id)
    .remove();
  return promise;
}

function customerListener(){
  return database.ref(CUSTOMERREFPATH);
}
