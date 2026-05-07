package src.service;
import src.model.AporteNutricional;
import src.model.IngredienteReceta;
import src.model.Receta;
public class NutricionService {
    public AporteNutricional calcularAporteTotalReceta(Receta receta) throws IllegalArgumentException {
        if (receta == null) {
            throw new IllegalArgumentException("La receta no puede ser nula.");
        }
        double totalCalorias = 0;
        double totalProteinas = 0;
        double totalCarbohidratos = 0;
        for (IngredienteReceta ingrediente : receta.getIngredientes()) {
            try {
                // Validar que el alimento exista
                if (ingrediente.getAlimento() == null) {
                    throw new IllegalArgumentException("Ingrediente con alimento nulo encontrado.");
                }
                // Calcular factor: gramos / 100
                double factor = ingrediente.getCantidadGramos() / 100.0;
                // Validar que el factor sea válido
                if (Double.isNaN(factor) || Double.isInfinite(factor)) {
                    throw new IllegalStateException(
                            "Cálculo de factor resultó en infinito para: " + ingrediente.getAlimento().getNombre()
                    );
                }
                // Calcular aportes parciales
                double calorias = ingrediente.getAlimento().getCalorias() * factor;
                double proteinas = ingrediente.getAlimento().getProteinas() * factor;
                double carbohidratos = ingrediente.getAlimento().getCarbohidratos() * factor;
                // Validar que no haya valores inválidos
                if (Double.isNaN(calorias) || Double.isInfinite(calorias) || calorias < 0) {
                    throw new IllegalStateException("Cálculo de calorías inválido.");
                }
                if (Double.isNaN(proteinas) || Double.isInfinite(proteinas) || proteinas < 0) {
                    throw new IllegalStateException("Cálculo de proteínas inválido.");
                }
                if (Double.isNaN(carbohidratos) || Double.isInfinite(carbohidratos) || carbohidratos < 0) {
                    throw new IllegalStateException("Cálculo de carbohidratos inválido.");
                }
                totalCalorias += calorias;
                totalProteinas += proteinas;
                totalCarbohidratos += carbohidratos;
            } catch (NullPointerException e) {
                throw new IllegalArgumentException("Error procesando ingrediente: " + e.getMessage());
            }
        }
        // Validación final
        if (Double.isNaN(totalCalorias) || Double.isInfinite(totalCalorias) || totalCalorias < 0) {
            throw new IllegalStateException("Resultado final de calorías inválido.");
        }
        if (Double.isNaN(totalProteinas) || Double.isInfinite(totalProteinas) || totalProteinas < 0) {
            throw new IllegalStateException("Resultado final de proteínas inválido.");
        }
        if (Double.isNaN(totalCarbohidratos) || Double.isInfinite(totalCarbohidratos) || totalCarbohidratos < 0) {
            throw new IllegalStateException("Resultado final de carbohidratos inválido.");
        }
        return new AporteNutricional(totalCalorias, totalProteinas, totalCarbohidratos);
    }
    public AporteNutricional calcularAportePorcion(double calorias, double proteinas, double carbohidratos, double gramos)
            throws IllegalArgumentException {
        if (gramos <= 0) {
            throw new IllegalArgumentException("Los gramos deben ser mayores a 0.");
        }
        if (calorias < 0 || proteinas < 0 || carbohidratos < 0) {
            throw new IllegalArgumentException("Los valores nutricionales no pueden ser negativos.");
        }
        double factor = gramos / 100.0;
        double aporteCalorias = calorias * factor;
        double aporteProt = proteinas * factor;
        double aporteCarbs = carbohidratos * factor;
        // Validar resultados
        if (Double.isNaN(aporteCalorias) || Double.isInfinite(aporteCalorias) ||
                Double.isNaN(aporteProt) || Double.isInfinite(aporteProt) ||
                Double.isNaN(aporteCarbs) || Double.isInfinite(aporteCarbs)) {
            throw new IllegalStateException("Cálculo de aporte resultó en valores inválidos.");
        }
        return new AporteNutricional(aporteCalorias, aporteProt, aporteCarbs);
    }
}
