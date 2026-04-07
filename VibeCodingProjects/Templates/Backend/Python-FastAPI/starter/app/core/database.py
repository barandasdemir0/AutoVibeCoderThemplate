# ============================================
# Dosya: database.py
# Amaç: SQLAlchemy async engine + session factory
# Bağımlılıklar: config.py
# ============================================

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase

from app.core.config import settings

engine = create_async_engine(settings.DATABASE_URL, echo=settings.APP_ENV == "development")

AsyncSessionLocal = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


class Base(DeclarativeBase):
    """Tüm modeller bu class'ı extend edecek."""
    pass


async def get_db():
    """FastAPI Dependency — her request'te yeni session."""
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()
