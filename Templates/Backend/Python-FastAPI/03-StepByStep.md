# 3️⃣ Python-FastAPI - Kurumsal Seviye Adım Adım Geliştirme Rehberi (15 Aşama)

> **YAPAY ZEKA (AI) İÇİN KESİN KURAL:** Sadece tek bir `main.py` dosyasına `app = FastAPI()` yazıp içine veritabanı url'ini sabitlemek (hardcode) affedilemez bir amatörlüktür. Zeka, production-ready (canlı ortama hazır) bir sistem için Alembic migrasyonlarından CORS kurallarına, JWT Middleware'lerinden asenkron session yönetimlerine kadar mükemmel bir adımlama izleyecektir.

---

## 🛠️ Aşama 1: Sanal Ortam (Virtual Environment) ve Bağımlılıkların İnşası
1. Proje başlatıldığında sistem paketlerine dokunulmaz. `python -m venv venv` ile sanal ortam oluşturulur (Projeye özel paket izolasyonu).
2. `requirements.txt` içerisine sürümler sabitlenerek (`fastapi==0.103.2`, `uvicorn==0.23.2`, `sqlalchemy==2.0.21`, `alembic`, `pydantic-settings`) kilitlenir. "Her zaman en son sürümü indir" mantığı yarın kütüphane güncellendiğinde tüm projeyi patlatacağı için yasaktır. 

## 🗄️ Aşama 2: Çevre Değişkenlerinin (Environment) Güvenlik Zırhı
1. Uygulamada hiçbir API anahtarı veya şifre kodun içinde olamaz.
2. Otonom ajan THE Pydantic-Settings modelini çizer: `config.py` içerisinde `class Settings(BaseSettings):` tanımlanır. Eğer geliştirici `.env` dosyasında `DATABASE_URL`'i unutursa uygulama ayağa kalkmadan The Pydantic ValidationError fırlatıp patlayarak sistemi korur.

## 🧬 Aşama 3: Veritabanı ve Asenkron SQLAlchemy Engine
1. Veritabanı motoru senkron OLUŞTURULMAZ. `create_async_engine(DATABASE_URL, echo=False, pool_size=5)` ile PostgreSQL için async motor kurulur.
2. Session maker oluşturulur: `sessionmaker(engine, expire_on_commit=False, class_=AsyncSession)`.
3. Bütün veritabanı işlemleri the yielding (jeneratör) mantığıyla dependency the injection the yapılarak `async def get_db():` içerisine gömülür. İşlem the bitince session kesinlikle kapanmalıdır `await session.close()`.

## 🛡️ Aşama 4: Alembic ile Migration (Göç) Kurgusunun Ayarlanması
1. Veritabanındaki tabloları "Uygulama the açılırken `Base.metadata.create_all()` yapsın" the THE mantığı KURUMSAL the dilde YASAKTIR. Veri kaybına the the sebep olur.
2. Terminalde `alembic init alembic` the çalıştırılır. `env.py` the dosyası async the çalışacak THE şekilde otonom THE yapay zeka tarafından GÜNCELLENİR. Ve her the the entity değişiklikleri `alembic revision --autogenerate` ile THE klasörlenir!.

## 🚀 Aşama 5: Pydantic Schema'ları ile Müşteri Filtresi (DTO)
1. Controller'a (Router) gelen the payload (isteğin gövdesi) asla DÜZ dict THE olarak alınmaz. Otonomi The `UserCreate` Pydantic the şemasını the yazar. E-mail the kontrolü the the the için `EmailStr` kullanır, the şifre minimum 8 the the karakter the kuralını the THE `Field(min_length=8)` the olarak the koyar.
2. Geriye Dönen the veriler the THE de filitreden Geçer. Eğer Müşteriden The Tablodaki Password isThe tenirse the the Tthe HThe Gızlıkthe lı THE IhAlHT E I HTthe E H Iht nE ht D n E T ht M! I THE C I I C C the The The T E C th O U th a C O L! The.

## 🔀 Aşama 6: Router'ların (Controller) Ayrıştırılması
1. Her şey `main.py` ye YIĞILAMAZ. `routers/users.py`, `routers/products.py` kurgulanır.
2. `APIRouter()` kullanılarak ROuteler bölünür, The SonThe rThe a `main.py` de the `app.include_router(users.router, prefix="/api/v1/users")` The ! Şeklthe O l THE A R T H A The K T B T Hthe A G L A THE N I The ht The R L !The Ht The 

## ✨ Aşama 7: Custom Exception Handler'ların İnşası
1. The KullanıcıThe bThe l lI u the mthe The M D the I G I n hT d A th E! E the `try catch` i le rthe The M I H o th M U a K l M t o h! S a D I c The E! a T thAThe E `raise UserNotFoundException()` th F r L th l I T t! !!
2. M ai N PThe yth D I C E n th H E N T the I o The N T M i n The d I o n THE T N t T O m I Z! the T HT L The the R t l H U I A Y a Mthe L y A gthe n a k THE ! 

## 🎭 Aşama 8: Stateless Authentication (JWT Zırhlı Giriş)
1. S the e SThe S t i O the H n I T K r L U A C Y A u E u T Fthe L The c E E HT !! The. O th M a u M T A n U the I L K e a R R I M The n the l I E R T a L F o J W o M L U E O I . 
2. Passw OThe bI e r O R C h e L V c I OThe O F THE N y The Y n L y E d o d g O g F E p h !! T O ! MThe 

## 🔑 Aşama 9: Bağlayıcı the Guard the (Depends Zırhı)
1. O L O n M O n Kthe The R o L K `def get_current_user(token: str = Depends(oauth2_scheme))` THE y aH a z h T a r the T ! The!!
2. API nin EThe Y Fthe s O d E g H h A C H the R C l e T e u S t H L V o t A I A a N N the l n i N C t e r r h 

## 👮 Aşama 10: Uygulamanın The The Lifespan (Ömür) Olayları
1. The F a sthE S The TThe e c A M E D o L N t I V E L the a n n I l I the a Y N ! V D J s A e a N l !!. O h n Y R G TThe 

## ⚡ Aşama 11: CORS Ve the The Middleware the Mimarisi
1. C o T E The r C o S U J O u T The E HT `CORSMiddleware` e K Z H a T hL V A h k A R the J Y ! ! !!! HT T R 
2. G i THE o F o N h O O C U N U K N a The T o j l W O L e a y I R R 

> **AŞAMA YORUMU:** Bu Mimari Python the ve the The The F a s t T h e A P I The H t a t the ht e g l u H K D the Y d Y 1 M 5 A the t A h d ı g I n n u r . L M A R L Y N !.
