# Java Backend Patterns

Source: Spring Boot 3.5 docs (spring.io/projects/spring-boot), Spring Security Reference

## Project Structure (Spring Boot)
```
src/main/java/com/company/project/
├── controller/     # REST controllers
├── service/        # Business logic
├── repository/     # Data access (JPA, JDBC)
├── model/          # Entities, DTOs
├── config/         # Configuration, security
├── exception/      # Custom exceptions, global handler
└── util/           # Shared utilities
```

## Layered Architecture

```java
// Controller — handles HTTP, delegates to service
@RestController
@RequestMapping("/api/v1/users")
public class UserController {
    private final UserService userService;

    @PostMapping
    public ResponseEntity<UserResponse> create(@Valid @RequestBody CreateUserRequest request) {
        UserResponse user = userService.create(request);
        return ResponseEntity.status(201).body(user);
    }
}

// Service — business logic, no HTTP awareness
@Service
public class UserService {
    private final UserRepository userRepository;
    // Constructor injection (never field injection)
}

// Repository — data access only
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
}
```

## DTOs and Validation

```java
// Use records for immutable DTOs
public record CreateUserRequest(
    @NotBlank @Size(max = 100) String name,
    @NotBlank @Email String email
) {}

public record UserResponse(Long id, String name, String email, Instant createdAt) {}

// Bean Validation: @NotBlank, @Size, @Email, @Min, @Max, @Pattern, @NotNull, @Past, @Future
```

## Global Error Handling

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(AppException.class)
    public ResponseEntity<ErrorResponse> handleAppException(AppException e) {
        return ResponseEntity.status(e.getStatus())
            .body(new ErrorResponse(e.getCode(), e.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException e) {
        var errors = e.getBindingResult().getFieldErrors().stream()
            .collect(Collectors.toMap(FieldError::getField, FieldError::getDefaultMessage));
        return ResponseEntity.badRequest()
            .body(new ErrorResponse("validation_error", errors.toString()));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleUnexpected(Exception e) {
        log.error("Unexpected error", e);
        return ResponseEntity.status(500)
            .body(new ErrorResponse("internal", "Internal error"));
    }
}
```

## Spring Security Configuration

Spring Boot 3.x uses `SecurityFilterChain` beans — no more `WebSecurityConfigurerAdapter`.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // disable for stateless APIs
            .sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .requestMatchers("/actuator/health").permitAll()
                .requestMatchers("/actuator/**").hasRole("ADMIN")
                .anyRequest().authenticated()
            )
            .oauth2ResourceServer(oauth2 ->
                oauth2.jwt(Customizer.withDefaults()));
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

**Actuator security**: always restrict actuator endpoints. Only `/actuator/health` should be public. Lock down `/actuator/env`, `/actuator/configprops`, `/actuator/beans` — they expose internals.

**HTTPS enforcement**:
```java
http.requiresChannel(channel -> channel.anyRequest().requiresSecure());
```

## Configuration

```java
// Type-safe config with records (Spring Boot 3.x)
@ConfigurationProperties(prefix = "app")
public record AppConfig(String apiKey, int maxRetries, Duration timeout) {}

// Enable in main class
@EnableConfigurationProperties(AppConfig.class)
@SpringBootApplication
public class Application { }
```

Externalize via `application.yml` + environment variables. Never hardcode secrets — use Spring Cloud Config or Secrets Manager.

```yaml
# application.yml
app:
  api-key: ${API_KEY}
  max-retries: 3
  timeout: 30s
```

## Dependency Injection

- **Constructor injection** only — not `@Autowired` on fields
- Mark dependencies as `final`
- Use `@RequiredArgsConstructor` (Lombok) or explicit constructors
- Single implementation: inject the interface, not the class

```java
@Service
@RequiredArgsConstructor
public class OrderService {
    private final OrderRepository orderRepository;  // final + constructor
    private final PaymentService paymentService;
    private final NotificationService notificationService;
}
```

## Testing

```java
// Integration test with full context
@SpringBootTest
@AutoConfigureMockMvc
class UserControllerTest {
    @Autowired MockMvc mockMvc;

    @Test
    void createUser_returnsCreated() throws Exception {
        mockMvc.perform(post("/api/v1/users")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {"name": "Test User", "email": "test@example.com"}
                    """))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.name").value("Test User"));
    }
}

// Slice test — only web layer
@WebMvcTest(UserController.class)
class UserControllerSliceTest {
    @Autowired MockMvc mockMvc;
    @MockitoBean UserService userService;
}
```

Use `@SpringBootTest` for integration, `@WebMvcTest` / `@DataJpaTest` for slices. Prefer slice tests for speed.
