// ============================================
// Dosya: User.js (Model)
// Amaç: User Mongoose şeması — validation, password hash, toJSON
// Bağımlılıklar: mongoose, bcryptjs
// ============================================

const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: [true, 'İsim zorunlu'], trim: true, minlength: 2, maxlength: 100 },
    email: { type: String, required: [true, 'Email zorunlu'], unique: true, lowercase: true, trim: true,
      match: [/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/, 'Geçerli email girin'] },
    password: { type: String, required: [true, 'Şifre zorunlu'], minlength: 6, select: false },
    role: { type: String, enum: ['user', 'admin'], default: 'user' },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

// Kayıt öncesi password hash
userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 12);
  next();
});

// Password doğrulama
userSchema.methods.comparePassword = async function (candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

// JSON'da password'u gizle
userSchema.methods.toJSON = function () {
  const obj = this.toObject();
  delete obj.password;
  return obj;
};

module.exports = mongoose.model('User', userSchema);
