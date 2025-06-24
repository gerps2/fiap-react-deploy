# React + TypeScript + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable type-aware lint rules:

```js
export default tseslint.config({
  extends: [
    // Remove ...tseslint.configs.recommended and replace with this
    ...tseslint.configs.recommendedTypeChecked,
    // Alternatively, use this for stricter rules
    ...tseslint.configs.strictTypeChecked,
    // Optionally, add this for stylistic rules
    ...tseslint.configs.stylisticTypeChecked,
  ],
  languageOptions: {
    // other options...
    parserOptions: {
      project: ['./tsconfig.node.json', './tsconfig.app.json'],
      tsconfigRootDir: import.meta.dirname,
    },
  },
})
```

You can also install [eslint-plugin-react-x](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-x) and [eslint-plugin-react-dom](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-dom) for React-specific lint rules:

```js
// eslint.config.js
import reactX from 'eslint-plugin-react-x'
import reactDom from 'eslint-plugin-react-dom'

export default tseslint.config({
  plugins: {
    // Add the react-x and react-dom plugins
    'react-x': reactX,
    'react-dom': reactDom,
  },
  rules: {
    // other rules...
    // Enable its recommended typescript rules
    ...reactX.configs['recommended-typescript'].rules,
    ...reactDom.configs.recommended.rules,
  },
})
```

# FIAP React Deploy

Este projeto é uma aplicação React + TypeScript + Vite com pipeline CI/CD completo implementado para deploy automatizado via Coolify.

## 🚀 Pipeline CI/CD

### Fluxo de Desenvolvimento
- `main` - Branch de produção (protegida)
- `develop` - Branch de desenvolvimento
- `feature/*` - Branches de funcionalidades
- `hotfix/*` - Correções urgentes
- `release/*` - Preparação de releases

### Automações Implementadas

#### 🔒 Proteção da Branch Main
- ✅ Pull Request obrigatório
- ✅ Histórico linear (linear history)
- ✅ Validação de título com versão (v1.2.3)
- ✅ Validação de branch origem (develop, release/*, hotfix/*)

#### 🧪 Pipeline de Validação (CI)
- ✅ Testes automatizados com cobertura
- ✅ Linting (ESLint)
- ✅ Build e teste do container Docker
- ✅ Relatórios detalhados de cobertura no PR

#### 🏷️ Auto-Tagging
- ✅ Tags criadas automaticamente no merge para main
- ✅ Extração de versão do título do PR
- ✅ Auto-incremento se versão não especificada
- ✅ Release notes automáticas

#### 🌟 Deploy Automático
- ✅ Deploy production via Coolify (trigger por tag)
- ✅ Validação pré-deploy completa
- ✅ Relatórios de deployment
- ✅ Rollback automático em caso de falha

### Como Usar

1. **Desenvolvimento Normal:**
   ```bash
   git checkout develop
   git checkout -b feature/nova-funcionalidade
   # ... desenvolvimento ...
   git push origin feature/nova-funcionalidade
   # Criar PR para develop
   ```

2. **Release para Produção:**
   ```bash
   # PR de develop para main com título:
   # "v1.2.3: Descrição da release"
   # Após merge: tag automática + deploy automático
   ```

3. **Hotfix Urgente:**
   ```bash
   git checkout main
   git checkout -b hotfix/v1.2.4-fix-critical-bug
   # ... correção ...
   # PR para main com título: "v1.2.4: Correção crítica"
   ```

## 🛠️ Stack Técnica

### Frontend
- **React 18** - Framework UI
- **TypeScript** - Tipagem estática
- **Vite** - Build tool e dev server
- **ESLint** - Linter de código

### DevOps & Deploy
- **Docker** - Containerização (nginx + aplicação)
- **Coolify** - Plataforma de deploy
- **GitHub Actions** - CI/CD pipeline
- **Traefik** - Reverse proxy e SSL

### Monitoramento
- **Health checks** automatizados
- **Coverage reports** em PRs
- **Deploy status** detalhado
- **Rollback** automático

## 🔧 Desenvolvimento Local
