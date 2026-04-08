# 💳 PAYMENT.md — Ödeme Entegrasyonu Rehberi

---

## 🔄 Ödeme Akışı (Genel)
```
1. Client → Ürün seç → Sepet → Checkout sayfası
2. Client → Ödeme bilgileri (kart no ASLA backend'e gitmez!)
3. Client → Payment Gateway SDK (Stripe/iyzico) → Token oluştur
4. Client → Backend'e token gönder (POST /api/payments)
5. Backend → Payment Gateway API → Token ile ödeme iste
6. Gateway → Bankaya sor → Sonuç döndür
7. Backend → Sonucu DB'ye kaydet → Client'a bildir
8. Backend → Webhook ile asenkron onay al (yedek)
```

## ⚠️ ALTIN KURAL: KART BİLGİSİ ASLA BACKEND'İNE GELMEMELİ!
- Kart numarası, CVV → sadece Payment Gateway SDK'sı ile işlenir
- Backend'e sadece **token/paymentMethodId** gelir
- PCI DSS uyumluluğu → Gateway halleder

---

## 🏦 Ödeme Sağlayıcıları

| Sağlayıcı | Bölge | Kullanım |
|-----------|-------|----------|
| **Stripe** | Global | En popüler, harika API |
| **iyzico** | Türkiye | Yerli kart desteği, sanal POS |
| **PayTR** | Türkiye | Kolay entegrasyon |
| **PayPal** | Global | Uluslararası ödemeler |

---

## Stripe Entegrasyonu

### Backend (.NET)
```csharp
// NuGet: Stripe.net
var options = new PaymentIntentCreateOptions {
    Amount = 2000, // 20.00 TL (kuruş cinsinden)
    Currency = "try",
    PaymentMethodTypes = new List<string> { "card" },
};
var service = new PaymentIntentService();
var intent = service.Create(options);
return Ok(new { clientSecret = intent.ClientSecret });
```

### Backend (Python)
```python
import stripe
stripe.api_key = os.getenv('STRIPE_SECRET_KEY')
intent = stripe.PaymentIntent.create(amount=2000, currency='try', payment_method_types=['card'])
return {"clientSecret": intent.client_secret}
```

### Backend (Node.js)
```javascript
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
const intent = await stripe.paymentIntents.create({ amount: 2000, currency: 'try' });
res.json({ clientSecret: intent.client_secret });
```

### Frontend (React)
```jsx
import { loadStripe } from '@stripe/stripe-js';
import { Elements, CardElement, useStripe } from '@stripe/react-stripe-js';
const stripePromise = loadStripe(import.meta.env.VITE_STRIPE_PUBLIC_KEY);

function CheckoutForm() {
    const stripe = useStripe();
    const handleSubmit = async (e) => {
        const { clientSecret } = await api.post('/api/payments/create-intent');
        const result = await stripe.confirmCardPayment(clientSecret, {
            payment_method: { card: elements.getElement(CardElement) }
        });
        if (result.error) { /* hata göster */ }
        else { /* başarılı */ }
    };
}
```

### Webhook (Asenkron Onay)
```javascript
// POST /api/webhooks/stripe
app.post('/api/webhooks/stripe', express.raw({type: 'application/json'}), (req, res) => {
    const sig = req.headers['stripe-signature'];
    const event = stripe.webhooks.constructEvent(req.body, sig, WEBHOOK_SECRET);
    if (event.type === 'payment_intent.succeeded') {
        const paymentIntent = event.data.object;
        // DB güncelle → sipariş onayla
    }
    res.json({ received: true });
});
```

---

## 💰 Ödeme Modelleri
| Model | Açıklama | Örnek |
|-------|----------|-------|
| Tek seferlik | Bir kere öde | E-ticaret ürünü |
| Abonelik (Recurring) | Aylık/yıllık otomatik | SaaS, Netflix |
| Marketplace | Satıcı-alıcı, komisyon | Trendyol, Etsy |
| Wallet/Bakiye | Ön yükleme | Oyun içi satın alma |
