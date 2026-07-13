/*
QUESTION:
Employee Management System - Hibernate-Specific Features
Implement dynamic insert and soft delete annotations on entities.
*/
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.Where;

@Entity
@DynamicInsert
@SQLDelete(sql = "UPDATE product SET deleted = true WHERE id=?")
@Where(clause = "deleted=false")
public class HibernateSpecificFeatures_Solution {
    @Id
    private Long id;
    private String name;
    private boolean deleted = Boolean.FALSE;
}
