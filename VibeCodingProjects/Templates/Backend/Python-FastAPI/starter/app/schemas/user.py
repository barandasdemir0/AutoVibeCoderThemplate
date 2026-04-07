# ============================================
# Dosya: user.py (Schema/DTO)
# Amaç: Pydantic şemaları — request/response validation
# Bağımlılıklar: pydantic
# ============================================

from datetime import datetime
from typing import Optional
from pydantic import BaseModel, EmailStr, Field


# ─── Request Schemas ───

class UserRegister(BaseModel):
    email: str = Field(..., description="E-posta adresi")
    name: str = Field(..., min_length=2, max_length=100)
    password: str = Field(..., min_length=6, max_length=128)


class UserLogin(BaseModel):
    email: str
    password: str


class UserUpdate(BaseModel):
    name: Optional[str] = Field(None, min_length=2, max_length=100)


# ─── Response Schemas ───

class UserResponse(BaseModel):
    id: str
    email: str
    name: str
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse


class MessageResponse(BaseModel):
    success: bool = True
    message: str
