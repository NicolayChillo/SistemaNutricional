export const AppColors = {
  dustGrey: '#DAD7CD',
  drySage: '#A3B18A',
  fern: '#588157',
  hunterGreen: '#3A5A40',
  pineTeal: '#344E41',
  error: '#D32F2F',
  success: '#388E3C',
  warning: '#F57C00',
  info: '#1976D2',
  textPrimary: '#344E41',
  textSecondary: '#3A5A40',
  textLight: '#A3B18A',
  textOnDark: '#DAD7CD',
  background: '#F5F5F5',
  surface: '#FFFFFF',
  surfaceDark: '#344E41',
};

export const themeConfig = {
  palette: {
    mode: 'light',
    primary: {
      main: '#3A5A40',
      light: '#588157',
      dark: '#344E41',
      contrastText: '#FFFFFF',
    },
    secondary: {
      main: '#588157',
      light: '#A3B18A',
      dark: '#3A5A40',
      contrastText: '#FFFFFF',
    },
    error: { main: '#D32F2F' },
    success: { main: '#388E3C' },
    warning: { main: '#F57C00' },
    info: { main: '#588157' },
    background: {
      default: '#F5F5F5',
      paper: '#FFFFFF',
    },
    text: {
      primary: '#344E41',
      secondary: '#3A5A40',
    },
  },
  typography: {
    fontFamily: [
      '-apple-system',
      'BlinkMacSystemFont',
      '"Segoe UI"',
      'Roboto',
      '"Helvetica Neue"',
      'Arial',
      'sans-serif',
    ].join(','),
    h4: { fontWeight: 600, color: '#344E41' },
    h5: { fontWeight: 600, color: '#344E41' },
    h6: { fontWeight: 600, color: '#344E41' },
  },
  components: {
    MuiAppBar: {
      styleOverrides: {
        root: { backgroundColor: '#3A5A40' },
      },
    },
    MuiDrawer: {
      styleOverrides: {
        paper: {
          backgroundColor: '#FFFFFF',
          borderRight: '1px solid #DAD7CD',
        },
      },
    },
    MuiButton: {
      styleOverrides: {
        root: {
          textTransform: 'none',
          borderRadius: 8,
          fontWeight: 500,
        },
        contained: {
          boxShadow: 'none',
          '&:hover': {
            boxShadow: '0 2px 8px rgba(58, 90, 64, 0.2)',
          },
        },
      },
    },
    MuiCard: {
      styleOverrides: {
        root: {
          borderRadius: 12,
          boxShadow: '0 2px 8px rgba(0, 0, 0, 0.08)',
        },
      },
    },
    MuiChip: {
      styleOverrides: {
        root: { borderRadius: 8 },
      },
    },
    MuiTableHead: {
      styleOverrides: {
        root: {
          backgroundColor: '#F5F5F5',
          '& .MuiTableCell-head': {
            color: '#344E41',
            fontWeight: 600,
          },
        },
      },
    },
    MuiListItemButton: {
      styleOverrides: {
        root: {
          borderRadius: 8,
          margin: '4px 8px',
          '&.Mui-selected': {
            backgroundColor: 'rgba(58, 90, 64, 0.08)',
            '&:hover': {
              backgroundColor: 'rgba(58, 90, 64, 0.12)',
            },
          },
        },
      },
    },
  },
};