<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GitHub Pages Site</title>
</head>
<body>
// AI Chatbot for Optima Meditech E-Commerce
// This chatbot helps customers with product inquiries and support

class OptimaMediChatbot {
    constructor() {
        this.isOpen = false;
        this.messages = [];
        this.init();
    }

    init() {
        this.createChatWidget();
        this.addEventListeners();
        this.addWelcomeMessage();
    }

    createChatWidget() {
        const chatHTML = `
            <div id="chatbot-container" class="chatbot-container">
                <!-- Chat Button -->
                <button id="chat-button" class="chat-button">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                    </svg>
                    <span class="chat-badge">1</span>
                </button>

                <!-- Chat Window -->
                <div id="chat-window" class="chat-window">
                    <div class="chat-header">
                        <div class="chat-header-info">
                            <div class="chat-avatar">🏥</div>
                            <div>
                                <div class="chat-title">Optima MediBot</div>
                                <div class="chat-status">Online • Ready to help</div>
                            </div>
                        </div>
                        <button id="close-chat" class="close-chat">×</button>
                    </div>

                    <div id="chat-messages" class="chat-messages">
                        <!-- Messages will be added here -->
                    </div>

                    <div class="chat-quick-replies" id="quick-replies">
                        <button class="quick-reply" data-message="Show me your products">🛍️ Products</button>
                        <button class="quick-reply" data-message="What are your prices?">💰 Pricing</button>
                        <button class="quick-reply" data-message="Do you offer warranties?">🛡️ Warranty</button>
                        <button class="quick-reply" data-message="How can I contact support?">📞 Support</button>
                    </div>

                    <div class="chat-input-container">
                        <input type="text" id="chat-input" class="chat-input" placeholder="Type your message...">
                        <button id="send-button" class="send-button">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="22" y1="2" x2="11" y2="13"></line>
                                <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', chatHTML);
    }

    addEventListeners() {
        const chatButton = document.getElementById('chat-button');
        const closeChat = document.getElementById('close-chat');
        const sendButton = document.getElementById('send-button');
        const chatInput = document.getElementById('chat-input');

        chatButton.addEventListener('click', () => this.toggleChat());
        closeChat.addEventListener('click', () => this.toggleChat());
        sendButton.addEventListener('click', () => this.sendMessage());
        chatInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') this.sendMessage();
        });

        // Quick replies
        document.querySelectorAll('.quick-reply').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const message = e.target.dataset.message;
                this.sendMessage(message);
            });
        });
    }

    toggleChat() {
        this.isOpen = !this.isOpen;
        const chatWindow = document.getElementById('chat-window');
        const chatButton = document.getElementById('chat-button');
        const badge = document.querySelector('.chat-badge');

        if (this.isOpen) {
            chatWindow.classList.add('open');
            chatButton.classList.add('hidden');
            if (badge) badge.style.display = 'none';
        } else {
            chatWindow.classList.remove('open');
            chatButton.classList.remove('hidden');
        }
    }

    addWelcomeMessage() {
        setTimeout(() => {
            this.addMessage('bot', 'Hello! 👋 Welcome to Optima Meditech. I\'m your AI assistant. How can I help you today?');
        }, 1000);
    }

    sendMessage(text = null) {
        const input = document.getElementById('chat-input');
        const message = text || input.value.trim();

        if (!message) return;

        this.addMessage('user', message);
        input.value = '';

        // Simulate typing
        setTimeout(() => {
            this.addTypingIndicator();
            setTimeout(() => {
                this.removeTypingIndicator();
                const response = this.generateResponse(message);
                this.addMessage('bot', response);
            }, 1500);
        }, 500);
    }

    addMessage(sender, text) {
        const messagesContainer = document.getElementById('chat-messages');
        const messageDiv = document.createElement('div');
        messageDiv.className = `chat-message ${sender}-message`;

        if (sender === 'bot') {
            messageDiv.innerHTML = `
                <div class="message-avatar">🏥</div>
                <div class="message-content">${text}</div>
            `;
        } else {
            messageDiv.innerHTML = `
                <div class="message-content">${text}</div>
            `;
        }

        messagesContainer.appendChild(messageDiv);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }

    addTypingIndicator() {
        const messagesContainer = document.getElementById('chat-messages');
        const typingDiv = document.createElement('div');
        typingDiv.className = 'chat-message bot-message typing-indicator';
        typingDiv.id = 'typing-indicator';
        typingDiv.innerHTML = `
            <div class="message-avatar">🏥</div>
            <div class="message-content">
                <div class="typing-dots">
                    <span></span><span></span><span></span>
                </div>
            </div>
        `;
        messagesContainer.appendChild(typingDiv);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }

    removeTypingIndicator() {
        const indicator = document.getElementById('typing-indicator');
        if (indicator) indicator.remove();
    }

    generateResponse(message) {
        const lowerMessage = message.toLowerCase();

        // Product inquiries
        if (lowerMessage.includes('product') || lowerMessage.includes('equipment') || lowerMessage.includes('device')) {
            return 'We offer a wide range of medical equipment including:\n\n🏥 Patient Monitors\n🔬 Diagnostic Imaging (X-Ray, Ultrasound)\n🚑 Emergency Care Equipment (Ventilators, Defibrillators)\n⚕️ OT Equipment\n❤️ Cardiology Devices\n\nWould you like to see our full catalog? <a href="products-firebase.html" style="color: #4A9FD8; font-weight: 600;">View Products →</a>';
        }

        // Pricing
        if (lowerMessage.includes('price') || lowerMessage.includes('cost') || lowerMessage.includes('expensive')) {
            return 'Our products range from ₹45,000 to ₹15,75,000 depending on the equipment. We offer:\n\n💰 Competitive pricing\n🎁 Bulk discounts (up to 20% off)\n💳 Flexible payment terms\n📦 Free installation\n\nWould you like a detailed quote for specific equipment?';
        }

        // Warranty
        if (lowerMessage.includes('warrant') || lowerMessage.includes('guarantee')) {
            return 'All our medical equipment comes with:\n\n✅ 1-2 year manufacturer warranty\n🔧 Free maintenance for first year\n📞 24/7 technical support\n🚚 On-site service available\n\nExtended warranty plans are also available!';
        }

        // Contact/Support
        if (lowerMessage.includes('contact') || lowerMessage.includes('support') || lowerMessage.includes('help')) {
            return 'You can reach us at:\n\n📧 Email: support@optimameditech.com\n📞 Phone: +91 98765 43210\n🕐 Hours: Mon-Sat, 9 AM - 6 PM\n📍 Location: Mumbai, India\n\nOr visit our <a href="admin-firebase.html" style="color: #4A9FD8; font-weight: 600;">Admin Portal</a> for more details.';
        }

        // Delivery/Shipping
        if (lowerMessage.includes('deliver') || lowerMessage.includes('ship') || lowerMessage.includes('installation')) {
            return 'We provide:\n\n🚚 Pan-India delivery\n📦 Free shipping on orders above ₹1,00,000\n⚙️ Professional installation included\n📅 Delivery within 7-15 business days\n🔒 Fully insured transit\n\nWhere would you like the equipment delivered?';
        }

        // Payment
        if (lowerMessage.includes('payment') || lowerMessage.includes('pay')) {
            return 'We accept multiple payment methods:\n\n💳 Credit/Debit Cards\n🏦 Bank Transfer\n📝 Purchase Orders\n💰 EMI options available\n\nWe also offer Net 30/45/60 payment terms for bulk orders!';
        }

        // Discount
        if (lowerMessage.includes('discount') || lowerMessage.includes('offer') || lowerMessage.includes('deal')) {
            return 'Current offers:\n\n🎉 WELCOME10 - 10% off on orders above ₹1,00,000\n🎁 BULK20 - 20% off on orders above ₹5,00,000\n🎊 NEWYEAR2025 - ₹50,000 off on orders above ₹10,00,000\n\nUse these codes at checkout!';
        }

        // Specifications
        if (lowerMessage.includes('spec') || lowerMessage.includes('detail') || lowerMessage.includes('feature')) {
            return 'I can provide detailed specifications for any equipment. Which product are you interested in?\n\n• Patient Monitors\n• Ultrasound Machines\n• Ventilators\n• X-Ray Systems\n• ECG Machines\n• Defibrillators\n\nJust let me know!';
        }

        // Greeting
        if (lowerMessage.includes('hi') || lowerMessage.includes('hello') || lowerMessage.includes('hey')) {
            return 'Hello! 👋 Great to hear from you! I\'m here to help you find the perfect medical equipment for your needs. What can I assist you with today?';
        }

        // Thanks
        if (lowerMessage.includes('thank') || lowerMessage.includes('thanks')) {
            return 'You\'re very welcome! 😊 Is there anything else I can help you with today?';
        }

        // Default response
        return 'I\'m here to help! I can assist you with:\n\n🛍️ Product information\n💰 Pricing and quotes\n🛡️ Warranty details\n📞 Contact information\n🚚 Delivery and installation\n💳 Payment options\n\nWhat would you like to know more about?';
    }
}

// Initialize chatbot when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        new OptimaMediChatbot();
    });
} else {
    new OptimaMediChatbot();
}

</body>
</html>