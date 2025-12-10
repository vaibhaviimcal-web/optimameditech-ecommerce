<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GitHub Pages Site</title>
</head>
<body>
// Firebase Configuration for Optima Meditech E-Commerce
// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getFirestore, collection, getDocs, addDoc, updateDoc, deleteDoc, doc, query, where, orderBy, limit } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyC194-sAmiGOJQmf834P2REN1d77HFhz8A",
  authDomain: "optimameditech-ecommerce.firebaseapp.com",
  projectId: "optimameditech-ecommerce",
  storageBucket: "optimameditech-ecommerce.firebasestorage.app",
  messagingSenderId: "301836474574",
  appId: "1:301836474574:web:bf1a4d3fa6be8ab775589f"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// Export for use in other files
export { db, collection, getDocs, addDoc, updateDoc, deleteDoc, doc, query, where, orderBy, limit };

console.log('✅ Firebase initialized successfully!');

</body>
</html>