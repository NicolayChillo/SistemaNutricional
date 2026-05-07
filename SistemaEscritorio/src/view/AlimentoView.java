package src.view;
import src.model.Alimento;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;
public class AlimentoView extends JPanel {
    private JTextField txtNombre, txtCalorias, txtProteinas, txtCarbohidratos, txtGramos;
    private JLabel lblGramos;
    private JButton btnGuardar, btnCalcular, btnEditar, btnEliminar;
    private JTable tabla;
    private DefaultTableModel modelo;
    private JLabel lblStatus;
    private boolean modoEdicionActivo = false;
    public AlimentoView() {
        setLayout(new BorderLayout(12, 12));
        setBackground(UIStyle.BACKGROUND);
        // ============ PANEL SUPERIOR: FORMULARIO ============
        JPanel cardForm = new JPanel(new BorderLayout(10, 10));
        cardForm.setBackground(UIStyle.CARD);
        cardForm.setBorder(UIStyle.cardBorder());
        cardForm.add(UIStyle.titleLabel("Gestión de Alimentos"), BorderLayout.NORTH);
        JPanel formContent = crearFormulario();
        cardForm.add(formContent, BorderLayout.CENTER);
        add(cardForm, BorderLayout.NORTH);
        // ============ PANEL CENTRAL: TABLA ============
        JPanel cardTabla = new JPanel(new BorderLayout(10, 10));
        cardTabla.setBackground(UIStyle.CARD);
        cardTabla.setBorder(UIStyle.cardBorder());
        modelo = new DefaultTableModel(new String[]{"ID", "Nombre", "Cal", "Prot", "Carb"}, 0) {
            public boolean isCellEditable(int r, int c) { return false; }
        };
        tabla = new JTable(modelo);
        tabla.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        tabla.setRowSelectionAllowed(true);
        tabla.setColumnSelectionAllowed(false);
        UIStyle.styleTable(tabla);
        JScrollPane scrollTabla = new JScrollPane(tabla);
        scrollTabla.setPreferredSize(new Dimension(600, 200));
        cardTabla.add(scrollTabla, BorderLayout.CENTER);
        add(cardTabla, BorderLayout.CENTER);
        // ============ PANEL INFERIOR: ESTADO ============
        lblStatus = new JLabel(" ");
        lblStatus.setFont(UIStyle.FONT);
        lblStatus.setOpaque(true);
        lblStatus.setBackground(UIStyle.BACKGROUND);
        lblStatus.setBorder(BorderFactory.createEmptyBorder(8, 8, 8, 8));
        add(lblStatus, BorderLayout.SOUTH);
    }
    private JPanel crearFormulario() {
        JPanel panel = new JPanel(new GridBagLayout());
        panel.setOpaque(false);
        GridBagConstraints c = new GridBagConstraints();
        c.insets = UIStyle.PADDING;
        c.fill = GridBagConstraints.HORIZONTAL;
        c.weightx = 1.0;
        // --- ROW 0: Nombre ---
        c.gridx = 0; c.gridy = 0;
        panel.add(UIStyle.fieldLabel("Nombre"), c);
        txtNombre = new JTextField();
        UIStyle.styleField(txtNombre);
        c.gridx = 1;
        panel.add(txtNombre, c);
        // --- ROW 1: Calorías ---
        c.gridx = 0; c.gridy = 1;
        panel.add(UIStyle.fieldLabel("Calorías (kcal)"), c);
        txtCalorias = new JTextField();
        UIStyle.styleField(txtCalorias);
        c.gridx = 1;
        panel.add(txtCalorias, c);
        // --- ROW 2: Proteínas ---
        c.gridx = 0; c.gridy = 2;
        panel.add(UIStyle.fieldLabel("Proteínas (g)"), c);
        txtProteinas = new JTextField();
        UIStyle.styleField(txtProteinas);
        c.gridx = 1;
        panel.add(txtProteinas, c);
        // --- ROW 3: Carbohidratos ---
        c.gridx = 0; c.gridy = 3;
        panel.add(UIStyle.fieldLabel("Carbohidratos (g)"), c);
        txtCarbohidratos = new JTextField();
        UIStyle.styleField(txtCarbohidratos);
        c.gridx = 1;
        panel.add(txtCarbohidratos, c);
        // --- ROW 4: Gramos ---
        c.gridx = 0; c.gridy = 4;
        lblGramos = UIStyle.fieldLabel("Gramos (calcular)");
        panel.add(lblGramos, c);
        txtGramos = new JTextField();
        UIStyle.styleField(txtGramos);
        c.gridx = 1;
        panel.add(txtGramos, c);
        // --- ROW 5: Botones ---
        btnGuardar = new JButton("Guardar Alimento");
        btnCalcular = new JButton("Calcular Calorias");
        btnEditar = new JButton("Editar");
        btnEliminar = new JButton("Eliminar");
        UIStyle.styleButton(btnGuardar, UIStyle.PRIMARY);
        UIStyle.styleButton(btnCalcular, UIStyle.SUCCESS);
        UIStyle.styleButton(btnEditar, UIStyle.PRIMARY);
        UIStyle.styleButton(btnEliminar, UIStyle.DANGER);
        JPanel botonesPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 8, 0));
        botonesPanel.setOpaque(false);
        botonesPanel.add(btnGuardar);
        botonesPanel.add(btnCalcular);
        botonesPanel.add(btnEditar);
        botonesPanel.add(btnEliminar);
        c.gridx = 0; c.gridy = 5; c.gridwidth = 2;
        c.fill = GridBagConstraints.NONE;
        c.anchor = GridBagConstraints.EAST;
        panel.add(botonesPanel, c);
        mostrarCampoGramos(false);
        setCamposEditables(true);
        setModoEdicion(false);
        setModoCalculo(false);
        return panel;
    }
    public void cargarTabla(List<Alimento> lista) {
        modelo.setRowCount(0);
        if (lista != null) {
            for (Alimento a : lista) {
                modelo.addRow(new Object[]{
                        a.getId(),
                        a.getNombre(),
                        redondear1Decimal(a.getCalorias()),
                        redondear1Decimal(a.getProteinas()),
                        redondear1Decimal(a.getCarbohidratos())
                });
            }
        }
    }
    private Double redondear1Decimal(double valor) {
        return Math.round(valor * 10.0) / 10.0;
    }
    // ============ GETTERS ============
    public JButton getBtnGuardar() { return btnGuardar; }
    public JButton getBtnCalcular() { return btnCalcular; }
    public JButton getBtnEditar() { return btnEditar; }
    public JButton getBtnEliminar() { return btnEliminar; }
    public JTable getTabla() { return tabla; }
    public String getNombreInput() { return txtNombre.getText().trim(); }
    public String getCaloriasInput() { return txtCalorias.getText().trim(); }
    public String getProteinasInput() { return txtProteinas.getText().trim(); }
    public String getCarbohidratosInput() { return txtCarbohidratos.getText().trim(); }
    public String getGramosInput() { return txtGramos.getText().trim(); }
    public Alimento getAlimentoSeleccionado() {
        int r = tabla.getSelectedRow();
        if (r < 0) return null;
        try {
            Object idObj = modelo.getValueAt(r, 0);
            Object nombreObj = modelo.getValueAt(r, 1);
            Object calObj = modelo.getValueAt(r, 2);
            Object protObj = modelo.getValueAt(r, 3);
            Object carbObj = modelo.getValueAt(r, 4);
            int id = (idObj instanceof Number) ? ((Number) idObj).intValue() : Integer.parseInt(idObj.toString());
            double cal = parseDoubleCelda(calObj);
            double prot = parseDoubleCelda(protObj);
            double carb = parseDoubleCelda(carbObj);
            return new Alimento(id, nombreObj.toString(), cal, prot, carb);
        } catch (Exception e) {
            System.err.println("Error al obtener alimento: " + e.getMessage());
            return null;
        }
    }
    private double parseDoubleCelda(Object value) {
        if (value == null) return 0.0;
        if (value instanceof Number) {
            return ((Number) value).doubleValue();
        }
        // Soportar coma decimal si el valor vino como String (por locale)
        String text = value.toString().trim().replace(',', '.');
        return Double.parseDouble(text);
    }
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
    public void limpiarCampos() {
        txtNombre.setText("");
        txtCalorias.setText("");
        txtProteinas.setText("");
        txtCarbohidratos.setText("");
        txtGramos.setText("");
        txtNombre.requestFocus();
        setCamposEditables(true);
        setModoEdicion(false);
    }
    public void cargarCampos(Alimento alimento) {
        if (alimento == null) {
            return;
        }
        txtNombre.setText(alimento.getNombre());
        txtCalorias.setText(String.valueOf(alimento.getCalorias()));
        txtProteinas.setText(String.valueOf(alimento.getProteinas()));
        txtCarbohidratos.setText(String.valueOf(alimento.getCarbohidratos()));
    }
    public void setCamposEditables(boolean editables) {
        txtNombre.setEditable(editables);
        txtCalorias.setEditable(editables);
        txtProteinas.setEditable(editables);
        txtCarbohidratos.setEditable(editables);
    }
    public void setModoEdicion(boolean activo) {
        modoEdicionActivo = activo;
        btnEditar.setText(activo ? "Cancelar edicion" : "Editar");
    }
    public boolean isModoEdicionActivo() {
        return modoEdicionActivo;
    }
    public void setModoCalculo(boolean activo) {
        btnCalcular.setText(activo ? "Calcular calorias" : "Realizar calculo calorias");
        mostrarCampoGramos(activo);
        if (!activo) {
            limpiarGramos();
        }
    }
    public void mostrarCampoGramos(boolean visible) {
        if (lblGramos != null) {
            lblGramos.setVisible(visible);
        }
        if (txtGramos != null) {
            txtGramos.setVisible(visible);
        }
        revalidate();
        repaint();
    }
    public void limpiarGramos() {
        txtGramos.setText("");
    }
}