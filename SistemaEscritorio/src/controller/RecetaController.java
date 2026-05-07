package src.controller;
import src.model.Alimento;
import src.model.AporteNutricional;
import src.model.IngredienteReceta;
import src.model.Receta;
import src.repository.AlimentoRepository;
import src.repository.RecetaRepository;
import src.service.NutricionService;
import src.util.ExceptionHandler;
import src.util.InputValidator;
import src.view.RecetaView;
import javax.swing.*;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;
public class RecetaController {
    private final RecetaView vista;
    private final AlimentoRepository alimentoRepository;
    private final RecetaRepository recetaRepository;
    private final NutricionService nutricionService;
    private final List<IngredienteReceta> ingredientesTemporales = new ArrayList<>();
    private Integer recetaCargadaId = null;
    public RecetaController(RecetaView vista) {
        this.vista = vista;
        this.alimentoRepository = new AlimentoRepository();
        this.recetaRepository = new RecetaRepository();
        this.nutricionService = new NutricionService();
        init();
    }
    private void init() {
        try {
            cargarAlimentos();
            cargarRecetas();
            refrescarVistaReceta();
            configurarFiltroIngredientes();
            vista.setCamposRecetaEditables(true);
            vista.setModoEdicionReceta(false);
            vista.setCamposRecetaEditables(true);
            vista.getBtnAgregarIngrediente().addActionListener(e -> agregarIngredienteTemporal());
            vista.getBtnQuitarIngrediente().addActionListener(e -> quitarIngredienteTemporal());
            vista.getBtnFinalizarReceta().addActionListener(e -> finalizarRecetaConConfirmacion());
            vista.getBtnCargarReceta().addActionListener(e -> cargarRecetaSeleccionada());
            vista.getBtnEditarReceta().addActionListener(e -> editarReceta());
            vista.getBtnEliminarReceta().addActionListener(e -> eliminarReceta());
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaController.init", e);
            vista.mostrarEstado("Error inicializando controlador.", new Color(255, 200, 200));
        }
    }
    private void agregarIngredienteTemporal() {
        try {
            String nombrePlato = vista.getNombrePlatoInput();
            try {
                InputValidator.validarNombre(nombrePlato);
            } catch (IllegalArgumentException e) {
                vista.mostrarEstado("Nombre invalido: " + e.getMessage(), new Color(255, 200, 200));
                return;
            }
            Alimento alimento = vista.getAlimentoSeleccionado();
            if (alimento == null) {
                vista.mostrarEstado("Selecciona un ingrediente valido o busca uno disponible.", new Color(255, 210, 150));
                return;
            }
            Double gramos;
            try {
                gramos = InputValidator.validarDecimalPositivo(vista.getCantidadGramosInput());
                InputValidator.validarMayorACero(gramos);
            } catch (IllegalArgumentException | IllegalStateException e) {
                vista.mostrarEstado("Cantidad invalida: " + e.getMessage(), new Color(255, 200, 200));
                return;
            }
            agregarOMergearIngrediente(alimento, gramos);
            vista.limpiarCantidadInput();
            refrescarVistaReceta();
            vista.mostrarEstado(
                    String.format("%.0fg de %s anadido(a).", gramos, alimento.getNombre()),
                    new Color(210, 245, 220)
            );
        } catch (NullPointerException e) {
            ExceptionHandler.logException("RecetaController.agregarIngredienteTemporal - NullPointerException", e);
            vista.mostrarEstado("Datos no cargados. Recarga la pagina.", new Color(255, 200, 200));
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaController.agregarIngredienteTemporal", e);
            vista.mostrarEstado("Error: " + ExceptionHandler.obtenerMensajeAmigable(e), new Color(255, 200, 200));
        }
    }
    private void quitarIngredienteTemporal() {
        try {
            int fila = vista.getFilaIngredienteSeleccionada();
            if (fila < 0 || fila >= ingredientesTemporales.size()) {
                vista.mostrarEstado("Selecciona un ingrediente para quitar.", new Color(255, 210, 150));
                return;
            }
            IngredienteReceta ingredienteAQuitar = ingredientesTemporales.get(fila);
            String nombreAlimento = ingredienteAQuitar.getAlimento().getNombre();
            int resultado = JOptionPane.showConfirmDialog(
                    null,
                    "¿Deseas quitar " + nombreAlimento + " de la receta?",
                    "Confirmar eliminación",
                    JOptionPane.YES_NO_OPTION,
                    JOptionPane.WARNING_MESSAGE
            );
            if (resultado == JOptionPane.YES_OPTION) {
                ingredientesTemporales.remove(fila);
                refrescarVistaReceta();
                vista.mostrarEstado(
                        nombreAlimento + " eliminado de la receta.",
                        new Color(230, 240, 255)
                );
            }
        } catch (IndexOutOfBoundsException e) {
            vista.mostrarEstado("Ingrediente no encontrado.", new Color(255, 210, 150));
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaController.quitarIngredienteTemporal", e);
            vista.mostrarEstado("Error: " + ExceptionHandler.obtenerMensajeAmigable(e), new Color(255, 200, 200));
        }
    }
    private void finalizarRecetaConConfirmacion() {
        try {
            String nombrePlato = vista.getNombrePlatoInput();
            try {
                InputValidator.validarNombre(nombrePlato);
            } catch (IllegalArgumentException e) {
                vista.mostrarEstado("Nombre invalido: " + e.getMessage(), new Color(255, 200, 200));
                return;
            }
            if (ingredientesTemporales.isEmpty()) {
                vista.mostrarEstado(
                        "Agrega al menos un ingrediente antes de finalizar.",
                        new Color(255, 210, 150)
                );
                return;
            }
            if (recetaCargadaId == null) {
                if (recetaRepository.existePorNombre(nombrePlato)) {
                    vista.mostrarEstado("Ya existe una receta con ese nombre.", new Color(255, 210, 150));
                    return;
                }
            } else {
                if (recetaRepository.existePorNombreExcluyendoId(nombrePlato, recetaCargadaId)) {
                    vista.mostrarEstado("Ya existe otra receta con ese nombre.", new Color(255, 210, 150));
                    return;
                }
            }
            AporteNutricional aporteActual = calcularAporteTemporal();
            String accion = recetaCargadaId == null ? "Guardar" : "Actualizar";
            int confirmacion = JOptionPane.showConfirmDialog(
                    null,
                    String.format(
                        "%s receta '%s' con %d ingrediente(s)?\nCalorias totales: %.2f kcal",
                            accion,
                            nombrePlato,
                        ingredientesTemporales.size(),
                        aporteActual.getCalorias()
                    ),
                    "Confirmar " + accion.toLowerCase() + " de receta",
                    JOptionPane.YES_NO_OPTION,
                    JOptionPane.INFORMATION_MESSAGE
            );
            if (confirmacion == JOptionPane.YES_OPTION) {
                finalizarReceta(nombrePlato);
            } else {
                vista.mostrarEstado(accion.toLowerCase() + " cancelado.", new Color(220, 240, 255));
            }
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaController.finalizarRecetaConConfirmacion", e);
            vista.mostrarEstado("Error: " + ExceptionHandler.obtenerMensajeAmigable(e), new Color(255, 200, 200));
        }
    }
    private void finalizarReceta(String nombrePlato) {
        try {
            Receta receta = new Receta(nombrePlato);
            for (IngredienteReceta ingrediente : ingredientesTemporales) {
                receta.agregarIngrediente(ingrediente);
            }
            if (recetaCargadaId != null) {
                receta.setId(recetaCargadaId);
                recetaRepository.actualizarConDetalle(receta);
                vista.mostrarEstado("Receta actualizada exitosamente.", new Color(210, 245, 220));
            } else {
                recetaRepository.guardarRecetaConDetalle(receta);
                vista.mostrarEstado("Receta guardada exitosamente.", new Color(210, 245, 220));
            }
            ingredientesTemporales.clear();
            vista.limpiarFormularioReceta();
            refrescarVistaReceta();
            cargarRecetas();
            recetaCargadaId = null;
            vista.setModoEdicionReceta(false);
            vista.setCamposRecetaEditables(true);
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaController.finalizarReceta", e);
            vista.mostrarEstado("Error al guardar: " + ExceptionHandler.obtenerMensajeAmigable(e), new Color(255, 200, 200));
        }
    }
    private void refrescarVistaReceta() {
        try {
            vista.cargarTablaIngredientes(ingredientesTemporales);
            vista.mostrarTotales(calcularAporteTemporal());
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaController.refrescarVistaReceta", e);
            vista.mostrarTotales(new AporteNutricional(0, 0, 0));
        }
    }
    private void cargarAlimentos() {
        try {
            List<Alimento> alimentos = alimentoRepository.listar();
            vista.cargarAlimentosCombo(alimentos);
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaController.cargarAlimentos", e);
            vista.mostrarEstado("Error cargando alimentos.", new Color(255, 210, 150));
            vista.cargarAlimentosCombo(new ArrayList<>());
        }
    }
    public void refrescarAlimentosDisponibles() {
        cargarAlimentos();
    }
    private void configurarFiltroIngredientes() {
        JTextField buscador = vista.getTxtBuscarIngrediente();
        if (buscador == null) {
            return;
        }
        buscador.getDocument().addDocumentListener(new DocumentListener() {
            @Override
            public void insertUpdate(DocumentEvent e) {
                actualizarFiltro();
            }
            @Override
            public void removeUpdate(DocumentEvent e) {
                actualizarFiltro();
            }
            @Override
            public void changedUpdate(DocumentEvent e) {
                actualizarFiltro();
            }
            private void actualizarFiltro() {
                if (vista.isActualizandoFiltro()) {
                    return;
                }
                vista.actualizarFiltroIngredientes(vista.getTextoBusquedaIngrediente());
            }
        });
    }
    private AporteNutricional calcularAporteTemporal() {
        if (ingredientesTemporales.isEmpty()) {
            return new AporteNutricional(0, 0, 0);
        }
        Receta recetaTemporal = new Receta("temporal");
        for (IngredienteReceta i : ingredientesTemporales) {
            recetaTemporal.agregarIngrediente(i);
        }
        return nutricionService.calcularAporteTotalReceta(recetaTemporal);
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
    private void cargarRecetas() {
        try {
            List<Receta> recetas = recetaRepository.listar();
            vista.cargarTablaRecetas(recetas);
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaController.cargarRecetas", e);
            vista.mostrarEstado("Error cargando recetas.", new Color(255, 210, 150));
            vista.cargarTablaRecetas(new ArrayList<>());
        }
    }
    private void cargarRecetaSeleccionada() {
        try {
            Integer idReceta = vista.getIdRecetaSeleccionada();
            if (idReceta == null) {
                vista.mostrarEstado("Selecciona una receta para cargar.", new Color(255, 210, 150));
                return;
            }
            Receta receta = recetaRepository.obtenerPorId(idReceta);
            if (receta == null) {
                vista.mostrarEstado("Receta no encontrada.", new Color(255, 210, 150));
                return;
            }
            // Cargar datos de la receta
            ingredientesTemporales.clear();
            for (IngredienteReceta ing : receta.getIngredientes()) {
                ingredientesTemporales.add(ing);
            }
            recetaCargadaId = idReceta;
            vista.establecerNombrePlato(receta.getNombrePlato());
            refrescarVistaReceta();
            vista.setModoEdicionReceta(false);
            vista.mostrarEstado("Receta '" + receta.getNombrePlato() + "' cargada en modo visualizacion.", new Color(220, 240, 255));
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaController.cargarRecetaSeleccionada", e);
            vista.mostrarEstado("Error: " + ExceptionHandler.obtenerMensajeAmigable(e), new Color(255, 200, 200));
        }
    }
    private void editarReceta() {
        try {
            if (recetaCargadaId == null) {
                Integer idReceta = vista.getIdRecetaSeleccionada();
                if (idReceta == null) {
                    vista.mostrarEstado("Selecciona y carga una receta para editar.", new Color(255, 210, 150));
                    return;
                }
                cargarRecetaSeleccionada();
            }
            if (vista.isModoEdicionReceta()) {
                vista.setModoEdicionReceta(false);
                if (recetaCargadaId != null) {
                    Receta receta = recetaRepository.obtenerPorId(recetaCargadaId);
                    if (receta != null) {
                        ingredientesTemporales.clear();
                        ingredientesTemporales.addAll(receta.getIngredientes());
                        vista.establecerNombrePlato(receta.getNombrePlato());
                        refrescarVistaReceta();
                    }
                }
                vista.mostrarEstado("Edicion cancelada. Datos restaurados.", new Color(220, 240, 255));
            } else {
                vista.setModoEdicionReceta(true);
                vista.mostrarEstado("Modo edicion activo. Ajusta datos y finaliza para guardar.", new Color(220, 240, 255));
            }
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaController.editarReceta", e);
            vista.mostrarEstado("Error: " + ExceptionHandler.obtenerMensajeAmigable(e), new Color(255, 200, 200));
        }
    }
    private void eliminarReceta() {
        try {
            Integer idReceta = vista.getIdRecetaSeleccionada();
            if (idReceta == null) {
                vista.mostrarEstado("Selecciona una receta para eliminar.", new Color(255, 210, 150));
                return;
            }
            Receta receta = recetaRepository.obtenerPorId(idReceta);
            if (receta == null) {
                vista.mostrarEstado("Receta no encontrada.", new Color(255, 210, 150));
                return;
            }
            int confirmacion = JOptionPane.showConfirmDialog(
                    null,
                    "Deseas eliminar la receta '" + receta.getNombrePlato() + "'?\nEsta accion no se puede deshacer.",
                    "Confirmar eliminacion",
                    JOptionPane.YES_NO_OPTION,
                    JOptionPane.WARNING_MESSAGE
            );
            if (confirmacion == JOptionPane.YES_OPTION) {
                recetaRepository.eliminar(idReceta);
                cargarRecetas();
                vista.mostrarEstado("Receta eliminada correctamente.", new Color(200, 255, 200));
            }
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaController.eliminarReceta", e);
            vista.mostrarEstado("Error: " + ExceptionHandler.obtenerMensajeAmigable(e), new Color(255, 200, 200));
        }
    }
}
