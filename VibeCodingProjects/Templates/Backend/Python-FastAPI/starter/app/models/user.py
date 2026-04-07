# ============================================
# Dosya: user.py (Model)
# Amaç: User SQLAlchemy modeli — DB tablosu tanımı
# Bağımlılıklar: database.py
# ============================================

from datetime import datetime, timezone
from sqlalchemy import Column, String, DateTime, Boolean
from app.core.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    name = Column(String, nullable=False)
    hashed_password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(DateTime, default=None, onupdate=lambda: datetime.now(timezone.utc))

    # TODO: Yeni modeller aynı pattern ile ekle
    # class Product(Base):
    #     __tablename__ = "products"
    #     id = Column(String, primary_key=True)
    #     name = Column(String, nullable=False)
    #     price = Column(Float, nullable=False)
    #     user_id = Column(String, ForeignKey("users.id"))
