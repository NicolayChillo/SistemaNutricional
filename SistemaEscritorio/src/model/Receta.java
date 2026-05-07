package src.model;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
public class Receta {
    private int id;
    private String nombrePlato;
    private final List<IngredienteReceta> ingredientes;
    public Receta(String nombrePlato) {
        this(0, nombrePlato, new ArrayList<>());
    }
    public Receta(int id, String nombrePlato, List<IngredienteReceta> ingredientes) {
        this.id = id;
        this.nombrePlato = nombrePlato;
        this.ingredientes = new ArrayList<>(ingredientes);
    }
    public int getId() { return id; }
    public void setId(int id) { 
        this.id = id; 
    }
    public String getNombrePlato() { return nombrePlato; }
    public void setNombrePlato(String nombrePlato) { 
        this.nombrePlato = nombrePlato;
    }
    public List<IngredienteReceta> getIngredientes() {
        return Collections.unmodifiableList(ingredientes);
    }
    public void agregarIngrediente(IngredienteReceta ingrediente) {
        ingredientes.add(ingrediente);
    }
}
