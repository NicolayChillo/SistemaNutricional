package src.view;
import src.model.*;
import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumnModel;
import java.awt.*;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import javax.swing.ListSelectionModel;
public class RecetaView extends JPanel {
    private static final String PLACEHOLDER_BUSCAR = "Buscar ingrediente...";
    private JTextField txtNombrePlato, txtBuscarIngrediente, txtCantidadGramos, txtBuscarReceta;
    private JComboBox<Alimento> cmbAlimentos;
    private JButton btnAgregarIngrediente, btnQuitarIngrediente, btnFinalizarReceta, btnCargarReceta, btnEditarReceta, btnEliminarReceta;
    private JTable tablaIngredientes, tablaRecetas;
    private DefaultTableModel modeloIngredientes, modeloRecetas;
    private JLabel lblTotales, lblStatus;
    private List<Alimento> alimentosDisponibles = new ArrayList<>();
    private List<Receta> recetasDisponibles = new ArrayList<>();
    private boolean actualizandoFiltro = false;
    private boolean modoEdicionReceta = false;
    private DecimalFormat df = new DecimalFormat("#.##");
    private static final String PLACEHOLDER_BUSCAR_RECETA = "Buscar receta...";
    public RecetaView() {
        setLayout(new BorderLayout(12, 12));
        setBackground(UIStyle.BACKGROUND);
        JPanel content = new JPanel(new GridBagLayout());
        content.setOpaque(false);
        GridBagConstraints c = new GridBagConstraints();
        c.insets = new Insets(0, 0, 10, 0);
        c.fill = GridBagConstraints.BOTH;
        c.weightx = 1.0;
        JPanel panelDatos = crearPanelDatosPlato();
        c.gridx = 0;
        c.gridy = 0;
        c.weighty = 0.0;
        content.add(panelDatos, c);
        JPanel panelConstructor = crearPanelConstructor();
        c.gridy = 1;
        c.weighty = 0.65;
        content.add(panelConstructor, c);
        JPanel panelRecetas = crearPanelRecetasGuardadas();
        c.gridy = 2;
        c.weighty = 0.35;
        c.insets = new Insets(0, 0, 0, 0);
        content.add(panelRecetas, c);
        JScrollPane scrollContenido = new JScrollPane(
                content,
                JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED,
                JScrollPane.HORIZONTAL_SCROLLBAR_NEVER
        );
        scrollContenido.setBorder(null);
        scrollContenido.getVerticalScrollBar().setUnitIncrement(16);
        add(scrollContenido, BorderLayout.CENTER);
        // ============ PANEL INFERIOR: ESTADO ============
        lblStatus = new JLabel(" ");
        lblStatus.setFont(UIStyle.FONT);
        lblStatus.setOpaque(true);
        lblStatus.setBackground(UIStyle.BACKGROUND);
        lblStatus.setBorder(BorderFactory.createEmptyBorder(8, 8, 8, 8));
        add(lblStatus, BorderLayout.SOUTH);
    }
    private JPanel crearPanelDatosPlato() {
        JPanel panel = new JPanel(new GridBagLayout());
        panel.setOpaque(false);
        panel.setBorder(titledBorder("Datos del Plato"));
        GridBagConstraints c = new GridBagConstraints();
        c.insets = new Insets(4, 8, 4, 8);
        c.fill = GridBagConstraints.HORIZONTAL;
        c.weightx = 1.0;
        c.gridx = 0; c.gridy = 0;
        panel.add(UIStyle.fieldLabel("Nombre del Plato"), c);
        txtNombrePlato = new JTextField();
        UIStyle.styleField(txtNombrePlato);
        c.gridx = 1;
        panel.add(txtNombrePlato, c);
        return panel;
    }
    private JPanel crearPanelConstructor() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setOpaque(false);
        panel.setBorder(titledBorder("Añadir Ingredientes"));
        panel.setMinimumSize(new Dimension(0, 0));
        panel.setPreferredSize(new Dimension(900, 340));
        JPanel formulario = new JPanel(new GridBagLayout());
        formulario.setOpaque(false);
        GridBagConstraints c = new GridBagConstraints();
        c.insets = new Insets(4, 8, 4, 8);
        c.fill = GridBagConstraints.HORIZONTAL;
        c.gridx = 0; c.gridy = 0;
        c.weightx = 0;
        formulario.add(UIStyle.fieldLabel("Buscar Ingrediente"), c);
        txtBuscarIngrediente = new JTextField(20);
        UIStyle.styleField(txtBuscarIngrediente);
        txtBuscarIngrediente.setToolTipText("Escribe para filtrar ingredientes disponibles");
        txtBuscarIngrediente.setColumns(20);
        txtBuscarIngrediente.setEditable(true);
        txtBuscarIngrediente.setEnabled(true);
        c.gridx = 1;
        c.weightx = 1.0;
        formulario.add(txtBuscarIngrediente, c);
        c.gridx = 0; c.gridy = 1;
        c.weightx = 0;
        formulario.add(UIStyle.fieldLabel("Ingrediente Seleccionado"), c);
        cmbAlimentos = new JComboBox<>();
        cmbAlimentos.setMaximumRowCount(8);
        c.gridx = 1;
        c.weightx = 1.0;
        formulario.add(cmbAlimentos, c);
        c.gridx = 0; c.gridy = 2;
        c.weightx = 0;
        formulario.add(UIStyle.fieldLabel("Cantidad en Gramos"), c);
        txtCantidadGramos = new JTextField(20);
        UIStyle.styleField(txtCantidadGramos);
        txtCantidadGramos.setColumns(20);
        txtCantidadGramos.setEditable(true);
        txtCantidadGramos.setEnabled(true);
        c.gridx = 1;
        c.weightx = 1.0;
        formulario.add(txtCantidadGramos, c);
        panel.add(formulario, BorderLayout.NORTH);
        modeloIngredientes = new DefaultTableModel(new String[]{"Ingrediente", "Gramos", "Cal", "Prot", "Carb"}, 0) {
            public boolean isCellEditable(int r, int c) { return false; }
        };
        tablaIngredientes = new JTable(modeloIngredientes);
        tablaIngredientes.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        tablaIngredientes.setRowSelectionAllowed(true);
        tablaIngredientes.setColumnSelectionAllowed(false);
        tablaIngredientes.setAutoResizeMode(JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
        UIStyle.styleTable(tablaIngredientes);
        configurarColumnasTablaIngredientes();
        JScrollPane scrollIngredientes = new JScrollPane(tablaIngredientes);
        scrollIngredientes.setMinimumSize(new Dimension(0, 0));
        scrollIngredientes.setPreferredSize(new Dimension(900, 200));
        panel.add(scrollIngredientes, BorderLayout.CENTER);
        // --- ROW 3: Botones ---
        btnAgregarIngrediente = new JButton("Añadir Ingrediente");
        btnQuitarIngrediente = new JButton("Quitar");
        btnFinalizarReceta = new JButton("Finalizar Receta");
        UIStyle.styleButton(btnAgregarIngrediente, UIStyle.SUCCESS);
        UIStyle.styleButton(btnQuitarIngrediente, UIStyle.DANGER);
        UIStyle.styleButton(btnFinalizarReceta, UIStyle.PRIMARY);
        JPanel botonesPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 8, 0));
        botonesPanel.setOpaque(false);
        botonesPanel.add(btnAgregarIngrediente);
        botonesPanel.add(btnQuitarIngrediente);
        botonesPanel.add(btnFinalizarReceta);
        JPanel pie = new JPanel(new BorderLayout(8, 8));
        pie.setOpaque(false);
        lblTotales = new JLabel("Totales: 0.00 kcal - Proteina: 0.00 g - Carbohidratos: 0.00 g");
        lblTotales.setFont(UIStyle.FONT_BOLD);
        lblTotales.setForeground(UIStyle.PRIMARY);
        pie.add(lblTotales, BorderLayout.WEST);
        pie.add(botonesPanel, BorderLayout.EAST);
        panel.add(pie, BorderLayout.SOUTH);
        installBuscarIngredienteListeners();
        return panel;
    }
    private JPanel crearPanelRecetasGuardadas() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setOpaque(false);
        panel.setPreferredSize(new Dimension(900, 200));
        panel.setBorder(titledBorder("Recetas Guardadas"));
        panel.setMinimumSize(new Dimension(0, 0));
        // Panel con buscador
        JPanel busquedaPanel = new JPanel(new GridBagLayout());
        busquedaPanel.setOpaque(false);
        GridBagConstraints bc = new GridBagConstraints();
        bc.insets = new Insets(0, 0, 8, 0);
        bc.fill = GridBagConstraints.HORIZONTAL;
        bc.weightx = 1.0;
        bc.gridx = 0; bc.gridy = 0;
        busquedaPanel.add(UIStyle.fieldLabel("Buscar"), bc);
        txtBuscarReceta = new JTextField();
        UIStyle.styleField(txtBuscarReceta);
        txtBuscarReceta.setColumns(20);
        txtBuscarReceta.setEditable(true);
        txtBuscarReceta.setEnabled(true);
        bc.gridx = 1;
        busquedaPanel.add(txtBuscarReceta, bc);
        panel.add(busquedaPanel, BorderLayout.NORTH);
        modeloRecetas = new DefaultTableModel(new String[]{"ID", "Nombre Receta"}, 0) {
            public boolean isCellEditable(int r, int c) { return false; }
        };
        tablaRecetas = new JTable(modeloRecetas);
        tablaRecetas.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        tablaRecetas.setRowSelectionAllowed(true);
        tablaRecetas.setColumnSelectionAllowed(false);
        UIStyle.styleTable(tablaRecetas);
        JScrollPane scrollRecetas = new JScrollPane(tablaRecetas);
        scrollRecetas.setMinimumSize(new Dimension(0, 0));
        scrollRecetas.setPreferredSize(new Dimension(900, 100));
        panel.add(scrollRecetas, BorderLayout.CENTER);
        JPanel botonesRecetas = new JPanel(new FlowLayout(FlowLayout.RIGHT, 8, 8));
        botonesRecetas.setOpaque(false);
        btnCargarReceta = new JButton("Cargar Receta");
        btnEditarReceta = new JButton("Editar");
        btnEliminarReceta = new JButton("Eliminar");
        UIStyle.styleButton(btnCargarReceta, UIStyle.SUCCESS);
        UIStyle.styleButton(btnEditarReceta, UIStyle.PRIMARY);
        UIStyle.styleButton(btnEliminarReceta, UIStyle.DANGER);
        botonesRecetas.add(btnCargarReceta);
        botonesRecetas.add(btnEditarReceta);
        botonesRecetas.add(btnEliminarReceta);
        panel.add(botonesRecetas, BorderLayout.SOUTH);
        installBuscarRecetaListeners();
        return panel;
    }
    private void configurarColumnasTablaIngredientes() {
        TableColumnModel columnas = tablaIngredientes.getColumnModel();
        columnas.getColumn(0).setPreferredWidth(220); // Ingrediente
        columnas.getColumn(1).setPreferredWidth(80);  // Gramos
        columnas.getColumn(2).setPreferredWidth(70);  // Cal
        columnas.getColumn(3).setPreferredWidth(70);  // Prot
        columnas.getColumn(4).setPreferredWidth(70);  // Carb
    }
    private TitledBorder titledBorder(String title) {
        return BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(new Color(220, 220, 220)),
                title,
                TitledBorder.LEFT,
                TitledBorder.TOP,
                UIStyle.FONT_BOLD,
                UIStyle.TEXT
        );
    }
    private void installBuscarIngredienteListeners() {
    }
    private void installBuscarRecetaListeners() {
        txtBuscarReceta.getDocument().addDocumentListener(new javax.swing.event.DocumentListener() {
            @Override
            public void insertUpdate(javax.swing.event.DocumentEvent e) {
                actualizarFiltroRecetas(getTextoBusquedaReceta());
            }
            @Override
            public void removeUpdate(javax.swing.event.DocumentEvent e) {
                actualizarFiltroRecetas(getTextoBusquedaReceta());
            }
            @Override
            public void changedUpdate(javax.swing.event.DocumentEvent e) {
                actualizarFiltroRecetas(getTextoBusquedaReceta());
            }
        });
    }
    public void cargarAlimentosCombo(List<Alimento> alimentos) {
        alimentosDisponibles = alimentos == null ? new ArrayList<>() : new ArrayList<>(alimentos);
        actualizarFiltroIngredientes(getTextoBusquedaIngrediente());
    }
    public void cargarTablaIngredientes(List<IngredienteReceta> ingredientes) {
        modeloIngredientes.setRowCount(0);
        if (ingredientes != null) {
            for (IngredienteReceta i : ingredientes) {
                try {
                    double f = i.getCantidadGramos() / 100.0;
                    modeloIngredientes.addRow(new Object[]{
                            i.getAlimento().getNombre(),
                            df.format(i.getCantidadGramos()),
                            df.format(i.getAlimento().getCalorias() * f),
                            df.format(i.getAlimento().getProteinas() * f),
                            df.format(i.getAlimento().getCarbohidratos() * f)
                    });
                } catch (Exception e) {
                    System.err.println("Error cargando ingrediente: " + e.getMessage());
                }
            }
        }
    }
    public void cargarTablaRecetas(List<Receta> recetas) {
        recetasDisponibles = recetas == null ? new ArrayList<>() : new ArrayList<>(recetas);
        actualizarFiltroRecetas(getTextoBusquedaReceta());
    }
    public void actualizarFiltroRecetas(String textoFiltro) {
        modeloRecetas.setRowCount(0);
        if (recetasDisponibles != null) {
            String filtro = textoFiltro == null ? "" : textoFiltro.trim().toLowerCase();
            for (Receta r : recetasDisponibles) {
                if (filtro.isEmpty() || r.getNombrePlato().toLowerCase().contains(filtro)) {
                    modeloRecetas.addRow(new Object[]{
                            r.getId(),
                            r.getNombrePlato()
                    });
                }
            }
        }
    }
    public String getTextoBusquedaReceta() {
        if (txtBuscarReceta == null) {
            return "";
        }
        String texto = txtBuscarReceta.getText().trim();
        return PLACEHOLDER_BUSCAR_RECETA.equals(texto) ? "" : texto;
    }
    public void limpiarBusquedaReceta() {
        if (txtBuscarReceta != null) {
            txtBuscarReceta.setText(PLACEHOLDER_BUSCAR_RECETA);
            txtBuscarReceta.setForeground(Color.GRAY);
        }
    }
    public void mostrarTotales(AporteNutricional aporte) {
        if (aporte != null) {
            lblTotales.setText(String.format(
                    "Totales: %.2f kcal - Proteina: %.2f g - Carbohidratos: %.2f g",
                    aporte.getCalorias(),
                    aporte.getProteinas(),
                    aporte.getCarbohidratos()
            ));
        } else {
            lblTotales.setText("Totales: 0.00 kcal - Proteina: 0.00 g - Carbohidratos: 0.00 g");
        }
    }
    // ============ GETTERS ============
    public JButton getBtnAgregarIngrediente() { return btnAgregarIngrediente; }
    public JButton getBtnQuitarIngrediente() { return btnQuitarIngrediente; }
    public JButton getBtnFinalizarReceta() { return btnFinalizarReceta; }
    public JButton getBtnCargarReceta() { return btnCargarReceta; }
    public JButton getBtnEditarReceta() { return btnEditarReceta; }
    public JButton getBtnEliminarReceta() { return btnEliminarReceta; }
    public String getNombrePlatoInput() { return txtNombrePlato.getText().trim(); }
    public JTextField getTxtBuscarIngrediente() { return txtBuscarIngrediente; }
    public String getTextoBusquedaIngrediente() {
        if (txtBuscarIngrediente == null) {
            return "";
        }
        return txtBuscarIngrediente.getText().trim();
    }
    public String getCantidadGramosInput() { return txtCantidadGramos.getText().trim(); }
    public int getFilaIngredienteSeleccionada() { return tablaIngredientes.getSelectedRow(); }
    public int getFilaRecetaSeleccionada() { 
        return tablaRecetas.getSelectedRow();
    }
    public Integer getIdRecetaSeleccionada() {
        int fila = getFilaRecetaSeleccionada();
        if (fila < 0) return null;
        try {
            Object idObj = modeloRecetas.getValueAt(fila, 0);
            return (idObj instanceof Number) ? ((Number) idObj).intValue() : Integer.parseInt(idObj.toString());
        } catch (Exception e) {
            return null;
        }
    }
    public Alimento getAlimentoSeleccionado() {
        Object item = cmbAlimentos.getSelectedItem();
        return (item instanceof Alimento) ? (Alimento) item : null;
    }
    public void actualizarFiltroIngredientes(String textoFiltro) {
        actualizandoFiltro = true;
        try {
            String filtro = textoFiltro == null ? "" : textoFiltro.trim().toLowerCase();
            List<Alimento> filtrados = alimentosDisponibles.stream()
                    .filter(a -> filtro.isEmpty() || a.getNombre().toLowerCase().contains(filtro))
                    .collect(Collectors.toList());
            DefaultComboBoxModel<Alimento> model = new DefaultComboBoxModel<>();
            for (Alimento a : filtrados) {
                model.addElement(a);
            }
            cmbAlimentos.setModel(model);
            if (model.getSize() > 0) {
                cmbAlimentos.setSelectedIndex(0);
            }
        } finally {
            actualizandoFiltro = false;
        }
    }
    public void limpiarBusquedaIngrediente() {
        if (txtBuscarIngrediente != null) {
            txtBuscarIngrediente.setText(PLACEHOLDER_BUSCAR);
            txtBuscarIngrediente.setForeground(Color.GRAY);
        }
    }
    public boolean isActualizandoFiltro() {
        return actualizandoFiltro;
    }
    // ============ ESTADO ============
    public void mostrarEstado(String mensaje, Color color) {
        lblStatus.setText(mensaje);
        lblStatus.setBackground(color);
        lblStatus.setOpaque(true);
        Timer t = new Timer(4000, e -> limpiarEstado());
        t.setRepeats(false);
        t.start();
    }
    public void limpiarEstado() {
        lblStatus.setText(" ");
        lblStatus.setOpaque(false);
    }
    public void limpiarCantidadInput() {
        txtCantidadGramos.setText("");
        txtCantidadGramos.requestFocus();
    }
    public void limpiarCamposConstructor() {
        limpiarFormularioReceta();
        limpiarBusquedaIngrediente();
        actualizarFiltroIngredientes("");
    }
    public void limpiarFormularioReceta() {
        txtNombrePlato.setText("");
        txtCantidadGramos.setText("");
        txtNombrePlato.requestFocus();
        limpiarEstado();
    }
    public void establecerNombrePlato(String nombre) {
        txtNombrePlato.setText(nombre);
    }
    public void setCamposRecetaEditables(boolean editables) {
        txtNombrePlato.setEditable(true);
        txtNombrePlato.setEnabled(true);
        txtNombrePlato.setFocusable(true);
        txtBuscarIngrediente.setEditable(true);
        txtBuscarIngrediente.setEnabled(true);
        txtBuscarIngrediente.setFocusable(true);
        txtCantidadGramos.setEditable(true);
        txtCantidadGramos.setEnabled(true);
        txtCantidadGramos.setFocusable(true);
        if (txtBuscarReceta != null) {
            txtBuscarReceta.setEditable(true);
            txtBuscarReceta.setEnabled(true);
            txtBuscarReceta.setFocusable(true);
        }
        cmbAlimentos.setEnabled(editables);
        btnAgregarIngrediente.setEnabled(editables);
        btnQuitarIngrediente.setEnabled(editables);
        btnFinalizarReceta.setEnabled(editables);
    }
    public void setModoEdicionReceta(boolean activo) {
        modoEdicionReceta = activo;
        btnEditarReceta.setText(activo ? "Cancelar edicion" : "Editar");
        setCamposRecetaEditables(activo);
    }
    public boolean isModoEdicionReceta() {
        return modoEdicionReceta;
    }
}