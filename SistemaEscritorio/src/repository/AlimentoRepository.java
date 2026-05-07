package src.repository;
import src.model.Alimento;
import src.util.ExceptionHandler;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class AlimentoRepository {
    public void guardar(Alimento alimento) throws IllegalArgumentException, RuntimeException {
        if (alimento == null) {
            throw new IllegalArgumentException("El alimento no puede ser nulo.");
        }
        if (existePorNombre(alimento.getNombre())) {
            throw new IllegalArgumentException("Ya existe un alimento con el nombre '" + alimento.getNombre() + "'.");
        }
        String sql = "INSERT INTO alimentos(nombre, calorias, proteinas, carbohidratos) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionSQLite.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, alimento.getNombre());
            stmt.setDouble(2, alimento.getCalorias());
            stmt.setDouble(3, alimento.getProteinas());
            stmt.setDouble(4, alimento.getCarbohidratos());
            int filasInsertadas = stmt.executeUpdate();
            if (filasInsertadas == 0) {
                throw new RuntimeException("No se pudo insertar el alimento en la base de datos.");
            }
        } catch (SQLException e) {
            ExceptionHandler.logException("AlimentoRepository.guardar", e);
            throw new RuntimeException("Error al guardar alimento: " + ExceptionHandler.obtenerMensajeAmigable(e));
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoRepository.guardar", e);
            throw new RuntimeException("Error inesperado: " + e.getMessage());
        }
    }
    public boolean existePorNombre(String nombre) {
        if (nombre == null || nombre.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM alimentos WHERE LOWER(nombre) = LOWER(?)";
        try (Connection conn = ConexionSQLite.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nombre.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoRepository.existePorNombre", e);
            // En caso de error, asumir que no existe para no bloquear
            return false;
        }
        return false;
    }
    public boolean existePorNombreExcluyendoId(String nombre, int idExcluir) {
        if (nombre == null || nombre.trim().isEmpty() || idExcluir <= 0) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM alimentos WHERE LOWER(nombre) = LOWER(?) AND id <> ?";
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
            ExceptionHandler.logException("AlimentoRepository.existePorNombreExcluyendoId", e);
            return false;
        }
        return false;
    }
    public List<Alimento> listar() {
        List<Alimento> lista = new ArrayList<>();
        String sql = "SELECT * FROM alimentos ORDER BY nombre ASC";
        try (Connection conn = ConexionSQLite.conectar();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                try {
                    lista.add(new Alimento(
                            rs.getInt("id"),
                            rs.getString("nombre"),
                            rs.getDouble("calorias"),
                            rs.getDouble("proteinas"),
                            rs.getDouble("carbohidratos")
                    ));
                } catch (Exception e) {
                    ExceptionHandler.logException("AlimentoRepository.listar - Fila", e);
                }
            }
        } catch (SQLException e) {
            ExceptionHandler.logException("AlimentoRepository.listar", e);
            // Retornar lista vacía en caso de error para no bloquear la UI
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoRepository.listar", e);
        }
        return lista;
    }
    public Alimento obtenerPorId(int id) {
        String sql = "SELECT * FROM alimentos WHERE id = ?";
        try (Connection conn = ConexionSQLite.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Alimento(
                            rs.getInt("id"),
                            rs.getString("nombre"),
                            rs.getDouble("calorias"),
                            rs.getDouble("proteinas"),
                            rs.getDouble("carbohidratos")
                    );
                }
            }
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoRepository.obtenerPorId", e);
        }
        return null;
    }
    public void actualizar(Alimento alimento) throws RuntimeException {
        if (alimento == null || alimento.getId() <= 0) {
            throw new IllegalArgumentException("El alimento debe tener un ID valido.");
        }
        if (existePorNombreExcluyendoId(alimento.getNombre(), alimento.getId())) {
            throw new IllegalArgumentException("Ya existe otro alimento con el nombre '" + alimento.getNombre() + "'.");
        }
        String sql = "UPDATE alimentos SET nombre = ?, calorias = ?, proteinas = ?, carbohidratos = ? WHERE id = ?";
        try (Connection conn = ConexionSQLite.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, alimento.getNombre());
            stmt.setDouble(2, alimento.getCalorias());
            stmt.setDouble(3, alimento.getProteinas());
            stmt.setDouble(4, alimento.getCarbohidratos());
            stmt.setInt(5, alimento.getId());
            int filasActualizadas = stmt.executeUpdate();
            if (filasActualizadas == 0) {
                throw new RuntimeException("El alimento no fue encontrado para actualizar.");
            }
        } catch (SQLException e) {
            ExceptionHandler.logException("AlimentoRepository.actualizar", e);
            throw new RuntimeException("Error al actualizar alimento: " + ExceptionHandler.obtenerMensajeAmigable(e));
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoRepository.actualizar", e);
            throw new RuntimeException("Error inesperado: " + e.getMessage());
        }
    }
    public void eliminar(int id) throws RuntimeException {
        if (id <= 0) {
            throw new IllegalArgumentException("El ID debe ser mayor a 0.");
        }
        String sql = "DELETE FROM alimentos WHERE id = ?";
        try (Connection conn = ConexionSQLite.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            int filasEliminadas = stmt.executeUpdate();
            if (filasEliminadas == 0) {
                throw new RuntimeException("El alimento no fue encontrado para eliminar.");
            }
        } catch (SQLException e) {
            ExceptionHandler.logException("AlimentoRepository.eliminar", e);
            throw new RuntimeException("Error al eliminar alimento: " + ExceptionHandler.obtenerMensajeAmigable(e));
        } catch (Exception e) {
            ExceptionHandler.logException("AlimentoRepository.eliminar", e);
            throw new RuntimeException("Error inesperado: " + e.getMessage());
        }
    }
}