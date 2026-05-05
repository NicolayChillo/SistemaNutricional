package src.repository;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class ConexionSQLite {

    private static final String URL = "jdbc:sqlite:nutricion.db";

    public static Connection conectar() {
        try {
            Connection conn = DriverManager.getConnection(URL);

            String sqlAlimentos = """
                CREATE TABLE IF NOT EXISTS alimentos (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    nombre TEXT NOT NULL,
                    calorias REAL,
                    proteinas REAL,
                    carbohidratos REAL
                );
            """;

            String sqlRecetas = """
                CREATE TABLE IF NOT EXISTS recetas (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    nombre_plato TEXT NOT NULL
                );
            """;

            String sqlDetalleReceta = """
                CREATE TABLE IF NOT EXISTS detalle_receta (
                    id_receta INTEGER NOT NULL,
                    id_alimento INTEGER NOT NULL,
                    cantidad_gramos REAL NOT NULL,
                    FOREIGN KEY (id_receta) REFERENCES recetas(id),
                    FOREIGN KEY (id_alimento) REFERENCES alimentos(id)
                );
            """;

            Statement stmt = conn.createStatement();
            stmt.execute(sqlAlimentos);
            stmt.execute(sqlRecetas);
            stmt.execute(sqlDetalleReceta);

            return conn;

        } catch (Exception e) {
            throw new RuntimeException("Error al conectar DB", e);
        }
    }
}