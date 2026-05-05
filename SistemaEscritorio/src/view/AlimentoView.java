package src.view;

import src.model.Alimento;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class AlimentoView extends JPanel {

    private JTextField txtNombre, txtCalorias, txtProteinas, txtCarbohidratos, txtGramos;
    private JButton btnGuardar, btnCalcular;
    private JTable tabla;
    private DefaultTableModel modelo;
    private JLabel lblStatus;

    public AlimentoView() {

        setLayout(new BorderLayout(12, 12));
        setBackground(UIStyle.BACKGROUND);

        JPanel card = new JPanel(new BorderLayout(10, 10));
        card.setBackground(UIStyle.CARD);
        card.setBorder(UIStyle.cardBorder());

        card.add(UIStyle.titleLabel("Gestión de Alimentos"), BorderLayout.NORTH);

        JPanel formCard = new JPanel(new GridBagLayout());
        formCard.setOpaque(false);

        GridBagConstraints c = new GridBagConstraints();
        c.insets = UIStyle.PADDING;
        c.fill = GridBagConstraints.HORIZONTAL;

        txtNombre = new JTextField();
        txtCalorias = new JTextField();
        txtProteinas = new JTextField();
        txtCarbohidratos = new JTextField();
        txtGramos = new JTextField();

        UIStyle.styleField(txtNombre);
        UIStyle.styleField(txtCalorias);
        UIStyle.styleField(txtProteinas);
        UIStyle.styleField(txtCarbohidratos);
        UIStyle.styleField(txtGramos);

        int y = 0;

        c.gridx = 0; c.gridy = y; formCard.add(UIStyle.fieldLabel("Nombre"), c);
        c.gridx = 1; formCard.add(txtNombre, c); y++;

        c.gridx = 0; c.gridy = y; formCard.add(UIStyle.fieldLabel("Calorías"), c);
        c.gridx = 1; formCard.add(txtCalorias, c); y++;

        c.gridx = 0; c.gridy = y; formCard.add(UIStyle.fieldLabel("Proteínas"), c);
        c.gridx = 1; formCard.add(txtProteinas, c); y++;

        c.gridx = 0; c.gridy = y; formCard.add(UIStyle.fieldLabel("Carbohidratos"), c);
        c.gridx = 1; formCard.add(txtCarbohidratos, c); y++;

        c.gridx = 0; c.gridy = y; formCard.add(UIStyle.fieldLabel("Gramos"), c);
        c.gridx = 1; formCard.add(txtGramos, c); y++;

        btnGuardar = new JButton("Guardar");
        btnCalcular = new JButton("Calcular");

        UIStyle.styleButton(btnGuardar, UIStyle.PRIMARY);
        UIStyle.styleButton(btnCalcular, UIStyle.SUCCESS);

        JPanel actions = UIStyle.buttonGroup(btnGuardar, btnCalcular);

        c.gridx = 0; c.gridy = y; c.gridwidth = 2;
        formCard.add(actions, c);

        card.add(formCard, BorderLayout.NORTH);

        modelo = new DefaultTableModel(new String[]{"ID","Nombre","Cal","Prot","Carb"}, 0) {
            public boolean isCellEditable(int r, int c) { return false; }
        };

        tabla = new JTable(modelo);
        UIStyle.styleTable(tabla);

        card.add(new JScrollPane(tabla), BorderLayout.CENTER);

        add(card, BorderLayout.CENTER);

        lblStatus = new JLabel(" ");
        add(lblStatus, BorderLayout.SOUTH);
    }

    public void cargarTabla(List<Alimento> lista) {
        modelo.setRowCount(0);
        for (Alimento a : lista) {
            modelo.addRow(new Object[]{
                    a.getId(),
                    a.getNombre(),
                    a.getCalorias(),
                    a.getProteinas(),
                    a.getCarbohidratos()
            });
        }
    }

    public JButton getBtnGuardar() { return btnGuardar; }
    public JButton getBtnCalcular() { return btnCalcular; }

    // --- Getters usados por el controlador ---
    public String getNombreInput() { return txtNombre.getText().trim(); }
    public String getCaloriasInput() { return txtCalorias.getText().trim(); }
    public String getProteinasInput() { return txtProteinas.getText().trim(); }
    public String getCarbohidratosInput() { return txtCarbohidratos.getText().trim(); }
    public String getGramosInput() { return txtGramos.getText().trim(); }

    public Alimento getAlimentoSeleccionado() {
        int r = tabla.getSelectedRow();
        if (r < 0) return null;
        Object idObj = modelo.getValueAt(r, 0);
        Object nombreObj = modelo.getValueAt(r, 1);
        Object calObj = modelo.getValueAt(r, 2);
        Object protObj = modelo.getValueAt(r, 3);
        Object carbObj = modelo.getValueAt(r, 4);
        int id = (idObj instanceof Number) ? ((Number) idObj).intValue() : Integer.parseInt(idObj.toString());
        double cal = (calObj instanceof Number) ? ((Number) calObj).doubleValue() : Double.parseDouble(calObj.toString());
        double prot = (protObj instanceof Number) ? ((Number) protObj).doubleValue() : Double.parseDouble(protObj.toString());
        double carb = (carbObj instanceof Number) ? ((Number) carbObj).doubleValue() : Double.parseDouble(carbObj.toString());
        return new Alimento(id, nombreObj.toString(), cal, prot, carb);
    }

    public void mostrarEstado(String mensaje, Color color) {
        lblStatus.setText(mensaje);
        lblStatus.setOpaque(true);
        lblStatus.setBackground(color);
        Timer t = new Timer(3500, e -> limpiarEstado());
        t.setRepeats(false); t.start();
    }

    public void limpiarEstado() { lblStatus.setText(" "); lblStatus.setOpaque(false); }

    public void limpiarCampos() {
        txtNombre.setText(""); txtCalorias.setText(""); txtProteinas.setText(""); txtCarbohidratos.setText(""); txtGramos.setText("");
        txtNombre.requestFocus();
    }
}