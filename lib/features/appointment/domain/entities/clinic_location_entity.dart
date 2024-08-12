import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ClinicLocationEntity extends Equatable {
  final String? id;
  final String? name;
  final String? address;
  final String? phone;
  final TimeOfDay? openingTime;
  final TimeOfDay? closingTime;

  const ClinicLocationEntity({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.openingTime,
    this.closingTime,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        phone,
        openingTime,
        closingTime,
      ];
}
