import '@testing-library/jest-dom';

// Configurações globais para os testes
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: jest.fn().mockImplementation(query => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: jest.fn(), // deprecated
    removeListener: jest.fn(), // deprecated
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    dispatchEvent: jest.fn(),
  })),
});

// Mock para IntersectionObserver
Object.defineProperty(global, 'IntersectionObserver', {
  writable: true,
  value: jest.fn().mockImplementation(() => ({
    observe: jest.fn(),
    unobserve: jest.fn(),
    disconnect: jest.fn(),
    root: null,
    rootMargin: '0px',
    thresholds: [],
    takeRecords: jest.fn().mockReturnValue([]),
  })),
});

// Mock para ResizeObserver
Object.defineProperty(global, 'ResizeObserver', {
  writable: true,
  value: jest.fn().mockImplementation(() => ({
    observe: jest.fn(),
    unobserve: jest.fn(),
    disconnect: jest.fn(),
  })),
});

// Mock para LogRocket
jest.mock('logrocket', () => ({
  init: jest.fn(),
  log: jest.fn(),
  identify: jest.fn(),
  track: jest.fn(),
}));

// Configuração para ambiente de teste
process.env.NODE_ENV = 'test'; 