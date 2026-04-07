# 📋 Planning — Java Test Suite (JUnit 5 + Mockito + MockMvc)

## 🎯
- **Framework:** JUnit 5 (Jupiter)
- **Mock:** Mockito (@Mock, @InjectMocks)
- **Web:** MockMvc (Spring @WebMvcTest)
- **DB:** @DataJpaTest (H2 InMemory)
- **Coverage:** JaCoCo

## Maven Dependencies
```xml
<dependency><groupId>org.springframework.boot</groupId><artifactId>spring-boot-starter-test</artifactId><scope>test</scope></dependency>
<!-- Includes: JUnit 5, Mockito, AssertJ, MockMvc, Hamcrest -->
```

## Klasör Yapısı
```
src/test/java/com/project/
├── unit/
│   ├── service/
│   │   ├── UserServiceTest.java      → @Mock repo + @InjectMocks service
│   │   └── ProductServiceTest.java
│   └── entity/
│       └── UserTest.java
├── integration/
│   ├── repository/
│   │   └── UserRepositoryTest.java   → @DataJpaTest (H2)
│   └── controller/
│       ├── AuthControllerTest.java   → @SpringBootTest + MockMvc
│       └── ProductControllerTest.java
└── fixtures/
    └── TestDataFactory.java          → Reusable test veri üretici
```

## Unit Test (@Mock + @InjectMocks)
```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    @Mock private UserRepository userRepository;
    @InjectMocks private UserService userService;
    
    @Test
    void getById_WhenExists_ReturnsUser() {
        var user = new User(1L, "Baran", "baran@test.com");
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        var result = userService.getById(1L);
        assertThat(result).isNotNull();
        assertThat(result.getName()).isEqualTo("Baran");
        verify(userRepository).findById(1L);
    }
    
    @Test
    void getById_WhenNotExists_ThrowsException() {
        when(userRepository.findById(999L)).thenReturn(Optional.empty());
        assertThrows(EntityNotFoundException.class, () -> userService.getById(999L));
    }
}
```

## Integration Test (@SpringBootTest + MockMvc)
```java
@SpringBootTest
@AutoConfigureMockMvc
class ProductControllerTest {
    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper objectMapper;
    
    @Test
    void getAll_Returns200() throws Exception {
        mockMvc.perform(get("/api/products").header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }
    
    @Test
    void create_WithInvalidData_Returns400() throws Exception {
        mockMvc.perform(post("/api/products")
            .contentType(MediaType.APPLICATION_JSON)
            .content("{}"))
            .andExpect(status().isBadRequest());
    }
}
```

## Repository Test (@DataJpaTest)
```java
@DataJpaTest
class UserRepositoryTest {
    @Autowired private UserRepository userRepository;
    
    @Test
    void findByEmail_ReturnsUser() {
        userRepository.save(new User(null, "Test", "test@test.com"));
        var found = userRepository.findByEmail("test@test.com");
        assertThat(found).isPresent();
        assertThat(found.get().getName()).isEqualTo("Test");
    }
}
```

## Debug + Resources
- **@Mock null** → `@ExtendWith(MockitoExtension.class)` eklendi mi?
- **H2 schema error** → `spring.jpa.hibernate.ddl-auto=create-drop` (test profile)
- **MockMvc 403** → Test'te security disable et veya `@WithMockUser`
- JUnit 5: https://junit.org/junit5 | Mockito: https://site.mockito.org | AssertJ: https://assertj.github.io
