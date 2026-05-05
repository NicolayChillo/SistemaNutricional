package src.model;

public class AporteNutricional {
    private final double calorias;
    private final double proteinas;
    private final double carbohidratos;

    public AporteNutricional(double calorias, double proteinas, double carbohidratos) {
        this.calorias = calorias;
        this.proteinas = proteinas;
        this.carbohidratos = carbohidratos;
    }

    public double getCalorias() { return calorias; }
    public double getProteinas() { return proteinas; }
    public double getCarbohidratos() { return carbohidratos; }
}
