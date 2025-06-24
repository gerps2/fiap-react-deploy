export function add(a: number, b: number): number {
  return a + b;
}

export function subtract(a: number, b: number): number {
  return a - b;
}

export function multiply(a: number, b: number): number {
  return a * b;
}

export function divide(a: number, b: number): number {
  if (b === 0) {
    throw new Error('Division by zero is not allowed');
  }
  return a / b;
}

export function isEven(num: number): boolean {
  return num % 2 === 0;
}

export function isPositive(num: number): boolean {
  return num > 0;
}

export function factorial(n: number): number {
  if (n < 0) {
    throw new Error('Factorial is not defined for negative numbers');
  }
  if (n === 0 || n === 1) {
    return 1;
  }
  return n * factorial(n - 1);
}

export function clamp(value: number, min: number, max: number): number {
  if (min > max) {
    throw new Error('Min value cannot be greater than max value');
  }
  return Math.min(Math.max(value, min), max);
} 