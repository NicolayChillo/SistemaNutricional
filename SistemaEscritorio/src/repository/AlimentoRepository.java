package src.repository;

import src.model.Alimento;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlimentoRepository {

    public void guardar(Alimento alimento) {
        String sql = "INSERT INTO alimentos(nombre, calorias, proteinas, carbohidratos) VALUES (?, ?, ?, ?)";

        try (Connection conn = ConexionSQLite.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, alimento.getNombre());
            stmt.setDouble(2, alimento.getCalorias());
            stmt.setDouble(3, alimento.getProteinas());
            stmt.setDouble(4, alimento.getCarbohidratos());

            stmt.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<Alimento> listar() {
        List<Alimento> lista = new ArrayList<>();
        String sql = "SELECT * FROM alimentos";

        try (Connection conn = ConexionSQLite.conectar();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                lista.add(new Alimento(
                        rs.getInt("id"),
                        rs.getString("nombre"),
                        rs.getDouble("calorias"),
                        rs.getDouble("proteinas"),
                        rs.getDouble("carbohidratos")
                ));
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return lista;
    }
}