package src.controller;

import src.model.Alimento;
import src.repository.AlimentoRepository;
import src.service.AlimentoService;
import src.view.AlimentoView;

import java.util.List;

public class AlimentoController {

    private AlimentoView vista;
    private AlimentoRepository repo;
    private AlimentoService service;
    private Runnable onAlimentosActualizados;

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
        cargarTabla();

        vista.getBtnGuardar().addActionListener(e -> guardar());
        vista.getBtnCalcular().addActionListener(e -> calcular());
    }

    private void guardar() {
        try {
            String nombre = vista.getNombreInput();
            if (nombre.isEmpty()) {
                vista.mostrarEstado("Nombre es obligatorio.", new java.awt.Color(255, 200, 200));
                return;
            }

            String soloLetras = nombre.replaceAll("[^\\p{L}]", "");
            if (soloLetras.length() < 3) {
                vista.mostrarEstado("El nombre debe tener 3 letras o más.", new java.awt.Color(255, 200, 200));
                return;
            }

            Double calorias = validarDecimal(vista.getCaloriasInput(), "Calorías");
            if (calorias == null) return;
            if (calorias < 0) {
                vista.mostrarEstado("Calorías no puede ser negativo.", new java.awt.Color(255, 200, 200));
                return;
            }

            Double proteinas = validarDecimal(vista.getProteinasInput(), "Proteínas");
            if (proteinas == null) return;
            if (proteinas < 0) {
                vista.mostrarEstado("Proteínas no puede ser negativo.", new java.awt.Color(255, 200, 200));
                return;
            }

            Double carbohidratos = validarDecimal(vista.getCarbohidratosInput(), "Carbohidratos");
            if (carbohidratos == null) return;
            if (carbohidratos < 0) {
                vista.mostrarEstado("Carbohidratos no puede ser negativo.", new java.awt.Color(255, 200, 200));
                return;
            }

            Alimento a = new Alimento(nombre, calorias, proteinas, carbohidratos);

            repo.guardar(a);
            cargarTabla();
            if (onAlimentosActualizados != null) {
                onAlimentosActualizados.run();
            }
            vista.limpiarCampos();
            vista.mostrarEstado("Alimento guardado correctamente.", new java.awt.Color(200, 255, 200));

        } catch (Exception e) {
            vista.mostrarEstado("Error: " + e.getMessage(), new java.awt.Color(255, 200, 200));
        }
    }

    private void cargarTabla() {
        List<Alimento> lista = repo.listar();
        vista.cargarTabla(lista);
    }

    private void calcular() {
        try {
            Alimento seleccionado = vista.getAlimentoSeleccionado();

            Double gramos = validarDecimal(vista.getGramosInput(), "Gramos");
            if (gramos == null) return;
            if (gramos <= 0) {
                vista.mostrarEstado("Gramos debe ser mayor a 0.", new java.awt.Color(255, 200, 200));
                return;
            }

            double resultado = service.calcularCaloriasTotales(seleccionado, gramos);

            vista.mostrarEstado("Calorías por porción: " + String.format("%.2f", resultado), new java.awt.Color(220, 240, 255));
            vista.limpiarCampos();

        } catch (Exception e) {
            vista.mostrarEstado("Error: " + e.getMessage(), new java.awt.Color(255, 200, 200));
        }
    }

    private Double validarDecimal(String valor, String campo) {
        if (valor == null || valor.trim().isEmpty()) {
            vista.mostrarEstado(campo + " es obligatorio.", new java.awt.Color(255, 200, 200));
            return null;
        }
        try {
            String normalized = valor.trim().replace(',', '.');
            return Double.parseDouble(normalized);
        } catch (NumberFormatException e) {
            vista.mostrarEstado(campo + " inválido.", new java.awt.Color(255, 200, 200));
            return null;
        }
    }
}