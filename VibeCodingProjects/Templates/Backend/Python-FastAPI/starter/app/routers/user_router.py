# ============================================
# Dosya: user_router.py
# Amaç: User CRUD endpoint'leri — protected routes
# Bağımlılıklar: user_service, security, database
# ============================================

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.core.security import get_current_user
from app.schemas.user import UserResponse, UserUpdate, MessageResponse
from app.services.user_service import UserService

router = APIRouter()


@router.get("/me", response_model=UserResponse)
async def get_me(
    current_user: dict = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Mevcut kullanıcı bilgileri."""
    service = UserService(db)
    user = await service.get_by_id(current_user["id"])
    if not user:
        raise HTTPException(status_code=404, detail="Kullanıcı bulunamadı")
    return user


@router.put("/me", response_model=UserResponse)
async def update_me(
    data: UserUpdate,
    current_user: dict = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Mevcut kullanıcı bilgilerini güncelle."""
    service = UserService(db)
    user = await service.update(current_user["id"], data)
    if not user:
        raise HTTPException(status_code=404, detail="Kullanıcı bulunamadı")
    return user


@router.get("/", response_model=list[UserResponse])
async def get_users(
    skip: int = 0,
    limit: int = 20,
    current_user: dict = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Tüm kullanıcıları listele (admin)."""
    service = UserService(db)
    return await service.get_all(skip=skip, limit=limit)
