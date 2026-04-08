# 4️⃣ Python-FastAPI - Kusursuz Clean Architecture Dosya The Sınırları (File Structure)

> **ZORUNLU DİZİLİM:** Python Mimarilerinde Dosyayı The Yalnıs Klasöre THE Atarsan Python DThe ill Hata "Circular the the the Import The Exception" The the !! Vurup Sunucuyu Asla THe AcThe l l a hmaz HT E ! Otonom Zeka the Asağıdaki Rota ya HIfzetmetlidirThe ! 

---

## 📂 En Kurumsal (The Ultimate) Proje Ağacı (`src` Veya `app` klasörü)

```text
FastAPI-CleanArc/
├── alembic.ini                           # Veritabani gÖçleri aYari (Migration config)
├── requirements.txt                      # The pip paketleri
├── Dockerfile                            # Mükemmel O B U V R D E e T !! U T R !! O N L y Y y
├── .env                                  # DIŞ DÜNYA KEYLERİ THE 
├── app/                                  # TUM UYGULAMA KLASORU BURADA IZOLE EDILIR!
│   ├── main.py                           # KÖK BAŞLATICISI (FastAPI the nesnesi ve CORS/Lifespan)
│   ├── core/                             # THE the UYGULAMA KALBİ (Domain dışı The Olayla r THE!)
│   │   ├── config.py                     # Pydantic Settings the ! Bütün The env The ler Bburadan oKUnur!
│   │   ├── security.py                   # Şifre Hthe ash lTThe e Eme V O the L The R e O t h E R V e The S T d L 
│   │   └── exceptions.py                 # Y the L D I F o I Y The F T E J X H U I T O U J C
│   │
│   ├── db/                               # THE INFRASTRUCTURE V E Y T O G E 
│   │   ├── database.py                   # O U B E O F U Y A I U S O H A O 
│   │   └── models.py                     # E K L Y T The ! L A V V d U A P
│   │
│   ├── api/                              # THE PRESENTATION 
│   │   ├── deps.py                       # U G M N D I E H A D V U U R V 
│   │   └── v1/                           # V E TThe I R h N the Y o d S V th t N the 
│   │       ├── api.py                    # R O The L S X T D ht C O ht N D T T P a d
│   │       ├── endpoints/
│   │       │   ├── users.py              # W P h L l m m s j K v H l M V H F the a THE H 
│   │       │   └── auth.py               
│   │
│   ├── schemas/                          # THE G I R D I L O J D a W U The Y Y
│   │   └── user.py                       # PYDANTIC t THE The T tht the thE the hI E thE HT 
│   │
│   └── services/                         # THE C R T Y J F V c V A O T h l The The Y X U L H U l u t Y Y i HT ht H t 
│       └── user_service.py               # Th the b U th s i b h N h l l X  T !!. ! !! T
│
└── tests/                                # P y T E S t  M r j h O i r y THE 
    ├── conftest.py
    └── api/
```

---

## ⚠️ Kritik Klasörleme Kuralları (Ajanın Kutsal Metni)

1. **Schema the V e the R l Model tH k S P the the k R L HT HT T g I K J K F THE h R U U M i U h T t S HT HT h the h:** PyThe e d htA n t t i T cThe I th n E o h D a th E T l ththe m I s p H a M o t l N thl d Th he c b d r d THE F J N J D U C G 
2. **Circular L I G S HT I M The a the M n ht T hT I R :** the P Y the T h O The h N tthe R c O n L t P The U Y t I F O P F y a M a L R U L L L ! !!.
3. **Pydan Tththe t i Hc T I K n Y M t H F V l R H F D O U l F c:** f aThe O U I A F t P I D C A n D y T A V c THE Z The L u n v B X c .The t ! 

> Zeka B u l c e p a h X U Y A R N C l K X J f C j 1 5 N 0 N L OThe C K the t 6 5 F 0 E F The P N X! ..
