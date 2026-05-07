package src.repository;
import src.model.Alimento;
import src.model.IngredienteReceta;
import src.model.Receta;
import src.util.ExceptionHandler;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class RecetaRepository {
    public boolean existePorNombre(String nombre) {
        if (nombre == null || nombre.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM recetas WHERE LOWER(nombre_plato) = LOWER(?)";
        try (Connection conn = ConexionSQLite.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nombre.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaRepository.existePorNombre", e);
            return false;
        }
        return false;
    }
    public boolean existePorNombreExcluyendoId(String nombre, int idExcluir) {
        if (nombre == null || nombre.trim().isEmpty() || idExcluir <= 0) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM recetas WHERE LOWER(nombre_plato) = LOWER(?) AND id <> ?";
        try (Connection conn = ConexionSQLite.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nombre.trim());
            stmt.setInt(2, idExcluir);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaRepository.existePorNombreExcluyendoId", e);
            return false;
        }
        return false;
    }
    public void guardarRecetaConDetalle(Receta receta) {
        if (receta == null) {
            throw new IllegalArgumentException("La receta no puede ser nula.");
        }
        if (existePorNombre(receta.getNombrePlato())) {
            throw new IllegalArgumentException("Ya existe una receta con el nombre '" + receta.getNombrePlato() + "'.");
        }
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
    public List<Receta> listar() {
        List<Receta> lista = new ArrayList<>();
        String sql = "SELECT id, nombre_plato FROM recetas ORDER BY nombre_plato ASC";
        try (Connection conn = ConexionSQLite.conectar();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Receta r = new Receta(rs.getString("nombre_plato"));
                r.setId(rs.getInt("id"));
                lista.add(r);
            }
        } catch (SQLException e) {
            ExceptionHandler.logException("RecetaRepository.listar", e);
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaRepository.listar", e);
        }
        return lista;
    }
    public Receta obtenerPorId(int id) {
        String sqlReceta = "SELECT id, nombre_plato FROM recetas WHERE id = ?";
        String sqlDetalles = "SELECT dr.id_alimento, dr.cantidad_gramos, a.nombre, a.calorias, a.proteinas, a.carbohidratos " +
                "FROM detalle_receta dr " +
                "JOIN alimentos a ON dr.id_alimento = a.id " +
                "WHERE dr.id_receta = ?";
        try (Connection conn = ConexionSQLite.conectar();
             PreparedStatement stmtReceta = conn.prepareStatement(sqlReceta)) {
            stmtReceta.setInt(1, id);
            try (ResultSet rs = stmtReceta.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                Receta receta = new Receta(rs.getString("nombre_plato"));
                receta.setId(rs.getInt("id"));
                // Cargar ingredientes
                try (PreparedStatement stmtDetalles = conn.prepareStatement(sqlDetalles)) {
                    stmtDetalles.setInt(1, id);
                    try (ResultSet rsDetalles = stmtDetalles.executeQuery()) {
                        while (rsDetalles.next()) {
                            Alimento alimento = new Alimento(
                                    rsDetalles.getInt("id_alimento"),
                                    rsDetalles.getString("nombre"),
                                    rsDetalles.getDouble("calorias"),
                                    rsDetalles.getDouble("proteinas"),
                                    rsDetalles.getDouble("carbohidratos")
                            );
                            IngredienteReceta ingrediente = new IngredienteReceta(
                                    alimento,
                                    rsDetalles.getDouble("cantidad_gramos")
                            );
                            receta.agregarIngrediente(ingrediente);
                        }
                    }
                }
                return receta;
            }
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaRepository.obtenerPorId", e);
        }
        return null;
    }
    public void actualizarConDetalle(Receta receta) {
        if (receta == null || receta.getId() <= 0) {
            throw new IllegalArgumentException("La receta debe tener un ID valido.");
        }
        if (existePorNombreExcluyendoId(receta.getNombrePlato(), receta.getId())) {
            throw new IllegalArgumentException("Ya existe otra receta con el nombre '" + receta.getNombrePlato() + "'.");
        }
        String sqlUpdateReceta = "UPDATE recetas SET nombre_plato = ? WHERE id = ?";
        String sqlDeleteDetalles = "DELETE FROM detalle_receta WHERE id_receta = ?";
        String sqlInsertDetalle = "INSERT INTO detalle_receta(id_receta, id_alimento, cantidad_gramos) VALUES (?, ?, ?)";
        Connection conn = null;
        try {
            conn = ConexionSQLite.conectar();
            conn.setAutoCommit(false);
            // Actualizar nombre de receta
            try (PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdateReceta)) {
                stmtUpdate.setString(1, receta.getNombrePlato());
                stmtUpdate.setInt(2, receta.getId());
                int filasActualizadas = stmtUpdate.executeUpdate();
                if (filasActualizadas == 0) {
                    throw new SQLException("La receta no fue encontrada para actualizar.");
                }
            }
            // Eliminar ingredientes anteriores
            try (PreparedStatement stmtDelete = conn.prepareStatement(sqlDeleteDetalles)) {
                stmtDelete.setInt(1, receta.getId());
                stmtDelete.executeUpdate();
            }
            // Insertar nuevos ingredientes
            try (PreparedStatement stmtInsert = conn.prepareStatement(sqlInsertDetalle)) {
                for (IngredienteReceta ingrediente : receta.getIngredientes()) {
                    stmtInsert.setInt(1, receta.getId());
                    stmtInsert.setInt(2, ingrediente.getAlimento().getId());
                    stmtInsert.setDouble(3, ingrediente.getCantidadGramos());
                    stmtInsert.addBatch();
                }
                stmtInsert.executeBatch();
            }
            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    throw new RuntimeException("Error al revertir transacción", rollbackEx);
                }
            }
            throw new RuntimeException("Error al actualizar receta con detalle: " + e.getMessage(), e);
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
    public void actualizar(Receta receta) {
        if (receta == null || receta.getId() <= 0) {
            throw new IllegalArgumentException("La receta debe tener un ID valido.");
        }
        if (existePorNombreExcluyendoId(receta.getNombrePlato(), receta.getId())) {
            throw new IllegalArgumentException("Ya existe otra receta con el nombre '" + receta.getNombrePlato() + "'.");
        }
        String sql = "UPDATE recetas SET nombre_plato = ? WHERE id = ?";
        try (Connection conn = ConexionSQLite.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, receta.getNombrePlato());
            stmt.setInt(2, receta.getId());
            int filasActualizadas = stmt.executeUpdate();
            if (filasActualizadas == 0) {
                throw new RuntimeException("La receta no fue encontrada para actualizar.");
            }
        } catch (SQLException e) {
            ExceptionHandler.logException("RecetaRepository.actualizar", e);
            throw new RuntimeException("Error al actualizar receta: " + e.getMessage());
        } catch (Exception e) {
            ExceptionHandler.logException("RecetaRepository.actualizar", e);
            throw new RuntimeException("Error inesperado: " + e.getMessage());
        }
    }
    public void eliminar(int id) {
        if (id <= 0) {
            throw new IllegalArgumentException("El ID debe ser mayor a 0.");
        }
        Connection conn = null;
        try {
            conn = ConexionSQLite.conectar();
            conn.setAutoCommit(false);
            // Eliminar detalles
            String sqlDetalles = "DELETE FROM detalle_receta WHERE id_receta = ?";
            try (PreparedStatement stmtDetalles = conn.prepareStatement(sqlDetalles)) {
                stmtDetalles.setInt(1, id);
                stmtDetalles.executeUpdate();
            }
            // Eliminar receta
            String sqlReceta = "DELETE FROM recetas WHERE id = ?";
            try (PreparedStatement stmtReceta = conn.prepareStatement(sqlReceta)) {
                stmtReceta.setInt(1, id);
                int filasEliminadas = stmtReceta.executeUpdate();
                if (filasEliminadas == 0) {
                    throw new RuntimeException("La receta no fue encontrada para eliminar.");
                }
            }
            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    ExceptionHandler.logException("RecetaRepository.eliminar - Rollback", rollbackEx);
                }
            }
            ExceptionHandler.logException("RecetaRepository.eliminar", e);
            throw new RuntimeException("Error al eliminar receta: " + e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException closeEx) {
                    ExceptionHandler.logException("RecetaRepository.eliminar - Close", closeEx);
                }
            }
        }
    }
}
