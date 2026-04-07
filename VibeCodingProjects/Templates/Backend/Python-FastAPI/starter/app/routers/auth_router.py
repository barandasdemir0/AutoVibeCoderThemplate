# ============================================
# Dosya: auth_router.py
# Amaç: Auth endpoint'leri — register, login
# Bağımlılıklar: user_service, user schema, database
# ============================================

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.schemas.user import UserRegister, UserLogin, TokenResponse, MessageResponse, UserResponse
from app.services.user_service import UserService

router = APIRouter()


@router.post("/register", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
async def register(data: UserRegister, db: AsyncSession = Depends(get_db)):
    """Yeni kullanıcı kaydı."""
    service = UserService(db)
    try:
        user = await service.register(data)
        _, token = await service.authenticate(data.email, data.password)
        return TokenResponse(
            access_token=token,
            user=UserResponse.model_validate(user),
        )
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))


@router.post("/login", response_model=TokenResponse)
async def login(data: UserLogin, db: AsyncSession = Depends(get_db)):
    """Kullanıcı girişi."""
    service = UserService(db)
    try:
        user, token = await service.authenticate(data.email, data.password)
        return TokenResponse(
            access_token=token,
            user=UserResponse.model_validate(user),
        )
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=str(e))
