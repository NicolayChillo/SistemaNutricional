package src.view;

import src.model.*;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.text.DecimalFormat;
import java.util.List;

public class RecetaView extends JPanel {

    private JTextField txtNombrePlato, txtCantidadGramos;
    private JComboBox<Alimento> cmbAlimentos;
    private JButton btnAgregarIngrediente, btnQuitarIngrediente, btnFinalizarReceta;
    private JTable tablaIngredientes;
    private DefaultTableModel modelo;
    private JLabel lblTotales, lblStatus;

    public RecetaView() {

        setLayout(new BorderLayout(12, 12));
        setBackground(UIStyle.BACKGROUND);

        JPanel card = new JPanel(new BorderLayout(10, 10));
        card.setBackground(UIStyle.CARD);
        card.setBorder(UIStyle.cardBorder());

        card.add(UIStyle.titleLabel("Constructor de Recetas"), BorderLayout.NORTH);

        JPanel form = new JPanel(new GridBagLayout());
        form.setOpaque(false);

        GridBagConstraints c = new GridBagConstraints();
        c.insets = UIStyle.PADDING;
        c.fill = GridBagConstraints.HORIZONTAL;

        txtNombrePlato = new JTextField();
        txtCantidadGramos = new JTextField();
        cmbAlimentos = new JComboBox<>();

        UIStyle.styleField(txtNombrePlato);
        UIStyle.styleField(txtCantidadGramos);

        int y = 0;

        c.gridx = 0; c.gridy = y; form.add(UIStyle.fieldLabel("Plato"), c);
        c.gridx = 1; form.add(txtNombrePlato, c); y++;

        c.gridx = 0; c.gridy = y; form.add(UIStyle.fieldLabel("Ingrediente"), c);
        c.gridx = 1; form.add(cmbAlimentos, c); y++;

        c.gridx = 0; c.gridy = y; form.add(UIStyle.fieldLabel("Gramos"), c);
        c.gridx = 1; form.add(txtCantidadGramos, c); y++;

        btnAgregarIngrediente = new JButton("Añadir");
        btnQuitarIngrediente = new JButton("Quitar");
        btnFinalizarReceta = new JButton("Finalizar");

        UIStyle.styleButton(btnAgregarIngrediente, UIStyle.SUCCESS);
        UIStyle.styleButton(btnQuitarIngrediente, UIStyle.DANGER);
        UIStyle.styleButton(btnFinalizarReceta, UIStyle.PRIMARY);

        JPanel actions = UIStyle.buttonGroup(btnAgregarIngrediente, btnQuitarIngrediente, btnFinalizarReceta);

        c.gridx = 0; c.gridy = y; c.gridwidth = 2;
        form.add(actions, c);

        card.add(form, BorderLayout.NORTH);

        modelo = new DefaultTableModel(
                new String[]{"Alimento","Gr","Cal","Prot","Carb"}, 0
        );

        tablaIngredientes = new JTable(modelo);
        UIStyle.styleTable(tablaIngredientes);

        JPanel bottom = new JPanel(new BorderLayout());
        bottom.setOpaque(false);

        lblTotales = new JLabel("Totales: 0 kcal");
        lblTotales.setFont(UIStyle.FONT_BOLD);

        lblStatus = new JLabel(" ");

        bottom.add(new JScrollPane(tablaIngredientes), BorderLayout.CENTER);
        bottom.add(lblTotales, BorderLayout.NORTH);
        bottom.add(lblStatus, BorderLayout.SOUTH);

        card.add(bottom, BorderLayout.CENTER);

        add(card, BorderLayout.CENTER);
    }

    public void cargarAlimentosCombo(List<Alimento> alimentos) {
        DefaultComboBoxModel<Alimento> model = new DefaultComboBoxModel<>();
        for (Alimento a : alimentos) model.addElement(a);
        cmbAlimentos.setModel(model);
    }

    public void cargarTablaIngredientes(List<IngredienteReceta> ingredientes) {
        DecimalFormat df = new DecimalFormat("#.##");
        modelo.setRowCount(0);

        for (IngredienteReceta i : ingredientes) {
            double f = i.getCantidadGramos() / 100.0;

            modelo.addRow(new Object[]{
                    i.getAlimento().getNombre(),
                    df.format(i.getCantidadGramos()),
                    df.format(i.getAlimento().getCalorias() * f),
                    df.format(i.getAlimento().getProteinas() * f),
                    df.format(i.getAlimento().getCarbohidratos() * f)
            });
        }
    }

    public String getNombrePlatoInput() { return txtNombrePlato.getText().trim(); }

    public void mostrarTotales(src.model.AporteNutricional aporte) {
        lblTotales.setText(String.format("Totales: %.2f kcal — Prot: %.2f g — Carb: %.2f g",
                aporte.getCalorias(), aporte.getProteinas(), aporte.getCarbohidratos()));
    }

    // --- Getters usados por el controlador ---
    public JButton getBtnAgregarIngrediente() { return btnAgregarIngrediente; }
    public JButton getBtnQuitarIngrediente() { return btnQuitarIngrediente; }
    public JButton getBtnFinalizarReceta() { return btnFinalizarReceta; }
    public Alimento getAlimentoSeleccionado() { return (Alimento) cmbAlimentos.getSelectedItem(); }
    public String getCantidadGramosInput() { return txtCantidadGramos.getText().trim(); }
    public int getFilaIngredienteSeleccionada() { return tablaIngredientes.getSelectedRow(); }

    // Estado / util
    public void mostrarEstado(String mensaje, Color color) {
        lblStatus.setText(mensaje);
        lblStatus.setBackground(color);
        Timer t = new Timer(4000, e -> limpiarEstado());
        t.setRepeats(false); t.start();
    }

    public void limpiarEstado() {
        lblStatus.setText(" ");
        lblStatus.setBackground(UIStyle.BACKGROUND);
    }

    public void limpiarCantidadInput() { txtCantidadGramos.setText(""); txtCantidadGramos.requestFocus(); }

    public void limpiarFormularioReceta() { txtNombrePlato.setText(""); txtCantidadGramos.setText(""); txtNombrePlato.requestFocus(); limpiarEstado(); }
}