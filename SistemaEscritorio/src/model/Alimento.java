package src.model;
public class Alimento {
    private int id;
    private String nombre;
    private double calorias;
    private double proteinas;
    private double carbohidratos;
    public Alimento(int id, String nombre, double calorias, double proteinas, double carbohidratos) {
        this.id = id;
        this.nombre = nombre;
        this.calorias = calorias;
        this.proteinas = proteinas;
        this.carbohidratos = carbohidratos;
    }
    public Alimento(String nombre, double calorias, double proteinas, double carbohidratos) {
        this(0, nombre, calorias, proteinas, carbohidratos);
    }
    public int getId() { return id; }
    public String getNombre() { return nombre; }
    public double getCalorias() { return calorias; }
    public double getProteinas() { return proteinas; }
    public double getCarbohidratos() { return carbohidratos; }
    @Override
    public String toString() {
        return nombre;
    }
}