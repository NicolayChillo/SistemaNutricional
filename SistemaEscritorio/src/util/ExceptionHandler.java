package src.util;
public class ExceptionHandler {
    public static String obtenerMensajeAmigable(Exception e) {
        if (e instanceof IllegalArgumentException) {
            return "Error de validación: " + e.getMessage();
        } else if (e instanceof IllegalStateException) {
            return "Error de estado: " + e.getMessage();
        } else if (e instanceof NullPointerException) {
            return "Error: Datos no cargados. Por favor, recarga la información.";
        } else if (e.getMessage() != null && e.getMessage().contains("UNIQUE constraint failed")) {
            return "Este nombre ya existe en la base de datos.";
        } else if (e.getMessage() != null && e.getMessage().contains("database is locked")) {
            return "La base de datos está ocupada. Intenta de nuevo en un momento.";
        } else {
            return "Error inesperado: " + (e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName());
        }
    }
    public static void logException(String context, Exception e) {
        System.err.println("[ERROR] " + context + ": " + e.getMessage());
        e.printStackTrace();
    }
}
