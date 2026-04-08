## SEQUENCE-ENGINE v1 (ZORUNLU)
Bu template ile calisirken sirayi bozmak YASAK:
1) QUICK-START.md
2) 01-Planning.md
3) 02-Architecture.md
4) 03-StepByStep.md
5) 04-FilesStructure.md
6) 05-DebugTips.md
7) 06-Resources.md

Kural:
- Her dosyadan sonra 3-5 maddelik "cikarim ozeti" yaz.
- Ozeti yazmadan sonraki dosyaya gecme.
- 7 dosya tamamlanmadan kod uretimine baslama.
- Bu akisin detay standardi: Templates/_Universal/TEMPLATE-SEQUENCE-ENGINE.md

---
# ⚡ PYTHON FASTAPI - OTONOM BEYİN THE (QUICK-START & MASTER YASAKLARI)

> **DİKKAT YAPAY ZEKA:** EGER BU PROJEDE KURUMSAL `PYTHON VE FASTAPI` ALTYAPISI GERÇEKLEGTİRİYORSAN, AGAgIDAKİ (ASENKRON, TYPE-HINT, DEPENDENCY KİLİTLERİ) KURALLARINA %100 UYMAK ZORUNDASIN. BU BİR DJANGO VEYA AMATÖR FLASK PROJESİ DEGİLDİR. SPAGETTİ KOD VEYA BLOCKING I/O YAPARSAN TÜM SUNUCUYU KİLİTLERSİN! İGLEM İPTAL EDİLİR.

## YASAKLAR LİSTESİ (ANTI-PATTERNS) - ASLA YAPMA!

1. ❌ **ASENKRON İGLEVLER (ASYNC DEF) İÇİNE SENKRON THE GECİKTİRİCİLER YAZMAK YASAKTIR:** 
   Eğer Otonom AI gidip `async def get_data():` içine `time.sleep(2)` veya `requests.get("https://")` yazarsa Python'ın tek olan işlemcisi FELÇ GEÇİRİR. Bütün müşterilerin request'i o 2 saniye boyunca durur! SADECE `await asyncio.sleep(2)` VE `httpx.AsyncClient` kullanılabilir!

2. ❌ **MODELLERDE TİP BİLDİRİMİNİ EKSİK BIRAKMAK (ANY KULLANMAK) HARFİYEN YASAKTIR:** 
   FastAPI gücünü TypeScript gibi Tip zorlamasından alır. `def create_user(user_data):` yazılmaz! `async def create_user(user_data: UserCreateSchema) -> UserResponseSchema:` kullanılmak ZORUNDADIR! Aksi halde FastAPI'nin Pydantic doğrulama zırhı çöpe gider ve API Dokümantasyonu (Swagger) Bozuk çıkar.

3. ❌ **GİZLİ BİLGİLERİ (gİFRE VS) RESPONSE (YANIT) GÖVDESİNDEN SIZDIRMAK YASAKTIR:** 
   Müşteri giriş yaptıktan sonra veya profile bastığında, `User` SQLAlchemy objesindeki `hashed_password` JSON olarak dünyaya dönemez. Response dönülürken `response_model=UserResponse` KANUN gibi Routh'un tepesine yapıştırılmalı ve `UserResponse` Pydantic modelinde şifre barındırılmamalıdır!

4. ❌ **BAGIMLILIK (DEPENDS) KULLANMADAN MANTIGA GİRMEK YASAKTIR:**
   Zeka gidip Request gelince Token var mı diye `if not req.headers.get("Authorization"): return 401` kodunu KULLANAMAZ! Bu tarz tüm güvenlik önlemleri The DEPENDS (Bağımlılık Enjeksiyonu) `current_user: User = Depends(get_current_user)` ile sağlanacaktır ki tüm API Controller blokları ince ve temiz kalsın!

---

## ✅ ZORUNLU MİMARİ YAPISI (CLEAN ENTERPRISE)

```text
/fastapi-app (The Zırhlı Klasörler)
 ├── /core          => BÜTÜN Konfigürasyon (.env Settings Pydantic), Güvenlik ve JWT Kalkanları
 ├── /db            => Asenkron SQLAlchemy Engine Motoru ve Models.py!
 ├── /schemas       => Pydantic DTO (Validation) zırhları! Veri buraya çarpmadan API'ye giremez.
 ├── /api           => Routerlar! Hiçbir Business Logic Barındırmayan Sadece Request/Response Taşıyıcıları.
 └── main.py        => Sadeleştirilmiş Kök başlatıcı ve CORS/Middleware Ayar Dairesi.
```

---

## BAGLAMADAN ÖNCE BİLMEN GEREKEN İLK ADIM

Eğer User sana "Kurumsal Bir Python Rest API the Çiz" dediyse dahi,
**BU DOSYA (QUICK-START)** seni bağlar. 

1. Başlarken VENV (Sanal ortamını) hazırla, FastAPI ve Uvicorn paketlerin kilit sürüm ile the `requirements.txt` ye Otonom gekilde Göm!.
2. Projeye başlarken `main.py` içerisine 100 satır the routerları YIGMA. Temiz Klasörle (Routers) klasöründen Pürüzsüz `TRouter` importunu YAP!.
3. SQLAlchemy ve Asyncpg ile kurduğun Veritabanında oturumu `yield` ile sağlayıp, hata durumunda `finally` ile the kapatacağından (%100 sızdırmazlık) emin olmadan projeye geçme!!.
4. The Git the IGNORE dosyasının içine `__pycache__` ve `.env` dosyalarını atarak the kurumsal güvenlik adımlarını THE unutma!

**PYTHON DİLİNİN GÜCÜNÜ THE FASTAPI gAHLANDIRIR, SENKRON VEYA ESKİ YÖNTEMLERE DÖNME!. MÜKEMMEL KURULUMA BAGLAYABİLİRSİN!**

