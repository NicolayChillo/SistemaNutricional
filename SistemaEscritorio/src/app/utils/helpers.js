export const MAX_DECIMALS = 4;

export const roundToDecimals = (value, decimals = MAX_DECIMALS) => {
  if (isNaN(value)) return 0;
  const factor = Math.pow(10, decimals);
  return Math.round(value * factor) / factor;
};

export const hasExcessiveDecimals = (value, maxDecimals = MAX_DECIMALS) => {
  if (!value) return false;
  const str = String(value);
  const decimalPart = str.split('.')[1];
  return decimalPart && decimalPart.length > maxDecimals;
};

export const cleanNumericFields = (obj, fields, decimals = MAX_DECIMALS) => {
  const cleaned = { ...obj };
  fields.forEach((field) => {
    if (cleaned[field] !== undefined && cleaned[field] !== null) {
      cleaned[field] = roundToDecimals(cleaned[field], decimals);
    }
  });
  return cleaned;
};

// Limpia un objeto nutritionalInfo redondeando todos los campos numéricos
export const cleanNutritionalInfo = (nutritionalInfo, maxDecimals = MAX_DECIMALS) => {
  if (!nutritionalInfo) return {};
  const cleaned = { ...nutritionalInfo };
  const numericFields = ['calories', 'protein', 'carbohydrates', 'fat', 'fiber', 'sugar', 'sodium'];
  numericFields.forEach(field => {
    if (cleaned[field] !== undefined && cleaned[field] !== null) {
      cleaned[field] = roundToDecimals(cleaned[field], maxDecimals);
    }
  });
  return cleaned;
};