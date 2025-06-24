import { useState, useEffect } from 'react';
import {
  Container,
  Typography,
  Card,
  CardContent,
  Chip,
  TextField,
  List,
  ListItem,
  ListItemText,
  Box,
  Paper,
  Divider,
  Alert,
  Stack,
  Button,
} from '@mui/material';
import {
  Speed as SpeedIcon,
  CloudUpload as DeployIcon,
  Code as CodeIcon,
} from '@mui/icons-material';
import LogRocket from 'logrocket';
import Counter from './components/Counter';

// Inicializar LogRocket
if (import.meta.env.PROD) {
  LogRocket.init('your-app-id/your-project-name');
}

interface StatusItem {
  id: number;
  text: string;
  timestamp: string;
}

function App() {
  const [counter, setCounter] = useState(0);
  const [newItem, setNewItem] = useState('');
  const [statusItems, setStatusItems] = useState<StatusItem[]>([
    {
      id: 1,
      text: 'Sistema inicializado',
      timestamp: new Date().toISOString(),
    },
  ]);

  // Variáveis de ambiente e informações do sistema
  const environment = import.meta.env.VITE_ENVIRONMENT || 'DEV';
  const appVersion = import.meta.env.VITE_APP_VERSION || '1.0.0';
  const buildTimestamp = import.meta.env.VITE_BUILD_TIMESTAMP || new Date().toISOString();
  const isProduction = environment === 'PROD';

  useEffect(() => {
    // Log inicial no LogRocket
    if (isProduction) {
      LogRocket.log('Status App initialized', {
        environment,
        version: appVersion,
        buildTimestamp,
      });
    }
  }, [environment, appVersion, buildTimestamp, isProduction]);

  const incrementCounter = () => {
    const newCount = counter + 1;
    setCounter(newCount);
    
    // Log da ação no LogRocket
    if (isProduction) {
      LogRocket.log('Counter incremented', { 
        newValue: newCount,
        timestamp: new Date().toISOString() 
      });
    }
  };

  const addStatusItem = () => {
    if (newItem.trim()) {
      const item: StatusItem = {
        id: Date.now(),
        text: newItem,
        timestamp: new Date().toISOString(),
      };
      
      setStatusItems(prev => [item, ...prev]);
      setNewItem('');
      
      // Log da ação no LogRocket
      if (isProduction) {
        LogRocket.log('Status item added', { 
          item: item.text,
          timestamp: item.timestamp 
        });
      }
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleString('pt-BR');
  };

  return (
    <main id="main-content">
      <Box
        sx={{
          minHeight: '100vh',
          background: 'linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%)',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          py: { xs: 2, sm: 3, md: 4 },
        }}
      >
        <Container 
          maxWidth="lg" 
          sx={{ 
            px: { xs: 2, sm: 3, md: 4 },
            width: '100%',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
          }}
        >
          {/* Header */}
          <Paper 
            elevation={6} 
            sx={{ 
              p: { xs: 2, sm: 3, md: 4 }, 
              mb: { xs: 3, sm: 4 }, 
              background: 'linear-gradient(45deg, #2196F3 30%, #21CBF3 90%)',
              borderRadius: 3,
              width: '100%',
              maxWidth: '100%',
              textAlign: 'center',
            }}
          >
            <Typography 
              variant="h3" 
              component="h1" 
              gutterBottom 
              sx={{ 
                color: 'white', 
                fontWeight: 'bold',
                fontSize: { xs: '1.75rem', sm: '2.5rem', md: '3rem' },
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                flexWrap: 'wrap',
                gap: 1,
              }}
            >
              <SpeedIcon sx={{ fontSize: { xs: '1.75rem', sm: '2.5rem', md: '3rem' } }} />
              Status App - Painel de Diagnóstico
            </Typography>
            <Typography 
              variant="h6" 
              sx={{ 
                color: 'rgba(255,255,255,0.9)',
                fontSize: { xs: '1rem', sm: '1.1rem', md: '1.25rem' },
              }}
            >
              Monitoramento em tempo real do ambiente de deploy - v1.2.7 🚀
            </Typography>
          </Paper>

          <Stack spacing={{ xs: 2, sm: 3, md: 4 }} sx={{ width: '100%', maxWidth: '100%' }}>
            {/* Linha superior com as duas cartas */}
            <Stack 
              direction={{ xs: 'column', lg: 'row' }} 
              spacing={{ xs: 2, sm: 3, md: 4 }}
              sx={{ width: '100%' }}
            >
              {/* Informações do Sistema */}
              <Card 
                elevation={4} 
                sx={{ 
                  flex: 1, 
                  borderRadius: 2,
                  transition: 'transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out',
                  '&:hover': {
                    transform: 'translateY(-4px)',
                    boxShadow: 6,
                  },
                }}
              >
                <CardContent sx={{ p: { xs: 2, sm: 3, md: 4 } }}>
                  <Typography 
                    variant="h5" 
                    gutterBottom 
                    color="primary" 
                    sx={{ 
                      display: 'flex', 
                      alignItems: 'center', 
                      mb: 3,
                      fontSize: { xs: '1.25rem', sm: '1.5rem' },
                      justifyContent: { xs: 'center', sm: 'flex-start' },
                      textAlign: { xs: 'center', sm: 'left' },
                    }}
                  >
                    <CodeIcon sx={{ mr: 1 }} />
                    Informações do Sistema
                  </Typography>
                  
                  <Stack spacing={3} sx={{ alignItems: { xs: 'center', sm: 'flex-start' } }}>
                    <Box sx={{ textAlign: { xs: 'center', sm: 'left' } }}>
                      <Typography variant="subtitle1" gutterBottom sx={{ fontWeight: 600 }}>
                        Ambiente:
                      </Typography>
                      <Chip 
                        label={environment}
                        color={isProduction ? 'error' : 'success'}
                        variant="filled"
                        size="medium"
                        sx={{ 
                          fontWeight: 'bold',
                          fontSize: '0.9rem',
                          px: 2,
                          py: 1,
                        }}
                      />
                    </Box>

                    <Box sx={{ textAlign: { xs: 'center', sm: 'left' } }}>
                      <Typography variant="subtitle1" gutterBottom sx={{ fontWeight: 600 }}>
                        Versão do App:
                      </Typography>
                      <Typography 
                        variant="h6" 
                        color="text.secondary"
                        sx={{ 
                          fontWeight: 'bold',
                          fontSize: { xs: '1.1rem', sm: '1.25rem' },
                        }}
                      >
                        v{appVersion}
                      </Typography>
                    </Box>

                    <Box sx={{ textAlign: { xs: 'center', sm: 'left' } }}>
                      <Typography 
                        variant="subtitle1" 
                        gutterBottom 
                        sx={{ 
                          fontWeight: 600,
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: { xs: 'center', sm: 'flex-start' },
                        }}
                      >
                        <DeployIcon sx={{ mr: 1 }} />
                        Último Deploy:
                      </Typography>
                      <Typography 
                        variant="body1" 
                        color="text.secondary"
                        sx={{ fontSize: { xs: '0.9rem', sm: '1rem' } }}
                      >
                        {formatDate(buildTimestamp)}
                      </Typography>
                    </Box>

                    {isProduction && (
                      <Alert 
                        severity="info" 
                        sx={{ 
                          width: '100%',
                          borderRadius: 2,
                        }}
                      >
                        LogRocket está ativo - monitorando sessões
                      </Alert>
                    )}
                  </Stack>
                </CardContent>
              </Card>

              {/* Counter Component */}
              <Counter 
                counter={counter}
                onIncrement={incrementCounter}
                isProduction={isProduction}
              />
            </Stack>

            {/* Lista de Status */}
            <Card 
              elevation={4}
              sx={{ 
                borderRadius: 2,
                transition: 'transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out',
                '&:hover': {
                  transform: 'translateY(-2px)',
                  boxShadow: 6,
                },
              }}
            >
              <CardContent sx={{ p: { xs: 2, sm: 3, md: 4 } }}>
                <Typography 
                  variant="h5" 
                  gutterBottom 
                  color="primary" 
                  sx={{ 
                    mb: 3,
                    fontSize: { xs: '1.25rem', sm: '1.5rem' },
                    textAlign: { xs: 'center', sm: 'left' },
                    fontWeight: 'bold',
                  }}
                >
                  Sistema de Status em Tempo Real
                </Typography>
                
                <Stack 
                  direction={{ xs: 'column', sm: 'row' }} 
                  spacing={2} 
                  sx={{ mb: 3 }}
                >
                  <TextField
                    fullWidth
                    variant="outlined"
                    label="Adicionar novo status"
                    value={newItem}
                    onChange={(e) => setNewItem(e.target.value)}
                    onKeyPress={(e) => e.key === 'Enter' && addStatusItem()}
                    sx={{
                      '& .MuiOutlinedInput-root': {
                        borderRadius: 2,
                      },
                    }}
                  />
                  <Button
                    variant="contained"
                    onClick={addStatusItem}
                    disabled={!newItem.trim()}
                    sx={{ 
                      minWidth: { xs: '100%', sm: 120 },
                      py: { xs: 1.5, sm: 1 },
                      borderRadius: 2,
                      fontWeight: 'bold',
                      textTransform: 'none',
                    }}
                  >
                    Adicionar
                  </Button>
                </Stack>

                <Divider sx={{ mb: 2 }} />

                <List sx={{ 
                  maxHeight: { xs: 300, sm: 400 }, 
                  overflow: 'auto',
                  '& .MuiListItem-root': {
                    borderRadius: 1,
                    mb: 1,
                    '&:hover': {
                      backgroundColor: 'rgba(0, 0, 0, 0.04)',
                    },
                  },
                }}>
                  {statusItems.map((item) => (
                    <ListItem key={item.id} divider>
                      <ListItemText
                        primary={item.text}
                        secondary={`Adicionado em: ${formatDate(item.timestamp)}`}
                        primaryTypographyProps={{
                          fontSize: { xs: '0.9rem', sm: '1rem' },
                          fontWeight: 500,
                        }}
                        secondaryTypographyProps={{
                          fontSize: { xs: '0.8rem', sm: '0.875rem' },
                        }}
                      />
                    </ListItem>
                  ))}
                </List>

                {statusItems.length === 0 && (
                  <Typography 
                    variant="body2" 
                    color="text.secondary" 
                    textAlign="center" 
                    py={4}
                    sx={{ fontSize: { xs: '0.9rem', sm: '1rem' } }}
                  >
                    Nenhum item de status adicionado ainda.
                  </Typography>
                )}
              </CardContent>
            </Card>
          </Stack>

          {/* Footer */}
          <Paper 
            elevation={2} 
            sx={{ 
              mt: { xs: 3, sm: 4 }, 
              p: { xs: 2, sm: 3 }, 
              textAlign: 'center', 
              bgcolor: 'grey.100',
              borderRadius: 2,
              width: '100%',
            }}
          >
            <Typography 
              variant="body2" 
              color="text.secondary"
              sx={{ 
                fontSize: { xs: '0.8rem', sm: '0.875rem' },
                lineHeight: 1.5,
              }}
            >
              Status App v{appVersion} - Ambiente: {environment} | 
              Build: {formatDate(buildTimestamp)}
              {isProduction && ' | LogRocket Ativo'}
            </Typography>
          </Paper>
        </Container>
      </Box>
    </main>
  );
}

export default App;
