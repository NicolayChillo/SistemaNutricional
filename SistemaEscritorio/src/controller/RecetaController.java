package src.controller;

import src.model.Alimento;
import src.model.AporteNutricional;
import src.model.IngredienteReceta;
import src.model.Receta;
import src.repository.AlimentoRepository;
import src.repository.RecetaRepository;
import src.service.NutricionService;
import src.view.RecetaView;

import java.awt.Color;
import java.util.ArrayList;
import java.util.List;

public class RecetaController {

    private final RecetaView vista;
    private final AlimentoRepository alimentoRepository;
    private final RecetaRepository recetaRepository;
    private final NutricionService nutricionService;

    private final List<IngredienteReceta> ingredientesTemporales = new ArrayList<>();

    public RecetaController(RecetaView vista) {
        this.vista = vista;
        this.alimentoRepository = new AlimentoRepository();
        this.recetaRepository = new RecetaRepository();
        this.nutricionService = new NutricionService();

        init();
    }

    private void init() {
        cargarAlimentos();
        refrescarVistaReceta();

        vista.getBtnAgregarIngrediente().addActionListener(e -> agregarIngredienteTemporal());
        vista.getBtnQuitarIngrediente().addActionListener(e -> quitarIngredienteTemporal());
        vista.getBtnFinalizarReceta().addActionListener(e -> finalizarReceta());
    }

    private void cargarAlimentos() {
        List<Alimento> alimentos = alimentoRepository.listar();
        vista.cargarAlimentosCombo(alimentos);
    }

    public void refrescarAlimentosDisponibles() {
        cargarAlimentos();
    }

    private void agregarIngredienteTemporal() {
        try {
            Alimento alimento = vista.getAlimentoSeleccionado();
            if (alimento == null) {
                vista.mostrarEstado("Ingrediente es obligatorio. Registre alimentos si no hay opciones.", new Color(255, 210, 210));
                return;
            }

            Double gramos = validarDecimal(vista.getCantidadGramosInput(), "Cantidad (g)");
            if (gramos == null) {
                return;
            }
            if (gramos <= 0) {
                vista.mostrarEstado("Cantidad (g) debe ser mayor a 0.", new Color(255, 210, 210));
                return;
            }

            agregarOMergearIngrediente(alimento, gramos);
            vista.limpiarCantidadInput();
            refrescarVistaReceta();
            vista.mostrarEstado("Ingrediente añadido a la receta temporal.", new Color(210, 245, 220));
        } catch (Exception e) {
            vista.mostrarEstado("Error: " + e.getMessage(), new Color(255, 210, 210));
        }
    }

    private void agregarOMergearIngrediente(Alimento alimento, double gramos) {
        for (int i = 0; i < ingredientesTemporales.size(); i++) {
            IngredienteReceta actual = ingredientesTemporales.get(i);
            if (actual.getAlimento().getId() == alimento.getId()) {
                double nuevaCantidad = actual.getCantidadGramos() + gramos;
                ingredientesTemporales.set(i, new IngredienteReceta(alimento, nuevaCantidad));
                return;
            }
        }
        ingredientesTemporales.add(new IngredienteReceta(alimento, gramos));
    }

    private void quitarIngredienteTemporal() {
        int fila = vista.getFilaIngredienteSeleccionada();
        if (fila < 0 || fila >= ingredientesTemporales.size()) {
            vista.mostrarEstado("Seleccione un ingrediente para quitar.", new Color(255, 210, 210));
            return;
        }

        ingredientesTemporales.remove(fila);
        refrescarVistaReceta();
        vista.mostrarEstado("Ingrediente eliminado de la receta temporal.", new Color(230, 240, 255));
    }

    private void finalizarReceta() {
        try {
            String nombrePlato = vista.getNombrePlatoInput();
            if (!validarNombrePlato(nombrePlato)) {
                return;
            }

            if (ingredientesTemporales.isEmpty()) {
                vista.mostrarEstado("Agregue al menos un ingrediente antes de finalizar.", new Color(255, 210, 210));
                return;
            }

            Receta receta = new Receta(nombrePlato);
            for (IngredienteReceta ingrediente : ingredientesTemporales) {
                receta.agregarIngrediente(ingrediente);
            }

            recetaRepository.guardarRecetaConDetalle(receta);
            ingredientesTemporales.clear();
            vista.limpiarFormularioReceta();
            refrescarVistaReceta();
            vista.mostrarEstado("Receta guardada con éxito.", new Color(210, 245, 220));
        } catch (Exception e) {
            vista.mostrarEstado("Error al finalizar receta: " + e.getMessage(), new Color(255, 210, 210));
        }
    }

    private void refrescarVistaReceta() {
        vista.cargarTablaIngredientes(ingredientesTemporales);

        Receta recetaTemporal = new Receta("temporal");
        for (IngredienteReceta i : ingredientesTemporales) {
            recetaTemporal.agregarIngrediente(i);
        }
        AporteNutricional aporte = nutricionService.calcularAporteTotalReceta(recetaTemporal);
        vista.mostrarTotales(aporte);
    }

    private Double validarDecimal(String valor, String campo) {
        if (valor == null || valor.trim().isEmpty()) {
            vista.mostrarEstado(campo + " es obligatorio.", new Color(255, 210, 210));
            return null;
        }
        try {
            String normalized = valor.trim().replace(',', '.');
            return Double.parseDouble(normalized);
        } catch (NumberFormatException e) {
            vista.mostrarEstado(campo + " inválido.", new Color(255, 210, 210));
            return null;
        }
    }

    private boolean validarNombrePlato(String nombrePlato) {
        if (nombrePlato == null || nombrePlato.trim().isEmpty()) {
            vista.mostrarEstado("Nombre del plato es obligatorio.", new Color(255, 210, 210));
            return false;
        }

        String soloLetras = nombrePlato.trim().replaceAll("[^\\p{L}]", "");
        if (soloLetras.length() < 3) {
            vista.mostrarEstado("El nombre del plato debe tener mínimo 3 letras.", new Color(255, 210, 210));
            return false;
        }

        return true;
    }
}
