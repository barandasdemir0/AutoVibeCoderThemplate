// ============================================
// Dosya: app.js
// Amaç: Express uygulama giriş noktası — middleware, router, DB bağlantısı
// Bağımlılıklar: express, cors, helmet, morgan, dotenv, mongoose
// ============================================

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const { connectDB } = require('./config/database');
const { errorHandler, notFoundHandler } = require('./middleware/errorHandler');

const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

// ─── DB Bağlantısı ───
connectDB();

// ─── Middleware (SIRA ÖNEMLİ!) ───
app.use(helmet());                                    // 1. Security headers
app.use(express.json({ limit: '10mb' }));             // 2. JSON parser
app.use(express.urlencoded({ extended: true }));       // 3. URL encoded
app.use(cors({ origin: process.env.CORS_ORIGIN, credentials: true })); // 4. CORS
app.use(morgan('dev'));                                // 5. Logging

// Rate limiting
const limiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 100 });
app.use('/api/', limiter);

// ─── Routes ───
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);

// Health check
app.get('/api/health', (req, res) => res.json({ status: 'ok', app: process.env.APP_NAME || '{{PROJECT_NAME}}' }));

// ─── Error Handling (EN SON!) ───
app.use(notFoundHandler);
app.use(errorHandler);

// ─── Start ───
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`📚 Environment: ${process.env.NODE_ENV}`);
});

module.exports = app;
