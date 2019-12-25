package ru.vlapin.experiments.aeroportigor.model;

import io.swagger.annotations.ApiModelProperty;
import java.time.LocalDateTime;
import java.util.UUID;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@Data
@Entity
@NoArgsConstructor
@RequiredArgsConstructor
public class AirlineOrder {

  @Id
  @GeneratedValue
  @EqualsAndHashCode.Exclude
  @ApiModelProperty(hidden = true)
  @Column(updatable = false, nullable = false)
  UUID id;

//  @Version
//  int version;

  @NonNull
  @ApiModelProperty(required = true)
  String airline;

  @NonNull
  @ApiModelProperty(required = true)
  LocalDateTime localDateTime;

  @NonNull
  @ApiModelProperty(required = true)
  String destination;

  //todo 24.12.2019: поменять на справочник
  @NonNull
  @ApiModelProperty(required = true)
  String airplaneType;

  @NonNull
  @ApiModelProperty(required = true)
  boolean isFood;

}
