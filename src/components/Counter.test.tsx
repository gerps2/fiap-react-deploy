import { add } from '../utils/math';

interface CounterProps {
  counter: number;
  onIncrement: () => void;
  isProduction?: boolean;
}

function simulateCounterLogic(props: CounterProps) {
  const { counter, onIncrement, isProduction = false } = props;
  
  return {
    value: counter,
    increment: onIncrement,
    isProduction,
    displayText: `Contador: ${counter}`,
    description: isProduction 
      ? 'Contador em produção - LogRocket ativo'
      : 'Contador em desenvolvimento'
  };
}

describe('Counter Component Logic', () => {
  test('should initialize with correct counter value', () => {
    const mockIncrement = jest.fn();
    const logic = simulateCounterLogic({ counter: 0, onIncrement: mockIncrement });
    
    expect(logic.value).toBe(0);
    expect(logic.displayText).toBe('Contador: 0');
  });

  test('should display correct value when counter changes', () => {
    const mockIncrement = jest.fn();
    const logic = simulateCounterLogic({ counter: 5, onIncrement: mockIncrement });
    
    expect(logic.value).toBe(5);
    expect(logic.displayText).toBe('Contador: 5');
  });

  test('should have increment function', () => {
    const mockIncrement = jest.fn();
    const logic = simulateCounterLogic({ counter: 0, onIncrement: mockIncrement });
    
    expect(typeof logic.increment).toBe('function');
    logic.increment();
    expect(mockIncrement).toHaveBeenCalledTimes(1);
  });

  test('should show production description when isProduction is true', () => {
    const mockIncrement = jest.fn();
    const logic = simulateCounterLogic({ 
      counter: 0, 
      onIncrement: mockIncrement, 
      isProduction: true 
    });
    
    expect(logic.description).toBe('Contador em produção - LogRocket ativo');
    expect(logic.isProduction).toBe(true);
  });

  test('should show development description when isProduction is false', () => {
    const mockIncrement = jest.fn();
    const logic = simulateCounterLogic({ 
      counter: 0, 
      onIncrement: mockIncrement, 
      isProduction: false 
    });
    
    expect(logic.description).toBe('Contador em desenvolvimento');
    expect(logic.isProduction).toBe(false);
  });

  test('should handle negative counter values', () => {
    const mockIncrement = jest.fn();
    const logic = simulateCounterLogic({ counter: -5, onIncrement: mockIncrement });
    
    expect(logic.value).toBe(-5);
    expect(logic.displayText).toBe('Contador: -5');
  });

  test('should handle large counter values', () => {
    const mockIncrement = jest.fn();
    const logic = simulateCounterLogic({ counter: 999999, onIncrement: mockIncrement });
    
    expect(logic.value).toBe(999999);
    expect(logic.displayText).toBe('Contador: 999999');
  });

  test('should integrate with math utilities', () => {
    const mockIncrement = jest.fn();
    const currentValue = 5;
    const newValue = add(currentValue, 1);
    
    const logic = simulateCounterLogic({ counter: newValue, onIncrement: mockIncrement });
    
    expect(logic.value).toBe(6);
    expect(logic.displayText).toBe('Contador: 6');
  });

  test('should call increment function multiple times', () => {
    const mockIncrement = jest.fn();
    const logic = simulateCounterLogic({ counter: 0, onIncrement: mockIncrement });
    
    logic.increment();
    logic.increment();
    logic.increment();
    
    expect(mockIncrement).toHaveBeenCalledTimes(3);
  });

  test('should handle zero counter value', () => {
    const mockIncrement = jest.fn();
    const logic = simulateCounterLogic({ counter: 0, onIncrement: mockIncrement });
    
    expect(logic.value).toBe(0);
    expect(logic.displayText).toBe('Contador: 0');
  });
}); 