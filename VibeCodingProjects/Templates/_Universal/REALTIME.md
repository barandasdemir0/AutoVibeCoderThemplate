# 🔴 REALTIME.md — Gerçek Zamanlı İletişim (WebSocket, SignalR, Socket.io)

> Chat, bildirim, canlı dashboard, canlı fiyat güncellemesi gibi real-time özellikler.

---

## 🔍 Ne Zaman Real-time?
| Özellik | Polling mı? | Real-time mı? |
|---------|------------|---------------|
| Chat / mesajlaşma | ❌ | ✅ WebSocket |
| Canlı bildirimler | ⚠️ | ✅ WebSocket |
| Dashboard (veri güncelleme) | ⚠️ Polling OK | ✅ Daha iyi |
| Canlı fiyat (borsa) | ❌ | ✅ WebSocket |
| Form submit sonucu | ✅ HTTP yeterli | ❌ |
| Dosya upload progress | ✅ HTTP yeterli | ❌ |

---

## ⚡ Zorunlu Sağlamlık: Heartbeat & Reconnect
WebSocket bağlantıları kopmaya mahkümdur (mobil ağ değişimi, tüneller vs.). AI şu 3 kuralı KESİN uygulamalıdır:

1. **Heartbeat (Ping/Pong):** Server 30 saniyede bir client'a PING yollar. Client PONG dönmezse, server o socket'i düşürür (zombi engelleme).
2. **Auto-Reconnect (Backoff):** Client bağ koptuğunda hemen değil, artan bekleme süresiyle (1s, 2s, 4s, 8s) tekrar bağlanmayı denemelidir.
3. **State Recovery (Senkronizasyon):** Client koptuğu süre boyunca kaçırdığı mesajları, "reconnect" olduktan hemen sonra REST API'den `last_message_id` vererek fetch etmek ZORUNDADIR. Aksi halde veri kaybı yaşanır.

---

## .NET — SignalR
```csharp
// Hub
public class ChatHub : Hub
{
    public async Task SendMessage(string user, string message)
    {
        await Clients.All.SendAsync("ReceiveMessage", user, message);
    }
    
    public async Task JoinRoom(string roomName)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, roomName);
    }
    
    public async Task SendToRoom(string roomName, string message)
    {
        await Clients.Group(roomName).SendAsync("ReceiveMessage", Context.User?.Identity?.Name, message);
    }
}

// Program.cs
builder.Services.AddSignalR();
app.MapHub<ChatHub>("/hubs/chat");

// Angular Client
import { HubConnectionBuilder } from '@microsoft/signalr';
const connection = new HubConnectionBuilder().withUrl('/hubs/chat').build();
connection.on('ReceiveMessage', (user, message) => { /* UI güncelle */ });
await connection.start();
await connection.invoke('SendMessage', 'Baran', 'Merhaba!');
```

## Node.js — Socket.io
```javascript
// Server
const io = require('socket.io')(server, { cors: { origin: 'http://localhost:5173' } });
io.on('connection', (socket) => {
    console.log('User connected:', socket.id);
    
    socket.on('joinRoom', (room) => socket.join(room));
    
    socket.on('sendMessage', (data) => {
        io.to(data.room).emit('receiveMessage', { user: data.user, message: data.message, time: new Date() });
    });
    
    socket.on('disconnect', () => console.log('User disconnected'));
});

// React Client
import { io } from 'socket.io-client';
const socket = io('http://localhost:3000');
socket.emit('joinRoom', 'general');
socket.emit('sendMessage', { room: 'general', user: 'Baran', message: 'Merhaba!' });
socket.on('receiveMessage', (data) => { /* messages state güncelle */ });
```

## Python — FastAPI WebSocket
```python
from fastapi import WebSocket, WebSocketDisconnect

class ConnectionManager:
    def __init__(self):
        self.active: list[WebSocket] = []
    
    async def connect(self, ws: WebSocket):
        await ws.accept()
        self.active.append(ws)
    
    def disconnect(self, ws: WebSocket):
        self.active.remove(ws)
    
    async def broadcast(self, message: str):
        for conn in self.active:
            await conn.send_text(message)

manager = ConnectionManager()

@app.websocket("/ws/chat")
async def chat(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.broadcast(f"User: {data}")
    except WebSocketDisconnect:
        manager.disconnect(websocket)
```

## Flutter — web_socket_channel
```dart
final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8000/ws/chat'));
channel.stream.listen((message) { setState(() { messages.add(message); }); });
channel.sink.add('Merhaba!');
// Dispose: channel.sink.close();
```

---

## 📋 Real-time Checklist
## 📋 Real-time Checklist ZORUNLULUKLARI
- [ ] Reconnection logic (bağlantı koparsa exponential backoff ile otomatik tekrar bağlan)
- [ ] Auth Handshake (WebSocket bağlantısında Token'ı ilk mesaj olarak (veya auth header) doğrulat)
- [ ] Heartbeat/ping-pong (bağlantı canlı mı kontrol mekanizması)
- [ ] Missed Data Recovery (Kopma anındaki verileri geri getirme)
- [ ] Rate limiting (WAF / socket.io rate limiter ile spam engelle)
- [ ] Room/Group management (Memory leak önleme)
