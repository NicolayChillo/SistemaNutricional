package src.service;

import src.model.Alimento;

public class AlimentoService {

    // Regla de tres: (calorias * gramos) / 100
    public double calcularCaloriasTotales(Alimento alimento, double gramos) {
        if (gramos <= 0) {
            throw new IllegalArgumentException("Los gramos deben ser mayores a 0");
        }

        return (alimento.getCalorias() * gramos) / 100.0;
    }
}