package ru.vlapin.experiments.aeroportigor;

import static com.jayway.jsonpath.JsonPath.parse;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.springframework.hateoas.MediaTypes.HAL_JSON_UTF8_VALUE;
import static org.springframework.hateoas.MediaTypes.HAL_JSON_VALUE;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import ru.vlapin.experiments.aeroportigor.dao.OrderRepository;
import ru.vlapin.experiments.aeroportigor.model.AirlineOrder;

@SpringBootTest
@AutoConfigureMockMvc
@RequiredArgsConstructor(onConstructor_ = @Autowired)
//@org.springframework.security.test.context.support.WithMockUser(authorities = "ADMIN")
class AeroportIgorApplicationTests {

  MockMvc mockMvc;

  OrderRepository orderRepository;

  @BeforeEach
  void setUp() {
    orderRepository.save(
        new AirlineOrder("Аэрофлот",
            LocalDateTime.parse("2019-12-12T15:33:55"),
            "SVO",
            "Boeing-747",
            true)
    );
  }

  @Test
  void contextLoads() {
  }

  @SneakyThrows
  @Test
  @DisplayName("restApiAvailable")
  void restApiAvailableTest() {
    mockMvc.perform(get("/airlineOrders"))
        .andExpect(status().isOk())
        .andExpect(content().contentType(HAL_JSON_UTF8_VALUE))
        .andExpect(mvcResult -> assertEquals(1,
            parse(mvcResult.getResponse().getContentAsString())
                .<Integer>read("$.page.totalElements").intValue()));
  }
}
