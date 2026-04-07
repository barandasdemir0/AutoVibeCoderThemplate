// ============================================
// Dosya: Layout.jsx
// Amaç: Ana layout — Navbar + Outlet (child routes)
// Bağımlılıklar: react-router-dom, authStore
// ============================================

import { Outlet, Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';
import './Layout.css';

const Layout = () => {
  const { user, logout } = useAuthStore();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <div className="layout">
      <nav className="navbar">
        <div className="navbar-brand">
          <Link to="/">{{PROJECT_NAME}}</Link>
        </div>
        <div className="navbar-menu">
          <Link to="/" className="nav-link">Ana Sayfa</Link>
          {/* TODO: Yeni linkler */}
        </div>
        <div className="navbar-end">
          <span className="nav-user">{user?.name || 'Kullanıcı'}</span>
          <button className="btn-logout" onClick={handleLogout}>Çıkış</button>
        </div>
      </nav>
      <main className="main-content">
        <Outlet />
      </main>
    </div>
  );
};

export default Layout;
