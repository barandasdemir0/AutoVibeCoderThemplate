import { Link } from 'react-router-dom';
const NotFoundPage = () => (
  <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', flexDirection: 'column', gap: '16px' }}>
    <h1 style={{ fontSize: '4rem', color: 'var(--color-primary)' }}>404</h1>
    <p>Sayfa bulunamadı</p>
    <Link to="/" style={{ padding: '10px 24px', background: 'var(--color-primary)', color: 'white', borderRadius: '8px', textDecoration: 'none' }}>Ana Sayfaya Dön</Link>
  </div>
);
export default NotFoundPage;
