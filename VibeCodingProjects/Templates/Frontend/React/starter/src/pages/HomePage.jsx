// ============================================
// Dosya: HomePage.jsx
// Amaç: Ana sayfa — hoş geldin mesajı, placeholder content
// ============================================

import { useEffect } from 'react';
import { useAuthStore } from '../store/authStore';

const HomePage = () => {
  const { user, fetchMe } = useAuthStore();

  useEffect(() => {
    if (!user) fetchMe();
  }, []);

  return (
    <div style={{ textAlign: 'center', paddingTop: '60px' }}>
      <h1>🚀 Hoş Geldiniz!</h1>
      <p style={{ fontSize: '1.1rem', marginTop: '8px' }}>
        {user ? `Merhaba, ${user.name}!` : 'Yükleniyor...'}
      </p>
      <p style={{ marginTop: '24px', color: 'var(--color-text-secondary)' }}>
        Burası ana sayfanız. İçerik eklemeye başlayın.
      </p>
    </div>
  );
};

export default HomePage;
