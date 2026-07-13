/*
QUESTION:
Employee Management System - Customizing Data Source Configuration
Configure multiple data sources or customize default dataSource bean.
*/
import javax.sql.DataSource;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CustomizingDataSourceConfiguration_Solution {
    @Bean
    public DataSource dataSource() {
        return DataSourceBuilder.create()
                .url("jdbc:h2:mem:customdb")
                .driverClassName("org.h2.Driver")
                .username("sa")
                .password("password")
                .build();
    }
}
