import React from 'react';
import {
  Card,
  CardContent,
  Typography,
  Button,
  Box,
} from '@mui/material';
import {
  Add as AddIcon,
  PlayArrow as PlayIcon,
} from '@mui/icons-material';

interface CounterProps {
  counter: number;
  onIncrement: () => void;
  isProduction?: boolean;
}

const Counter: React.FC<CounterProps> = ({ 
  counter, 
  onIncrement, 
  isProduction = false 
}) => {
  return (
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
      data-testid="counter-card"
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
          <PlayIcon sx={{ mr: 1 }} />
          Contador Interativo
        </Typography>
        
        <Box sx={{ textAlign: 'center', py: { xs: 2, sm: 3 } }}>
          <Typography 
            variant="h2" 
            color="primary" 
            gutterBottom
            sx={{ 
              fontSize: { xs: '3rem', sm: '4rem', md: '5rem' },
              fontWeight: 'bold',
            }}
            data-testid="counter-value"
          >
            {counter}
          </Typography>
          
          <Button
            variant="contained"
            size="large"
            onClick={onIncrement}
            startIcon={<AddIcon />}
            sx={{ 
              px: { xs: 3, sm: 4 }, 
              py: { xs: 1, sm: 1.5 },
              background: 'linear-gradient(45deg, #FF6B6B 30%, #FF8E53 90%)',
              borderRadius: 3,
              fontSize: { xs: '1rem', sm: '1.1rem' },
              fontWeight: 'bold',
              textTransform: 'none',
              boxShadow: 3,
              '&:hover': {
                background: 'linear-gradient(45deg, #FF5252 30%, #FF7043 90%)',
                boxShadow: 6,
              },
            }}
            data-testid="increment-button"
          >
            Incrementar
          </Button>
        </Box>
        
        <Typography 
          variant="caption" 
          display="block" 
          textAlign="center" 
          mt={2}
          sx={{ 
            fontSize: { xs: '0.8rem', sm: '0.9rem' },
            color: 'text.secondary',
          }}
          data-testid="counter-description"
        >
          {isProduction 
            ? 'Cada clique é logado no sistema de monitoramento'
            : 'Clique para incrementar o contador'
          }
        </Typography>
      </CardContent>
    </Card>
  );
};

export default Counter; 