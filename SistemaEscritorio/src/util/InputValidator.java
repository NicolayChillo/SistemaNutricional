package src.util;
import java.util.regex.Pattern;
public class InputValidator {
    // Expresión regular: solo números, punto decimal (una sola vez)
    private static final Pattern VALID_DECIMAL = Pattern.compile("^[0-9]+(\\.[0-9]+)?$");
    // Detecta notación científica (e, E, números muy grandes)
    private static final Pattern SCIENTIFIC_NOTATION = Pattern.compile("[eE]|\\d{16,}");
    public static Double validarDecimalPositivo(String valor) throws IllegalArgumentException, IllegalStateException {
        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException("El valor no puede estar vacío");
        }
        String normalized = valor.trim().replace(',', '.');
        // 1. Detectar caracteres no permitidos
        if (!VALID_DECIMAL.matcher(normalized).matches()) {
            throw new IllegalArgumentException("El valor contiene caracteres no numéricos. Solo se permiten números y punto decimal.");
        }
        // 2. Detectar notación científica o números muy grandes
        if (SCIENTIFIC_NOTATION.matcher(valor).find()) {
            throw new IllegalArgumentException("No se permite notación científica.");
        }
        try {
            double numValue = Double.parseDouble(normalized);
            // 3. Validar que no sea NaN o Infinito
            if (Double.isNaN(numValue) || Double.isInfinite(numValue)) {
                throw new IllegalStateException("El valor resulta en infinito o no es un número válido.");
            }
            // 4. Validar que no sea negativo
            if (numValue < 0) {
                throw new IllegalArgumentException("El valor no puede ser negativo.");
            }
            return numValue;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("No se puede interpretar como número: " + e.getMessage());
        }
    }
    public static boolean validarMayorACero(double valor) throws IllegalArgumentException {
        if (valor <= 0) {
            throw new IllegalArgumentException("El valor debe ser mayor a cero.");
        }
        return true;
    }
    public static boolean validarNombre(String nombre) throws IllegalArgumentException {
        if (nombre == null || nombre.trim().isEmpty()) {
            throw new IllegalArgumentException("El nombre no puede estar vacío.");
        }
        String nombreTrimmed = nombre.trim();
        // Extraer solo caracteres alfabéticos
        String soloLetras = nombreTrimmed.replaceAll("[^\\p{L}]", "");
        if (soloLetras.length() < 3) {
            throw new IllegalArgumentException("El nombre debe contener al menos 3 caracteres alfabéticos.");
        }
        return true;
    }
    public static boolean validarNombreEstricto(String nombre) throws IllegalArgumentException {
        if (nombre == null || nombre.trim().isEmpty()) {
            throw new IllegalArgumentException("El nombre no puede estar vacío.");
        }
        String nombreTrimmed = nombre.trim();
        // Solo letras, espacios y acentos permitidos
        if (!nombreTrimmed.matches("[\\p{L}\\s]+")) {
            throw new IllegalArgumentException("El nombre solo puede contener letras y espacios.");
        }
        // Mínimo 3 letras
        if (nombreTrimmed.length() < 3) {
            throw new IllegalArgumentException("El nombre debe tener mínimo 3 caracteres.");
        }
        return true;
    }
    public static boolean validarRango(double valor, double minimo, double maximo) throws IllegalArgumentException {
        if (valor < minimo || valor > maximo) {
            throw new IllegalArgumentException(
                    String.format("El valor %.2f está fuera del rango permitido [%.2f, %.2f]", valor, minimo, maximo)
            );
        }
        return true;
    }
}
