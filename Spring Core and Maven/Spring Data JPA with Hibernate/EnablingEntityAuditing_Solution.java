/*
QUESTION:
Employee Management System - Enabling Entity Auditing
Enable Spring Data JPA Auditing and add auditing annotations to entities.
*/
import jakarta.persistence.EntityListeners;
import jakarta.persistence.MappedSuperclass;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.context.annotation.Configuration;
import java.time.LocalDateTime;

@Configuration
@EnableJpaAuditing
class AuditingConfig {}

@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
abstract class BuildableEntity {
    @CreatedDate
    private LocalDateTime createdDate;
    @LastModifiedDate
    private LocalDateTime lastModifiedDate;
}
