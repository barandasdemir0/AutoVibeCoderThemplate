# ============================================
# Dosya: user_service.py
# Amaç: User iş mantığı — register, login, get, update
# Bağımlılıklar: user model, user schema, security, database
# ============================================

import uuid
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.user import User
from app.schemas.user import UserRegister, UserUpdate
from app.core.security import hash_password, verify_password, create_access_token


class UserService:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def register(self, data: UserRegister) -> User:
        """Yeni kullanıcı kaydet."""
        # Email kontrolü
        existing = await self.get_by_email(data.email)
        if existing:
            raise ValueError("Bu e-posta zaten kullanılıyor")

        user = User(
            id=str(uuid.uuid4()),
            email=data.email,
            name=data.name,
            hashed_password=hash_password(data.password),
        )
        self.db.add(user)
        await self.db.commit()
        await self.db.refresh(user)
        return user

    async def authenticate(self, email: str, password: str) -> tuple[User, str]:
        """Kullanıcı doğrula ve token üret."""
        user = await self.get_by_email(email)
        if not user or not verify_password(password, user.hashed_password):
            raise ValueError("E-posta veya şifre yanlış")

        token = create_access_token(data={"sub": user.id, "email": user.email})
        return user, token

    async def get_by_id(self, user_id: str) -> User | None:
        """ID ile kullanıcı getir."""
        result = await self.db.execute(select(User).where(User.id == user_id))
        return result.scalar_one_or_none()

    async def get_by_email(self, email: str) -> User | None:
        """Email ile kullanıcı getir."""
        result = await self.db.execute(select(User).where(User.email == email))
        return result.scalar_one_or_none()

    async def update(self, user_id: str, data: UserUpdate) -> User | None:
        """Kullanıcı bilgilerini güncelle."""
        user = await self.get_by_id(user_id)
        if not user:
            return None

        if data.name is not None:
            user.name = data.name

        await self.db.commit()
        await self.db.refresh(user)
        return user

    async def get_all(self, skip: int = 0, limit: int = 20) -> list[User]:
        """Tüm kullanıcıları listele (pagination)."""
        result = await self.db.execute(select(User).offset(skip).limit(limit))
        return list(result.scalars().all())
