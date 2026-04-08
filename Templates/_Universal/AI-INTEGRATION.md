# 🤖 AI-INTEGRATION.md — Projeye Yapay Zeka Ekleme Rehberi

---

## 🧠 AI Entegrasyon Yolları

| Yöntem | Açıklama | Ne Zaman |
|--------|----------|----------|
| **API Call** | OpenAI/Gemini/Claude API çağır | Hızlı, sunucu tarafı |
| **Self-hosted Model** | Kendi modelini sun (ONNX, TorchServe) | Özel model, gizlilik |
| **Embedded (On-device)** | TFLite/CoreML mobilde çalıştır | Offline, düşük latency |
| **RAG** | Vektör DB + LLM (kendi verisiyle cevap) | Doküman Q&A, chatbot |

---

## 🔌 OpenAI / Gemini API Entegrasyonu

### Python (Backend)
```python
import openai
client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
response = client.chat.completions.create(
    model="gpt-4",
    messages=[
        {"role": "system", "content": "Sen bir yardımcı asistansın."},
        {"role": "user", "content": user_message}
    ],
    temperature=0.7, max_tokens=1000
)
answer = response.choices[0].message.content
```

### Google Gemini
```python
import google.generativeai as genai
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
model = genai.GenerativeModel("gemini-pro")
response = model.generate_content(prompt)
print(response.text)
```

### Node.js
```javascript
import OpenAI from 'openai';
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
const response = await openai.chat.completions.create({
    model: 'gpt-4', messages: [{ role: 'user', content: userMessage }]
});
const answer = response.choices[0].message.content;
```

### .NET
```csharp
// Azure.AI.OpenAI NuGet
var client = new OpenAIClient(new Uri(endpoint), new AzureKeyCredential(key));
var response = await client.GetChatCompletionsAsync(new ChatCompletionsOptions {
    Messages = { new ChatMessage(ChatRole.User, userMessage) },
    DeploymentName = "gpt-4"
});
var answer = response.Value.Choices[0].Message.Content;
```

---

## 📧 Email Gönderme

### .NET (SmtpClient / MailKit)
```csharp
using MailKit.Net.Smtp;
using MimeKit;
var message = new MimeMessage();
message.From.Add(new MailboxAddress("App", "noreply@app.com"));
message.To.Add(new MailboxAddress("User", email));
message.Subject = "Hoşgeldiniz!";
message.Body = new TextPart("html") { Text = "<h1>Merhaba!</h1>" };
using var client = new SmtpClient();
await client.ConnectAsync("smtp.gmail.com", 587, false);
await client.AuthenticateAsync("user@gmail.com", "app-password");
await client.SendAsync(message);
```

### Python (smtplib)
```python
import smtplib
from email.mime.text import MIMEText
msg = MIMEText("<h1>Merhaba!</h1>", "html")
msg["Subject"] = "Hoşgeldiniz!"
msg["From"] = "noreply@app.com"
msg["To"] = email
with smtplib.SMTP("smtp.gmail.com", 587) as server:
    server.starttls()
    server.login("user@gmail.com", "app-password")
    server.send_message(msg)
```

### Node.js (Nodemailer)
```javascript
const nodemailer = require('nodemailer');
const transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com', port: 587,
    auth: { user: process.env.EMAIL, pass: process.env.EMAIL_PASS }
});
await transporter.sendMail({
    from: '"App" <noreply@app.com>', to: email,
    subject: 'Hoşgeldiniz!', html: '<h1>Merhaba!</h1>'
});
```

### Laravel
```php
Mail::to($user->email)->send(new WelcomeMail($user));
// app/Mail/WelcomeMail.php → Mailable class
```

---

## 🤖 Kendi Modelini Deploy Etme (Self-hosted)

### FastAPI + ONNX
```python
import onnxruntime as ort
session = ort.InferenceSession("model.onnx")

@app.post("/predict")
async def predict(data: InputSchema):
    input_array = preprocess(data)
    result = session.run(None, {"input": input_array})
    return {"prediction": postprocess(result)}
```

### TFLite (Mobile — On-device)
```dart
// Flutter — tflite_flutter
final interpreter = await Interpreter.fromAsset('model.tflite');
interpreter.run(inputData, outputData);
```

---

## 📂 AI Feature Ekleme Checklist
- [ ] API key → `.env` (ASLA hardcode etme)
- [ ] Rate limiting → API çağrı limiti koy
- [ ] Error handling → API down ise fallback
- [ ] Caching → Aynı prompt = aynı cevap → cache
- [ ] Logging → AI çağrılarını logla (prompt, response, token kullanımı)
- [ ] Cost tracking → Token kullanımını takip et
