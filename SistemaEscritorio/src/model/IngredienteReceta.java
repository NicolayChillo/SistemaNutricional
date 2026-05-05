package src.model;

public class IngredienteReceta {
    private final Alimento alimento;
    private final double cantidadGramos;

    public IngredienteReceta(Alimento alimento, double cantidadGramos) {
        if (alimento == null) {
            throw new IllegalArgumentException("El alimento no puede ser nulo.");
        }
        if (cantidadGramos <= 0) {
            throw new IllegalArgumentException("La cantidad en gramos debe ser mayor a 0.");
        }
        this.alimento = alimento;
        this.cantidadGramos = cantidadGramos;
    }

    public Alimento getAlimento() { return alimento; }
    public double getCantidadGramos() { return cantidadGramos; }
}
