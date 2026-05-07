package src.service;
import src.model.Alimento;
public class AlimentoService {
    public double calcularCaloriasTotales(Alimento alimento, double gramos) 
            throws IllegalArgumentException, IllegalStateException {
        if (alimento == null) {
            throw new IllegalArgumentException("El alimento no puede ser nulo.");
        }
        if (gramos <= 0) {
            throw new IllegalArgumentException("Los gramos deben ser mayores a 0.");
        }
        double calorias = alimento.getCalorias();
        if (calorias < 0) {
            throw new IllegalArgumentException("Las calorías del alimento no pueden ser negativas.");
        }
        double resultado = (calorias * gramos) / 100.0;
        // Validar que el resultado sea válido
        if (Double.isNaN(resultado) || Double.isInfinite(resultado)) {
            throw new IllegalStateException("El cálculo de calorías resultó en un valor infinito o inválido.");
        }
        if (resultado < 0) {
            throw new IllegalStateException("El resultado de calorías no puede ser negativo.");
        }
        return resultado;
    }
    public double calcularProteinasTotales(Alimento alimento, double gramos) 
            throws IllegalArgumentException, IllegalStateException {
        if (alimento == null) {
            throw new IllegalArgumentException("El alimento no puede ser nulo.");
        }
        if (gramos <= 0) {
            throw new IllegalArgumentException("Los gramos deben ser mayores a 0.");
        }
        double proteinas = alimento.getProteinas();
        if (proteinas < 0) {
            throw new IllegalArgumentException("Las proteínas del alimento no pueden ser negativas.");
        }
        double resultado = (proteinas * gramos) / 100.0;
        if (Double.isNaN(resultado) || Double.isInfinite(resultado)) {
            throw new IllegalStateException("El cálculo de proteínas resultó en un valor infinito o inválido.");
        }
        return resultado;
    }
    public double calcularCarbohidratosTotales(Alimento alimento, double gramos) 
            throws IllegalArgumentException, IllegalStateException {
        if (alimento == null) {
            throw new IllegalArgumentException("El alimento no puede ser nulo.");
        }
        if (gramos <= 0) {
            throw new IllegalArgumentException("Los gramos deben ser mayores a 0.");
        }
        double carbohidratos = alimento.getCarbohidratos();
        if (carbohidratos < 0) {
            throw new IllegalArgumentException("Los carbohidratos del alimento no pueden ser negativos.");
        }
        double resultado = (carbohidratos * gramos) / 100.0;
        if (Double.isNaN(resultado) || Double.isInfinite(resultado)) {
            throw new IllegalStateException("El cálculo de carbohidratos resultó en un valor infinito o inválido.");
        }
        return resultado;
    }
}