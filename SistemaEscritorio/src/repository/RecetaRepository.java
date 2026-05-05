package src.repository;

import src.model.IngredienteReceta;
import src.model.Receta;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RecetaRepository {

    public void guardarRecetaConDetalle(Receta receta) {
        String sqlReceta = "INSERT INTO recetas(nombre_plato) VALUES (?)";
        String sqlDetalle = "INSERT INTO detalle_receta(id_receta, id_alimento, cantidad_gramos) VALUES (?, ?, ?)";

        Connection conn = null;
        try {
            conn = ConexionSQLite.conectar();
            conn.setAutoCommit(false);

            int idReceta;
            try (PreparedStatement stmtReceta = conn.prepareStatement(sqlReceta, PreparedStatement.RETURN_GENERATED_KEYS)) {
                stmtReceta.setString(1, receta.getNombrePlato());
                stmtReceta.executeUpdate();

                try (ResultSet keys = stmtReceta.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new SQLException("No se pudo generar el id de la receta.");
                    }
                    idReceta = keys.getInt(1);
                }
            }

            try (PreparedStatement stmtDetalle = conn.prepareStatement(sqlDetalle)) {
                for (IngredienteReceta ingrediente : receta.getIngredientes()) {
                    stmtDetalle.setInt(1, idReceta);
                    stmtDetalle.setInt(2, ingrediente.getAlimento().getId());
                    stmtDetalle.setDouble(3, ingrediente.getCantidadGramos());
                    stmtDetalle.addBatch();
                }
                stmtDetalle.executeBatch();
            }

            conn.commit();
            receta.setId(idReceta);
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    throw new RuntimeException("Error al revertir transacción", rollbackEx);
                }
            }
            throw new RuntimeException("Error al guardar receta y detalle", e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException closeEx) {
                    throw new RuntimeException("Error al cerrar conexión", closeEx);
                }
            }
        }
    }
}
