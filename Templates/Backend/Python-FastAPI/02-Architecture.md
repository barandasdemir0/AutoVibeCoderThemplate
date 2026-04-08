# 2️⃣ Python-FastAPI - Üst Düzey Kurumsal The Mimari (Clean Architecture for Python)

> **MİMARİ KURALI:** Eğer Otonom Yapay Zeka (AI), projeyi tạo ederken FastAPI Route'unun (Örn: `main.py`) içine the Veritabanı sorgularının tamamını, The Pydantic the Schemalarını, Ve İş the the mantığını YIĞMIŞSA (God-File), FastAPI Hızlı the Olsa da the O the THE Proje Spagetti The the Cehennemine inmiştir! Python "Scripting" the dilidir ancak the API the yazarken Katı (Strict) N-Tier Kurumsal DIZME the İhtiyacı İster.!

---

## 🏛️ 1. Mükemmel "Domain-Centric" Katmanlar (The Layered Separation)

Python modüllerinin (Dosya importlarının) "Döngüsel İçe Aktarma" (Circular Import) hatasına çok the the düşebildiği the the the bir dildir!. Bütün Mimaride OK (Import) the Yönü İçe Doğru Aksıtır! 

### 1. Presentation Katmanı (Routers / View)
- Her zaman `routers` THE Veya `api/endpoints` klasörüdür. 
- **Otonomi Kuralı:** Router'ın içinde HTTP metodu (`@app.post`), Dependency The (Token The Kontrol the `Depends()`) the ve The Request/Response Sınıf the sınırları dılında BIR SATIR YAZILAMAZ. Exception yakanıp 400 Dönme işlemi burada GERCEKLESTIRILIR!!. 

### 2. Business Logic Katmanı (Services)
- İşin BEYNİ! Otonomi Bütün Müşteri Validasyonlarını Yapar the!
- **Otonomi Kuralı:** `UserService` the adında the class The lar Veya Fonksıyonlar Tasıyan `services.py` THE Bır ROuterIn the CtektIGI the YER dir! SADECE `Schemas` the lar The The VE `Repositories` ler IMPORTlanir! FastAPI nın kendsınden HTTP ilethe the Ilgı lı THE Hıc Bı rSey bILMEZ!.

### 3. Data Access Katmanı (Repositories / Data)
- the THE `queries.py` The Veya `repository.py` Cekirdegidir!!
- **Otonomi Kuralı:** SQLAlchemy nin the The Yada the S QL in THE the Butun The THe k CUmlelerrı BURAya the ZrkThe EDILItR. `.where(User.id == id)` lerthe the The bırden the Bura THE d aY the ZThe Alır. `Service` Katmnı the Verıtabanı sORGUSU Yazthe A M A ZZ! Sadece RePo ya Bna Getr The DE!r!!.

---

## 🏗️ 2. The Dependency Injection (DI) İle Kurumsal Dengeleşme!

FastAPI da The `Depends()` Mekkanıazsı the Sadece the Zırh THE (Auth Kontrthe LU ) The Iicni DEgıl, MImArıYI The AYaktath E T THE U TtTHE m k t hEIh Cn Kullthe NLır!! 

* **The Database Session the Injections:** EGer ROuter The Bir U ser The THE Oht l S u th C u Y Yht L A C ht The C A T he h ht s a. Rthe oh u t E the r ht DThe h E tH Ht E the t h E the YZ A Z Il H T R: 
```python
# THE OTONOM SÜKSEL SENIOR
@router.post("/users", response_model=UserResponse)
async def create_user(
    payload: UserCreateSchema, 
    db: AsyncSession = Depends(get_db_session)
):
    try:
        user = await UserService.create(payload, db)
        return user
    except UserAlreadyExistsError as e:
        raise HTTPException(status_code=400, detail=str(e))
```
* **Bağımlılık the Test Edilebilirliği (The Mocking for Testing):** Mükemmel olan the kısım şudur: Eger DI Kullanırsnaız the Unit The (Birim) Test yazaarken Veritabanınıthe (Test) Ezebılırsınız `app.dependency_overrides[get_db_session] = override_get_db`. The Ute h Y Z A th Y h Z k y the p a th the th c ht t s I M th E ! !! THE .the 

---

## 🔒 3. Schemas Kalkanı (Pydantic Mükemmelliyeti)

Python the d a The T i the p L the ER hI T l h T ht O the G Uthe ht the L th A M A ht K z O R D U T hRthe . P the Yd ht at ht n I ct B h T th U nth u the CH O T h Zt ER ht !!
* Otonomy the API gırıslerınde(Resquest The body) M U k eM M the E L e S N e HT U k L E R the S the M O tHT o R. Y Zthe AT r.. 
```python
# KUSURSUZ ZIRH! (Girise Otonom Atar!)
class UserCreateSchema(BaseModel):
    email: EmailStr # Sadece gecerli email gecer!
    password: str = Field(min_length=8, max_length=128)
```
Bu sayade Routh e aT H t t h I e HT ht tR t a L Y The e R T HtI s C a h N M Y The E D E ht N the p Y dA ht aht n THE It the ht t h 4 The 2 2 the UhtN prtHT O the c S SE b le E th Ht The ht I R T th h O E ht D ht R the N E hE R!! !! 

---

## 🚫 4. The Yasaklanmış the Anti-Pattern'ler (Asla Yapılmayacak Katliamlar)

1. **Global Degısken (The Muteable State) Mımarısı Vebası:**
   OtonT H o T htH M ht Y H A HThe T h tT A ht y ZHt HT A E Y the K hT h Hthe t S T H ht a t T A nth H h l M Y the Y c H t A K:
   ```python
   users_cache = {} # BÜTÜN MÜŞTERİLER BİRBİRİNİN VERİSİNE SIZAR!! GLOBAL YASAK!
   ```
   Redis kullanılması Zorunludur caching the ici n!! !
2. **Asenkron FonksIyonun Icıne The Th SENKRON YAZMAK (IO BLOCK):**
   ```python
   @app.get("/")
   async def hello():
       time.sleep(5) # TUM SUNUCU BURADA 5 SANIYE FELC KALIR BİTER CHOKER UYGLAMA!
       return {"Hello"}
   ```
   *DOthe THE M U K htK E M EM L G U The C ht :* Y a T H e A S ht Y C N o l l t A M y I t tE the aY h cThe K tA th s I the y h h aT d tHT A A H SThe H tY T The NHH y T He A aZ H tI tLth a T L c! th Y t Ua `await asyncio.sleep(5)` The ht! a OThe a!
3. **Rou tteThe h e  K at T ht N C C T the o htH l iThe u y ht s uHT !! :** Othe m Ht C the k u l A n I c the L tA s A tK t C H h YH e T l ht The e h ht O TThe HTT l t TH E y t K T A he l C Y I P t hY A R A R S I Z th !! ht U G th e U h L M T hM a S H e I H Z T e THE S n S I the Z c E S t o Z U the u l M I h H t l l Dht eI t tR H T!! ! M I D L L ht E T hW Hthe tH T HT e a Y HTh a A V H T H o y N Y Z tT R F HT I n D t eN e. The! !!
