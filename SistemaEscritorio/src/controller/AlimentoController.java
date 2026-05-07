package src.controller;
import src.model.Alimento;
import src.repository.AlimentoRepository;
import src.service.AlimentoService;
import src.util.ExceptionHandler;
import src.util.InputValidator;
import src.view.AlimentoView;
import java.awt.*;
import java.util.List;
import javax.swing.ListSelectionModel;
public class AlimentoController {
    private AlimentoView vista;
    private AlimentoRepository repo;
    private AlimentoService service;
    private Runnable onAlimentosActualizados;
    private Integer alimentoEnEdicionId;
    public AlimentoController(AlimentoView vista) {
        this(vista, null);
    }
    public AlimentoController(AlimentoView vista, Runnable onAlimentosActualizados) {
        this.vista = vista;
        this.repo = new AlimentoRepository();
        this.service = new AlimentoService();
        this.onAlimentosActualizados = onAlimentosActualizados;
        init();
    }
    private void init() {
        try {
            cargarTabla();
            configurarSeleccionTabla();
            vista.setCamposEditables(true);
            vista.setModoEdicion(false);
            vista.setModoCalculo(false);
            vista.getBtnGuardar().addActionListener(e -> guardar());
            vista.getBtnCalcular().addActionListener(e -> calcular());
            vista.getBtnEditar().addActionListener(e -> editar());
            vista.getBtnEliminar().addActionListener(e -> eliminar());
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoController.init", e);
            vista.mostrarEstado("Error inicializando controlador.", new Color(255, 200, 200));
        }
    }
    private void guardar() {
        try {
            String nombre = vista.getNombreInput();
            try {
                InputValidator.validarNombre(nombre);
            } catch (IllegalArgumentException e) {
                vista.mostrarEstado("Nombre invalido: " + e.getMessage(), new Color(255, 200, 200));
                return;
            }
            Double calorias;
            try {
                calorias = InputValidator.validarDecimalPositivo(vista.getCaloriasInput());
            } catch (IllegalArgumentException | IllegalStateException e) {
                vista.mostrarEstado("Calorias invalidas: " + e.getMessage(), new Color(255, 200, 200));
                return;
            }
            Double proteinas;
            try {
                proteinas = InputValidator.validarDecimalPositivo(vista.getProteinasInput());
            } catch (IllegalArgumentException | IllegalStateException e) {
                vista.mostrarEstado("Proteinas invalidas: " + e.getMessage(), new Color(255, 200, 200));
                return;
            }
            Double carbohidratos;
            try {
                carbohidratos = InputValidator.validarDecimalPositivo(vista.getCarbohidratosInput());
            } catch (IllegalArgumentException | IllegalStateException e) {
                vista.mostrarEstado("Carbohidratos invalidos: " + e.getMessage(), new Color(255, 200, 200));
                return;
            }
            if (alimentoEnEdicionId != null) {
                if (repo.existePorNombreExcluyendoId(nombre, alimentoEnEdicionId)) {
                    vista.mostrarEstado("Ya existe otro alimento con ese nombre.", new Color(255, 210, 150));
                    return;
                }
                Alimento alimento = new Alimento(alimentoEnEdicionId, nombre, calorias, proteinas, carbohidratos);
                try {
                    repo.actualizar(alimento);
                } catch (IllegalArgumentException e) {
                    vista.mostrarEstado(e.getMessage(), new Color(255, 210, 150));
                    return;
                }
            } else {
                Alimento alimento = new Alimento(nombre, calorias, proteinas, carbohidratos);
                try {
                    repo.guardar(alimento);
                } catch (IllegalArgumentException e) {
                    vista.mostrarEstado(e.getMessage(), new Color(255, 210, 150));
                    return;
                }
            }
            cargarTabla();
            if (onAlimentosActualizados != null) {
                onAlimentosActualizados.run();
            }
            alimentoEnEdicionId = null;
            vista.limpiarCampos();
            vista.setModoEdicion(false);
            vista.mostrarEstado("Alimento guardado correctamente.", new Color(200, 255, 200));
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoController.guardar", e);
            vista.mostrarEstado("Error: " + ExceptionHandler.obtenerMensajeAmigable(e), new Color(255, 200, 200));
        }
    }
    private void calcular() {
        try {
            // 1. VALIDAR ALIMENTO SELECCIONADO
            Alimento seleccionado = vista.getAlimentoSeleccionado();
            if (seleccionado == null) {
                vista.setModoCalculo(false);
                vista.mostrarEstado("Por favor, selecciona un alimento de la tabla.", new Color(255, 210, 150));
                return;
            }
            vista.setModoCalculo(true);
            // 2. VALIDAR GRAMOS
            Double gramos;
            try {
                gramos = InputValidator.validarDecimalPositivo(vista.getGramosInput());
                InputValidator.validarMayorACero(gramos);
            } catch (IllegalArgumentException | IllegalStateException e) {
                vista.mostrarEstado("Gramos invalidos: " + e.getMessage(), new Color(255, 200, 200));
                return;
            }
            // 3. CALCULAR
            double resultado = service.calcularCaloriasTotales(seleccionado, gramos);
            vista.mostrarEstado(
                    String.format("Calorias por %.0fg: %.2f kcal", gramos, resultado),
                    new Color(220, 240, 255)
            );
                vista.limpiarGramos();
        } catch (NullPointerException e) {
            ExceptionHandler.logException("AlimentoController.calcular - NullPointerException", e);
            vista.mostrarEstado("Error: Datos no cargados. Recarga la pagina.", new Color(255, 200, 200));
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoController.calcular", e);
            vista.mostrarEstado("Error: " + ExceptionHandler.obtenerMensajeAmigable(e), new Color(255, 200, 200));
        }
    }
    private void cargarTabla() {
        try {
            List<Alimento> lista = repo.listar();
            vista.cargarTabla(lista);
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoController.cargarTabla", e);
            vista.mostrarEstado("Error cargando tabla: " + ExceptionHandler.obtenerMensajeAmigable(e), new Color(255, 210, 150));
            vista.cargarTabla(new java.util.ArrayList<>());
        }
    }
    private void editar() {
        try {
            Alimento seleccionado = vista.getAlimentoSeleccionado();
            if (seleccionado == null) {
                vista.mostrarEstado("Selecciona un alimento para editar.", new Color(255, 210, 150));
                return;
            }
            if (vista.isModoEdicionActivo() && alimentoEnEdicionId != null && alimentoEnEdicionId == seleccionado.getId()) {
                alimentoEnEdicionId = null;
                vista.setModoEdicion(false);
                vista.getTabla().clearSelection();
                vista.limpiarCampos();
                vista.mostrarCampoGramos(false);
                vista.mostrarEstado("Edicion cancelada.", new Color(220, 240, 255));
                return;
            }
            alimentoEnEdicionId = seleccionado.getId();
            vista.cargarCampos(seleccionado);
            vista.setModoEdicion(true);
            vista.mostrarEstado("Modo edicion activo. Modifica los campos y pulsa Guardar.", new Color(220, 240, 255));
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoController.editar", e);
            vista.mostrarEstado("Error: " + ExceptionHandler.obtenerMensajeAmigable(e), new Color(255, 200, 200));
        }
    }
    private void eliminar() {
        try {
            Alimento seleccionado = vista.getAlimentoSeleccionado();
            if (seleccionado == null) {
                vista.mostrarEstado("Selecciona un alimento para eliminar.", new Color(255, 210, 150));
                return;
            }
            int confirmacion = javax.swing.JOptionPane.showConfirmDialog(
                    null,
                    "Deseas eliminar '" + seleccionado.getNombre() + "'?\nEsta accion no se puede deshacer.",
                    "Confirmar eliminacion",
                    javax.swing.JOptionPane.YES_NO_OPTION,
                    javax.swing.JOptionPane.WARNING_MESSAGE
            );
            if (confirmacion == javax.swing.JOptionPane.YES_OPTION) {
                repo.eliminar(seleccionado.getId());
                cargarTabla();
                if (onAlimentosActualizados != null) {
                    onAlimentosActualizados.run();
                }
                vista.limpiarCampos();
                vista.mostrarEstado("Alimento eliminado correctamente.", new Color(200, 255, 200));
            }
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoController.eliminar", e);
            vista.mostrarEstado("Error: " + ExceptionHandler.obtenerMensajeAmigable(e), new Color(255, 200, 200));
        }
    }
    private void configurarSeleccionTabla() {
        try {
            vista.getTabla().setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
            vista.getTabla().getSelectionModel().addListSelectionListener(event -> {
                if (!event.getValueIsAdjusting()) {
                    Alimento seleccionado = vista.getAlimentoSeleccionado();
                    vista.cargarCampos(seleccionado);
                    if (vista.isModoEdicionActivo()) {
                        vista.setCamposEditables(true);
                        if (vista.isModoEdicionActivo() && seleccionado != null) {
                            alimentoEnEdicionId = seleccionado.getId();
                        }
                    }
                    vista.setModoCalculo(seleccionado != null);
                    if (seleccionado == null) {
                        alimentoEnEdicionId = null;
                    }
                }
            });
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoController.configurarSeleccionTabla", e);
        }
    }
}