// ============================================
// Dosya: errorHandler.js
// Amaç: Global error handler + 404 handler
// Bağımlılıklar: Yok
// ============================================

const notFoundHandler = (req, res, next) => {
  res.status(404).json({ success: false, message: `Route bulunamadı: ${req.originalUrl}` });
};

const errorHandler = (err, req, res, next) => {
  console.error('❌ Error:', err.message);

  // Mongoose validation error
  if (err.name === 'ValidationError') {
    const messages = Object.values(err.errors).map((e) => e.message);
    return res.status(400).json({ success: false, message: 'Validation hatası', errors: messages });
  }

  // Mongoose duplicate key
  if (err.code === 11000) {
    const field = Object.keys(err.keyValue)[0];
    return res.status(400).json({ success: false, message: `Bu ${field} zaten kullanılıyor` });
  }

  // JWT error
  if (err.name === 'JsonWebTokenError') {
    return res.status(401).json({ success: false, message: 'Geçersiz token' });
  }

  // JWT expired
  if (err.name === 'TokenExpiredError') {
    return res.status(401).json({ success: false, message: 'Token süresi dolmuş' });
  }

  // Default
  res.status(err.statusCode || 500).json({
    success: false,
    message: err.message || 'Sunucu hatası',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
};

module.exports = { notFoundHandler, errorHandler };
