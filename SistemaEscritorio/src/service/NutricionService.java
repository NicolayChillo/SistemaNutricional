package src.service;

import src.model.AporteNutricional;
import src.model.IngredienteReceta;
import src.model.Receta;

public class NutricionService {

    public AporteNutricional calcularAporteTotalReceta(Receta receta) {
        if (receta == null) {
            throw new IllegalArgumentException("La receta no puede ser nula.");
        }

        double totalCalorias = 0;
        double totalProteinas = 0;
        double totalCarbohidratos = 0;

        for (IngredienteReceta ingrediente : receta.getIngredientes()) {
            double factor = ingrediente.getCantidadGramos() / 100.0;
            totalCalorias += ingrediente.getAlimento().getCalorias() * factor;
            totalProteinas += ingrediente.getAlimento().getProteinas() * factor;
            totalCarbohidratos += ingrediente.getAlimento().getCarbohidratos() * factor;
        }

        return new AporteNutricional(totalCalorias, totalProteinas, totalCarbohidratos);
    }
}
