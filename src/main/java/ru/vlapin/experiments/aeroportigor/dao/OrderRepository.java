package ru.vlapin.experiments.aeroportigor.dao;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import ru.vlapin.experiments.aeroportigor.model.AirlineOrder;

@RepositoryRestResource
public interface OrderRepository extends JpaRepository<AirlineOrder, UUID> {
}
