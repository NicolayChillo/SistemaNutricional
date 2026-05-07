import src.controller.AlimentoController;
import src.controller.RecetaController;
import src.view.AlimentoView;
import src.view.RecetaView;
import javax.swing.*;
import java.awt.*;
public class App {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            try {
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            } catch (Exception e) {
                e.printStackTrace();
            }
            JFrame frame = new JFrame("Sistema de Gestión Nutricional");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setSize(1000, 650);
            frame.setLocationRelativeTo(null);
            AlimentoView vistaAlimentos = new AlimentoView();
            RecetaView vistaRecetas = new RecetaView();
            RecetaController recetaController = new RecetaController(vistaRecetas);
            new AlimentoController(vistaAlimentos, recetaController::refrescarAlimentosDisponibles);
            JTabbedPane tabs = new JTabbedPane();
            tabs.setFont(new Font("Segoe UI", Font.BOLD, 13));
            tabs.setBackground(new Color(245, 247, 250));
            tabs.setForeground(new Color(44, 62, 80));
            tabs.addTab("Alimentos", vistaAlimentos);
            tabs.addTab("Recetas", vistaRecetas);
            JLabel lblLogo = new JLabel();
            try {
                java.net.URL imgUrl = App.class.getResource("/logo.png");
                ImageIcon icon;
                if (imgUrl != null) {
                    icon = new ImageIcon(imgUrl);
                } else {
                    icon = new ImageIcon("src/resources/logo.png");
                }
                Image img = icon.getImage().getScaledInstance(50, 50, Image.SCALE_SMOOTH);
                lblLogo.setIcon(new ImageIcon(img));
            } catch (Exception ex) {
                System.out.println("Logo no encontrado.");
            }
            JPanel top = new JPanel(new BorderLayout());
            top.setBackground(new Color(33, 150, 243));
            top.setBorder(BorderFactory.createEmptyBorder(10, 15, 10, 15));
            JLabel titulo = new JLabel("Sistema de Gestión Nutricional");
            titulo.setForeground(Color.WHITE);
            titulo.setFont(new Font("Segoe UI", Font.BOLD, 18));
            top.add(lblLogo, BorderLayout.WEST);
            top.add(titulo, BorderLayout.CENTER);
            JPanel main = new JPanel(new BorderLayout());
            main.setBorder(BorderFactory.createEmptyBorder(8, 8, 8, 8));
            main.setBackground(new Color(245, 247, 250));
            main.add(top, BorderLayout.NORTH);
            main.add(tabs, BorderLayout.CENTER);
            frame.setContentPane(main);
            frame.setVisible(true);
        });
    }
}