export const roundToDecimals = (value, decimals = 2) => {
  if (isNaN(value)) return 0;
  const factor = Math.pow(10, decimals);
  return Math.round(value * factor) / factor;
};

export const hasExcessiveDecimals = (value, maxDecimals = 2) => {
  if (!value) return false;
  const str = String(value);
  const decimalPart = str.split('.')[1];
  return decimalPart && decimalPart.length > maxDecimals;
};